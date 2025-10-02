--[[Initialization]]--
local _, ns = ...

--On encounter start, check the player spec, confirm its supported and calculate the real cooldown of spells according to haste
function ns:SetPlayerSpec()
    local specId = GetSpecializationInfo(GetSpecialization())
    ns.specName = ns.specs[specId]
    if ns.specName then
        ns.specSupported = true
        local haste = GetHaste() / 100
        for spellId, spell in pairs(ns[ns.specName]['spells']) do
            if spell['modifiers'] then
                for modifier, effect in pairs(spell['modifiers']) do
                    if IsPlayerSpell(modifier) then
                        if spell['baseCd'] then
                            ns[ns.specName]['spells'][spellId]['baseCd'] = ns[ns.specName]['spells'][spellId]['baseCd'] + effect
                        else
                            ns[ns.specName]['spells'][spellId]['cd'] = ns[ns.specName]['spells'][spellId]['cd'] + effect
                        end
                    end
                end
            end
            if spell['baseCd'] then
                ns[ns.specName]['spells'][spellId]['cd'] = tonumber(string.format('%.1f', (ns[ns.specName]['spells'][spellId]['baseCd']) / ( 1 + haste)))
            end
        end
    end
end

--Creates the assignments to be displayed, using info from the spec file. static assignments run on a fixed time and dynamic assignments depend on a charged spell cooldown
function ns:SetupTimings(event, encounterId, difficultyId)
    --ns:ResetDisplay() REPLACE THIS WITH A HIDE DISPLAYS IF YOU GO INTO COMBAT
    --Init fight assignments Table
    ns.fightAssignments = {}
    local rampTypesTable = ns[ns.specName]['rampTypes']()
    local cooldownsTable = ns[ns.specName]['cooldowns']
    local utilitiesTable = ns[ns.specName]['utilities']
    local assignmentsTable = rampTypesTable
    --Generate non-ramp assignment elements
    for id, spell in pairs(cooldownsTable) do
        if HarreksRampHelperDB.options.specs[ns.specName][spell] then
            assignmentsTable[spell] = {
                {
                    ['text'] = spell .. ' Soon',
                    ['icon'] = C_Spell.GetSpellInfo(id).iconID,
                    ['offset'] = HarreksRampHelperDB.options.timerDuration,
                    ['showTimer'] = true
                },
                {
                    ['text'] = spell,
                    ['icon'] = C_Spell.GetSpellInfo(id).iconID,
                    ['offset'] = 0
                }
            }
        end
    end
    for id, spell in pairs(utilitiesTable) do
        local spellInfo = C_Spell.GetSpellInfo(id)
        if HarreksRampHelperDB.options.specs[ns.specName][spell] and spellInfo and spellInfo.iconID then
            assignmentsTable[spell] = {
                {
                    ['text'] = spell .. ' Soon',
                    ['icon'] = spellInfo.iconID,
                    ['offset'] = HarreksRampHelperDB.options.timerDuration,
                    ['showTimer'] = true
                },
                {
                    ['text'] = spell,
                    ['icon'] = C_Spell.GetSpellInfo(id).iconID,
                    ['offset'] = 0
                }
            }
        end
    end
    local noteAssignments = {}
    --If Read From Note mode is enabled, grab the current note text and format it
    if event == "ENCOUNTER_START" and HarreksRampHelperDB.options.readFromNote then
        local mrtNoteArray = {
            HarreksRampHelperDB.options.readFromNote        and _G.VMRT.Note.Text1 or "",
            HarreksRampHelperDB.options.mrtPersonalNote     and _G.VMRT.Note.SelfText or ""
        }
        local mrtNoteText = table.concat(mrtNoteArray, "\n")
                    :gsub("^%s+", "")
                    :gsub("%s+$", "")
                    :gsub("\n%s*\n", "\n")
        local activeNote = ns:ConvertNoteToTable(mrtNoteText, ns.specName, encounterId, ns.difficulties[difficultyId]['slug'])
        for spell, timings in pairs(activeNote) do
            local rampType = ns[ns.specName]['cooldowns'][tonumber(spell)]
            if rampType then
                local timingsString = ""
                for _, time in pairs(timings) do
                    timingsString = timingsString .. time .. '\n'
                end
                noteAssignments[rampType] = timingsString
            end
        end
    end
    for type, _ in pairs(assignmentsTable) do
        local fightTimings
        if event == "ENCOUNTER_START" then
            if HarreksRampHelperDB.options.readFromNote then
                fightTimings = noteAssignments[type]
            else
                local difficultySlug = ns.difficulties[difficultyId]['slug']
                fightTimings =  HarreksRampHelperDB[ns.specName][difficultySlug][tostring(encounterId)][type]
            end
        elseif HarreksRampHelperDB.testing.testMode then
            fightTimings = HarreksRampHelperDB[ns.specName].testTimers[type]
        end
        fightTimings = ns:ConvertTimesToTable(fightTimings)
        for index, phaseTimings in pairs(fightTimings) do
            if not ns.fightAssignments[index] then
                ns.fightAssignments[index] = {
                    ['dynamic'] = {},
                    ['static'] = {}
                }
            end
            for _, timing in pairs(phaseTimings) do
                for _, assignment in pairs(assignmentsTable[type]) do
                    local assignmentTime = ns:CutDecimals(timing - assignment['offset'])
                    if assignmentTime >= 0 and (not HarreksRampHelperDB.options.preReqsOnly or (HarreksRampHelperDB.options.preReqsOnly and assignment['preRequisite'])) then
                        if assignment['dynamic'] then
                            if not ns.fightAssignments[index]['dynamic'][assignmentTime] then
                                ns.fightAssignments[index]['dynamic'][assignmentTime] = {}
                            end
                            table.insert(ns.fightAssignments[index]['dynamic'][assignmentTime], {
                                ['text'] = assignment['text'],
                                ['icon'] = assignment['icon'],
                                ['loaded'] = false,
                                ['spellId'] = assignment['spellId'],
                                ['tts'] = assignment['tts'] or nil
                            })
                        else
                            if not ns.fightAssignments[index]['static'][assignmentTime] then
                                ns.fightAssignments[index]['static'][assignmentTime] = {}
                            end
                            table.insert(ns.fightAssignments[index]['static'][assignmentTime], {
                                ['text'] = assignment['text'],
                                ['icon'] = assignment['icon'],
                                ['loaded'] = false,
                                ['showTimer'] = assignment['showTimer'],
                                ['tts'] = assignment['tts'] or nil
                            })
                        end
                    end
                end
            end
        end
    end
