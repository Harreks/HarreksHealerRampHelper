local _, ns = ...

ns['RestoDruid'] = {
    ['spells'] = {},
    ['cooldowns'] = {
        [197721] = 'Flourish',
        [740] = 'Tranquility'
    }
}

ns['RestoDruid']['rampTypes'] = function()
    return {
        ['Flourish'] = {
            {
                ['text'] = 'Start Ramping',
                ['icon'] = 136081,
                ['offset'] = 15,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Flourish Soon',
                ['icon'] = 538743,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Flourish',
                ['icon'] = 538743,
                ['offset'] = 0
            }
        },
        ['Tranquility'] = {
            {
                ['text'] = 'Tranquility Soon',
                ['icon'] = 136107,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Tranquility',
                ['icon'] = 136107,
                ['offset'] = 0
            }
        }
    }
end

ns['RestoDruid']['defaultAssignments'] = {
    [3129] = {
        name = "Plexus Sentinel",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3131] = {
        name = "Loomithar",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3130] = {
        name = "Soulbinder Naazindhri",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3132] = {
        name = "Forgeweaver Araz",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3122] = {
        name = "The Soul Hunters",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3133] = {
        name = "Fractillus",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3134] = {
        name = "Nexus King Salhadaar",
        assignments = {
            myth = "",
            hero = ""
        }
    },
    [3135] = {
        name = "Dimensius the All-Devouring",
        assignments = {
            myth = "",
            hero = ""
        }
    }
}