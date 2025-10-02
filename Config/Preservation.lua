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
        [370564] = 'Stasis Release',
        [359816] = 'Dreamflight',
        [363534] = 'Rewind',
        [443328] = 'Engulf'
    },
    ['utilities'] = {
        [357170] = 'Time Dilation',
        [374968] = 'Time Spiral',
        [374227] = 'Zephyr',
        [370665] = 'Rescue',
        [406735] = 'Spatial Paradox'
    },
    ['ramps'] = {
        [370537] = 'Stasis',
        [370960] = 'EC',
        [370984] = 'EC', --Viserio's CD planner uses a wrong id for EC, this duplicate means importing from the sheet still adds EC assignments
        [443330] = 'Double Engulf'
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
