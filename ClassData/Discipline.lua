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
        [421453] = 'Ultimate Penitence',
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
                ['offset'] = ns:GetRealCooldown('Discipline', 61304),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Ramp for Evang',
                ['tts'] = 'Ramp for Evangelism',
                ['icon'] = 135940,
                ['offset'] = 11 * (ns:GetRealCooldown('Discipline', 61304)),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Double Radiance',
                ['icon'] = 1386546,
                ['offset'] = 2 * (ns:GetRealCooldown('Discipline', 61304)),
            },
            {
                ['text'] = 'Evangelism',
                ['icon'] = 135895,
                ['offset'] = 0
            }
        },
        ['Ultimate Penitence'] = {
            {
                ['text'] = 'Ramp for UP',
                ['tts'] = 'Ramp for Ultimate Penitence',
                ['icon'] = 1060982,
                ['offset'] = 6 * (ns:GetRealCooldown('Discipline', 61304)),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Save one Radiance',
                ['icon '] = 1386546,
                ['offset'] = ns:GetRealCooldown('Discipline', 194509),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'UP Soon',
                ['tts'] = 'uppies soon',
                ['icon'] = 253400,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Ultimate Penitence',
                ['icon'] = 253400,
                ['offset'] = 0
            }
        },
        ['Double Radiance'] = {
            {
                ['text'] = 'Save Radiances',
                ['icon'] = 1386546,
                ['dynamic'] = true,
                ['spellId'] = 194509,
                ['offset'] = ns:GetRealCooldown('Discipline', 61304),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Ramp for Double Radiance',
                ['icon'] = 135940,
                ['offset'] = 11 * (ns:GetRealCooldown('Discipline', 61304)),
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Double Radiance',
                ['icon'] = 1386546,
                ['offset'] = 2 * (ns:GetRealCooldown('Discipline', 61304)),
            },
            {
                ['text'] = 'Heal Now',
                ['icon'] = 136224,
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