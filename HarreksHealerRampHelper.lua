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
local infoFrame = CreateFrame("FRAME", nil, UIParent) --The info frame is the containter for the whole display
infoFrame:SetWidth(1)
infoFrame:SetHeight(1)
infoFrame:SetPoint("CENTER", 0, 200)
infoFrame:SetFrameStrata("TOOLTIP")
infoFrame.text = infoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") --Text is the text that will be displayed
infoFrame.text:SetPoint("CENTER")
infoFrame.text:SetScale(2)
infoFrame.text:SetShadowColor(0, 0, 0, 1)
infoFrame.text:SetShadowOffset(-2, -2)
infoFrame.icon = infoFrame:CreateTexture(nil, "OVERLAY") --Icon that will be displayed
infoFrame.icon:SetSize(48, 48)
infoFrame.icon:SetPoint("CENTER", 0, 40)
infoFrame.timer = infoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") --Timer to be shown for the assignments marked with showTimer
infoFrame.timer:SetPoint("CENTER", 0, 15)
infoFrame.timer:SetScale(2.5)
infoFrame.timer:SetShadowColor(0, 0, 0, 1)
infoFrame.timer:SetShadowOffset(-2, -2)
ns.infoFrame = infoFrame
--Timer Frames
local startTimer = CreateFrame("Frame"); --The frame that runs the functions on encounter start
startTimer:RegisterEvent("PLAYER_REGEN_DISABLED");
startTimer:RegisterEvent("ENCOUNTER_START");
startTimer:SetScript("OnEvent", function(_, event, encounterId, _, difficultyId)
    if event == "ENCOUNTER_START" or (event == "PLAYER_REGEN_DISABLED" and HarreksRampHelperDB.testing.testMode) then
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
        local haste = GetHaste() / 1000
        for spellId, spell in pairs(ns[specName]['spells']) do
            if spell['charges'] then
                local spellCd = C_Spell.GetSpellCharges(spellId)
                ns[specName]['spells'][spellId]['cd'] = tonumber(string.format('%.1f', spellCd.cooldownDuration))
            else
                local spellCd = GetSpellBaseCooldown(spellId)
                ns[specName]['spells'][spellId]['cd'] = tonumber(string.format('%.1f', (spellCd / 1000) / ( 1 + haste)))
            end
        end
    end
end

--[[Assignment Functions]]--
--Creates the assignments to be displayed, using info from the spec file. static assignments run on a fixed time and dynamic assignments depend on a charged spell cooldown
function ns:SetupTimings(event, encounterId, difficultyId)
    ns.fightAssignments = {
        ['static'] = {},
        ['dynamic'] = {}
    }
    local rampTypesTable = ns[specName]['rampTypes']()
    for type, _ in pairs(rampTypesTable) do
        local fightTimings
        if event == "ENCOUNTER_START" then
            fightTimings =  HarreksRampHelperDB[specName][ns.difficulties[difficultyId]['slug']][encounterId][type]
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
                            ['spellId'] = assignment['spellId']
                        }
                    else
                        ns.fightAssignments['static'][assignmentTime] = {
                            ['text'] = assignment['text'],
                            ['icon'] = assignment['icon'],
                            ['loaded'] = false,
                            ['showTimer'] = assignment['showTimer']
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

--[[Display Functions]]--
--Showing an assignment involved updating the icon and text of the infoFrame, and sending the text as TTS. The timer is shown if the assignment has the showTimer flag set to true
function ns:ShowAssignment(assignment, displayTime)
    infoFrame.text:SetText(assignment['text'])
    infoFrame.icon:SetTexture(assignment['icon'])
    ns:SendTts(assignment['text'])
    local showTimer = nil
    if assignment['showTimer'] then
        showTimer = C_Timer.NewTicker(0.01, function()
            infoFrame.timer:SetText((string.format('%.1f', (displayTime + 3) - (GetTime() - timerStartTime))))
        end)
    end
    C_Timer.NewTimer(3, function()
        infoFrame.text:SetText("")
        infoFrame.icon:SetTexture(nil)
        if showTimer then
            showTimer:Cancel()
            infoFrame.timer:SetText("")
        end
    end)

end

--Sends a TTS message with some predefined parameters
function ns:SendTts(text)
    C_VoiceChat.SpeakText(1, text, Enum.VoiceTtsDestination.LocalPlayback, -1, 100)
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