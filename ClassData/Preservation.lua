local _, ns = ...

ns['Preservation'] = {
    ['spells'] = {
        [443328] = {
            ['name'] = 'Engulf',
            ['baseCd'] = 27,
            ['charges'] = true,
            ['cd'] = nil
        },
        [373861] = {
            ['name'] = 'Temporal Anomaly',
            ['baseCd'] = 15,
            ['cd'] = nil
        }
    },
    ['cooldowns'] = {
        [370537] = 'Stasis',
        [370564] = 'Stasis Release',
        [370960] = 'EC',
        [370984] = 'EC', --Viserio's CD planner uses a wrong id for EC, this duplicate means importing from the sheet still adds EC assignments
        [359816] = 'Dreamflight',
        [363534] = 'Rewind',
        [443328] = 'Double Engulf'
    }
}

ns['Preservation']['rampTypes'] = function()
    return {
        ['Stasis'] = {
            {
                ['text'] = 'Save Engulfs',
                ['icon'] = 5927629,
                ['dynamic'] = true,
                ['spellId'] = 443328,
                ['offset'] = 0,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Save TA',
                ['tts'] = 'Save tea a',
                ['icon'] = 4630480,
                ['offset'] = 15 + (ns:GetRealCooldown('Preservation', 373861)),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Save DB',
                ['icon'] = 4622454,
                ['offset'] = 30,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Ramp for Stasis',
                ['icon'] = 4630480,
                ['offset'] = 18,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Stasis Soon',
                ['icon'] = 4630476,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Stasis',
                ['icon'] = 4630476,
                ['offset'] = 0
            }
        },
        ['EC'] = {
            {
                ['text'] = 'Save TA',
                ['tts'] = 'Save tea a',
                ['icon'] = 4630480,
                ['offset'] = 18 + (ns:GetRealCooldown('Preservation', 373861)),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Ramp for EC',
                ['icon'] = 4630480,
                ['offset'] = 18,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'EC Soon',
                ['icon'] = 4630447,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'EC',
                ['icon'] = 4630447,
                ['offset'] = 0
            }
        },
        ['Stasis Release'] = {
            {
                ['text'] = 'Release Stasis',
                ['icon'] = 4630476,
                ['offset'] = 0
            },
            {
                ['text'] = 'Release Soon',
                ['icon'] = 4630476,
                ['offset'] = 3,
                ['showTimer'] = true
            },
        },
        ['Rewind'] = {
            {
                ['text'] = 'Rewind',
                ['icon'] = 4622474,
                ['offset'] = 0
            },
            {
                ['text'] = 'Rewind Soon',
                ['icon'] = 4622474,
                ['offset'] = 3,
                ['showTimer'] = true
            },
        },
        ['Dreamflight'] = {
            {
                ['text'] = 'Dreamflight',
                ['icon'] = 4622455,
                ['offset'] = 0
            },
            {
                ['text'] = 'Dreamflight Soon',
                ['icon'] = 4622455,
                ['offset'] = 3,
                ['showTimer'] = true
            },
        },
        ['Double Engulf'] = {
            {
                ['text'] = 'Save Engulfs',
                ['icon'] = 5927629,
                ['dynamic'] = true,
                ['spellId'] = 443328,
                ['offset'] = 0,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Save TA',
                ['tts'] = 'Save tea a',
                ['icon'] = 4630480,
                ['offset'] = 15 + (ns:GetRealCooldown('Preservation', 373861)),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Save DB',
                ['icon'] = 4622454,
                ['offset'] = 30,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Ramp for Double Engulf',
                ['icon'] = 4630480,
                ['offset'] = 18,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Double Engulf Soon',
                ['icon'] = 4914680,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Double Engulf',
                ['icon'] = 4914680,
                ['offset'] = 0
            }
        }
    }
end

ns['Preservation']['defaultAssignments'] = {
    [3017] = {
        name = "Plexus Sentinel",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3018] = {
        name = "Loomithar",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3019] = {
        name = "Soulbinder Naazindhri",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3020] = {
        name = "Forgeweaver Araz",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3021] = {
        name = "The Soul Hunters",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3022] = {
        name = "Fractillus",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3023] = {
        name = "Nexus King Salhadaar",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3024] = {
        name = "Dimensius the All-Devouring",
        assignments = {
            myth = "",
            hero = ""
        }
    }
}
