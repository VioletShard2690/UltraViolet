SMODS.Edition {key = 'quantum',
    shader = 'uv_quantum',
    loc_txt = {
        name = 'Quantum',
        label = 'Quantum',
        text = {
            "{X:chips,C:white}^#1#{} Chips"
        }
    },
    config = { e_chips = 1.1 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.edition and card.edition.e_chips or self.config.e_chips } }
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or (context.main_scoring and context.cardarea == G.play) then
            return {
                message = message,
                Echip_mod = card and card.edition and card.edition.e_chips or self.config.e_chips,
                colour = G.C.BLUE
            }
        end
        if context.joker_main then
            card.config.trigger = true
        end
        if context.after then
            card.config.trigger = nil
        end
    end
}
SMODS.Edition {key = 'ooopsier',
    shader = 'uv_ooopsier',
    loc_txt = {
        name = 'Ooopsier',
        label = 'Ooopsier',
        text = {
            "Triples all {C:green,E:1,S:1.1}probabilities{}",
            "for this card",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}3 in 3{}{C:inactive}){}"
        }
    },
    config = { x_chance = 3 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.edition and card.edition.x_chance or self.config.x_chance } }
    end,
    calculate = function(self, card, context)
        if context.mod_probability and context.trigger_obj == card then
            local multiplier = card and card.edition and card.edition.x_chance or self.config.x_chance or 3
            return {
                numerator = context.numerator * multiplier
            }
        end
    end
}
SMODS.Edition {key = 'overclocked',
    shader = 'uv_overclocked',
    loc_txt = {
        name = 'Overclocked',
        label = 'Overclocked',
        text = {
            "{C:attention}+#2#{} Card slot in shop",
            "every 10 times this card triggers",
            "{C:inactive}(Currently: #1#/10){}"
        }
    },
    config = { shop_slots = 1, triggers = 0 },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local current_triggers = card and card.edition and card.edition.triggers or 0
        local shop_slots = card and card.edition and card.edition.shop_slots
        return { vars = { current_triggers, shop_slots } }
    end,
    calculate = function(self, card, context)
        if card and (context.joker_main or (context.main_scoring and context.cardarea == G.play)) then
            card.edition.triggers = card.edition.triggers or 0
            card.edition.triggers = card.edition.triggers + 1
            if card.edition.triggers >= 10 then
                card.edition.triggers = 0
                change_shop_size(card.edition.shop_slots)
                return {
                    message = '+' .. card.edition.shop_slots .. ' Slot',
                    colour = G.C.ORANGE
                }
            end
        end
    end
}