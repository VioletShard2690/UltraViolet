SMODS.Back {key = "36_cards",
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
SMODS.Back {key = "gamble_deck",
    config = { lucky_block = true, wheel = true },
    loc_txt = {
        name = "Gamble Deck",
        text = {
            "Start with {C:attention}Lucky Block{}",
            "and {C:tarot}The Wheel of Fortune{}",
        }
    },
    atlas = 'gamble_deck',
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local lucky_block = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_uv_lucky_block', 'gamble')
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
SMODS.Back {key = 'prologue_deck',
    loc_txt = {
        name = 'Prologue Deck',
        text = {
            "Start the run at {C:attention}Ante 0{}"
        }
    },
    config = {},
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_ante(-1)
                return true
            end
        }))
    end
}
SMODS.Back {key = 'gray_deck',
    loc_txt = {
        name = 'Gray Deck',
        text = {
            "{C:attention}+#1#{} consumable slot",
            "{C:red}-#2#{} discard",
            "every round"
        }
    },
    -- atlas = 'gray_deck',
    config = { extra_c = 1, minus_d = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra_c, self.config.minus_d } }
    end,
    apply = function(self)
        G.GAME.starting_params.discards = G.GAME.starting_params.discards - self.config.minus_d
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - self.config.minus_d
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.consumable_slots = (G.GAME.modifiers.consumable_slots or 2) + self.config.extra_c
                if G.consumeables then 
                    G.consumeables.config.card_limit = G.GAME.modifiers.consumable_slots 
                end
                return true
            end
        }))
    end
}
SMODS.Back {key = 'tyrants_deck',
    loc_txt = {
        name = 'Deck of Tyrants',
        text = {
            "Every {C:attention}Blind{} is a",
            "{C:attention}Boss Blind{}"
        }
    },
    unlocked = true,
    discovered = true,
    config = { tyrant_mode = true }
}
SMODS.Back {key = 'turtle_deck',
    loc_txt = {
        name = 'Turtle Deck',
        text = {
            "Start with a {C:dark_edition}Negative{} {C:attention}Eternal{} {C:attention}Turtle{}",
            "Win the run at {C:attention}Ante 4{}"
        }
    },
    config = { win_ante = 4 },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.win_ante = self.config.win_ante
                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_uv_turtle', 'turtle_start')
                card:set_edition({negative = true}, true)
                card:set_eternal(true)
                card:add_to_deck()
                G.jokers:emplace(card)
                return true
            end
        }))
    end
}
SMODS.Back {key = 'orange_deck',
    loc_txt = {
        name = 'Orange Deck',
        text = {
            "{C:attention}+1{} hand size"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:change_size(1)
                return true
            end
        }))
    end
}
SMODS.Back {key = 'joker_deck',
    config = {x_mult = 4, joker_slot_mod = -1},
    loc_txt = {
        name = "Joker Deck",
        text = {
            "{X:mult,C:white}x4{} Mult",
            "{C:red}-1{} Joker slot"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.jokers.config.card_limit = G.jokers.config.card_limit + self.config.joker_slot_mod
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
        if context.main_scoring then
            return {
                Xmult = self.config.x_mult,
                update = true
            }
        end
    end
}
SMODS.Back {key = 'fortune_deck',
    loc_txt = {
        name = "Fortune Deck",
        text = {
            "Start with {C:attention}2{} random",
            "{C:attention}Vouchers{}"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 2 do
                    local voucher_key = get_next_voucher_key()
                    G.GAME.used_vouchers[voucher_key] = true
                    local dummy_voucher = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[voucher_key])
                    dummy_voucher:apply_to_run()
                end
                return true
            end
        }))
    end
}
SMODS.Back {key = 'royal_deck',
    loc_txt = {
        name = "Royal Deck",
        text = {
            "Start with every {C:attention}Queen{} and",
            "{C:attention}Jack{} turned into a {C:attention}King{}"
        }
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v:get_id() == 11 or v:get_id() == 12 then
                        local suit_prefix = string.sub(v.base.suit, 1, 1)
                        v:set_base(G.P_CARDS[suit_prefix..'_K'])
                    end
                end
                return true
            end
        }))
    end
}