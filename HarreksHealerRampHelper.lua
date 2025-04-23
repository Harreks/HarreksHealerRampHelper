--[[Initialization]]--
--Namespace
local _, ns = ...
local next = next
--Timer Variables
ns.mainTimerData = {
    currentTimer = 0,
    startTime = nil,
    timerRunning = false,
    runningTimer = nil
}
ns.phaseTimerData = {
    currentPhase = nil,
    currentTimer = 0,
    startTime = nil,
    timerRunning = false,
    runningTimer = nil,
    phaseActivations = {},
    phaseTriggerCounter = {}
}
--Assignment Variables
local specName = nil
local specSupported = false
ns.fightAssignments = {}
--Display Frames
ns.infoFrame = CreateFrame("FRAME", nil, UIParent) --The info frame is the container for the whole display
ns.infoFrame:SetWidth(1)
ns.infoFrame:SetHeight(1)
ns.infoFrame:SetFrameStrata("TOOLTIP")
ns.infoFrame.text = ns.infoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") --Text is the text that will be displayed
ns.infoFrame.text:SetPoint("CENTER", ns.infoFrame, "CENTER") --Attached to the info frame, in the center
ns.infoFrame.text:SetShadowColor(0, 0, 0, 1)
ns.infoFrame.text:SetShadowOffset(-2, -2)
ns.infoFrame.icon = ns.infoFrame:CreateTexture(nil, "OVERLAY") --Icon that will be displayed
ns.infoFrame.icon:SetPoint("CENTER", ns.infoFrame, "CENTER", 0, 40) --Attached to the info frame, in the center 40px upwards
ns.infoFrame.timer = ns.infoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") --Timer to be shown for the assignments marked with showTimer
ns.infoFrame.timer:SetPoint("CENTER", ns.infoFrame.icon, "CENTER") --Attached to the icon, in the center
ns.infoFrame.timer:SetShadowColor(0, 0, 0, 1)
ns.infoFrame.timer:SetShadowOffset(-2, -2)
--Timer Frames
local phaseEvents = CreateFrame("Frame") --Frame that handles phase changing
phaseEvents:SetScript("OnEvent", function()
    local _, subEvent, _, _, _, _, _, _, _, _, _, spellId = CombatLogGetCurrentEventInfo()
    for phase, trigger in pairs(ns.phaseTimerData.phaseActivations) do
        if subEvent == ns.phaseEvents[trigger.event] and spellId == tonumber(trigger.spell) then
            if ns.phaseTimerData.phaseTriggerCounter[phase] then
                ns.phaseTimerData.phaseTriggerCounter[phase] = ns.phaseTimerData.phaseTriggerCounter[phase] + 1
            else
                ns.phaseTimerData.phaseTriggerCounter[phase] = 1
            end
            if ns.phaseTimerData.phaseTriggerCounter[phase] == tonumber(ns.phaseTimerData.phaseActivations[phase].count) then
                ns:StartPhase(phase)
            end
        end
    end
end)

local startTimer = CreateFrame("Frame") --The frame that runs the functions on encounter start
startTimer:RegisterEvent("PLAYER_REGEN_DISABLED")
startTimer:RegisterEvent("ENCOUNTER_START")
startTimer:SetScript("OnEvent", function(_, event, encounterId, _, difficultyId)
    if (event == "ENCOUNTER_START" and ns.difficulties[difficultyId] and ns.bosses[encounterId]) or (event == "PLAYER_REGEN_DISABLED" and HarreksRampHelperDB.testing.testMode) then
        ns:SetPlayerSpec()
        if specSupported then
            ns:SetupTimings(event, encounterId, difficultyId)
            if encounterId and next(ns.bosses[encounterId].phases[ns.difficulties[difficultyId].slug]) ~= nil then
                local bossPhaseChanges = ns.bosses[encounterId].phases[ns.difficulties[difficultyId].slug]
                ns:SetupPhaseChanges(bossPhaseChanges)
            end
            ns:StartTimer()
        end
    end
end)

local stopTimer = CreateFrame("Frame") --Frame that stops the timer on encounter end
stopTimer:RegisterEvent("ENCOUNTER_END")
stopTimer:RegisterEvent("PLAYER_REGEN_ENABLED")
stopTimer:SetScript("OnEvent", function(_, event)
    if event == "ENCOUNTER_END" or (event == "PLAYER_REGEN_ENABLED" and HarreksRampHelperDB.testing.testMode) then
        ns:StopTimer()
    end
end)


