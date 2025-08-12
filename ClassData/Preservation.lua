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
            hero =
            "{time:00:28} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:00:36} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:01:02} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:00:23,SAA:1223364:2} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:00:57,SAA:1223364:2} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:06,SAA:1223364:2} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:01:31,SAA:1223364:2} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:00:57,SAA:1223364:3} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:06,SAA:1223364:3} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:00:24,SAA:1223364:4} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:00:59,SAA:1223364:4} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:10,SAA:1223364:4} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:01:36,SAA:1223364:4} - " .. GetUnitName("player", false) .. " {spell:363534} \n"
        }
    },
    [3018] = {
        name = "Loomithar",
        assignments = {
            myth = "",
            hero =
            "{time:02:09} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:00:25} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:00:42} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:01:08} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:01:26} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:54,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:02:00,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:00:15,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:02:40,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:00:19,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:00:55,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:01:19,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:01:35,SAA:1228070:1} - " .. GetUnitName("player", false) .. " {spell:363534} \n"
        }
    },
    [3019] = {
        name = "Soulbinder Naazindhri",
        assignments = {
            myth = "",
            hero =
            "{time:02:28} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:03:16} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:03:37} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:03:59} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:00:26} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:05:00} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:05:47} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:06:29} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:06:47} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:07:31} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:00:47} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:27} - " .. GetUnitName("player", false) .. " {spell:370960} \n"
        }
    },
    [3020] = {
        name = "Forgeweaver Araz",
        assignments = {
            myth = "",
            hero =
            "{time:02:30} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:02:35} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:00:37} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:22} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:02:26,SCC:1230529:1} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:02:36,SCC:1230529:1} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:01:15,SCC:1230529:1} - " .. GetUnitName("player", false) .. " {spell:370537} \n"
        }
    },
    [3021] = {
        name = "The Soul Hunters",
        assignments = {
            myth = "",
            hero =
            "{time:01:40} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:02:38} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:03:43} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:04:40} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:05:14} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:05:45} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:00:36} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:06:37} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:01:06} - " .. GetUnitName("player", false) .. " {spell:363534} \n"
        }
    },
    [3022] = {
        name = "Fractillus",
        assignments = {
            myth = "",
            hero =
            "{time:02:00} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:02:31} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:02:40} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:03:20} - " .. GetUnitName("player", false) .. " {spell:363534} \n" ..
            "{time:03:48} - " .. GetUnitName("player", false) .. " {spell:443328} \n" ..
            "{time:04:32} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:04:40} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:00:31} - " .. GetUnitName("player", false) .. " {spell:370537} \n" ..
            "{time:05:20} - " .. GetUnitName("player", false) .. " {spell:370960} \n" ..
            "{time:00:40} - " .. GetUnitName("player", false) .. " {spell:370564} \n" ..
            "{time:01:20} - " .. GetUnitName("player", false) .. " {spell:370960} \n"
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
