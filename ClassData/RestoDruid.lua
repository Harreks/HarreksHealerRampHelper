local _, ns = ...

ns['RestoDruid'] = {
    ['spells'] = {},
}

ns['RestoDruid']['rampTypes'] = function()
    return {
        ['Flourish'] = {
            {
                ['text'] = 'Start Ramping',
                ['icon'] = 136081,
                ['offset'] = 15
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