--[[Timer Functions]]--
--When encounter starts, this function starts the fight timer and creates a ticker to check twice every second if any assignment is due to be shown
function ns:StartTimer()
    ns.mainTimerData.startTime = GetTime()
    ns.mainTimerData.timerRunning = true
    ns.mainTimerData.runningTimer = C_Timer.NewTicker(0.5, function()
        ns.mainTimerData.currentTimer = GetTime() - ns.mainTimerData.startTime
        ns:RunAssignmentCheck(ns.mainTimerData.currentTimer, 'main')
    end)
end

--On encounter end, stops the timer
function ns:StopTimer()
    if ns.mainTimerData.timerRunning and ns.mainTimerData.runningTimer ~= nil then
        ns.mainTimerData.runningTimer:Cancel()
        ns.mainTimerData.timerRunning = false
    end
    phaseEvents:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    if ns.phaseTimerData.timerRunning and ns.phaseTimerData.runningTimer ~= nil then
        ns.phaseTimerData.runningTimer:Cancel()
        ns.phaseTimerData.timerRunning = false
    end
end

--When the conditions for starting a phase are met, starts the phase timer with the data for that phase
function ns:StartPhase(phase)
    ns.phaseTimerData.startTime = GetTime()
    ns.phaseTimerData.currentTimer = 0
    ns.phaseTimerData.timerRunning = true
    ns.phaseTimerData.currentPhase = phase
    if ns.phaseTimerData.runningTimer then
        ns.phaseTimerData.runningTimer:Cancel()
    end
    ns.phaseTimerData.runningTimer = C_Timer.NewTicker(0.5, function()
        ns.phaseTimerData.currentTimer = GetTime() - ns.phaseTimerData.startTime
        ns:RunAssignmentCheck(ns.phaseTimerData.currentTimer, phase)
    end)
end

--Called with a specific time and a phase, it checks for assignments for that phase at that time and if they haven't been ran before, runs them
function ns:RunAssignmentCheck(time, phase)
    if ns.fightAssignments[tostring(phase)] then
        local formattedTime = ns:CutDecimals(time)
        if ns.fightAssignments[tostring(phase)]['static'][formattedTime] and not ns.fightAssignments[tostring(phase)]['static'][formattedTime]['loaded'] then
            ns:ShowAssignment(ns.fightAssignments[tostring(phase)]['static'][formattedTime])
            ns.fightAssignments[tostring(phase)]['static'][formattedTime]['loaded'] = true
        end
        ns:ComputeDynamicAssignments(formattedTime, phase)
    end
end

--[[Data Functions]]--
--On encounter start, check the player spec, confirm its supported and calculate the real cooldown of spells according to haste
function ns:SetPlayerSpec()
    local specId = GetSpecializationInfo(GetSpecialization())
    specName = ns.specs[specId]
    if specName then
        specSupported = true
        local haste = GetHaste() / 100
        for spellId, spell in pairs(ns[specName]['spells']) do
            if spell['modifiers'] then
                for modifier, effect in pairs(spell['modifiers']) do
                    if IsPlayerSpell(modifier) then
                        if spell['baseCd'] then
                            ns[specName]['spells'][spellId]['baseCd'] = ns[specName]['spells'][spellId]['baseCd'] + effect
                        else
                            ns[specName]['spells'][spellId]['cd'] = ns[specName]['spells'][spellId]['cd'] + effect
                        end
                    end
                end
            end
            if spell['baseCd'] then
                ns[specName]['spells'][spellId]['cd'] = tonumber(string.format('%.1f', (ns[specName]['spells'][spellId]['baseCd']) / ( 1 + haste)))
            end
        end
    end
end

