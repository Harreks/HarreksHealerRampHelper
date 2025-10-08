--[[Initialization]]--
local _, ns = ...

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
    ns.phaseEventsTrigger:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
        if ns.fightAssignments[tostring(phase)]['static'][formattedTime] then
            for index, assignment in pairs(ns.fightAssignments[tostring(phase)]['static'][formattedTime]) do
                if not assignment['loaded'] then
                    ns:ShowAssignment(assignment)
                    ns.fightAssignments[tostring(phase)]['static'][formattedTime][index]['loaded'] = true
                end
            end
        end
        ns:ComputeDynamicAssignments(formattedTime, phase)
    end
end
