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
        [359816] = 'Dreamflight',
        [363534] = 'Rewind',
        [444088] = 'Double Engulf'
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
                ['offset'] = 0
            },
            {
                ['text'] = 'Save TA',
                ['tts'] = 'Save tea a',
                ['icon'] = 4630480,
                ['offset'] = 18 + (ns:GetRealCooldown('Preservation', 373861)),
            },
            {
                ['text'] = 'Save DB',
                ['icon'] = 4622454,
                ['offset'] = 30
            },
            {
                ['text'] = 'Ramp for Stasis',
                ['icon'] = 4630480,
                ['offset'] = 18
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
                ['offset'] = 18 + (ns:GetRealCooldown('Preservation', 373861))
            },
            {
                ['text'] = 'Ramp for EC',
                ['icon'] = 4630480,
                ['offset'] = 18
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
                ['offset'] = 0
            },
            {
                ['text'] = 'Save TA',
                ['tts'] = 'Save tea a',
                ['icon'] = 4630480,
                ['offset'] = 18 + (ns:GetRealCooldown('Preservation', 373861)),
            },
            {
                ['text'] = 'Save DB',
                ['icon'] = 4622454,
                ['offset'] = 30
            },
            {
                ['text'] = 'Ramp for Consume',
                ['icon'] = 4630480,
                ['offset'] = 18
            },
            {
                ['text'] = 'Consume Flame Soon',
                ['icon'] = 4914680,
                ['offset'] = 3,
                ['showTimer'] = true
            },
            {
                ['text'] = 'Consume Flame',
                ['icon'] = 4914680,
                ['offset'] = 0
            }
        }
    }
end