--[[Assignment Functions]]--
--Creates the assignments to be displayed, using info from the spec file. static assignments run on a fixed time and dynamic assignments depend on a charged spell cooldown
function ns:SetupTimings(event, encounterId, difficultyId)
    ns:ResetDisplay()
    --Init fight assignments Table
    ns.fightAssignments = {}
    local rampTypesTable = ns[specName]['rampTypes']()
    local noteAssignments = {}
    --If Read From Note mode is enabled, grab the current note text and format it
    if event == "ENCOUNTER_START" and HarreksRampHelperDB.options.readFromNote then
        local mrtNoteText = _G.VMRT.Note.Text1
        local activeNote = ns:ConvertNoteToTable(mrtNoteText, specName, encounterId, ns.difficulties[difficultyId]['slug'])
        for spell, timings in pairs(activeNote) do
            local rampType = ns[specName]['cooldowns'][tonumber(spell)]
            if rampType then
                local timingsString = ""
                for _, time in pairs(timings) do
                    timingsString = timingsString .. time .. '\n'
                end
                noteAssignments[rampType] = timingsString
            end
        end
    end
    for type, _ in pairs(rampTypesTable) do
        local fightTimings
        if event == "ENCOUNTER_START" then
            if HarreksRampHelperDB.options.readFromNote then
                fightTimings = noteAssignments[type]
            else
                local difficultySlug = ns.difficulties[difficultyId]['slug']
                fightTimings =  HarreksRampHelperDB[specName][difficultySlug][tostring(encounterId)][type]
            end
        elseif HarreksRampHelperDB.testing.testMode then
            fightTimings = HarreksRampHelperDB[specName].testTimers[type]
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
                for _, assignment in pairs(rampTypesTable[type]) do
                    local assignmentTime = ns:CutDecimals(timing - assignment['offset'])
                    if assignmentTime >= 0 and (not HarreksRampHelperDB.options.preReqsOnly or (HarreksRampHelperDB.options.preReqsOnly and assignment['preRequisite'])) then
                        if assignment['dynamic'] then
                            ns.fightAssignments[index]['dynamic'][assignmentTime] = {
                                ['text'] = assignment['text'],
                                ['icon'] = assignment['icon'],
                                ['loaded'] = false,
                                ['spellId'] = assignment['spellId'],
                                ['tts'] = assignment['tts'] or nil
                            }
                        else
                            ns.fightAssignments[index]['static'][assignmentTime] = {
                                ['text'] = assignment['text'],
                                ['icon'] = assignment['icon'],
                                ['loaded'] = false,
                                ['showTimer'] = assignment['showTimer'],
                                ['tts'] = assignment['tts'] or nil
                            }
                        end
                    end
                end
            end
        end
    end
end

--The time to show a dynamic assignment depends on how you are using the charges, this compares the potential cooldown of the spell with the remaining time before the assignment to see if it should be shown
function ns:ComputeDynamicAssignments(currentTime, phase)
    for time, assignment in pairs(ns.fightAssignments[tostring(phase)]['dynamic']) do
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
                ns.fightAssignments[tostring(phase)]['dynamic'][time]['loaded'] = true
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
    phaseEvents:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    ns.phaseTimerData.phaseActivations = phaseChanges
end

--[[Display Functions]]--
--Showing an assignment involved updating the icon and text of the infoFrame, and sending the text as TTS. The timer is shown if the assignment has the showTimer flag set to true
function ns:ShowAssignment(assignment)
    ns.infoFrame.text:SetText(assignment['text'])
    ns.infoFrame.icon:SetTexture(assignment['icon'])
    ns:SendTts(assignment['tts'] or assignment['text'])
    local showTimer = nil
    if assignment['showTimer'] then
        local hideTime = GetTime() + 3
        showTimer = C_Timer.NewTicker(0.01, function()
            ns.infoFrame.timer:SetText((string.format('%.1f', hideTime - GetTime())))
        end)
    end
    C_Timer.NewTimer(3, function()
        ns.infoFrame.text:SetText("")
        ns.infoFrame.icon:SetTexture(nil)
        if showTimer then
            showTimer:Cancel()
            ns.infoFrame.timer:SetText("")
        end
    end)
end

--Re init display in case settings changed
function ns:ResetDisplay()
    ns.infoFrame:ClearAllPoints()
    ns.infoFrame:SetPoint("CENTER", HarreksRampHelperDB.options.framePositionX, HarreksRampHelperDB.options.framePositionY)
    local text, icon, timer = '', 0, ''
    ns.infoFrame.text:SetText(text)
    ns.infoFrame.icon:SetTexture(icon)
    ns.infoFrame.timer:SetText(timer)
    HarreksRampHelperDB.options.toggleDisplay = false
end

--Sends a TTS message with some predefined parameters
function ns:SendTts(text)
    if HarreksRampHelperDB.options.ttsEnabled then
        C_VoiceChat.SpeakText(HarreksRampHelperDB.options.ttsVoice, text, Enum.VoiceTtsDestination.LocalPlayback, HarreksRampHelperDB.options.ttsRate, HarreksRampHelperDB.options.ttsVolume)
    end
end

--[[Format Functions]]--
--Removes decimals from a number
function ns:CutDecimals(time)
    return tonumber(string.format('%.0f', time))
end

