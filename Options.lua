--Namespace
local _, ns = ...
local next = next
local version = "1.2.4"
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
        ['iconSizeH'] = 48,
        ['ttsEnabled'] = true,
        ['ttsVoice'] = 1,
        ['ttsRate'] = -1,
        ['ttsVolume'] = 100,
        ['preReqsOnly'] = false,
        ['readFromNote'] = false,
        ['mrtPersonalNote'] = false
    },
    ['import'] = {
        ['fight'] = nil,
        ['difficulty'] = nil,
        ['importText'] = nil
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
        HarreksRampHelperDB.import.fight = nil
        HarreksRampHelperDB.import.difficulty = nil
        HarreksRampHelperDB.import.importText = nil
        ns.infoFrame.text:SetScale(HarreksRampHelperDB.options.textSize)
        ns.infoFrame.timer:SetScale(HarreksRampHelperDB.options.timerSize)
        ns.infoFrame.icon:SetSize(HarreksRampHelperDB.options.iconSizeW, HarreksRampHelperDB.options.iconSizeH)
        local defaultOptionWidth = 1.2
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
                            "\n\n-Harrek\n\nAddon Version: " .. version .. "\n\n",
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
                                textBox:SetText("https://www.curseforge.com/wow/addons/harreks-healer-ramp-helper")
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                            width = defaultOptionWidth,
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
                        },
                        ttsHeader = {
                            type = "header",
                            name = "Text to Speech",
                            order = 30
                        },
                        ttsPlay = {
                            type = "execute",
                            name = "Play Voice",
                            desc = "Plays a message to test the TTS. This won't work if TTS is disabled",
                            width = defaultOptionWidth,
                            order = 31,
                            func = function()
                                ns:SendTts('Healer Ramp Helper')
                            end
                        },
                        ttsEnabled = {
                            type = "toggle",
                            name = "Enable Text to Speech",
                            width = defaultOptionWidth,
                            order = 32,
                            get = function() return HarreksRampHelperDB.options.ttsEnabled end,
                            set = function(_, value) HarreksRampHelperDB.options.ttsEnabled = value end
                        },
                        ttsVoice = {
                            type = "select",
                            name = "Voice",
                            width = defaultOptionWidth,
                            order = 33,
                            values = function()
                                local voices = {}
                                for _, voice in pairs(C_VoiceChat.GetTtsVoices()) do
                                    voices[voice.voiceID] = voice.name
                                end
                                return voices
                            end,
                            get = function() return HarreksRampHelperDB.options.ttsVoice end,
                            set = function(_, voice) HarreksRampHelperDB.options.ttsVoice = voice end
                        },
                        ttsRate = {
                            type = "range",
                            name = "Rate",
                            width = defaultOptionWidth,
                            min = -10,
                            softMin = -10,
                            max = 10,
                            softMax = 10,
                            order = 34,
                            step = 1,
                            bigStep = 0.5,
                            get = function() return HarreksRampHelperDB.options.ttsRate end,
                            set = function(_, rate) HarreksRampHelperDB.options.ttsRate = rate end
                        },
                        ttsVolume = {
                            type = "range",
                            name = "Volume",
                            width = defaultOptionWidth,
                            min = 0,
                            softMin = 0,
                            max = 100,
                            softMax = 100,
                            order = 35,
                            step = 1,
                            bigStep = 5,
                            get = function() return HarreksRampHelperDB.options.ttsVolume end,
                            set = function(_, volume) HarreksRampHelperDB.options.ttsVolume = volume end
                        },
                        mrtHeader = {
                            type = "header",
                            name = "Using MRT Note",
                            order = 40
                        },
                        mrtDescription = {
                            type = "description",
                            name = "When one or both of options below is enabled, your manually input or imported timings are ignored, and instead the addon Will grab from the selected MRT option(s).",
                            order = 41
                        },
                        readFromNote = {
                            type = "toggle",
                            name = "Read From Main MRT Note",
                            desc = "Load assignments from the main MRT Note.",
                            width = defaultOptionWidth,
                            order = 42,
                            get = function() return HarreksRampHelperDB.options.readFromNote end,
                            set = function(_, value) HarreksRampHelperDB.options.readFromNote = value end
                        },
                        mrtPersonalNote = {
                            type = "toggle",
                            name = "Read From Personal MRT Note",
                            desc = "Load assignments from the personal MRT Note.",
                            width = defaultOptionWidth,
                            order = 43,
                            get = function() return HarreksRampHelperDB.options.mrtPersonalNote end,
                            set = function(_, value) HarreksRampHelperDB.options.mrtPersonalNote = value end
                        },
                        extraHeader = {
                            type = "header",
                            name = "Extra Options",
                            order = 50
                        },
                        preReqsOnly = {
                            type = "toggle",
                            name = "Only Prerequisites Mode",
                            desc = "All the setup steps for a ramp are considered prerequisites, while the final cooldown button press is not. In this mode you will still be shown all " ..
                                "the setup steps, but not the final warning to consume the ramp. In case you have another addon or weakaura that warns you of that.",
                            width = defaultOptionWidth,
                            order = 51,
                            get = function() return HarreksRampHelperDB.options.preReqsOnly end,
                            set = function(_, value) HarreksRampHelperDB.options.preReqsOnly = value end
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
            --Get the ramp types from the data file of the spec
            local rampTypes = ns[specName]['rampTypes']()
            --Initialize string description of the spec's ramps
            local specRampFiles = ""
            local firstType = true
            --For each type of ramp in the data
            for type, assignments in pairs(rampTypes) do
                --Build string description of the ramps
                if firstType then
                    firstType = false
                else
                    specRampFiles = specRampFiles .. '\n\n'
                end
                specRampFiles = specRampFiles .. '|cffffd100' .. type .. '|r\n'
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
                        args = {
                            desc = {
                            type = "description",
                            name = specRampFiles,
                            fontSize = "medium"
                        }}
                    },
                    --Import and export functionality
                    importExport = {
                        type = "group",
                        name = "Import/Export",
                        order = 3,
                        args = {
                            importHeader = {
                                type = "header",
                                name = "MRT Note import and export",
                                order = 0
                            },
                            importFight = {
                                type = "select",
                                name = "Fight",
                                order = 1,
                                width = defaultOptionWidth,
                                values = function()
                                    local fights = {}
                                    for fightId, fight in pairs(ns.bosses) do
                                        fights[fightId] = fight.name
                                    end
                                    return fights
                                end,
                                get = function() return HarreksRampHelperDB.import.fight end,
                                set = function(_, fightId) HarreksRampHelperDB.import.fight = fightId end
                            },
                            importDifficulty = {
                                type = "select",
                                name = "Difficulty",
                                order = 2,
                                width = defaultOptionWidth,
                                values = function()
                                    local difficulties = {}
                                    for diffId, diff in pairs(ns.difficulties) do
                                        difficulties[diffId] = diff.name
                                    end
                                    return difficulties
                                end,
                                get = function() return HarreksRampHelperDB.import.difficulty end,
                                set = function(_, diffId) HarreksRampHelperDB.import.difficulty = diffId end
                            },
                            pasteDefault = {
                                type = "execute",
                                name = "Paste Default Assignments For This Boss",
                                order = 3,
                                width = defaultOptionWidth * 2,
                                func = function()
                                    local fightId = HarreksRampHelperDB.import.fight
                                    local diffId = HarreksRampHelperDB.import.difficulty
                                    local diffSlug = ns.difficulties[diffId].slug
                                    local defaultText = ns[specName]['defaultAssignments'][fightId]['assignments'][diffSlug]
                                    if defaultText == "" then
                                        ns:WriteOutput('There are currently no default assignments setup for ' .. specName .. ' on ' .. ns.difficulties[diffId].name .. ' ' .. ns.bosses[fightId].name)
                                    else
                                        HarreksRampHelperDB.import.importText = defaultText
                                        ns:WriteOutput('Pasted default assignments for ' .. specName .. ' on ' .. ns.difficulties[diffId].name .. ' ' .. ns.bosses[fightId].name)
                                    end
                                end
                            },
                            importText = {
                                type = "input",
                                name = "Import Text",
                                order = 4,
                                multiline = 15,
                                width = "full",
                                set = function(_, val) HarreksRampHelperDB.import.importText = val end,
                                get = function() return HarreksRampHelperDB.import.importText end,
                                validate = function(_, val)
                                    local containsToonName = string.find(val, UnitName("player"))
                                    if containsToonName then
                                        return true
                                    else
                                        return "The imported text doesn't contain the name of your current character, no timings would be imported. Make sure you are importing an MRT Note that has " ..
                                        "correctly formatted assignments that match your in-game name."
                                    end
                                end
                            },
                            importButton = {
                                type = "execute",
                                name = "Import Timers",
                                order = 5,
                                width = defaultOptionWidth,
                                func = function()
                                    local fightId = HarreksRampHelperDB.import.fight
                                    local diffId = HarreksRampHelperDB.import.difficulty
                                    local importText = HarreksRampHelperDB.import.importText
                                    if fightId and diffId and importText then
                                        local diffSlug = ns.difficulties[diffId].slug
                                        local timers = ns:ConvertNoteToTable(importText, specName, fightId, diffSlug)
                                        for type, _ in pairs(HarreksRampHelperDB[specName][diffSlug][tostring(fightId)]) do
                                            HarreksRampHelperDB[specName][diffSlug][tostring(fightId)][type] = ''
                                        end
                                        for spell, timings in pairs(timers) do
                                            local rampType = ns[specName]['cooldowns'][tonumber(spell)]
                                            if rampType then
                                                local timingsString = ''
                                                for _, time in pairs(timings) do
                                                    timingsString = timingsString .. time .. '\n'
                                                end
                                                HarreksRampHelperDB[specName][diffSlug][tostring(fightId)][rampType] = timingsString
                                            end
                                        end
                                        HarreksRampHelperDB.import.importText = '';
                                        ns:WriteOutput('Successfully imported ' .. specName .. ' timings for ' .. ns.difficulties[diffId].name .. ' ' .. ns.bosses[fightId].name)
                                    end
                                end
                            },
                            exportButton = {
                                type = "execute",
                                name = "Export Timers",
                                order = 6,
                                width = defaultOptionWidth,
                                func = function()
                                    local fightId = HarreksRampHelperDB.import.fight
                                    local diffId = HarreksRampHelperDB.import.difficulty
                                    if fightId and diffId then
                                        local diffSlug = ns.difficulties[diffId].slug
                                        local timingsString = ns:ConvertTimingsToNote(specName, diffSlug, fightId)
                                        HarreksRampHelperDB.import.importText = timingsString
                                    end
                                end
                            },
                            defaultsHeader = {
                                type = "header",
                                name = "Default Assignments",
                                order = 7
                            },
                            defaultsDescription = {
                                type = "description",
                                name = "The addon comes with some default assignments saved based on recommended timings for each spec, using this option will " ..
                                    "import all the currently configured default assignments for all bosses for this specialization. " ..
                                    "If you want to import them for a single boss instead use the button located below the boss selection dropdowns. " ..
                                    "|cffff680aWarning:|r this will overwrite any assignments currently set up",
                                order = 8,
                                fontSize = "medium"
                            },
                            importAllDefaults = {
                                type = "execute",
                                name = "Import all default Assignments",
                                order = 9,
                                width = defaultOptionWidth * 2,
                                func = function()
                                    local importedBossList = ''
                                    for fightId, fightData in pairs(ns.bosses) do
                                        for diffId, diffData in pairs(ns.difficulties) do
                                            local diffSlug = diffData.slug
                                            local importText = ns[specName]['defaultAssignments'][fightId]['assignments'][diffSlug]
                                            if importText ~= "" then
                                                importedBossList = importedBossList .. ' - ' .. diffData.name .. ' ' .. fightData.name .. '\n'
                                                local timers = ns:ConvertNoteToTable(importText, specName, fightId, diffSlug)
                                                for type, _ in pairs(HarreksRampHelperDB[specName][diffSlug][tostring(fightId)]) do
                                                    HarreksRampHelperDB[specName][diffSlug][tostring(fightId)][type] = ''
                                                end
                                                for spell, timings in pairs(timers) do
                                                    local rampType = ns[specName]['cooldowns'][tonumber(spell)]
                                                    if rampType then
                                                        local timingsString = ''
                                                        for _, time in pairs(timings) do
                                                            timingsString = timingsString .. time .. '\n'
                                                        end
                                                        HarreksRampHelperDB[specName][diffSlug][tostring(fightId)][rampType] = timingsString
                                                    end
                                                end
                                                HarreksRampHelperDB.import.importText = '';
                                            end
                                        end
                                    end
                                    local resultText = ''
                                    if importedBossList == '' then
                                        resultText = "There are currently no default assignments to import for your spec."
                                    else
                                        resultText = "Successfully imported default assignments for the following bosses:\n" .. importedBossList
                                    end
                                    ns:WriteOutput(resultText)
                                end
                            }
                        }
                    }
                }
            }
            --For each difficulty in the data file
            for diffId, diff in pairs(ns.difficulties) do
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
                    order = 100 - diffId, --higher diff id shows up first, so mythic shows before heroic
                    args = {}
                }
                --For each encounter in the data file
                for encounterId, encounter in pairs(ns.bosses) do
                    --Check HarreksRampHelperDB if this boss exists for this difficulty on this spec
                    if not HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)] then
                        HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)] = {}
                    end
                    --Local variable to store the ramp types
                    local rampTypeOptions = {}
                    --For each type of ramp in the data
                    for type, _ in pairs(rampTypes) do
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
                            get = function() return HarreksRampHelperDB[specName][diffSlug][tostring(encounterId)][type] end,
                            validate = function(_, val)
                                local valid = not string.find(val, "[{}SCAR]")
                                print(valid)
                                if valid then
                                    return true
                                else
                                    return "Your input contains an invalid character. Your times are supposed to look like this:\n\n01:25\n00:50, p2\n\nIf your input contains parts like this:\n\n" ..
                                    "{time:00:25,SCC:468794:1}\n\nThen it is in MRT Note format, and you should import it instead."
                                end
                            end
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
                    end
                    --Build string of boss' phases
                    local bossPhasesString = ''
                    if next(ns.bosses[encounterId].phases[diffSlug]) == nil then
                        bossPhasesString = 'This boss has no phases'
                    else
                        for i = 1, 10 do
                            if ns.bosses[encounterId].phases[diffSlug][i] then
                                local phaseTrigger = ns:FormatPhaseChangeString(ns.bosses[encounterId].phases[diffSlug][i])
                                local triggerString = phaseTrigger.count
                                if tonumber(phaseTrigger.count) == 1 then
                                    triggerString = triggerString .. 'st '
                                elseif tonumber(phaseTrigger.count) == 2 then
                                    triggerString = triggerString .. 'nd '
                                elseif tonumber(phaseTrigger.count) == 3 then
                                    triggerString = triggerString .. 'rd '
                                else
                                    triggerString = triggerString .. 'th '
                                end
                                if phaseTrigger.event == 'SCC' then
                                    triggerString = triggerString .. 'successful cast of'
                                elseif phaseTrigger.event == 'SCS' then
                                    triggerString = triggerString .. 'start of the cast of'
                                elseif phaseTrigger.event == 'SAA' then
                                    triggerString = triggerString .. 'aura application of'
                                elseif phaseTrigger.event == 'SAR' then
                                    triggerString = triggerString .. 'aura removal of'
                                end
                                local spell = C_Spell.GetSpellInfo(phaseTrigger.spell)
                                if spell then
                                    triggerString = triggerString .. ' \'' .. C_Spell.GetSpellInfo(phaseTrigger.spell).name .. '\', spell id ' .. phaseTrigger.spell
                                    bossPhasesString = bossPhasesString .. '|cffffd100Phase ' .. i .. '|r\n' .. triggerString .. '\n\n'
                                end
                            end
                        end
                    end
                    --Add the ramp types for this fight to the appropriate difficulty in the specTable
                    specTable.args.fights.args[diffSlug].args[tostring(encounterId)] = {
                        type = "group",
                        name = encounter.name,
                        order = encounterId,
                        childGroups = "tab",
                        args = {
                            timings = {
                                type = "group",
                                name = "Timings",
                                order = 1,
                                args = rampTypeOptions
                            },
                            phases = {
                                type = "group",
                                name = "Phases",
                                order = 2,
                                args = {
                                    phasesString = {
                                        type = "description",
                                        name = bossPhasesString,
                                        fontSize = "medium"
                                    }
                                }
                            }
                        }
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
