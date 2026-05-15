SMODS.Voucher {key = 'backstock',
    atlas = 'backstock',
    pos = { x = 0, y = 0 },
    cost = 10,
    config = { extra = 1 },
    loc_txt = {
        name = 'Backstock',
        text = {
            '{C:attention}+#1#{} Booster Pack slot',
            'available in shop'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability.extra or self.config.extra) } }
    end,
    redeem = function(self, card)
        G.GAME.modifiers.booster_slots = (G.GAME.modifiers.booster_slots or 2) + self.config.extra
        if SMODS.change_booster_limit then
            SMODS.change_booster_limit(self.config.extra)
        end
    end
}
SMODS.Voucher {key = 'right_to_choose',
    atlas = 'right_to_choose',
    pos = { x = 0, y = 0 },
    cost = 10,
    requires = {'v_sj_backstock'}, 
    loc_txt = {
        name = 'Right to Choose',
        text = {
            'Choose {C:attention}1{} additional card',
            'in {C:attention}Booster Packs{}'
        }
    },
    unlocked = true,
    discovered = true,
    redeem = function(self)
        G.GAME.modifiers.custom_bonus_choices = (G.GAME.modifiers.custom_bonus_choices or 0) + 1
    end
 }
 local old_open = Card.open
 function Card.open(self)
    local result = old_open(self)
    if self.ability.set == 'Booster' and G.GAME.modifiers.custom_bonus_choices then
        G.GAME.pack_choices = G.GAME.pack_choices + G.GAME.modifiers.custom_bonus_choices
    end
    return result
end