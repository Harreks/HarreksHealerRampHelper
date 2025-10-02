local _, ns = ...

ns['RestoShaman'] = {
    ['spells'] = {},
    ['cooldowns'] = {
        [114052] = 'Ascendance',
        [108280] = 'Healing Tide Totem',
        [98008] = 'Spirit Link Totem',
        [207399] = 'Ancestral Protection Totem',
        [198838] = 'Earthen Wall Totem'
    },
    ['utilities'] = {
        [192077] = 'Wind Rush Totem',
        [108285] = 'Totemic Recall'
    },
    ['ramps'] = {
        [157153] = 'Cloudburst Totem'
    }
}

ns['RestoShaman']['rampTypes'] = function()
    return {
        ['Cloudburst Totem'] = {
            {
                ['text'] = 'Drop Cloudburst',
                ['icon'] = 971076,
                ['offset'] = 17,
                ['preRequisite'] = true
            },
            {
                ['text'] = 'Cloudburst Popping Soon',
                ['icon'] = 971076,
                ['offset'] = 3,
                ['showTimer'] = true
            }
        },
    }
end
