--Namespace
local _, ns = ...
local defaultOptions = {
    ['testing'] = {
        ['testMode'] = false
    },
    ['options'] = {
        ['toggleDisplay'] = false,
        ['framePositionX'] = 0,
        ['framePositionY'] = 200,
        ['textSize'] = 2,
        ['timerSize'] = 2.5,
        ['iconSizeW'] = 48,
        ['iconSizeH'] = 48
    }
}

local addonLoader = CreateFrame("Frame")
addonLoader:RegisterEvent("ADDON_LOADED")
addonLoader:RegisterEvent("PLAYER_LOGOUT")
addonLoader:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" and name == "HarreksHealerRampHelper" then
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
        --Initialize configurations
        HarreksRampHelperDB.options.toggleDisplay = false
        ns.infoFrame.text:SetScale(HarreksRampHelperDB.options.textSize)
        ns.infoFrame.timer:SetScale(HarreksRampHelperDB.options.timerSize)
        ns.infoFrame.icon:SetSize(HarreksRampHelperDB.options.iconSizeW, HarreksRampHelperDB.options.iconSizeH)
        ns:ResetDisplay()

        --Initialize options table
        local optionsTable = {
            type = "group",
            childGroups = "tree",
            args = {
                timings = {
                    type = "group",
                    name = "Timings",
                    order = 1,
                    args = {
                        timingsDesc = {
                            type = "description",
                            name = "The Healer Ramp Helper is a tool designed to help healers manage their cooldowns in order to properly execute ramps. It works similarly to " ..
                            "assigning every part of a ramp's instructions as warnings or reminders but facilitates this process by automatically creating reminders for all the steps based " ..
                            "on the best recommended practices for the spec. Inside the timings menu you will find all the specs currently supported and different menus for each " ..
                            "boss on each difficulty.\n\nOpening the Ramp Types menu for each spec will show you all the current configured ramps for that spec and what reminders they consist of, " ..
                            "typing a timer in the 'mm:ss' or 'ss' formats in the corresponding window for each ramp on a boss will create all the assignments for that ramp at that time " ..
                            "when that boss is pulled.\n\nTo change the size or style of the reminders head to the Options menu, to test the addon on a dummy head to the Testing menu and " ..
                            "turn on Testing Mode, which will pull from the test timers for your spec when you start combat.\n\nTo note, we do not currently support automatically grabbing " ..
                            "your assigned timers from an MRT note, but are working on implementing this. For the time being, you have to write down your ramp timings in the appropriate window " ..
                            "for the addon to work.\n\nIf you have any comment or question, feel free to let me know in any of the places listed below, and thank you for using the addon." ..
                            "\n\n-Harrek\n\n",
                            order = 1,
                            fontSize = "medium"
                        },
                        sbpDiscord = {
                            type = "execute",
                            name = "Spiritbloom.Pro Discord",
                            order = 2,
                            width = 1.5,
                            func = function()
                                local AceGUI = LibStub("AceGUI-3.0")
                                local frame = AceGUI:Create("Window")
                                frame:SetTitle("Spiritbloom.Pro Discord")
                                frame:SetWidth(300)
                                frame:SetHeight(80)
                                frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
                                local textBox = AceGUI:Create("EditBox")
                                textBox:SetFullWidth(true)
                                textBox:SetText("discord.spiritbloom.pro")
                                textBox:HighlightText()
                                textBox:SetFocus()
                                frame:AddChild(textBox)
                            end
                        },
                        evokerDiscord = {
                            type = "execute",
                            name = "Wyrmrest Temple Discord",
                            order = 3,
                            width = 1.5,
                            func = function()
                                local AceGUI = LibStub("AceGUI-3.0")
                                local frame = AceGUI:Create("Window")
                                frame:SetTitle("Wyrmrest Temple Discord")
                                frame:SetWidth(300)
                                frame:SetHeight(80)
                                frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
                                local textBox = AceGUI:Create("EditBox")
                                textBox:SetFullWidth(true)
                                textBox:SetText("https://discord.gg/evoker")
                                textBox:HighlightText()
                                textBox:SetFocus()
                                frame:AddChild(textBox)
                            end
                        },
                        cursePage = {
                            type = "execute",
                            name = "CurseForge AddOn Page",
                            order = 4,
                            width = 1.5,
                            func = function()
                                local AceGUI = LibStub("AceGUI-3.0")
                                local frame = AceGUI:Create("Window")
                                frame:SetTitle("CurseForge AddOn Page")
                                frame:SetWidth(300)
                                frame:SetHeight(80)
                                frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
                                local textBox = AceGUI:Create("EditBox")
                                textBox:SetFullWidth(true)
                                textBox:SetText("NYI")
                                textBox:HighlightText()
                                textBox:SetFocus()
                                frame:AddChild(textBox)
                            end
                        }
                    }
                },
                options = {
                    type = "group",
                    name = "Options",
                    order = 2,
                    args = {
                        toggleDisplay = {
                            type = "execute",
                            name = "Toggle Display",
                            width = 1.3,
                            order = 1,
                            func = function()
                                local showing = HarreksRampHelperDB.options.toggleDisplay
                                local text, icon, timer
                                if showing then
                                    text, icon, timer = '', 0, ''
                                    HarreksRampHelperDB.options.toggleDisplay = false
                                else
                                    text, icon, timer = 'Ramp Helper', 450907, '2.3'
                                    HarreksRampHelperDB.options.toggleDisplay = true
                                end
                                ns.infoFrame.text:SetText(text)
                                ns.infoFrame.icon:SetTexture(icon)
                                ns.infoFrame.timer:SetText(timer)
                            end
                        },
                        resetDefaults = {
                            type = "execute",
                            name = "Reset Default Settings",
                            width = 1.3,
                            order = 2,
                            func = function()
                                for option, defaultValue in pairs(defaultOptions.options) do
                                    HarreksRampHelperDB.options[option] = defaultValue
                                end
                                ns:ResetDisplay()
                                ns.infoFrame.text:SetScale(HarreksRampHelperDB.options.textSize)
                                ns.infoFrame.timer:SetScale(HarreksRampHelperDB.options.timerSize)
                                ns.infoFrame.icon:SetSize(HarreksRampHelperDB.options.iconSizeW, HarreksRampHelperDB.options.iconSizeH)
                            end
                        },
                        positionHeader = {
                            type = "header",
                            name = "Position",
                            order = 10
                        },
                        framePositionX = {
                            type = "range",
                            name = "Display X Position",
                            width = 1.3,
                            softMin = -1000,
                            softMax = 1000,
                            order = 11,
                            step = 1,
                            bigStep = 10,
                            get = function() return HarreksRampHelperDB.options.framePositionX end,
                            set = function(_, valueX)
                                HarreksRampHelperDB.options.framePositionX = valueX
                                ns.infoFrame:ClearAllPoints()
                                ns.infoFrame:SetPoint("CENTER", valueX, HarreksRampHelperDB.options.framePositionY)
                            end
                        },
                        framePositionY = {
                            type = "range",
                            name = "Display Y Position",
                            width = 1.3,
                            softMin = -1000,
                            softMax = 1000,
                            order = 12,
                            step = 1,
                            bigStep = 10,
                            get = function() return HarreksRampHelperDB.options.framePositionY end,
                            set = function(_, valueY)
                                HarreksRampHelperDB.options.framePositionY = valueY
                                ns.infoFrame:ClearAllPoints()
                                ns.infoFrame:SetPoint("CENTER", HarreksRampHelperDB.options.framePositionX, valueY)
                            end
                        },
                        sizeHeader = {
                            type = "header",
                            name = "Size",
                            order = 20
                        },
                        textSize = {
                            type = "range",
                            name = "Main Text Size",
                            width = 1.3,
                            min = 0.5,
                            softMin = 0.5,
                            max = 5,
                            softMax = 5,
                            order = 21,
                            step = 0.1,
                            bigStep = 0.1,
                            get = function() return HarreksRampHelperDB.options.textSize end,
                            set = function(_, size)
                                HarreksRampHelperDB.options.textSize = size
                                ns.infoFrame.text:SetScale(size)
                            end
                        },
                        timerSize = {
                            type = "range",
                            name = "Timer Text Size",
                            width = 1.3,
                            min = 0.5,
                            softMin = 0.5,
                            max = 5,
                            softMax = 5,
                            order = 22,
                            step = 0.1,
                            bigStep = 0.1,
                            get = function() return HarreksRampHelperDB.options.timerSize end,
                            set = function(_, size)
                                HarreksRampHelperDB.options.timerSize = size
                                ns.infoFrame.timer:SetScale(size)
                            end
                        },
                        iconSizeW = {
                            type = "range",
                            name = "Icon Width",
                            width = 1.3,
                            min = 10,
                            softMin = 10,
                            max = 200,
                            softMax = 200,
                            order = 23,
                            step = 1,
                            bigStep = 2,
                            get = function() return HarreksRampHelperDB.options.iconSizeW end,
                            set = function(_, size)
                                HarreksRampHelperDB.options.iconSizeW = size
                                ns.infoFrame.icon:SetSize(size, HarreksRampHelperDB.options.iconSizeH)
                            end
                        },
                        iconSizeH = {
                            type = "range",
                            name = "Icon Height",
                            width = 1.3,
                            min = 10,
                            softMin = 10,
                            max = 200,
                            softMax = 200,
                            order = 23,
                            step = 1,
                            bigStep = 2,
                            get = function() return HarreksRampHelperDB.options.iconSizeH end,
                            set = function(_, size)
                                HarreksRampHelperDB.options.iconSizeH = size
                                ns.infoFrame.icon:SetSize(HarreksRampHelperDB.options.iconSizeW, size)
                            end
                        }
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
                childGroups = "tab",
                args = {
                    fights = {
                        type = "group",
                        name = "Fights",
                        order = 1,
                        args = {}
                    },
                    ramps = {
                        type = "group",
                        name = "Ramp Types",
                        order = 2,
                        args = {}
                    }
                }
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
                specTable.args.fights.args[diffSlug] = {
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
                            multiline = 6,
                            name = type,
                            desc = "Input the timings you will execute this ramp on, in the mm:ss format, each time in a new line",
                            width = "full",
                            set = function(_, val) HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] = val end,
                            get = function() return HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] end
                        }
                        --Add this type of ramp to the test timers
                        specTestTimers.args[type] = {
                            type = "input",
                            multiline = 6,
                            name = type,
                            width = "full",
                            set = function(_, val) HarreksRampHelperDB[specName].testTimers[type] = val end,
                            get = function() return HarreksRampHelperDB[specName].testTimers[type] end
                        }
                        --Build string description of the ramps
                        if firstType then
                            firstType = false
                        else
                            specRampFiles = specRampFiles .. '\n\n'
                        end
                        specRampFiles = specRampFiles .. '|cffffd100' .. type .. ' Ramps|r \n'
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
                    specTable.args.ramps.args.desc = {
                        type = "description",
                        name = specRampFiles,
                        fontSize = "medium"
                    }
                    --Add the ramp types for this fight to the appropriate difficulty in the specTable
                    specTable.args.fights.args[diffSlug].args[tostring(encounterId)] = {
                        type = "group",
                        name = encounterName,
                        args = rampTypeOptions,
                        order = encounterId
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
    elseif event == "PLAYER_LOGOUT" then
    end
end)