end

--The time to show a dynamic assignment depends on how you are using the charges, this compares the potential cooldown of the spell with the remaining time before the assignment to see if it should be shown
function ns:ComputeDynamicAssignments(currentTime, phase)
    for time, assignmentSet in pairs(ns.fightAssignments[tostring(phase)]['dynamic']) do
        for index, assignment in pairs(assignmentSet) do
            if time >= currentTime and not assignment['loaded'] then
                local timeLeft = time - currentTime
                local spellInfo = C_Spell.GetSpellCharges(assignment['spellId'])
                local spellCd
                if spellInfo.currentCharges < 2 then
                    spellCd = spellInfo.cooldownStartTime + spellInfo.cooldownDuration - GetTime()
                else
                    spellCd = 0
                end
                local timeUntilFullCharges = spellInfo.cooldownDuration
                if spellInfo.currentCharges == 1 then
                    timeUntilFullCharges = timeUntilFullCharges + spellCd
                elseif spellInfo.currentCharges == 0 then
                    timeUntilFullCharges = timeUntilFullCharges + spellCd + spellInfo.cooldownDuration
                end
                if timeUntilFullCharges >= timeLeft then
                    ns:ShowAssignment(assignment)
                    ns.fightAssignments[tostring(phase)]['dynamic'][time][index]['loaded'] = true
                end
            end
        end
    end
end

--Gets either the actual cooldown or the base cooldown of a spell depending on if haste as been computed
function ns:GetRealCooldown(spec, spellId)
    return ns[spec]['spells'][spellId]['cd'] or ns[spec]['spells'][spellId]['baseCd']
end

--Sets up the phase changing condition for the current fight
function ns:SetupPhaseChanges(phaseChangesTable)
    ns.phaseTimerData.phaseTriggerCounter = {}
    local phaseChanges = {}
    for phase, trigger in pairs(phaseChangesTable) do
        phaseChanges[phase] = ns:FormatPhaseChangeString(trigger)
    end
    ns.phaseEvents:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    ns.phaseTimerData.phaseActivations = phaseChanges
end

--Import the currently pasted note into the addon assignments for the selected boss on the given spec
function ns:ImportNote(specName)
    local fightId = HarreksRampHelperDB.import.fight
    local diffId = HarreksRampHelperDB.import.difficulty
    local importText = HarreksRampHelperDB.import.importText
    if fightId and diffId and importText then
        local diffSlug = ns.difficulties[diffId].slug
        local timers = ns:ConvertNoteToTable(importText, specName, fightId, diffSlug)
        for type, _ in pairs(HarreksRampHelperDB[specName][diffSlug][tostring(fightId)]) do
            HarreksRampHelperDB[specName][diffSlug][tostring(fightId)][type] = ''
        end
        local spellList = ns:GetFullSpellList(specName)
        for spell, timings in pairs(timers) do
            local selectedSpell = spellList[tonumber(spell)]
            if selectedSpell then
                local timingsString = ''
                for _, time in pairs(timings) do
                    timingsString = timingsString .. time .. '\n'
                end
                HarreksRampHelperDB[specName][diffSlug][tostring(fightId)][selectedSpell] = timingsString
            end
        end
        HarreksRampHelperDB.import.importText = '';
        ns:WriteOutput('Successfully imported ' .. specName .. ' timings for ' .. ns.difficulties[diffId].name .. ' ' .. ns.bosses[fightId].name)
    end
end

--Grabs the default assignments from the Defaults folder and pastes them in the import box
function ns:PasteDefaultForSpecificBoss(specName)
    local fightId = HarreksRampHelperDB.import.fight
    local diffId = HarreksRampHelperDB.import.difficulty
    local diffSlug = ns.difficulties[diffId].slug
    local defaultText = ns[specName]['defaultAssignments'][fightId]['assignments'][diffSlug]
    if defaultText == "" then
        ns:WriteOutput('There are currently no default assignments setup for ' .. specName .. ' on ' .. ns.difficulties[diffId].name .. ' ' .. ns.bosses[fightId].name)
    else
        defaultText = defaultText:gsub("PLAYER", GetUnitName("player", false))
        HarreksRampHelperDB.import.importText = defaultText
        ns:WriteOutput('Pasted default assignments for ' .. specName .. ' on ' .. ns.difficulties[diffId].name .. ' ' .. ns.bosses[fightId].name)
    end
end