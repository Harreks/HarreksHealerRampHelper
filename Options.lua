--Namespace
local _, ns = ...

local optionsTable = {
	type = "group",
	args = {
		timings = {
			type = "group",
			name = "Timings",
            args = {}
		},
        options = {
            type = "group",
            name = "Options",
            args = {

            }
        }
	},
}

for specId, specName in pairs(ns.specs) do
    local specTable = {
        type = "group",
        name = specName,
        args = {}
    }
    for encounterId, encounterName in pairs(ns.bosses) do
        local rampTypes = ns[specName]['rampTypes']()
        local rampTypeOptions = {}
        for type, assignments in pairs(rampTypes) do
            rampTypeOptions[type] = {
                type = "input",
                multiline = 10,
                name = type .. ' ramps for ' .. encounterName,
                width = 1.3
            }
        end
        specTable.args[encounterName] = {
            type = "group",
            name = encounterName,
            args = rampTypeOptions
        }
    end
    optionsTable.args.timings.args[specName] = specTable
end

LibStub("AceConfig-3.0"):RegisterOptionsTable("Harrek's Healer Ramp Helper", optionsTable)
local optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Harrek's Healer Ramp Helper", "Harrek's Ramp Helper")
SLASH_HARREKSRAMPHELPER1 = "/hrh"

SlashCmdList.HARREKSRAMPHELPER = function(msg, editBox)
    Settings.OpenToCategory(optionsFrame.name)
end
