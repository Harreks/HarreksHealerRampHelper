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
                ['offset'] = 18 + (ns['Preservation']['spells'][373861]['cd'] or ns['Preservation']['spells'][373861]['baseCd'])
            },
            {
                ['text'] = 'Save DB',
                ['icon'] = 4622454,
                ['offset'] = 30
            },
            {
                ['text'] = 'Start Ramping',
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
                ['offset'] = 18 + (ns['Preservation']['spells'][373861]['cd'] or ns['Preservation']['spells'][373861]['baseCd'])
            },
            {
                ['text'] = 'Start Ramping',
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
        }
    }
end