SMODS.Edition {key = 'quantum',
    shader = 'uv_quantum',
    loc_txt = {
        name = 'Quantum',
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
        if (
            context.edition 
            and context.cardarea == G.jokers 
            and card.config.trigger
        ) or (
            context.main_scoring 
            and context.cardarea == G.play
        ) then
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
-- SMODS.Edition {key = 'ooopsier',
--     shader = 'uv_ooopsier',
--     loc_txt = {
--         name = 'Ooopsier',
--         text = {
--             "Triples all {C:green,E:1,S:1.1}probabilities{}",
--             "for this card",
--             "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}3 in 3{}{C:inactive}){}"
--         }
--     },
--     config = { x_chance = 3 },
--     unlocked = true,
--     discovered = true,
--     loc_vars = function(self, info_queue, card)
--         return { vars = { card and card.edition and card.edition.x_chance or self.config.x_chance } }
--     end,
--     adjust_chance = function(self, card, chance)
--         if card and card.edition and card.edition.key == 'e_uv_ooopsier' then
--             return chance * (card.edition.x_chance or 3)
--         end
--         return chance
--     end
-- }