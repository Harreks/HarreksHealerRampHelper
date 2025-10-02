--[[Initialization]]--
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
ns.specName = nil
ns.specSupported = false
ns.fightAssignments = {}
ns.frames = {}
--Timer Frames
ns.phaseEvents = CreateFrame("Frame") --Frame that handles phase changing
ns.phaseEvents:SetScript("OnEvent", function()
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
        if ns.specSupported then
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
