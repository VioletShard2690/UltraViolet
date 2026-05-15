SMODS.Blind {
    key = 'weed',
    loc_txt = {
        name = "The Weed",
        text = { 
            "All digital cards are debuffed"
    }
    },
    pos = { x = 0, y = 0 },
    atlas = 'weed',
    unlocked = true,
    discovered = true,
    boss = { min = 2, max = 40 },
    boss_colour = HEX('ff4a4a'),
    recalc_debuff = function(self, card, from_blind)
        if not (card:get_id() > 10 or card:get_id() == 14) then
            return true
        end
    end
}