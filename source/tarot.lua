SMODS.Consumable{key = 'chaotic',
    set = 'Tarot',
    atlas = 'chaotic',
    pos = {x = 0, y = 0},
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Chaotic",
        text = {
            "Enhances {C:attention}3{} selected cards:",
            "one into a {C:attention}Bonus Card{},",
            "one into a {C:attention}Mult Card{},",
            "and one into a {C:attention}Lucky Card{}"
        }
    },
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted == 3
    end,
    use = function(self, card, area, copier)
        local enhancements = {
            G.P_CENTERS.m_bonus,
            G.P_CENTERS.m_mult,
            G.P_CENTERS.m_lucky
        }
        for i = 1, #G.hand.highlighted do
            local target = G.hand.highlighted[i]
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2 * i,
                func = function()
                    target:flip()
                    play_sound('tarot2', 0.8 + (i*0.2))
                    target:juice_up(0.3, 0.5)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    target:set_ability(enhancements[i])
                    target:flip()
                    return true
                end
            }))
        end
    end
}