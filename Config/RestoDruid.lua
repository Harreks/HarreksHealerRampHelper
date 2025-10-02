local _, ns = ...

ns['RestoDruid'] = {
    ['spells'] = {},
    ['cooldowns'] = {
        [740] = 'Tranquility'
    },
    ['utilities'] = {
        [77761] = 'Stampeding Roar',
        [102793] = 'Ursol\'s Vortex',
        [102342] = 'Ironbark'
    },
    ['ramps'] = {
        [197721] = 'Flourish',
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
        }
    }
end