--Convert a string of times separated by new lines into a table. If the time has phases marked by 'p#' then they go into a table indexed by the phase number, otherwise they go into main
function ns:ConvertTimesToTable(timeString)
    local timesTable = {
        main = {}
    }
    if timeString then
        for time in timeString:gmatch("[^\r\n]+") do
            local phase = nil
            if time:find(',') then
                for val in time:gmatch("([^,]+)") do
                    if val:find('p') then
                        phase = val:gsub(' p', '')
                    else
                        time = val
                    end
                end
            end
            if string.find(time, ':') then
                local timeSplit = {}
                for val in time:gmatch("([^:]+)") do
                    table.insert(timeSplit, tonumber(val))
                end
                time = timeSplit[1] * 60 + timeSplit[2]
            end
            if not phase then
                table.insert(timesTable.main, tonumber(time))
            else
                if not timesTable[phase] then
                    timesTable[phase] = {}
                end
                table.insert(timesTable[phase], tonumber(time))
            end
        end
    end
    return timesTable
end

--Convert from MRTNote format to Table to write into the DB
function ns:ConvertNoteToTable(noteString, spec, fightId, diffSlug)
    local toonName = UnitName("player")
    local timesTable = {}
    if noteString then
        for line in noteString:gmatch("[^\r\n]+") do
            if line:find(toonName) then
                local assignment = {
                    time = nil,
                    spells = {}
                }
                for data in line:gmatch("%b{}") do
                    if(data:find("time")) then
                        local time = data:gsub("%{time:", ""):gsub("%}", "")
                        if time:find(',') then
                            local values = {
                                time = nil,
                                phase = nil,
                                track = nil
                            }
                            for val in time:gmatch("([^,]+)") do
                                if val:find('S') then
                                    values.track = val
                                else
                                    values.time = val
                                end
                            end
                            for phase, identifier in pairs(ns.bosses[fightId].phases[diffSlug]) do
                                if values.track == identifier then
                                    values.phase = ' p' .. phase
                                    break
                                end
                            end
                            time = time:gsub(values.track, values.phase)
                        end
                        assignment.time = time
                        break
                    end
                end
                for spell in line:gmatch(toonName .. " %{spell:(%d+)%}") do
                    table.insert(assignment.spells, spell)
                end
                for _, spell in pairs(assignment.spells) do
                    if ns[spec]['cooldowns'][tonumber(spell)] then
                        if timesTable[spell] == nil then
                            timesTable[spell] = {}
                        end
                        table.insert(timesTable[spell], assignment.time)
                    end
                end
            end
        end
    end
    return timesTable
end

--Convert timings from the DB to a string with MRT format
function ns:ConvertTimingsToNote(spec, diffSlug, fightId)
    local timingsTable = HarreksRampHelperDB[spec][diffSlug][tostring(fightId)]
    local toonName = UnitName("player")
    local parsedTimingsTable = {}
    local orderedTable = {}
    for ramp, timingsString in pairs(timingsTable) do
        local rampTimes = ns:ConvertTimesToTable(timingsString)
        for phase, assignmentList in pairs(rampTimes) do
            for _, time in pairs(assignmentList) do
                local currentSpellId = nil
                for spellId, rampSpellName in pairs(ns[spec]['cooldowns']) do
                    if ramp == rampSpellName then
                        currentSpellId = spellId
                        break
                    end
                end
                local minutes = floor(mod(time,3600)/60)
                local seconds = floor(mod(time,60))
                local parsedTime = format("%02d:%02d", minutes, seconds)
                local indexString = nil
                if phase ~= "main" then
                    if ns.bosses[fightId].phases[diffSlug][tonumber(phase)] then
                        parsedTime = parsedTime .. ',' .. ns.bosses[fightId].phases[diffSlug][tonumber(phase)]
                    else
                        parsedTime = parsedTime .. ',p' .. phase
                    end
                    indexString = tonumber(phase) .. '-' .. time
                else
                    indexString = 0 .. '-' .. time
                end
                table.insert(orderedTable, indexString)
                parsedTimingsTable[indexString] = "{time:" .. parsedTime .. "} - " .. toonName .. " {spell:" .. currentSpellId .. "} "
            end
        end
    end
    table.sort(orderedTable, function(a, b) return a < b end)
    local parsedNoteString = ''
    for _, index in ipairs(orderedTable) do
        parsedNoteString = parsedNoteString .. parsedTimingsTable[index] .. "\n"
    end
    return parsedNoteString
end

--Cuts up an MRT note formatted phase change string to its components
function ns:FormatPhaseChangeString(phaseChangesString)
    local parts = {}
    for part in phaseChangesString:gmatch("[^:]+") do
        table.insert(parts, part)
    end
    parts = {
        ['event'] = parts[1],
        ['spell'] = parts[2],
        ['count'] = parts[3]
    }
    return parts
end
