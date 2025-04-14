local _, ns = ...

--https://warcraft.wiki.gg/wiki/SpecializationID
ns.specs = {
    [1468] = "Preservation",
    [256] = "Discipline",
    [105] = "RestoDruid"
}

ns.bosses = {
    [3009] = {
        name = "Vexie and the Geargrinders",
        phases = {
            ["myth"] = {
                [2] = "SAA:460116:1",
                [3] = "SAR:460116:1",
                [4] = "SAA:460116:2",
                [5] = "SAR:460116:2",
                [6] = "SAA:460116:3",
                [7] = "SAR:460116:3",
            },
            ["hero"] = {
                [2] = "SAA:460116:1",
                [3] = "SAR:460116:1",
                [4] = "SAA:460116:2",
                [5] = "SAR:460116:2",
                [6] = "SAA:460116:3",
                [7] = "SAR:460116:3",
            }
        }
    },
    [3010] = {
        name = "Cauldron of Carnage",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3011] = {
        name = "Rik Reverb",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3012] = {
        name = "Stix Bunkjunker",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3013] = {
        name = "Sprocketmonger Lockenstock",
        phases = {
            ["myth"] = {},
            ["hero"] = {}
        }
    },
    [3014] = {
        name = "The One-armed Bandit",
        phases = {
            ["myth"] = {
                [2] = "SAR:461060:1",
                [3] = "SAR:461060:2",
                [4] = "SAR:461060:3",
                [5] = "SAR:461060:4",
                [6] = "SAR:461060:5",
                [7] = "SAR:461060:6",
                [8] = "SCC:465765:1",
            },
            ["hero"] = {
                [2] = "SAR:461060:1",
                [3] = "SAR:461060:2",
                [4] = "SAR:461060:3",
                [5] = "SAR:461060:4",
                [6] = "SAR:461060:5",
                [7] = "SCC:465765:1",
            }
        }
    },
    [3015] = {
        name = "Mug'zee",
        phases = {
            ["myth"] = {
                [1] = "SCC:468794:1",
                [2] = "SCC:468728:1",
                [3] = "SCC:468794:2",
                [4] = "SCC:468728:2",
                [5] = "SCC:468794:3",
                [6] = "SCS:1217791:1",
                [7] = "SAA:1222408:1",
            },
            ["hero"] = {
                [1] = "SCC:468728:1",
                [2] = "SCC:468794:1",
                [3] = "SCC:468728:2",
                [4] = "SCC:468794:2",
                [5] = "SCS:1215953:1",
                [6] = "SAA:1222408:1",
            }
        }
    },
    [3016] = {
        name = "Chrome King Gallywix",
        phases = {
            ["myth"] = {
                [2] = "SAR:1214369:1",
                [3] = "SAA:1226891:1",
                [4] = "SAR:1226891:1",
                [5] = "SAA:1226891:2",
                [6] = "SAR:1226891:2",
            },
            ["hero"] = {
                [2] = "SAA:1216846:1",
                [3] = "SAA:1216846:5",
                [4] = "SCS:1214369:1",
                [5] = "SAR:1214590:1",
                [6] = "SCS:466342:2",
                [7] = "SCC:1223658:3",
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