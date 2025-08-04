local _, ns = ...

--https://warcraft.wiki.gg/wiki/SpecializationID
ns.specs = {
    [1468] = "Preservation",
    [256] = "Discipline",
    [105] = "RestoDruid"
}

ns.bosses = {
    [3017] = {
        name = "Plexus Sentinel",
        phases = {
            ["myth"] = {
                [1] = "SAR:1223364:1",
                [2] = "SAA:1223364:2",
                [3] = "SAR:1223364:2",
                [4] = "SAA:1223364:3",
                [5] = "SAR:1223364:3",
                [6] = "SAA:1223364:4",
            },
            ["hero"] = {
                [1] = "SAR:1223364:1",
                [2] = "SAA:1223364:2",
                [3] = "SAR:1223364:2",
                [4] = "SAA:1223364:3",
                [5] = "SAR:1223364:3",
                [6] = "SAA:1223364:4",
            }
        }
    },
    [3018] = {
        name = "Loomithar",
        phases = {
            ["myth"] = {
                [1] = "SAA:1228070:1",
            },
            ["hero"] = {
                [1] = "SAA:1228070:1",
            }
        }
    },
    [3019] = {
        name = "Soulbinder Naazindhri",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3020] = {
        name = "Forgeweaver Araz",
        phases = {
            ["myth"] = {
                [1] = "SCC:1230529:1",
                [2] = "SCC:1230529:2",
            },
            ["hero"] = {
                [1] = "SCC:1230529:1",
                [2] = "SCC:1230529:2",
            }
        }
    },
    [3021] = {
        name = "The Soul Hunters",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3022] = {
        name = "Fractillus",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3023] = {
        name = "Nexus King Salhadaar",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3024] = {
        name = "Dimensius the All-Devouring",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    }
}

ns.difficulties = {
    [15] = {
        ["slug"] = "hero",
        ["name"] = "Heroic"
    },
    [16] = {
        ["slug"] = "myth",
        ["name"] = "Mythic"
    }
}

ns.phaseEvents = {
    ["SCC"] = "SPELL_CAST_SUCCESS",
    ["SCS"] = "SPELL_CAST_START",
    ["SAA"] = "SPELL_AURA_APPLIED",
    ["SAR"] = "SPELL_AURA_REMOVED",
}