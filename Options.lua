--Namespace
local _, ns = ...
local defaultOptions = {
    ['testing'] = {
        ['testMode'] = false
    }
}

local addonLoader = CreateFrame("Frame")
addonLoader:RegisterEvent("ADDON_LOADED")
addonLoader:RegisterEvent("PLAYER_LOGOUT")
addonLoader:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" and name == "HarreksHealerRampHelper" then
        ns.infoFrame.icon:SetTexture(4630480)
        if type(HarreksRampHelperDB) ~= 'table' then
            HarreksRampHelperDB = defaultOptions
        else
            for key, optionGroup in pairs(defaultOptions) do
                if not HarreksRampHelperDB[key] then
                    HarreksRampHelperDB[key] = {}
                end
                for option, value in pairs(optionGroup) do
                    if not HarreksRampHelperDB[key][option] then
                        HarreksRampHelperDB[key][option] = value
                    end
                end
            end
        end

        --Initialize options table
        local optionsTable = {
            type = "group",
            args = {
                timings = {
                    type = "group",
                    name = "Timings",
                    order = 1,
                    args = {
                        timingsDesc = {
                            type = "description",
                            name = "test desc",
                            order = 1,
                            fontSize = "medium"
                        }
                    }
                },
                options = {
                    type = "group",
                    name = "Options",
                    order = 2,
                    args = {

                    }
                },
                testing = {
                    type = "group",
                    name = "Testing",
                    order = 3,
                    args = {
                        testModeDescription = {
                            type = "description",
                            name = "When testing mode is enabled, starting combat with any entity will run the test timers for you current spec",
                            fontSize = "medium",
                            order = 1
                        },
                        testMode = {
                            type = "toggle",
                            name = "Enable Testing Mode",
                            order = 2,
                            get = function() return HarreksRampHelperDB.testing.testMode end,
                            set = function(_, testingEnabled) HarreksRampHelperDB.testing.testMode = testingEnabled end
                        }
                    }
                }
            },
        }

        --For each spec in the data file
        for specId, specName in pairs(ns.specs) do
            --Check HarreksRampHelperDB for existence of this spec
            if not HarreksRampHelperDB[specName] then
                HarreksRampHelperDB[specName] = {}
            end
            --Initialize test timers for this spec
            if not HarreksRampHelperDB[specName].testTimers then
                HarreksRampHelperDB[specName].testTimers = {}
            end
            local specTestTimers = {
                type = "group",
                name = specName .. ' Test Timers',
                args = {}
            }
            --Local variable to store the data for this spec
            local specTable = {
                type = "group",
                name = specName,
                args = {}
            }
            --For each difficulty in the data file
            for _, diff in pairs(ns.difficulties) do
                local diffSlug = diff.slug
                local diffName = diff.name
                --Check HarreksRampHelperDB if this difficulty exists for this spec
                if not HarreksRampHelperDB[specName][diffSlug] then
                    HarreksRampHelperDB[specName][diffSlug] = {}
                end
                --Add the difficulty as a group to the specTable
                specTable.args[diffSlug] = {
                    type = "group",
                    name = diffName,
                    args = {}
                }
                --For each encounter in the data file
                for encounterId, encounterName in pairs(ns.bosses) do
                    --Check HarreksRampHelperDB if this boss exists for this difficulty on this spec
                    if not HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)] then
                        HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)] = {}
                    end
                    --Local variable to store the ramp types
                    local rampTypeOptions = {}
                    --Get the ramp types from the data file of the spec
                    local rampTypes = ns[specName]['rampTypes']()
                    --Initialize string description of the spec's ramps
                    local specRampFiles = ""
                    local firstType = true
                    --For each type of ramp in the data
                    for type, assignments in pairs(rampTypes) do
                        --Check HarreksRampHelperDB if this rampType exists on this boss for this difficulty on this spec
                        if not HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] then
                            HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] = ""
                        end
                        --Add a multiline text input with the name of that ramp type
                        rampTypeOptions[diffSlug .. '-' .. encounterId ..'-' .. type] = {
                            type = "input",
                            multiline = 10,
                            name = type,
                            width = 1.3,
                            set = function(_, val) HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] = val end,
                            get = function() return HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] end
                        }
                        --Add this type of ramp to the test timers
                        specTestTimers.args[type] = {
                            type = "input",
                            multiline = 10,
                            name = type,
                            width = 1.3,
                            set = function(_, val) HarreksRampHelperDB[specName].testTimers[type] = val end,
                            get = function() return HarreksRampHelperDB[specName].testTimers[type] end
                        }
                        --Build string description of the ramps
                        if firstType then
                            firstType = false
                        else
                            specRampFiles = specRampFiles .. '\n\n'
                        end
                        specRampFiles = specRampFiles .. type .. ' Ramps\n'
                        for _, assignment in pairs(assignments) do
                            specRampFiles = specRampFiles .. "- '" .. assignment['text'] .. "'"
                            if assignment['dynamic'] then
                                specRampFiles = specRampFiles .. ' on a dynamic time depending on charges'
                            else
                                specRampFiles = specRampFiles .. ' ' .. assignment['offset'] .. ' seconds before the timer'
                            end
                            specRampFiles = specRampFiles .. '\n'
                        end
                    end
                    --Add the string description of the ramps to as content in the spec option
                    specTable.args.ramps = {
                        type = "description",
                        name = specRampFiles,
                        fontSize = "medium"
                    }
                    --Add the ramp types for this fight to the appropriate difficulty in the specTable
                    specTable.args[diffSlug].args[tostring(encounterId)] = {
                        type = "group",
                        name = encounterName,
                        args = rampTypeOptions
                    }
                end
            end
            --Add spec table to the main config table
            optionsTable.args.timings.args[specName] = specTable
            --Add test timers to main config table
            optionsTable.args.testing.args[specName] = specTestTimers
        end

        LibStub("AceConfig-3.0"):RegisterOptionsTable("Harrek's Healer Ramp Helper", optionsTable)
        local optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Harrek's Healer Ramp Helper", "Harrek's Ramp Helper")
        SLASH_HARREKSRAMPHELPER1 = "/hrh"

        SlashCmdList.HARREKSRAMPHELPER = function(msg, editBox)
            Settings.OpenToCategory(optionsFrame.name)
        end
    end
end)
