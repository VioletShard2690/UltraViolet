SMODS.Voucher {key = 'backstock',
    atlas = 'backstock',
    unlocked = true,
    discovered = true,
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
        SMODS.change_booster_limit(self.config.extra)
    end
}
SMODS.Voucher {key = 'right_to_choose',
    atlas = 'right_to_choose',
    cost = 10,
    requires = {'v_uv_backstock'}, 
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
SMODS.Voucher {key = 'six_finger_discount',
    loc_txt = {
        name = 'Six Finger Discount',
        text = {
            "{C:enhanced}+1{} card selection limit"
        }
    },
    config = { extra = 1 },
    cost = 10,
    unlocked = true,
    discovered = true,
    redeem = function(self, card)
        SMODS.change_play_limit(card.ability.extra or self.config.extra)
        SMODS.change_discard_limit(card.ability.extra or self.config.extra)
    end
}
SMODS.Voucher {key = 'extra_finger',
    loc_txt = {
        name = 'Extra Finger',
        text = {
            "{C:enhanced}+1{} card selection limit"
        }
    },
    config = { extra = 1 },
    cost = 10,
    unlocked = true,
    discovered = true,
    requires = { 'v_uv_six_finger_discount' },
    
    redeem = function(self, card)
        SMODS.change_play_limit(card.ability.extra or self.config.extra)
        SMODS.change_discard_limit(card.ability.extra or self.config.extra)
    end
}
SMODS.Voucher {key = 'coupon',
    loc_txt = {
        name = 'Coupon',
        text = {
            "{C:attention}Vouchers{} costs",
            "{C:money}$#1#{} less"
        }
    },
    config = { extra = 2 },
    cost = 10,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability and card.ability.extra or self.config.extra } }
    end,
    redeem = function(self, card)
        G.GAME.coupon_active = true
        G.GAME.coupon_discount_amount = card.ability.extra or self.config.extra
        if G.shop_vouchers and G.shop_vouchers.cards then
            for i = 1, #G.shop_vouchers.cards do
                G.shop_vouchers.cards[i]:set_cost()
            end
        end
    end
}
SMODS.Voucher {key = 'black_friday',
    cost = 10,
    unlocked = true,
    discovered = true,
    requires = { 'v_uv_coupon' },
    loc_txt = {
        name = 'Black Friday',
        text = {
            "{C:attention}Vouchers{} costs",
            "{C:money}$2{} less"
        }
    },
    config = { extra = 4 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability and card.ability.extra or self.config.extra } }
    end,
    redeem = function(self, card)
        G.GAME.coupon_active = true
        G.GAME.coupon_discount_amount = card.ability.extra or self.config.extra
        if G.shop_vouchers and G.shop_vouchers.cards then
            for i = 1, #G.shop_vouchers.cards do
                G.shop_vouchers.cards[i]:set_cost()
            end
        end
    end
}