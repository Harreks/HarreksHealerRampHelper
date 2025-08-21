local _, ns = ...

--https://warcraft.wiki.gg/wiki/SpecializationID
ns.specs = {
    [1468] = "Preservation",
    [256] = "Discipline",
    [105] = "RestoDruid"
}

ns.bosses = {
    [3129] = {
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
    [3131] = {
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
    [3130] = {
        name = "Soulbinder Naazindhri",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3132] = {
        name = "Forgeweaver Araz",
        phases = {
            ["myth"] = {
                [1] = "SCS:1230529:1",
                [2] = "SCS:1230529:2",
            },
            ["hero"] = {
                [1] = "SCS:1230529:1",
                [2] = "SCS:1230529:2",
            }
        }
    },
    [3122] = {
        name = "The Soul Hunters",
        phases = {
            ["myth"] = {
                [1] = "SAR:1245978:1",
                [2] = "SAR:1245978:3",
                [3] = "SAR:1245978:5"
            },
            ["hero"] = {
                [1] = "SAR:1242133:1",
                [2] = "SAR:1242133:3",
                [3] = "SAR:1242133:5"
            }
        }
    },
    [3133] = {
        name = "Fractillus",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3134] = {
        name = "Nexus King Salhadaar",
        phases = {
            ["myth"] = {},
            ["hero"] = {
                [1] = "SAR:1228265:1"
            }
        }
    },
    [3135] = {
        name = "Dimensius the All-Devouring",
        phases = {
            ["myth"] = {},
            ["hero"] = {
                [1] = "SAR:1228367:1",
                [2] = "SAA:1246143:1",
                [3] = "SAR:1246143:1",
                [4] = "SAA:1246143:2",
                [5] = "SAA:1245292:1"
            }
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