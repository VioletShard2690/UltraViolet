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
            "{C:attention}+1{} consumable slot",
            "{C:red}-1{} discard",
            "every round"
        }
    },
    atlas = 'gray_deck',
    config = { extra_c = 1, minus_d = 1 },
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
            "{C:attention}+1{} hand size",
            "every round"
        }
    },
    atlas = 'orange_deck',
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
    atlas = 'joker_deck',
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
SMODS.Back {key = 'deck_deck',
    config = {deck_cards_start = 2},
    loc_txt = {
        name = "Deck Deck",
        text = {
            "Start run with",
            "{C:attention}2{} random {C:green}Deck Cards{}"
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local valid_pool = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'DeckCard' then
                        table.insert(valid_pool, k)
                    end
                end
                for i = 1, self.config.deck_cards_start do
                    local chosen_key = nil
                    if #valid_pool > 0 then
                        chosen_key = pseudorandom_element(valid_pool, pseudoseed('uv_card_deck'))
                    else
                        local backup_pool = {}
                        for k, v in pairs(G.P_CENTERS) do
                            if v.set == 'Tarot' then
                                table.insert(backup_pool, k)
                            end
                        end
                        chosen_key = pseudorandom_element(backup_pool, pseudoseed('uv_card_deck_backup'))
                    end
                    local card = create_card('DeckCard', G.consumeables, nil, nil, nil, nil, chosen_key, nil)
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
                return true
            end
        }))
    end
}
SMODS.Back {key = 'purple_deck',
    loc_txt = {
        name = 'Purple Deck',
        text = {
            "{C:enhanced}+1{} card selection limit",
            "every round"
        }
    },
    atlas = 'purple_deck',
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
                return true
            end
        }))
    end
}
SMODS.Back {key = 'light_blue_deck',
    loc_txt = {
        name = 'Light Blue Deck',
        text = {
            "{C:attention}+1{} consumable slot",
            "every round"
        }
    },
    atlas = 'light_blue_deck',
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                return true
            end
        }))
    end
}
SMODS.Back {key = 'rainbow_deck',
    loc_txt = {
        name = 'Rainbow Deck',
        text = {
            "{C:red}+1{} discard",
            "{C:blue}+1{} hand",
            "{C:attention}+1{} ante",
            "{C:attention}+1{} consumeable slot",
            "{C:attention}+1{} joker slot",
            "{C:attention}+1{} round",
            "{C:attention}+1{} card slot in the shop",
            "{C:money}+$1{}",
            "{C:attention}+1{} voucher slot",
            "{C:attention}+1{} booster slot",
            "{C:blue}+1{} card play limit",
            "{C:red}+1{} card discard limit",
            "{C:attention}+1{} hand size",
            "{C:attention}+1{} ante to win",
            "{C:money}+$1{} per hand",
            "{C:money}+$1{} per discard",
            "{C:money}+$1{} of interest",
            "{C:mult}+1{} mult",
            "{C:blue}+1{} chip",
            "{C:green}+1{} probability",
            "{C:money}+$1{} reroll cost",
            "{C:attention}+1{} retrigger for each card",
            "{C:attention}+1{} cost of items in shop",
            "{C:attention}+1{} boss blind in ante",
            "{C:attention}+1{} level to all hands"
        }
    },
    atlas = 'rainbow_deck',
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_discard(1)
                ease_hands_played(1)
                ease_ante(1)
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                ease_round(1)
                change_shop_size(1)
                ease_dollars(1)
                SMODS.change_voucher_limit(1)
                SMODS.change_booster_limit(1)
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
                G.hand:change_size(1)
                G.GAME.win_ante = 9
                G.GAME.modifiers.money_per_hand = 2
                G.GAME.modifiers.money_per_discard = 1
                G.GAME.interest_amount = G.GAME.interest_amount + 1
                G.GAME.probabilities.normal = G.GAME.probabilities.normal + 1
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + 1
                G.GAME.inflation = 1
                G.GAME.round_resets.blind_choices.Big = get_new_boss()
                if G.FUNCS and G.FUNCS.set_blind_select and G.STATE == G.STATES.BLIND_SELECT then 
                    G.FUNCS.set_blind_select()
                end
                for k, v in pairs(G.GAME.hands) do
                    level_up_hand(nil, k, true, 1)
                end
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
        if context.main_scoring then
            return {
                mult = 1,
                chips = 1,
                update = true
            }
        end
        if context.repetition and context.cardarea == G.play then
            if context.scoring_hand then
                for i = 1, #context.scoring_hand do
                    return {
                        message = 'Again!',
                        repetitions = 1,
                        card = card,
                        update = true
                    }
                end
            end
        end
    end
}
SMODS.Back {key = 'sandbox_deck',
    loc_txt = {
        name = "Sandbox Deck",
        text = {
            "Start run with",
            "{C:green}Perkeo{} and",
            "{C:spectral}POINTER://{}",
            "{C:dark_edition}Cryptid cross-mod deck{}"
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local perkeo = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_perkeo', 'sandbox')
                perkeo:add_to_deck()
                G.jokers:emplace(perkeo)
                perkeo:start_materialize()
                if SMODS.Mods["Cryptid"] then
                    local pointer = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_cry_pointer', 'sandbox')
                    if pointer then
                        pointer:add_to_deck()
                        G.consumeables:emplace(pointer)
                        pointer:start_materialize()
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back{key = 'chimps_deck',
    loc_txt = {
        name = "CHIMPS Deck",
        text = {
            "no {C:attention}Consumable{} slots",
            "{C:blue}1{} Hand per round",
            "no {C:attention}Interest",
            "Money set to {C:red}-$10{}",
            "Plus {C:attention}2{} antes to win",
            "Start with {C:red}-1{} hand size"
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 2
            ease_hands_played(-3)
            G.GAME.modifiers.no_interest = true
            G.GAME.win_ante = 10
            G.GAME.modifiers.cry_price_mod = (G.GAME.modifiers.cry_price_mod or 1) * 2
            ease_dollars(-14)
            G.hand:change_size(-1)
            return true
        end}))
    end
}
SMODS.Back{key = '7lb2vpk_deck',
    loc_txt = {
        name = "7LB2WVPK Deck",
        text = {
            "Every card in your deck",
            "is the exact same card"
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local random_card_key = pseudorandom_element(G.P_CARDS, pseudoseed('broken_seed'))
                for k, v in pairs(G.playing_cards) do
                    v:set_base(random_card_key)
                end
                return true
            end
        }))
    end
}
SMODS.Back{key = 'subscription_deck',
    loc_txt = {
        name = "Subscription Deck",
        text = {
            "shop has no {C:attention}booster pack{} slots",
            "shop has 3 {C:attention}voucher{} slots"
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(2)
                SMODS.change_booster_limit(-2)
                return true
            end
        }))
    end
}
SMODS.Back{key = 'desktop_deck',
    loc_txt = {
        name = 'Desktop Deck',
        text = {
            "Start with {C:money}+$1{} for every",
            "{C:attention}50 files{} on your real Desktop.",
            "{C:inactive}(Currently {C:money}+$#1#{C:inactive})"
        }
    },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info)
        local money_bonus = math.floor(G.DESKTOP_FILE_COUNT / 50)
        return { vars = { money_bonus } }
    end,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.E_DECK = true
                local money_bonus = math.floor(G.DESKTOP_FILE_COUNT / 50)
                if money_bonus > 0 then
                    ease_dollars(money_bonus)
                end
                return true
            end
        }))
    end
}
SMODS.Back{key = 'supermarket_deck',
    loc_txt = {
        name = "Supermarket Deck",
        text = {
            "blind gives no money from {C:blue}hands{}",
            "and {C:attention}interest",
            "{C:attention}+2 voucher{} slots",
            "{C:attention}+1 booster{} slot",
            "{C:attention}+3 card{} slots in the shop",
            "rerolls cost {C:red}$3{} less"
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(2)
                SMODS.change_booster_limit(1)
                G.GAME.modifiers.no_interest = true
                G.GAME.modifiers.money_per_hand = 0
                change_shop_size(3)
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 3
                return true
            end
        }))
    end
}