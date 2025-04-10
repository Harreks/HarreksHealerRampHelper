--[[Initialization]]--
--Namespace
local _, ns = ...
--Timer Variables
local currentTimer = 0
local timerStartTime = nil
local timerRunning = false
local runningTimer = nil
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
local startTimer = CreateFrame("Frame"); --The frame that runs the functions on encounter start
startTimer:RegisterEvent("PLAYER_REGEN_DISABLED");
startTimer:RegisterEvent("ENCOUNTER_START");
startTimer:SetScript("OnEvent", function(_, event, encounterId, _, difficultyId)
    if (event == "ENCOUNTER_START" and ns.difficulties[difficultyId] and ns.bosses[encounterId]) or (event == "PLAYER_REGEN_DISABLED" and HarreksRampHelperDB.testing.testMode) then
        ns:SetPlayerSpec()
        if specSupported then
            ns:SetupTimings(event, encounterId, difficultyId)
            ns:StartTimer()
        end
    end
end)
local stopTimer = CreateFrame("Frame"); --Frame that stops the timer on encounter end
stopTimer:RegisterEvent("ENCOUNTER_END");
stopTimer:RegisterEvent("PLAYER_REGEN_ENABLED");
stopTimer:SetScript("OnEvent", function(_, event)
    if event == "ENCOUNTER_END" or (event == "PLAYER_REGEN_ENABLED" and HarreksRampHelperDB.testing.testMode) then
        ns:StopTimer()
    end
end)

--[[Timer Functions]]--
--When encounter starts, this function starts the fight timer and creates a ticker to check twice every second if any assignment is due to be shown
function ns:StartTimer()
    timerStartTime = GetTime()
    timerRunning = true
    runningTimer = C_Timer.NewTicker(0.5, function()
        currentTimer = GetTime() - timerStartTime
        local formattedTime = ns:CutDecimals(currentTimer)
        if ns.fightAssignments['static'][formattedTime] and not ns.fightAssignments['static'][formattedTime]['loaded'] then
            ns:ShowAssignment(ns.fightAssignments['static'][formattedTime], formattedTime)
            ns.fightAssignments['static'][formattedTime]['loaded'] = true
        end
        ns:ComputeDynamicAssignments(formattedTime)
    end)
end

--On encounter end, stops the timer
function ns:StopTimer()
    if timerRunning and runningTimer ~= nil then
        runningTimer:Cancel()
        timerRunning = false
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
    ns.fightAssignments = {
        ['static'] = {},
        ['dynamic'] = {}
    }
    local rampTypesTable = ns[specName]['rampTypes']()
    for type, _ in pairs(rampTypesTable) do
        local fightTimings
        if event == "ENCOUNTER_START" then
            local difficultySlug = ns.difficulties[difficultyId]['slug']
            fightTimings =  HarreksRampHelperDB[specName][difficultySlug][tostring(encounterId)][type]
        elseif HarreksRampHelperDB.testing.testMode then
            fightTimings = HarreksRampHelperDB[specName].testTimers[type]
        end
        fightTimings = ns:ConvertTimesToTable(fightTimings)
        for _, timing in pairs(fightTimings) do
            for _, assignment in pairs(rampTypesTable[type]) do
                local assignmentTime = ns:CutDecimals(timing - assignment['offset'])
                if assignmentTime >= 0 then
                    if assignment['dynamic'] then
                        ns.fightAssignments['dynamic'][assignmentTime] = {
                            ['text'] = assignment['text'],
                            ['icon'] = assignment['icon'],
                            ['loaded'] = false,
                            ['spellId'] = assignment['spellId'],
                            ['tts'] = assignment['tts'] or nil
                        }
                    else
                        ns.fightAssignments['static'][assignmentTime] = {
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

--The time to show a dynamic assignment depends on how you are using the charges, this compares the potential cooldown of the spell with the remaining time before the assignment to see if it should be shown
function ns:ComputeDynamicAssignments(currentTime)
    for time, assignment in pairs(ns.fightAssignments['dynamic']) do
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
                ns:ShowAssignment(assignment, currentTime)
                ns.fightAssignments['dynamic'][time]['loaded'] = true
            end
        end
    end
end

--Gets either the actual cooldown or the base cooldown of a spell depending on if haste as been computed
function ns:GetRealCooldown(spec, spellId)
    return ns[spec]['spells'][spellId]['cd'] or ns[spec]['spells'][spellId]['baseCd']
end

--[[Display Functions]]--
--Showing an assignment involved updating the icon and text of the infoFrame, and sending the text as TTS. The timer is shown if the assignment has the showTimer flag set to true
function ns:ShowAssignment(assignment, displayTime)
    ns.infoFrame.text:SetText(assignment['text'])
    ns.infoFrame.icon:SetTexture(assignment['icon'])
    ns:SendTts(assignment['tts'] or assignment['text'])
    local showTimer = nil
    if assignment['showTimer'] then
        showTimer = C_Timer.NewTicker(0.01, function()
            ns.infoFrame.timer:SetText((string.format('%.1f', (displayTime + 3) - (GetTime() - timerStartTime))))
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

--Convert a string of times separated by new lines into a table
function ns:ConvertTimesToTable(timeString)
    local timesTable = {}
    if timeString then
        for time in timeString:gmatch("[^\r\n]+") do
            if string.find(time, ':') then
                local timeSplit = {}
                for val in time:gmatch("([^:]+)") do
                    table.insert(timeSplit, tonumber(val))
                end
                time = timeSplit[1] * 60 + timeSplit[2]
            end
            table.insert(timesTable, tonumber(time))
        end
    end
    return timesTable
end

--Convert from MRTNote format to Table to write into the DB
function ns:ConvertNoteToTable(noteString)
    local timesTable = {}
    if noteString then
        for line in noteString:gmatch("[^\r\n]+") do
            local assignment = {
                time = nil,
                spell = nil
            }
            for data in line:gmatch("%b{}") do
                if(data:find("time")) then
                    local time = data:gsub("%{time:", ""):gsub("%}", "")
                    assignment.time = time
                elseif(data:find("spell")) then
                    local spell = data:gsub("%{spell:", ""):gsub("%}", "")
                    assignment.spell = spell
                end
            end
            if timesTable[assignment.spell] == nil then
                timesTable[assignment.spell] = {}
            end
            table.insert(timesTable[assignment.spell], assignment.time)
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
        for _, time in pairs(rampTimes) do
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
            table.insert(orderedTable, time)
            parsedTimingsTable[time] = "{time:" .. parsedTime .. "} - " .. toonName .. " {spell:" .. currentSpellId .. "}"
        end
    end
    table.sort(orderedTable, function(a, b) return a < b end)
    local parsedNoteString = ''
    for _, time in ipairs(orderedTable) do
        parsedNoteString = parsedNoteString .. parsedTimingsTable[time] .. "\n"
    end
    return parsedNoteString
end