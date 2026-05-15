SMODS.Back {name = "Russian Deck",
    key = "36_cards",
    pos = {x = 0, y = 0},
            unlocked = true,
    discovered = true,
    atlas = "36_cards",
    config = {},
    loc_txt = {
        name = "Russian Deck",
        text = {
                    "Start run with",
                    "no {C:attention}2s, 3s, 4s, and 5s",
                    "in your deck"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local to_remove = {}
                for k, v in pairs(G.playing_cards) do
                    if v:get_id() >= 2 and v:get_id() <= 5 then
                        to_remove[#to_remove + 1] = v
                    end
                end
                for i = 1, #to_remove do
                    to_remove[i]:remove_from_deck()
                    to_remove[i]:remove()
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end
        }))
    end
}
SMODS.Back {name = "Gamble Deck",
    key = "gamble_deck",
    config = { lucky_block = true, wheel = true },
    loc_txt = {
        name = "Gamble Deck",
        text = {
            "all cards in deck are {C:attention}lucky cards{}",
            "Start with {C:attention}Lucky Block{}",
            "and {C:tarot}The Wheel of Fortune{}",
        }
    },
    pos = {x = 0, y = 0},
    atlas = 'gamble_deck',
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.playing_cards and G.P_CENTERS.m_lucky then
                    for _, v in ipairs(G.playing_cards) do
                        v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                    end
                end
                local lucky_block = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sj_lucky_block', 'gamble')
                if lucky_block then
                    lucky_block:add_to_deck()
                    G.jokers:emplace(lucky_block)
                end
                local wheel = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'gamble')
                if wheel then
                    wheel:add_to_deck()
                    G.consumeables:emplace(wheel)
                end
                
                return true
            end
        }))
    end
}