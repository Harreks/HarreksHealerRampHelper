local _, ns = ...

ns['Discipline'] = {
    ['spells'] = {
        [61304] = {
            ['name'] = 'GCD',
            ['baseCd'] = 1.5,
            ['cd'] = nil
        },
        [194509] = {
            ['name'] = 'Power Word: Radiance',
            ['cd'] = 18,
            ['charges'] = true,
            ['modifiers'] = {
                [390684] = -3
            }
        }
    },
    ['cooldowns'] = {
        [472433] = 'Evangelism',
        [62618] = 'Barrier'
    }
}

ns['Discipline']['rampTypes'] = function()
    return {
        ['Evangelism'] = {
            {
                ['text'] = 'Save Radiance',
                ['icon'] = 1386546,
                ['dynamic'] = true,
                ['spellId'] = 194509,
                ['offset'] = 7 * (ns:GetRealCooldown('Discipline', 61304))
            },
            {
                ['text'] = 'Start Ramping',
                ['icon'] = 135940,
                ['offset'] = 11 * (ns:GetRealCooldown('Discipline', 61304))
            },
            {
                ['text'] = 'Double Radiance',
                ['icon'] = 1386546,
                ['offset'] = 2 * (ns:GetRealCooldown('Discipline', 61304))
            },
            {
                ['text'] = 'Evangelism',
                ['icon'] = 135895,
                ['offset'] = 0
            }
        },
        ['Barrier'] = {
            {
                ['text'] = 'Barrier Soon',
                ['icon'] = 253400,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Barrier',
                ['icon'] = 253400,
                ['offset'] = 0
            }
        }
    }
end