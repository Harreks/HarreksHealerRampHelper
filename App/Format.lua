--[[Initialization]]--
local _, ns = ...

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
            local lineError = nil
            if line:find(toonName) and line:find("{spell:") then
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
                            if values.phase then
                                time = time:gsub(values.track, values.phase)
                            else
                                lineError = true
                            end
                        end
                        assignment.time = time
                        break
                    end
                end
                for spell in line:gmatch(toonName .. " %{spell:(%d+)%}") do
                    table.insert(assignment.spells, spell)
                end
                if lineError then
                    ns:WriteOutput("The line |cffffd100" .. line .. "|r isn't properly formatted or refers to a boss phase not set up, it is being ignored.")
                else
                    local spellList = ns:GetFullSpellList(spec)
                    for _, spell in pairs(assignment.spells) do
                        if spellList[tonumber(spell)] then
                            if timesTable[spell] == nil then
                                timesTable[spell] = {}
                            end
                            table.insert(timesTable[spell], assignment.time)
                        end
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
    local spellList = ns:GetFullSpellList(spec)
    for ramp, timingsString in pairs(timingsTable) do
        local rampTimes = ns:ConvertTimesToTable(timingsString)
        for phase, assignmentList in pairs(rampTimes) do
            for _, time in pairs(assignmentList) do
                local currentSpellId = nil
                for spellId, rampSpellName in pairs(spellList) do
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


--Get all spells (cooldowns, ramps, utilities) of a given spec in a single table with format [id] => 'name'
function ns:GetFullSpellList(specName)
    local spellList = {}
    for id, spell in pairs(ns[specName]['cooldowns']) do
        spellList[id] = spell
    end
    for id, spell in pairs(ns[specName]['ramps']) do
        spellList[id] = spell
    end
    for id, spell in pairs(ns[specName]['utilities']) do
        spellList[id] = spell
    end
    return spellList
end