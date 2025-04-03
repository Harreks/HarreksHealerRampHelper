local _, ns = ...

ns['RestoDruid'] = {
    ['spells'] = {},
}

ns['RestoDruid']['rampTypes'] = function()
    return {
        ['Flourish'] = {
            {
                ['text'] = 'Flourish Ramp',
                ['icon'] = 136081,
                ['offset'] = 0
            }
        }
    }
end