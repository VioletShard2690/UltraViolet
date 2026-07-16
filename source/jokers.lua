function shakecard(self)
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(0.5, 0.5)
            return true
        end
    }))
end
local function factorial(n)
    if n == 0 then return 1 end
    local res = 1
    for i = 1, n do res = res * i end
    return res
end
SMODS.Joker{key = "sample_test_joker",
    config = { x_mult = 15 }, 
    rarity = 3,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'sample_test_joker',
        loc_txt = {
                name = "Sample Test joker",
                text = { 
                    "Gives {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive}how it even ended up here?"
                }
            },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.x_mult .. ' Mult',
                Xmult_mod = card.ability.x_mult
            }
        end
    end
}
SMODS.Joker{key = 'valavo',
    name = 'Valavo',
    loc_txt = {
        name = 'Valavo',
        text = {
            "At end of round,",
            "creates {C:attention}#1#{} {C:planet}Planet{} cards",
            "of your most played",
            "{C:attention}Poker Hand{} this run",
            "{C:inactive}(Must have room)"
        }
    },
    config = { extra = { planets = 2 } },
    rarity = 2,
    atlas = 'valavo',
    unlocked = true,
    discovered = true,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.planets } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            local most_played_hand = "High Card"
            local max_plays = -1
            for k, v in pairs(G.GAME.hands) do
                if v.played > max_plays then
                    max_plays = v.played
                    most_played_hand = k
                end
            end
            local planet_key = nil
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Planet' and v.config.hand_type == most_played_hand then
                    planet_key = k
                    break
                end
            end
            if planet_key then
                local space_available = G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer)
                local planets_to_spawn = math.min(card.ability.extra.planets, space_available)
                if planets_to_spawn > 0 then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + planets_to_spawn
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            for i = 1, planets_to_spawn do
                                local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet_key, 'valavo')
                                new_card:add_to_deck()
                                G.consumeables:emplace(new_card)
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                            end
                            return true
                        end)
                    }))
                    return {
                        message = '+2 planets',
                        colour = G.C.SECONDARY_SET.Planet,
                        card = card
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'second_second',
    loc_txt = {
        name = '2nd Second',
        text = {
            "Each played {C:attention}2{}",
            "is retriggered {C:attention}2{} additional times"
        }
    },
    config = { extra = { repetitions = 2 } },
    rarity = 1,
    atlas = 'second_second',
    cost = 4,
    blueprint_compat = true,
            unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 2 then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'tea_for_two',
    loc_txt = {
        name = 'Tea for Two',
        text = {
            "Earn {C:money}$1{} for each {C:attention}Pair{}",
            "played this round",
            "{C:inactive}(Currently {C:money}$#1#{C:inactive})"
        }
    },
    config = { extra = { money_per_pair = 1, current_payout = 0 } },
    rarity = 2,
    atlas = 'tea_for_two',
    cost = 6,
        blueprint_compat = false,
        unlocked = true,
    discovered = true,
 loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_payout } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == "Pair" and not context.blueprint then
            card.ability.extra.current_payout = card.ability.extra.current_payout + card.ability.extra.money_per_pair
            return {
                message = '+$1',
                colour = G.C.MONEY
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition then
        end
    end,
    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.current_payout
        if bonus > 0 then
            card.ability.extra.current_payout = 0 
            return bonus
        end
    end
}
SMODS.Joker{key = 'mr_two',
    loc_txt = {
        name = 'Mr. Two',
        text = { "Gives {X:mult,C:white} X#1# {} Mult if played hand",
                 "contains exactly {C:attention}two 2's{}",
    }
    },
    config = { extra = 2.22 },
    rarity = 2, 
    atlas = 'mr_two',
    cost = 2,
        blueprint_compat = true,
        unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 2 then
                    count = count + 1
                end
            end
            if #context.scoring_hand == 2 and count == 2 then
                return {
                    message = 'x' .. card.ability.extra .. ' Mult',
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
}
SMODS.Joker{key = 'pavel',
    config = { extra = { odds = 4, neg_odds = 16 } },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    atlas = 'pavel',
    unlocked = true,
    discovered = true,
    
    loc_txt = {
        name = "Pavel",
        text = {
             "At end of round,",
            "{C:green}#1# in #2#{} chance to",
            "create a {C:attention}Cavendish{}",
            "{C:inactive}({C:green}#1# in #3#{C:inactive} chance to be {C:dark_edition}Negative{C:inactive})",
            "{C:inactive}(Must have room){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.neg_odds } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if #G.jokers.cards < G.jokers.config.card_limit then
                if pseudorandom('pavel_rng') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    local is_negative = pseudorandom('pavel_neg') < G.GAME.probabilities.normal / card.ability.extra.neg_odds
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local cav = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_cavendish')
                            
                            if is_negative then
                                cav:set_edition({negative = true}, true)
                            end

                            cav:add_to_deck()
                            G.jokers:emplace(cav)
                            G.VIBRATION = G.VIBRATION + 1
                            play_sound('card1', 1, 0.6) 
                            
                            card:juice_up(0.5, 0.5)
                            return true
                        end
                    }))
                    if is_negative then
                        return {
                            message = "Black banana!",
                            colour = G.C.DARK_EDITION
                        }
                    else
                        return {
                            message = 'Cavendish!',
                            colour = G.C.FILTER
                        }
                    end
                else
                    return {
                        message = 'Hui tebe!',
                        colour = G.C.GREY
                    }
                end
            else
                return {
                    message = 'No room!',
                    colour = G.C.ORANGE
                }
            end
        end
    end
}
SMODS.Joker{key = 'smart_magnifying_glass',
    loc_txt = {
        name = 'Smart Magnifying Glass',
        text = {
                "When Face cards and Aces scored",
                "give chips equal to",
                "their {C:attention}rank ID{}",
                "{C:inactive}(J=11, Q=12 etc.){}"
        }
    },
    config = {},
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    atlas = 'smart_magnifying_glass',
        unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            local rank_id = context.other_card.base.id
            if rank_id >= 11 then
                return {
                    chips = rank_id,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'diamond_pickaxe',
    loc_txt = {
        name = 'Diamond Pickaxe',
        text = {
            "if played hand is {C:diamonds}flush of diamonds{},",
            "all played cards become {C:attention}steel{}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    atlas = "diamond_pickaxe",
            unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local flush_diamonds = true
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i]:is_suit('Diamonds') then
                    flush_diamonds = false
                end
            end
            
            if flush_diamonds and #context.scoring_hand >= 5 then
                for i = 1, #context.scoring_hand do
                    local sc = context.scoring_hand[i]
                    sc:set_ability(G.P_CENTERS.m_steel, nil, true)
                end
                return {
                    message = 'Mined!',
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'shadow',
    loc_txt = {
        name = 'Shadow',
        text = {
                   "Copies the ability",
                   "of rightmost {C:attention}Joker{}"
        }
    },
    config = { extra = { type = 'Shadow' } },
    rarity = 3,
    blueprint_compat = false,
    cost = 8,
    atlas = 'shadow',
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
    local target = G.jokers.cards[#G.jokers.cards]
    if target == card then target = G.jokers.cards[#G.jokers.cards - 1] end
    if target and not context.blueprint and target.key ~= self.key then
        context.blueprint = 1
        local res = target:calculate_joker(context)
        context.blueprint = nil
        if res then
            res.card = card
            return res
        end
    end
 end
}
SMODS.Joker{key = 'math_draft',
    loc_txt = {
        name = 'Math Draft',
        text = {
            "(1{C:chips}+63{})/(8{X:mult,C:white}x2{})={C:money}4{}"
        }
    },
    config = { extra = { chips = 63, x_mult = 2, money = 4 } },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    atlas = 'math_draft',
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local combined_message = "+" .. card.ability.extra.chips .. " & X" .. card.ability.extra.x_mult
            return {
                message = combined_message,
                chip_mod = card.ability.extra.chips,
                Xmult_mod = card.ability.extra.x_mult,
                card = card
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end
}
SMODS.Joker{key = 'broken_brick',
    loc_txt = {
         name = 'Broken Brick',
          text = {
             "{C:mult}+#1#{} mult" 
            } 
        },
    config = { extra = 5 },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    atlas = "broken_brick",
    unlocked = true,
    discovered = true,
    hidden = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra }
        end
    end
}
SMODS.Joker{key = 'brick',
    loc_txt = {
        name = 'Brick',
        text = {
            "{X:mult,C:white}X#3#{} Mult",
            "{C:green}#1# in #2#{} chance to be cracked",
            "at end of round"
        }
    },
    config = { extra = 2, chance = 4 },
    rarity = 1, cost = 4,
    blueprint_compat = true,
    atlas = "brick",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            G.GAME.probabilities.normal, card.ability.chance, card.ability.extra
        } }
    end,
 calculate = function(self, card, context)
    if context.joker_main then
        return { x_mult = card.ability.extra }
    end
    if context.end_of_round and not (context.individual or context.repetition or context.blueprint) then
        if pseudorandom('brick') < G.GAME.probabilities.normal / card.ability.chance then
            return {
                message = "Cracked!",
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card:start_dissolve()
                            local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_uv_broken_brick')
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            return true
                        end
                    }))
                end
            }
        else
            return { message = "Safe!" }
        end
    end
 end
}
SMODS.Joker{key = 'edition_joker',
    loc_txt = {
        name = 'The Edition Joker',
        text = {
            "This Joker gives {X:mult,C:white}X#2#{} Mult",
            "for every Joker with {C:attention}Edition{}",
            "what you own",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {}{C:inactive} Mult)"
        }
    },
    config = { extra = 0.5 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    atlas = "edition_joker",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.edition then count = count + 1 end
            end
        end
        return { vars = { 1 + (count * card.ability.extra), card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, v in ipairs(G.jokers.cards) do
                if v.edition then count = count + 1 end
            end
            if count > 0 then
                return { x_mult = 1 + (count * card.ability.extra) }
            end
        end
    end
}
SMODS.Joker{key = 'prism',
    loc_txt = {
        name = 'Prism',
        text = {
            "{C:red}discarding{} {C:attention}4{} different suits",
            "at the same time creates {C:spectral}spectral card{}",
            "{C:red}-1 hand size{}"
        }
    },
    config = { extra = { h_size = -1 } },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    atlas = "prism",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            local suits_found = {Spades = false, Hearts = false, Clubs = false, Diamonds = false}
            local wild_cards_count = 0
            for i = 1, #context.full_hand do
                if context.full_hand[i].config.center == G.P_CENTERS.m_wild then
                    wild_cards_count = wild_cards_count + 1
                else
                    local suit = context.full_hand[i].base.suit
                    if suits_found[suit] ~= nil then 
                        suits_found[suit] = true
                    end
                end
            end
            local unique_suits_count = 0
            for k, v in pairs(suits_found) do
                if v then unique_suits_count = unique_suits_count + 1 end
            end
            if (unique_suits_count + wild_cards_count) >= 4 then
                if #G.consumeables.cards < G.consumeables.config.card_limit then
                    return {
                        message = 'Refracted!',
                        colour = G.C.SECONDARY_SET.Spectral,
                        card_events = {
                            G.E_MANAGER:add_event(Event({
                                func = function() 
                                    local _card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'prism')
                                    _card:add_to_deck()
                                    G.consumeables:emplace(_card)
                                    return true
                                end
                            }))
                        }
                    }
                else
                    return {
                        message = 'No room!',
                        colour = G.C.UI.TEXT_INACTIVE
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'joker_lua',
    loc_txt = {
        name = 'SMODS.Joker',
        text = {"SMODS.Atlas({",
    'key = "joker_lua",',
    'path = "j_joker_lua.png",',
    "px = 71,",
    "py = 95",
 "})",
            "SMODS.Joker{",
    "key = 'joker_lua',",
    "loc_txt = {",
        "name = 'SMODS.Joker',",
        'text = { "gives{X:mult,C:white} X1.5 {} Mult" }',
    "},",
    "config = { extra = 1.5 },",
    "rarity = 1,",
    "cost = 4,",
    "blueprint_compat = true,",
    'atlas = "joker_lua",',
    "unlocked = true,",
    "discovered = true,",
    "calculate = function(self, card, context)",
        "if context.joker_main then",
            "return {",
                "message = 'x' .. card.ability.extra,",
                "Xmult_mod = card.ability.extra",
            "}",
        "end",
    "end",
 "}"
                    }
    },
    config = { extra = 1.5 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    atlas = "joker_lua",
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.extra,
                Xmult_mod = card.ability.extra
            }
        end
    end
}
SMODS.Joker{key = 'lucky_block',
    loc_txt = {
        name = 'Lucky Block',
        text = {
            "When {C:attention}sold{}, create a",
            "{C:attention}random{} Joker",
            "{C:inactive}(Excludes Legendaries & himself)"
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    atlas = "lucky_block",
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.selling_self or (context.selling_card == card and not context.blueprint) then
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'lucky')
                    
                    while new_card.config.center.key == 'j_lucky_block' or new_card.config.center.rarity == 4 do
                        new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'lucky')
                    end
                    
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                    new_card:start_materialize()
                    play_sound('coin1', 1, 0.5) 
                    attention_text({
                        text = 'Lucky!',
                        scale = 1, 
                        hold = 0.8,
                        major = G.jokers,
                        backdrop_col = G.C.MONEY,
                        align = 'tm',
                        offset = {x = 0, y = -2}
                    })
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'doomsday',
    loc_txt = {
        name = 'Doomsday',
        text = {
            "{X:mult,C:white} X5 {} Mult, but if blind is",
            "not defeated in {C:attention}1 hand{}",
            "{C:red}KABOOM GAME OVER{}"
        }
    },
    config = { extra = { x_mult = 5 } },
    rarity = 3,
    blueprint_compat = true,
    cost = 8,
    atlas = "doomsday",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.extra.x_mult,
                Xmult_mod = card.ability.extra.x_mult
            }
        end
        if context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.GAME.chips < G.GAME.blind.chips then
                        G.STATE = G.STATES.GAME_OVER
                        if not G.DONE_GAME_OVER then 
                            G.STATE_COMPLETE = false 
                        end
                    end
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'tax_haven',
    loc_txt = {
        name = 'Tax Haven',
        text = {
            "{C:dark_edition}+#1#{} Joker slot for every",
            "{C:money}$100{} you have",
            "{C:inactive}(Currently {C:dark_edition}+#2#{} {C:inactive}slots)"
        }
    },
    config = { extra = { slots_per_100 = 1, current_bonus = 0 } },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    atlas = 'tax_haven',
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots_per_100, card.ability.extra.current_bonus or 0 } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.base_limit = G.jokers.config.card_limit
        card.ability.extra.current_bonus = math.floor(G.GAME.dollars / 100) * card.ability.extra.slots_per_100
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.current_bonus
    end,
    update = function(self, card)
        if G.STAGE == G.STAGES.RUN and G.jokers and card.ability.extra.base_limit then
            local new_bonus = math.floor(G.GAME.dollars / 100) * card.ability.extra.slots_per_100
            if card.ability.extra.current_bonus ~= new_bonus then
                G.jokers.config.card_limit = card.ability.extra.base_limit + new_bonus
                card.ability.extra.current_bonus = new_bonus
            end
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.jokers and card.ability.extra.base_limit then
            G.jokers.config.card_limit = card.ability.extra.base_limit
            card.ability.extra.current_bonus = 0
        end
    end
}
SMODS.Joker{key = 'cube_joker',
    loc_txt = {
        name = 'Cube Joker',
        text = {
            "{X:mult,C:white} X3 {} Mult, if played hand contains",
        "exactly {C:attention}3{} cards"
    }
    },
    config = { extra = { x_mult = 3 } },
    rarity = 2,
    blueprint_compat = true,
    cost = 5,
    atlas = 'cube_joker',
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand == 3 then
            return {
                message = 'x' .. card.ability.extra.x_mult,
                Xmult_mod = card.ability.extra.x_mult
            }
        end
    end
}
SMODS.Joker{key = 'exponential_growth',
    loc_txt = {
    name = 'Exponential Growth',
    text = { 
        "If scored {C:attention}10X{}", 
        "the {C:attention}required score{}, give", 
        "{C:dark_edition}Negative{} edition to a", 
        "random {C:attention}Joker{}",
        "{C:inactive}(effect doesn't apply to this Joker){}"
    }
 },
    rarity = 'uv_super_rare',
    cost = 15,
    atlas = 'exponential_growth',
    unlocked = true,
    discovered = true,
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            if G.GAME.chips >= G.GAME.blind.chips * 10 then
                local other_jokers = {}
                for k, v in ipairs(G.jokers.cards) do
                    if v ~= card and v.edition == nil then
                        table.insert(other_jokers, v)
                    end
                end
                if #other_jokers > 0 then
                    local target = pseudorandom_element(other_jokers, pseudoseed('exp_growth'))
                    target:set_edition({negative = true}, true)
                    return {
                        message = 'Upgrade!',
                        colour = G.C.DARK_EDITION
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'doublet',
    loc_txt = {
        name = 'Doublet',
        text = { 
        "{C:mult}+#1#{} Mult for every {C:attention}2{} in your full deck",
        "{C:inactive}(Currently {C:mult}+#2#{C:inactive})"
     }
    },
    config = { extra = 2 },
    rarity = 2,
    atlas = 'doublet',
    unlocked = true,
    discovered = true,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.playing_cards then
            for _, v in pairs(G.playing_cards) do
                if v:get_id() == 2 then count = count + 1 end
            end
        end
        return { vars = { card.ability.extra, count * card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, v in pairs(G.playing_cards) do
                if v:get_id() == 2 then count = count + 1 end
            end
            if count > 0 then
                return {
                    mult_mod = count * card.ability.extra,
                    message = '+' .. (count * card.ability.extra) .. ' Mult'
                }
            end
        end
    end
}
SMODS.Joker{key = 'second_chance',
    loc_txt = {
        name = 'Second Chance',
        text = { "{C:chips}+#1#{} Chips if this is the", "{C:attention}second{} played hand of the round" }
    },
    config = { extra = 200 },
    rarity = 2,
    atlas = 'second_chance',
    unlocked = true,
    discovered = true,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 1 then
            return {
                chip_mod = card.ability.extra,
                message = '+' .. card.ability.extra .. ' Chips!'
            }
        end
    end
}
SMODS.Joker{key = 'binary_code',
    loc_txt = {
        name = 'Binary Code',
        text = { "{X:mult,C:white} X2 {} Mult if played hand", "contains exactly {C:attention}2{} ranks", "and {C:attention}2{} suits" }
    },
    config = { extra = 2 },
    rarity = 1,
    atlas = 'binary_code',
    unlocked = true,
    discovered = true,
    cost = 4,
    calculate = function(self, card, context)
        if context.joker_main then
            local ranks = {}
            local suits = {}
            for i = 1, #context.full_hand do
                local r = context.full_hand[i].base.value
                local s = context.full_hand[i].base.suit
                ranks[r] = true
                suits[s] = true
            end
            local rank_count = 0
            for _ in pairs(ranks) do rank_count = rank_count + 1 end
            local suit_count = 0
            for _ in pairs(suits) do suit_count = suit_count + 1 end
            if rank_count == 2 and suit_count == 2 then
                return {
                    Xmult_mod = card.ability.extra,
                    message = 'x' .. card.ability.extra .. 'mult'
                }
            end
        end
    end
}
SMODS.Joker{key = 'night_watch',
    loc_txt = {
        name = 'Night Watch',
        text = { 
            "Earn {C:money}$2{} at end of round",
        "if you have exactly {C:attention}2{} discards remaining" 
    }
    },
    config = { extra = 2 },
    rarity = 1,
    atlas = 'night_watch',
    unlocked = true,
    discovered = true,
    cost = 4,
    calculate = function(self, card, context)
        if context.ending_shop and G.GAME.current_round.discards_left == 2 then
            return {
                message = '$' .. card.ability.extra,
                dollar_counts = card.ability.extra,
                colour = G.C.MONEY
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.current_round.discards_left == 2 then
            return card.ability.extra
        end
    end
}
SMODS.Joker{key = "ace_of_spades",
    config = { chips = 11 }, 
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'ace_of_spades',
    loc_txt = {
        name = "Ace of Spades",
        text = { 
            "{C:chips}+#1#{} chips"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.chips } }
    end,
    update = function(self, card, dt)
        if G.GAME and G.GAME.blind then
            if G.GAME.blind.name == 'The Goad' and not G.GAME.blind.disabled then
                if not card.debuff then
                    card:set_debuff(true)
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '+' .. card.ability.chips,
                chip_mod = card.ability.chips
            }
        end
    end
}
SMODS.Joker{key = 'charm_joker',
    loc_txt = {
        name = 'Mega Arcana Pack',
        text = {
            "Gives {C:attention}Charm Tag{}",
            "at end of round"
        }
    },
    config = {},
    rarity = 2,
    atlas = 'charm_joker',
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    display_size = { w = 71, h = 115 },
 calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_charm'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
            return {
                message = "Tag!", 
                colour = G.C.FILTER
            }
        end
    end
}
SMODS.Joker{key = 'Imposter',
    loc_txt = {
        name = 'Imposter',
        text = {
            'gives chips and mult based on',
            '{C:attention}random poker hand{} with the',
            'same number of cards',


            '{C:inactive}5 = Flush Five, Flush House, Five of a Kind, Straight Flush{}',
            '{C:inactive}Four of a Kind, Full House, Flush, Straight{}',
            '{C:inactive}4 = Four of a Kind, Two Pair, Pair{}',
            '{C:inactive}3 = Three of a Kind, Pair{}',
            '{C:inactive}2 = Two Pair, Pair{}',
            '{C:inactive}1 = High Card{}'
        }
    },
    config = {},
    rarity = 2,
    atlas = 'Imposter',
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = #context.scoring_hand
            local logic = {
                [5] = {"Flush Five", "Flush House", "Five of a Kind", "Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight"},
                [4] = {"Four of a Kind", "Two Pair", "Pair"},
                [3] = {"Three of a Kind", "Pair"},
                [2] = {"Two Pair", "Pair"},
                [1] = {"High Card"}
            }
            local possible_hands = logic[count] or {"High Card"}
            local new_hand_name = pseudorandom_element(possible_hands, pseudoseed('i'))
            local new_hand_data = G.GAME.hands[new_hand_name]
            local target_chips = new_hand_data.chips + (new_hand_data.level - 1) * new_hand_data.l_chips
            local target_mult = new_hand_data.mult + (new_hand_data.level - 1) * new_hand_data.l_mult
            return {
                message = new_hand_name .. '!',
                chip_mod = target_chips,
                mult_mod = target_mult,
                colour = G.C.FILTER
            }
        end
    end
}
SMODS.Joker{key = 'void_contract',
    loc_txt = {
        name = 'Void Contract',
        text = {
            "Gives {X:mult,C:white} X#2 # {} Mult",
            "increases by {X:mult,C:white} X#1 # {} Mult after each blind",
            '{C:red}Destroys{} 1 random card from your deck',
            'when {C:attention}Blind{} is defeated'
        }
    },
    config = { extra = { x_mult_gain = 0.1, x_mult = 1 } },
    rarity = 2,
    atlas = 'void_contract',
    cost = 6,
    blueprint_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
    if context.joker_main then
        return {
            message = 'x' .. card.ability.extra.x_mult,
            Xmult_mod = card.ability.extra.x_mult
        }
    end
    if context.end_of_round and not (context.individual or context.repetition) then
        if not context.blueprint then
            if G.deck and #G.deck.cards > 0 then
                local destroyed_card = pseudorandom_element(G.deck.cards, pseudoseed('void_contract'))
                destroyed_card:remove()
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                return {
                    message = '-1 card',
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
    end
}
SMODS.Joker{key = 'joker_404',
    loc_txt = {
        name = '404: Joker not found',
        text = {
            'Gives {C:chips}+#1#{} chips',
            'increases by {C:chips}#2#{} every time when',
            'exactly {C:attention}4{} cards discarded'
        }
    },
    config = { extra = 40, chips = 0 }, 
    rarity = 2, 
    cost = 4,
    atlas = 'joker_404', 
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.chips, card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable', key='a_chips', vars={card.ability.chips}},
                chip_mod = card.ability.chips,
                colour = G.C.CHIPS
            }
        end
        if context.discard and not context.blueprint then
            if context.other_card == context.full_hand[#context.full_hand] and #context.full_hand == 4 then
                card.ability.chips = card.ability.chips + card.ability.extra
                return {
                    message = 'Upgrade!',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'schrodinger_cat',
    loc_txt = {
        name = "Schrödinger's Cat",
        text = {
            "Gives {X:mult,C:white} X#3# {} Mult,",
            "has a {C:green}#1# in #2#{} chance",
            "to give {X:mult,C:white} X0 {} Mult instead"
        }
    },
    config = { extra = { Xmult = 3, odds = 4 } },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    atlas = 'schrodinger_cat',
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('schrodinger_cat') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return {
                    message = 'X0',
                    Xmult_mod = 0,
                    colour = G.C.MULT
                }
            else
                return {
                    message = 'x' .. card.ability.extra.Xmult,
                    Xmult_mod = card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = "joker_outline",
    config = { mult = 0.4 }, 
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'joker_outline',
        loc_txt = {
                name = "Joker outline",
                text = { 
                    "{C:mult}+#1#{} mult"
                }
            },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '+' .. card.ability.mult .. ' Mult',
                mult_mod = card.ability.mult
            }
        end
    end
}
SMODS.Joker{key = "small_joker",
    config = {}, 
    rarity = 3,
    cost = 1,
    blueprint_compat = false,
    unlocked = true,
    discovered = true,
        loc_txt = {
                name = "Small Joker",
                text = { 
                    "yay u found Easter Egg yippee"
                }
            },
    display_size = { w = 10000000, h = 10000000 },
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "big_boi" })
    end
}
SMODS.Joker{key = "code_joker", -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    config = { extra = { gain = 0.1, chips = 6281 } },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'code_joker',
        loc_txt = {
                name = "Code joker",
                text = { 
                    "gives {C:chips}+#1#{} chips for every line",
                    "of code in {C:blue}jokers.lua{}",
                    "{C:inactive}(currently{} {C:chips}+#2#{}{C:inactive} chips){}"
                }
            },
    loc_vars = function(self, info_queue, card)
        local final_chips = card.ability.extra.chips * card.ability.extra.gain
        return { vars = { card.ability.extra.gain, final_chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local final_chips = card.ability.extra.chips * card.ability.extra.gain
            return {
                message = '+' .. final_chips .. ' Chips',
                chip_mod = final_chips
            }
        end
    end
}
SMODS.Joker{key = 'bloody_knife',
    atlas = 'bloody_knife', 
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_txt = {
        name = 'Bloody Knife',
        text = {
            "{C:attention}-#1#%{} blind requirement",
        }
    },
    config = { extra = { reduction = 0.10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.reduction * 100 } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local current_chips = G.GAME.blind.chips
            local new_chips = math.max(1, math.floor(current_chips * (1 - card.ability.extra.reduction)))
            G.GAME.blind.chips = new_chips
            G.GAME.blind.chip_text = number_format(new_chips)
            return {
                message = "-" .. card.ability.extra.reduction * 100 .. "%",
                colour = G.C.RED,
                card = card
            }
        end
    end
}
SMODS.Joker{key = 'shark',
    atlas = 'shark',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_txt = {
        name = 'Shark',
        text = {
            "Destroys card with {C:attention}lowest rank{} when scored",
            "adds its base chips to this Joker",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
            '{C:inactive}if there are more than 1 card with lowest rank{}',
            '{C:inactive}destroy the rightmost one{}'
        }
    },
    config = { extra = { chips = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    message = "+" .. card.ability.extra.chips,
                    chip_mod = card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end
        if context.before and not context.blueprint then
            if context.scoring_hand and #context.scoring_hand > 0 then
                local lowest_card = context.scoring_hand[1]
                for i = 2, #context.scoring_hand do
                    if context.scoring_hand[i].base.id < lowest_card.base.id then
                        lowest_card = context.scoring_hand[i]
                    end
                end
                card.ability.shark_target = lowest_card
            end
        end
        if context.destroying_card and not context.blueprint then
            if card.ability.shark_target and context.destroying_card == card.ability.shark_target then
                local chips_to_add = context.destroying_card.base.nominal or 0
                card.ability.extra.chips = card.ability.extra.chips + chips_to_add
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "+" .. chips_to_add .. " Chips!",
                    colour = G.C.CHIPS
                })
                card.ability.shark_target = nil
                return true
            end
        end
        if context.after and not context.blueprint then
            card.ability.shark_target = nil
        end
    end
}
SMODS.Joker{key = 'tooth',
    loc_txt = {
        name = '2th',
        text = {
            "Every scored {C:attention}2{}",
            "gives {C:mult}+#1#{} mult"
        }
    },
    config = { extra = 22 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'tooth',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 2 then
                return {
                    mult = card.ability.extra,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'book',
    loc_txt = {
        name = 'Book',
        text = {
            "{C:chips}+#1#{} Chips for each",
            "{C:attention}Lucky Card{} in your full deck",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    config = { extra = { chips_per = 10 } },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'book',
    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.playing_cards then
            for _, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_lucky then
                    count = count + 1
                end
            end
        end
        return { vars = { card.ability.extra.chips_per, count * card.ability.extra.chips_per } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_lucky then
                    count = count + 1
                end
            end
            if count > 0 then
                return {
                    message = localize{type='variable', key='a_chips', vars={count * card.ability.extra.chips_per}},
                    chip_mod = count * card.ability.extra.chips_per
                }
            end
        end
    end
}
SMODS.Joker{key = 'accumulation',
    loc_txt = {
        name = 'Accumulation',
        text = {
            "{C:chips}+#1#{} Chips for each card",
            "above {C:attention}52{} in your full deck",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    config = { extra = { chips_per = 3, threshold = 52 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'accumulation',
    loc_vars = function(self, info_queue, card)
        local deck_size = G.playing_cards and #G.playing_cards or 52
        local count = math.max(0, deck_size - card.ability.extra.threshold)
        return { vars = { card.ability.extra.chips_per, count * card.ability.extra.chips_per } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local deck_size = #G.playing_cards
            local count = math.max(0, deck_size - card.ability.extra.threshold)
            if count > 0 then
                return {
                    message = localize{type='variable', key='a_chips', vars={count * card.ability.extra.chips_per}},
                    chip_mod = count * card.ability.extra.chips_per
                }
            end
        end
    end
}
SMODS.Joker{key = 'banana_farm',
    loc_txt = {
        name = 'Banana Farm',
        text = {
            "Gains {C:money}$#2#{} at the end of shop",
            "{C:inactive}(Currently {C:money}$#1#{C:inactive})"
        }
    },
    config = { extra = { money = 1, increase = 1 } },
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'banana_farm',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.increase } }
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.money > 0 then
            return card.ability.extra.money
        end
    end,
    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint and not context.repetition then
            card.ability.extra.money = card.ability.extra.money + card.ability.extra.increase
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Upgraded!'})
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'dr_balatro',
    loc_txt = {
        name = 'Dr. Balatro',
        text = {
            "Each played {C:attention}King{} of {C:hearts}Hearts{}",
            "gives {X:mult,C:white}X#1#{} Mult"
        }
    },
    config = { extra = 2.1 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'dr_balatro',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 13 and context.other_card:is_suit('Hearts') then
                return {
                    x_mult = card.ability.extra,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'frame_perfect',
    loc_txt = {
        name = 'Frame Perfect',
        text = {
            "{C:green}#1# in #2#{} chance to {C:edition}win the game{}",
            "at the end of the round"
        }
    },
    config = { extra = 240 },
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'frame_perfect', 
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal, card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition then
            if pseudorandom('frame_perfect') < G.GAME.probabilities.normal / card.ability.extra then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'GG!'})
                        win_game()
                        return true
                    end
                }))
            end
        end
    end
}
SMODS.Joker{key = 'bouncy_ball',
    loc_txt = {
        name = 'Bouncy Ball',
        text = {
            "{C:chips}+#1#{} Chips for each time {C:attention}Spacebar{} is pressed",
            "Resets after Boss Blind",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    config = { extra = { chips = 0, per_press = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'bouncy_ball', 
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per_press, card.ability.extra.chips } }
    end,
    update = function(self, card, dt)
        local is_pressed = love.keyboard.isDown('space')
        if is_pressed and not card.last_space_pressed then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.per_press
            local message_pool = {'Boink!', 'Boing!', 'Hop!', 'Spring!', 'Jump!'}
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = message_pool[math.random(#message_pool)], 
                colour = G.C.CHIPS, 
                instant = true 
            })
            card:juice_up(0.2, 0.05)
        end
        card.last_space_pressed = is_pressed
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize{type='variable', key='a_chips', vars={card.ability.extra.chips}}
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if G.GAME.blind.boss then
                card.ability.extra.chips = 0
                return {
                    message = 'Reset!',
                    colour = G.C.CHIPS
                }
            end
        end
        if card.ability.extra.chips >= 1000 then
            check_for_unlock({ type = "spacebar_warrior" })
        end
    end
}
SMODS.Joker{key = 'golden_bullet',
    loc_txt = {
    name = 'Golden Bullet',
    text = {
        "{C:mult}+#1#{} Mult for each",
        "each remaining",
        "{C:attention}hand{}"
    }
    },
    config = { extra = 5 },
    rarity = 1,
    atlas = 'golden_bullet',
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local remaining_hands = G.GAME.current_round.hands_left
            if remaining_hands > 0 then
                return {
                    message = '+' .. (card.ability.extra * remaining_hands) .. ' Mult',
                    mult_mod = card.ability.extra * remaining_hands
                }
            end
        end
    end
}
SMODS.Joker{key = 'face_james',
    loc_txt = {
        name = 'Face James',
        text = {
            "Played cards with",
            "{C:attention}faces{} gives",
            "{C:money}$#1#{} when scored",
            "{C:inactive}(J, Q, K){}"
        }
    },
    config = { extra = { dollars = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    rarity = 1,
    atlas = 'face_james',
    cost = 4,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                return {
                    dollars = card.ability.extra.dollars,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'pqbd',
    loc_txt = {
        name = 'pqbd',
        text = {
            "every letter gives",
            "something different"
        }
    },
    config = { extra = { mult = 16, x_mult = 1.7, money = 2, chips = 40 } },
    rarity = 2,
    atlas = 'pqbd',
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local roll = pseudorandom('pqbd')
            if roll < 0.25 then
                return {
                    mult = card.ability.extra.mult,
                    message = 'p',
                    colour = G.C.MULT
                }
            elseif roll < 0.5 then
                return {
                    x_mult = card.ability.extra.x_mult,
                    message = 'q',
                    colour = G.C.MULT
                }
            elseif roll < 0.75 then
                ease_dollars(card.ability.extra.money)
                return {
                    message = 'b',
                    colour = G.C.MONEY
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    message = 'd',
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker{key = 'bear_skeleton',
    loc_txt = {
    name = 'Bear Skeleton',
        text = {
            "Gives {X:mult,C:white}x#2#^n{} mult",
            "where n is the number",
            "of current hand",
            "{C:inactive}(currently {X:mult,C:white}x#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { base = 2 } },
    rarity = 3, 
    atlas = 'bear_skeleton',
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local hands_in_round = G.GAME.current_round.hands_played or 0
        local current_x = math.pow(card.ability.extra.base, hands_in_round + 1)
        return { vars = { current_x, card.ability.extra.base } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.extra.base ^ ((G.GAME.current_round.hands_played or 0) + 1) .. ' Mult',
                Xmult_mod = card.ability.extra.base ^ ((G.GAME.current_round.hands_played or 0) + 1),
                colour = G.C.MULT
            }
        end
    end
}
SMODS.Joker{key = 'cursed_calculator',
    loc_txt = {
        name = 'Cursed Calculator',
        text = {
            "{C:red}#1#{} mult",
            "{X:mult,C:white}x#2#{} mult"
        }
    },
    config = { extra = { mult = -10, x_mult = 1.5 } },
    rarity = 1,
    atlas = 'cursed_calculator',
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                x_mult = card.ability.extra.x_mult,
                message = message,
                colour = G.C.MULT
            }
        end
    end
}
SMODS.Joker{key = 'math_chaos',
    loc_txt = {
        name = 'Mathematical Chaos',
        text = {
            "Played cards give {X:mult,C:white}X#1#{} Mult and {C:chips}+#2#{} Chips",
            "Gives {X:chips,C:white}X#12#{} chips for every Joker to the left",
            "{C:inactive}(currently {}{X:chips,C:white}X#10#{}{C:inactive} chips){}",
            "upgrade played hand by {C:attention}#11#{} level for every joker to the {C:attention}right{}",
            "Using {C:planet}Planet{} cards gives {C:mult}+#3#{} Mult {C:inactive}(Currently {C:mult}+#4#{C:inactive})",
            "Using {C:tarot}Tarot{} cards gives {C:chips}+#5#{} Chips {C:inactive}(Currently {C:chips}+#6#{C:inactive})",
            "Earn {C:money}$#7#{} at end of round",
            "Gains {C:money}+$#13#{} after Blind, {X:money,C:white}X#13#{} after Boss Blind",
            "Rerolls in shop damage blind by {C:attention}#8#%{} {C:inactive}(Currently {C:attention}-#9#%#{C:inactive})",
            "Using {C:spectral}Spectral{} cards resets all values",
            "{C:inactive}({}{C:tarot}Tarot{} {C:inactive}bonus scored before {}{X:chips,C:white}X chips{}{C:inactive}){}"
        }
    },
    config = {
        extra = {
            card_xmult = 1.2, card_chips = 11,
            planet_gain = 9, tarot_gain = 15, money_gain = 2, drain_gain = 0.1,
            bonus_mult = 0, bonus_chips = 0, bonus_money = 0, total_drain = 0,
            x_chips_base = 1, x_chips_per_joker = 0.2, level_up_per_joker = 1
        }
    },
    rarity = 'uv_super_rare',
    cost = 15,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'math_chaos',
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    loc_vars = function(self, info_queue, card)
        local vars = (card and card.ability and card.ability.extra) and card.ability.extra or self.config.extra
        local left_jokers = 0
        if G.jokers and G.jokers.cards then
            for i, jkr in ipairs(G.jokers.cards) do
                if jkr == card then break end
                left_jokers = left_jokers + 1
            end
        end
        local current_x_chips = vars.x_chips_base + (left_jokers * vars.x_chips_per_joker)
        return { vars = {
            vars.card_xmult, vars.card_chips,
            vars.planet_gain, vars.bonus_mult,
            vars.tarot_gain, vars.bonus_chips,
            vars.bonus_money, vars.drain_gain, vars.total_drain,
            current_x_chips, vars.level_up_per_joker, vars.x_chips_per_joker, vars.money_gain
        }}
    end,
    calculate = function(self, card, context)
        local extra = card.ability.extra
        if context.joker_main then
            local left_count = 0
            for i, jkr in ipairs(G.jokers.cards) do
                if jkr == card then break end
                left_count = left_count + 1
            end
            local total_x_chips = extra.x_chips_base + (left_count * extra.x_chips_per_joker)
            return {
                message = 'x' .. total_x_chips .. ' Chips',
                Xchip_mod = total_x_chips,
                mult_mod = extra.bonus_mult > 0 and extra.bonus_mult or nil,
                colour = G.C.CHIPS
            }
        end
        if context.individual and context.cardarea == G.play then
            return {
                x_mult = extra.card_xmult,
                chips = extra.card_chips,
                card = context.other_card
            }
        end
        if context.before and not context.blueprint then
            local my_pos = nil
            for i, jkr in ipairs(G.jokers.cards) do
                if jkr == card then my_pos = i break end
            end
            if my_pos and my_pos < #G.jokers.cards then
                local right_count = #G.jokers.cards - my_pos
                level_up_hand(card, context.scoring_name, nil, right_count * extra.level_up_per_joker)
                return { message = 'Level Up!', colour = G.C.ATTENTION }
            end
        end
        if context.using_consumeable and not context.blueprint then
            local set = context.consumeable.ability.set
            if set == 'Planet' then
                extra.bonus_mult = extra.bonus_mult + extra.planet_gain
                return { message = '+' .. extra.planet_gain .. ' Mult', colour = G.C.MULT }
            elseif set == 'Tarot' then
                extra.bonus_chips = extra.bonus_chips + extra.tarot_gain
                return { message = '+' .. extra.tarot_gain .. ' Chips', colour = G.C.CHIPS }
            elseif set == 'Spectral' then
                extra.bonus_mult = 0; extra.bonus_chips = 0; extra.bonus_money = 0; extra.total_drain = 0
                return { message = 'Reset!', colour = G.C.RED }
            end
        end
        if context.reroll_shop and not context.blueprint then
            extra.total_drain = extra.total_drain + extra.drain_gain
            return { message = '+' .. extra.drain_gain .. '%', colour = G.C.BLUE }
        end
        if context.setting_blind and not context.blueprint then
            if extra.total_drain > 0 and G.GAME.blind.chips then
                local damage = G.GAME.blind.chips * (extra.total_drain / 100)
                G.GAME.blind.chips = G.GAME.blind.chips - damage
                if G.GAME.blind.chips < to_big(1) then G.GAME.blind.chips = to_big(1) end
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return { message = 'Damaged!' }
            end
        end
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if G.GAME.blind.boss then
                extra.bonus_money = extra.bonus_money * extra.money_gain
                return { message = 'X$' .. extra.money_gain, colour = G.C.MONEY }
            else
                extra.bonus_money = extra.bonus_money + extra.money_gain
                return { message = '+$' .. extra.money_gain, colour = G.C.MONEY }
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.bonus_money > 0 then
            return card.ability.extra.bonus_money
        end
    end
}
SMODS.Joker{key = 'bag_of_chips',
    loc_txt = {
        name = 'Bag of Chips',
        text = { "Gives {X:chips,C:white}x#1#{} chips" }
    },
    config = { extra = 3 },
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'bag_of_chips',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.extra .. ' Chips',
                Xchip_mod = card.ability.extra,
                colour = G.C.CHIPS
            }
        end
    end
}
SMODS.Joker{key = 'pascal',
    loc_txt = {
        name = 'Pascal',
        text = {
            "Gives {X:mult,C:white}Xfactorial{} mult",
            "equal to scored cards",
            "in current hand",
            "{C:enhanced}+#1#{} card selection limit"
        }
    },
    config = { extra = { csl = 1 } },
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    atlas = 'pascal',
    soul_pos={x=0,y=1},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.csl } }
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(card.ability.extra.csl)
        SMODS.change_discard_limit(card.ability.extra.csl)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_play_limit(-card.ability.extra.csl)
        SMODS.change_discard_limit(-card.ability.extra.csl)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if #context.scoring_hand >= 50 then
                check_for_unlock({ type = "superfactorial" })
            end
            local n = #context.scoring_hand
            if n > 0 then
                local res = 1
                for i = 1, n do 
                    res = res * i 
                end
                if res > 1 then
                    return {
                        message = 'X' .. number_format(res) .. ' Mult',
                        Xmult_mod = res,
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'trash_can',
    loc_txt = {
        name = 'The Trash Can',
        text = { "{C:red}+#1#{} card discard limit" }
    },
    config = { extra = 1 },
    rarity = 1,
    blueprint_compat = true,
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'trash_can',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_discard_limit(card.ability.extra)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_discard_limit(-card.ability.extra)
    end
}
SMODS.Joker{key = 'lemon',
    loc_txt = {
        name = 'Lemon',
        text = {
            "{C:attention}-#1#%{} Blind requirement",
            "reduces by",
            "{C:red}#2#%{} every round"
        }
    },
    config = { extra = { current_reduction = 25, step = 5 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_reduction, card.ability.extra.step } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if G.GAME.blind.chips and card.ability.extra.current_reduction > 0 then
                local reduction_factor = (100 - card.ability.extra.current_reduction) / 100
                G.GAME.blind.chips = G.GAME.blind.chips * reduction_factor
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                return {
                    message = 'Squeezed!',
                    colour = G.C.FILTER
                }
            end
        end
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current_reduction = card.ability.extra.current_reduction - card.ability.extra.step
            if card.ability.extra.current_reduction <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Eaten!',
                    colour = G.C.ORANGE
                }
            else
                return {
                    message = '-5%',
                    colour = G.C.FILTER
                }
            end
        end
    end
}
SMODS.Joker{key = 'exponential_power',
    loc_txt = {
        name = 'Exponential Power',
        text = {
            "{X:mult,C:white}^#1#{} mult",
        }
    },
    config = { extra = { e_mult = 2 } },
    rarity = 'uv_super_rare',
    cost = 15,
    unlocked = true,
    discovered = true, 
    blueprint_compat = true,
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.e_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '^' .. card.ability.extra.e_mult .. ' Mult',
                Emult_mod = card.ability.extra.e_mult,
                colour = G.C.MULT
            }
        end
    end
}
SMODS.Joker{key = 'great_equalizer',
    loc_txt = {
        name = 'The Great Equalizer',
        text = {
            "{X:chips,C:white}^#1#{} chips",
            "{X:mult,C:white}^#2#{} mult"
        }
    },
    config = { extra = { e_chips = 2, e_mult = 0.5 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'great_equalizer',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.e_chips, card.ability.extra.e_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'Equalized!',
                Echip_mod = card.ability.extra.e_chips,
                Emult_mod = card.ability.extra.e_mult,
                colour = G.C.PURPLE
            }
        end
    end
}
SMODS.Joker{key = 'pear',
    loc_txt = {
        name = 'Pear',
        text = {
            "{X:chips,C:white}X#1#{} chips,",
            "reduces by {X:chips,C:white}X#2#{}",
            "after each hand played"
        }
    },
    config = { extra = { current_x = 3, step = 0.25 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x, card.ability.extra.step } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.current_x > 1 then
            return {
                message = 'x' .. card.ability.extra.current_x .. ' Chips',
                Xchip_mod = card.ability.extra.current_x,
                colour = G.C.CHIPS
            }
        end
        if context.after and not context.blueprint then
            card.ability.extra.current_x = card.ability.extra.current_x - card.ability.extra.step
            if card.ability.extra.current_x <= 1 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Eaten!',
                    colour = G.C.GREEN
                }
            else
                return {
                    message = '-x' .. card.ability.extra.step,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker{key = 'plum',
    loc_txt = {
        name = 'Plum',
        text = {
            "{X:mult,C:white}^#1#{} mult",
            "{X:mult,C:white}-^#2#{} per",
            "round played"
        }
    },
    config = { extra = { current_pow = 1.5, step = 0.05 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_pow, card.ability.extra.step } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '^' .. card.ability.extra.current_pow .. ' Mult',
                Emult_mod = card.ability.extra.current_pow,
                colour = G.C.MULT
            }
        end
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current_pow = card.ability.extra.current_pow - card.ability.extra.step
            if card.ability.extra.current_pow <= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Eaten!',
                    colour = G.C.PURPLE
                }
            else
                return {
                    message = '-^' .. card.ability.extra.step .. ' Mult',
                    colour = G.C.PURPLE
                }
            end
        end
    end
}
SMODS.Joker{key = 'kiwi',
    loc_txt = {
        name = 'Kiwi',
        text = {
            "{X:chips,C:white}^#1#{} chips",
            "reduces by {X:chips,C:white}-^#2#{}",
            "after each hand played"
        }
    },
    config = { extra = { current_pow = 2.0, step = 0.1 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_pow, card.ability.extra.step } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '^' .. card.ability.extra.current_pow .. ' Chips',
                Echip_mod = card.ability.extra.current_pow,
                colour = G.C.CHIPS
            }
        end
        if context.after and not context.blueprint then
            card.ability.extra.current_pow = card.ability.extra.current_pow - card.ability.extra.step
            if card.ability.extra.current_pow <= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Eaten!',
                    colour = G.C.GREEN
                }
            else
                return {
                    message = '-^' .. card.ability.extra.step .. ' Chips',
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker{key = 'overclock',
    loc_txt = {
        name = 'Overclock',
        text = {
            "Gives {X:mult,C:white}^#1#{} Mult",
            "Increases by {X:mult,C:white}^#2#{}",
            "after each {C:attention}hand{} is played",
        }
    },
    config = { extra = { current_pow = 1, step = 0.02 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_pow, card.ability.extra.step } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local p_val = card.ability.extra.current_pow
            if p_val > 1 then
                return {
                    message = '^' .. p_val .. ' Mult',
                    Emult_mod = p_val,
                    colour = G.C.MULT
                }
            end
        end
        if context.after and not context.blueprint then
            card.ability.extra.current_pow = card.ability.extra.current_pow + card.ability.extra.step
            return {
                message = '+^' .. card.ability.extra.step .. ' Mult',
                colour = G.C.PURPLE,
                card = card
            }
        end
    end
}
SMODS.Joker{key = 'puzzle',
    loc_txt = {
        name = 'Puzzle',
        text = {
            "Converts all {C:attention}played cards{} to",
            "a random suit every round",
            "{C:inactive}(Currently #1#)"
        }
    },
    config = { extra = { current_suit = 'Spades' } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'puzzle',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_suit } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
            card.ability.extra.current_suit = suits[pseudorandom('kaleido', 1, 4)]
            return {
                message = card.ability.extra.current_suit .. '!',
                colour = G.C.FILTER
            }
        end
        if context.before and not context.blueprint then
            for i=1, #context.scoring_hand do
                local scoring_card = context.scoring_hand[i]
                if scoring_card.base.suit ~= card.ability.extra.current_suit then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scoring_card:change_suit(card.ability.extra.current_suit)
                            scoring_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            return {
                message = 'Refracted!',
                colour = G.C.FILTER
            }
        end
    end
}
SMODS.Joker{key = 'pomegranate',
    loc_txt = {
        name = 'Pomegranate',
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "decreases by {C:money}$#2#{} at end of round"
        }
    },
    config = { extra = { payout = 5, step = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.payout, card.ability.extra.step } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            local current_payout = card.ability.extra.payout
            if current_payout > 0 then
                ease_dollars(current_payout)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.5, 0.5)
                        return true
                    end
                }))
            end
            if not context.blueprint then
                card.ability.extra.payout = card.ability.extra.payout - card.ability.extra.step
                if card.ability.extra.payout <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card:start_dissolve()
                            return true
                        end
                    }))
                    return {
                        message = 'Eaten!',
                        colour = G.C.MONEY
                    }
                else
                    return {
                        message = '-$' .. card.ability.extra.step,
                        colour = G.C.MONEY
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'hand_mutant',
    loc_txt = {
        name = 'Hand-Mutant',
        text = {
            "{C:blue}+#1#{} hands"
        }
    },
    config = { extra = { hands = 1.22 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
    end,
}
SMODS.Joker{key = 'gangle_mask',
    loc_txt = {
        name = "Gangle's Mask",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "{C:green}#2# in #3#{} chance to",
            "break at end of round"
        }
    },
    config = { extra = { x_mult = 5.7, odds = 6 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'gangle_mask',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, G.GAME.probabilities.normal, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.extra.x_mult .. ' Mult',
                Xmult_mod = card.ability.extra.x_mult
            }
        end
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if pseudorandom('gangle') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot2')
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Broken!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}
SMODS.Joker{key = 'scissors',
    loc_txt = {
        name = 'Scissors',
        text = {
            "add all current {C:chips}chips{} and {C:mult}mult{} to this joker",
            "score apply only on the last hand of round",
            "apply all stored score at last hand of round",
            "score in joker stacks",
            "{C:inactive}(currently {}{C:chips}+#1# chips{}{C:inactive} and {}{C:mult}+#2# mult{}{C:inactive}){}",
            "{C:inactive}(joker doesn't store values, if in first joker slot){}"
        }
    },
    config = { extra = { stored_chips = 0, stored_mult = 0 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'scissors',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.stored_chips, card.ability.extra.stored_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            if G.GAME.current_round.hands_left > 0 then
                card.ability.extra.stored_chips = card.ability.extra.stored_chips + hand_chips
                card.ability.extra.stored_mult = card.ability.extra.stored_mult + mult
                hand_chips = 0
                mult = 0
                return {
                    message = 'Stored!',
                    colour = G.C.MULT
                }
            else
                return {
                    chips = card.ability.extra.stored_chips,
                    mult = card.ability.extra.stored_mult,
                    message = message
                }
            end
        end
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.stored_chips = 0
            card.ability.extra.stored_mult = 0
        end
    end
}
SMODS.Joker{key = 'recursive_hands',
    loc_txt = {
        name = 'Recursive Hands',
        text = {
            "{X:blue,C:white} x#1# {} Hands"
        }
    },
    config = { extra = { hand_mod = 1.5 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_mod } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands * card.ability.extra.hand_mod
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands / card.ability.extra.hand_mod
    end,
}
SMODS.Joker{key = 'bottomless_pocket',
    loc_txt = {
        name = 'Bottomless Pocket',
        text = {
            "{X:red,C:white}^#1#{} Discards"
        }
    },
    config = { extra = { discard_pow = 1.3 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.discard_pow } }
    end,
    add_to_deck = function(self, card, from_debuff)
        old_discards = G.GAME.round_resets.discards
        G.GAME.round_resets.discards = G.GAME.round_resets.discards ^ card.ability.extra.discard_pow
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = old_discards
    end,
}
SMODS.Joker{key = 'infinite_staircase',
    loc_txt = {
        name = 'Infinite Staircase',
        text = {
            "{C:green}#1# in #2#{} chance when",
            "{C:attention}Boss Blind{} is defeated",
            "to go back {C:attention}1{} Ante",
            "{C:inactive}cannot fall lower than ante 2{}"
        }
    },
    config = { extra = { odds = 3 } },
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'infinite_staircase',
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, G.GAME.round_resets.ante } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.blind.boss and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('staircase') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.GAME.round_resets.ante = math.max(1, G.GAME.round_resets.ante - 2)
                
                return {
                    message = 'Falling Back!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}
SMODS.Joker{key = 'golden_cookie',
    loc_txt = {
        name = 'Golden Cookie',
        text = {
            "Gives {X:money,C:white}x#1#{} dollars",
            "at the end of round"
        }
    },
    config = { extra = { money_mult = 1.5 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'golden_cookie',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money_mult } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            local current_dollars = to_big(G.GAME.dollars)
            local mult = to_big(card.ability.extra.money_mult)
            local zero = to_big(0)
            local bonus = current_dollars * mult - current_dollars
            if bonus > zero then
                local message_val = (type(bonus) == 'table') and 'Big Money!' or bonus
                
                ease_dollars(bonus)
                return {
                    message = 'X' .. card.ability.extra.money_mult .. '$',
                    colour = G.C.MONEY
                }
            end
        end
    end
}
SMODS.Joker{key = 'ai_generated_joker',
    loc_txt = {
        name = 'AI-Generated Joker',
        text = {
            "this joker was fully coded by ai expect this line and name",
            "When {C:attention}Boss Blind{} is defeated, {C:green}#1# in #2#{} chance",
            "to {C:attention}corrupt{} data:",
            "{C:inactive}(ex: delete a suit, make cards Polychrome, etc.){}",
            "{C:inactive}(It feels unstable...){}"
        }
    },
    config = { extra = { odds = 4, effect_pool = {'delete_suit', 'polychrome_all', 'make_stone', 'foil_all'} } },
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'ai_joker',
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.blind.boss and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('ai_generated') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local effect = pseudorandom_element(card.ability.extra.effect_pool, pseudoseed('ai_gen_effect'))
                local message = ''
                if effect == 'delete_suit' then
                    local suits = {'Hearts', 'Clubs', 'Diamonds', 'Spades'}
                    local target_suit = pseudorandom_element(suits, pseudoseed('delete_suit'))
                    for _, k in pairs(G.playing_cards) do
                        if k.base.suit == target_suit then
                            k:set_suit('Wild')
                        end
                    end
                    message = target_suit .. ' Corrupted!'
                elseif effect == 'polychrome_all' then
                    for i, k in ipairs(context.scoring_hand) do
                        k:set_edition({polychrome = true}, true)
                    end
                    message = 'Glitch! xMult!'
                elseif effect == 'make_stone' then
                    local cards_in_hand = G.hand.cards
                    for i=1, 2 do
                        local target_card = pseudorandom_element(cards_in_hand, pseudoseed('make_stone'))
                        if target_card then
                            target_card:set_ability(G.P_CENTERS.m_stone)
                        end
                    end
                    message = 'System Brick!'
                elseif effect == 'foil_all' then
                    for i, k in ipairs(G.hand.cards) do
                        k:set_edition({foil = true}, true)
                    end
                    message = 'Neon Glow!'
                end
                card:juice_up(0.5, 0.5)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        attention_text({
                            text = message,
                            scale = 1.5, 
                            hold = 3,
                            colour = G.C.PURPLE,
                            align = 'cm',
                            offset = {x=0, y=-2.5}
                        })
                        return true
                    end
                }))
                return {
                    message = 'Glitching!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}
SMODS.Joker{key = 'the_headstart',
    loc_txt = {
        name = 'The Headstart',
        text = {
            "{C:purple}+#1#{} score",
            "at start of round"
        }
    },
    config = { extra = { chip_bonus = 2222 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_bonus } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local bonus = to_big(card.ability.extra.chip_bonus)
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_chips(bonus)
                    return true
                end
            }))
            return {
                message = "+2222 score",
                colour = G.C.PURPLE
            }
        end
    end
}
SMODS.Joker{key = 'bureaucrat',
    loc_txt = {
        name = 'The Bureaucrat',
        text = {
            "When {C:attention}sold{}, restocks the",
            "{C:attention}Voucher{} in shop"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.selling_self and G.STATE == G.STATES.SHOP then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.shop_vouchers then
                        for i = #G.shop_vouchers.cards, 1, -1 do
                            G.shop_vouchers.cards[i]:remove()
                        end
                        local v_key = get_next_voucher_key(true)
                        if v_key == 'v_blank' then v_key = get_next_voucher_key(true) end
                        local new_v = Card(
                            G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
                            G.shop_vouchers.T.y, 
                            G.CARD_W, 
                            G.CARD_H, 
                            G.P_CARDS.empty, 
                            G.P_CENTERS[v_key], 
                            {bypass_discovery_center = true, bypass_discovery_ui = true}
                        )
                        new_v:set_ability(G.P_CENTERS[v_key])
                        create_shop_card_ui(new_v, 'Voucher', G.shop_vouchers)
                        new_v:set_cost()
                        new_v.area = G.shop_vouchers
                        G.shop_vouchers:emplace(new_v)
                        new_v:start_materialize()
                        attention_text({
                            text = 'Restocked!',
                            scale = 1, 
                            hold = 1.2,
                            major = new_v,
                            backdrop_colour = G.C.GOLD
                        })
                    end
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'telescope',
    loc_txt = {
        name = 'Telescope',
        text = {
            "If you have the {C:planet}Planet{} card of",
            "current played {C:attention}Poker Hand{}",
            "upgrade that hand"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'telescope',
    calculate = function(self, card, context)
        if context.before and not context.repetition then
            local played_hand = context.scoring_name
            local found_planet = false
            if G.consumeables and G.consumeables.cards then
                for i = 1, #G.consumeables.cards do
                    local c = G.consumeables.cards[i]
                    if c.ability.set == 'Planet' and c.config.center.config.hand_type == played_hand then
                        found_planet = true
                        break
                    end
                end
            end
            if found_planet then
                level_up_hand(card, played_hand, false, 1)
                return {
                    message = 'Level Up!',
                    colour = G.C.BLUE
                }
            end
        end
    end
}
SMODS.Joker{key = 'vcr_player',
    loc_txt = {
        name = 'VCR Player',
        text = {
            "This Joker gains {X:chips,C:white}x#2#{} chips",
            "every time {C:attention}Boss{} is rerolled.",
            "{C:inactive}(Currently {}{X:chips,C:white}x#1#{}{C:inactive} chips){}"
        }
    },
    config = { extra = 1.0, gain = 0.25 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'vhs_player',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra > 1 then
            return {
                message = 'x' .. card.ability.extra .. ' Chips',
                Xchip_mod = card.ability.extra,
                colour = G.C.CHIPS
            }
        end
        if context.reroll_boss and not context.blueprint then
            card.ability.extra = card.ability.extra + card.ability.gain
            return {
                message = 'Upgrade!',
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
}
SMODS.Joker{key = 'snail',
    loc_txt = {
        name = 'Snail',
        text = {
            "{X:mult,C:white}x#1#{} Mult if game",
            "speed is set to {C:attention}#2#x{}"
        }
    },
    config = { extra = 8.5, target_speed = 0.5 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'snail',
    loc_vars = function(self, info_queue, card)
        local current_speed = G.SETTINGS and G.SETTINGS.GAMESPEED or 1
        return { vars = { card.ability.extra, card.ability.target_speed, current_speed } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.SETTINGS and G.SETTINGS.GAMESPEED == card.ability.target_speed then
                return {
                    message = 'x' .. card.ability.extra .. ' Mult',
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
}
SMODS.Joker{key = 'collectors_album',
    loc_txt = {
        name = "collector's album",
        text = {
            "This Joker gains {X:mult,C:white}x#1#{} Mult",
            "for each {C:attention}unique Tag{} you have",
            "{C:inactive}(Currently {}{X:mult,C:white}x#2#{} {C:inactive}Mult){}"
        }
    },
    config = { extra = 1 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local unique_tags = 0
        if G.GAME and G.GAME.tags then
            local seen_tags = {}
            for _, tag in pairs(G.GAME.tags) do
                if not seen_tags[tag.key] then
                    seen_tags[tag.key] = true
                    unique_tags = unique_tags + 1
                end
            end
        end
        local current_mult = 1 + (unique_tags * card.ability.extra)
        return { vars = { card.ability.extra, current_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local seen_tags = {}
            local unique_count = 0
            if G.GAME and G.GAME.tags then
                for _, tag in pairs(G.GAME.tags) do
                    if not seen_tags[tag.key] then
                        seen_tags[tag.key] = true
                        unique_count = unique_count + 1
                    end
                end
            end
            if unique_count > 0 then
                local total_xmult = 1 + (unique_count * card.ability.extra)
                return {
                    message = localize{type='variable', key='a_xmult', vars={total_xmult}},
                    Xmult_mod = total_xmult
                }
            end
        end
    end
}
SMODS.Joker{key = 'joker_blind',
    loc_txt = {
        name = 'Joker Blind',
        text = {
            "{C:attention}rerolls{} the",
            "current Boss Blind when {C:attention}sold{}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'joker_blind',
    display_size = { w = 71, h = 71 },
    calculate = function(self, card, context)
        if context.selling_self then
            if G.GAME and G.GAME.blind and G.GAME.blind:get_type() ~= 'Boss' then
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.FUNCS.reroll_boss()
                    ease_dollars(10)
                    attention_text({
                        text = 'Rerolled!',
                        scale = 1, 
                        hold = 1.2,
                        major = G.play,
                        backdrop_colour = G.C.BLUE
                    })
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'discord',
    loc_txt = {
        name = 'Discord Joker',
        text = {
            "{C:mult}+#1#{} Mult for each {C:attention}unique suit{}",
            "contained in played hand"
        }
    },
    config = { extra = 22 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'discord',
    display_size = { w = 71, h = 71 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local suits_present = {}
            local unique_suits_count = 0
            for i = 1, #context.full_hand do
                local suit = context.full_hand[i].base.suit
                if not suits_present[suit] then
                    suits_present[suit] = true
                    unique_suits_count = unique_suits_count + 1
                end
            end
            if unique_suits_count > 0 then
                return {
                    message = '+' .. (unique_suits_count * card.ability.extra) .. ' Mult',
                    mult_mod = unique_suits_count * card.ability.extra
                }
            end
        end
    end
}
SMODS.Joker{key = 'spotify',
    loc_txt = {
        name = 'Spotify',
        text = {
            "This Joker gains {C:mult}+#1#{} Mult per",
            "{C:attention}consecutive{} hand played with same {C:attention}suit{}",
            "{C:inactive}(Currently {}{C:mult}+#2#{} {C:inactive}Mult){}"
        }
    },
    config = { extra = 8, current_mult = 0, last_suit = 'None' },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'spotify',
    display_size = { w = 71, h = 71 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.current_mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local flush_suit = nil
            local is_single_suit = true
            for i = 1, #context.scoring_hand do
                if not flush_suit then flush_suit = context.scoring_hand[i].base.suit end
                if context.scoring_hand[i].base.suit ~= flush_suit then
                    is_single_suit = false; break
                end
            end

            if is_single_suit and flush_suit then
                if flush_suit == card.ability.last_suit then
                    card.ability.current_mult = card.ability.current_mult + card.ability.extra
                else
                    card.ability.last_suit = flush_suit
                    card.ability.current_mult = card.ability.extra
                end
                return {
                    message = '+' .. card.ability.current_mult .. ' Mult',
                    mult_mod = card.ability.current_mult
                }
            else
                card.ability.current_mult = 0
                card.ability.last_suit = 'None'
            end
        end
    end
}
SMODS.Joker{key = 'roblox',
    loc_txt = {
        name = 'Roblox',
        text = {
            "{C:chips}+#1#{} Chips for each",
            "{C:attention}Joker{} and {C:attention}Consumable{} card you have",
            "{C:inactive}(Currently {}{C:chips}+#2#{} {C:inactive}Chips){}"
        }
    },
    config = { extra = 25 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'roblox',
    display_size = { w = 71, h = 71 },
    loc_vars = function(self, info_queue, card)
        local total_items = #G.jokers.cards + #G.consumeables.cards
        return { vars = { card.ability.extra, total_items * card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total_items = #G.jokers.cards + #G.consumeables.cards
            return {
                message = '+' .. (total_items * card.ability.extra) .. ' Chips',
                chip_mod = total_items * card.ability.extra
            }
        end
    end
}
SMODS.Joker{key = 'messenger_max',
    loc_txt = {
        name = 'Messenger Max',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult",
            "{C:red}Instant lose{} if",
            "you have apps that {C:red}banned in russia{}",
            "Ловит даже на парковке"
        }
    },
    config = { x_mult = 5.2 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'max',
    display_size = { w = 71, h = 71 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    update = function(self, card)
        if G.STAGE == G.STAGES.RUN and G.STATE ~= G.STATES.GAME_OVER and card.area == G.jokers then
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center.key == 'j_uv_discord' or 
                   j.config.center.key == 'j_uv_spotify' or 
                   j.config.center.key == 'j_uv_x' or 
                   j.config.center.key == 'j_uv_roblox' then
                    G.STATE = G.STATES.GAME_OVER
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            card:juice_up()
                            G.FUNCS.overlay_menu{
                                definition = create_UIBox_game_over(),
                                config = {no_esc = true}
                            }
                            return true
                        end
                    }))
                    break
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.x_mult .. ' Mult',
                Xmult_mod = card.ability.x_mult
            }
        end
    end
}
SMODS.Joker{key = 'socrates',
    loc_txt = {
        name = 'Socrates',
        text = {
            "if {C:mult}Mult{} is your power",
            "who are you without it?",
            "All {C:mult}+Mult{} Jokers",
            "gives {C:chips}+Chips{} instead"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    calculate = function(self, card, context)
    end
}
SMODS.Joker{key = 'lcdirects0.5',
    loc_txt = {
        name = 'LCDirects with 10.5 points',
        text = {
            "Earn {C:money}$#1#{} after",
            "each played hand"
        }
    },
    config = { extra = 0.5 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'lcdirects0.5',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            ease_dollars(card.ability.extra)
            return {
                message = '$0.5',
                colour = G.C.MONEY
            }
        end
    end
}
SMODS.Joker{key = 'eight_four',
    loc_txt = {
        name = 'Eight Four',
        text = {
            "If played hand contains an {C:attention}8, 4 and king{}",
            "{C:chips}+84{} Chips and {C:mult}+12{} Mult"
        }
    },
    config = { chips = 84, mult = 12 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local has_8 = false
            local has_4 = false
            local has_K = false
            for i = 1, #context.full_hand do
                if context.full_hand[i]:get_id() == 8 then has_8 = true end
                if context.full_hand[i]:get_id() == 4 then has_4 = true end
                if context.full_hand[i]:get_id() == 13 then has_K = true end
            end
            if has_8 and has_4 and has_K then
                return {
                    message = '84!',
                    chip_mod = card.ability.chips,
                    mult_mod = card.ability.mult,
                    colour = G.C.PURPLE
                }
            end
        end
    end
}
SMODS.Joker{key = 'x',
    loc_txt = {
        name = 'X',
        text = {
            "Gives {X:mult,C:white}X#1#{} mult if",
            "played hand contains {C:attention}1{} card,",
            "otherwise gives {X:mult,C:white}X#2#{}",
            "mult for each card in hand"
        }
    },
    config = { extra = { x_mult_single = 2.2, x_mult_per_card = 0.2, base = 1 } },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_single, card.ability.extra.x_mult_per_card } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local card_count = #context.full_hand
            local final_x_mult = 1
            if card_count == 1 then
                final_x_mult = card.ability.extra.x_mult_single
            else
                final_x_mult = card.ability.extra.base + (card_count * card.ability.extra.x_mult_per_card)
            end
            return {
                message = 'x' .. final_x_mult .. ' Mult',
                Xmult_mod = final_x_mult
            }
        end
    end
}
SMODS.Joker{key = 'extender',
    loc_txt = {
        name = 'Extender',
        text = {
            "{C:enhanced}+#1#{} card selection limit",
            "{C:red}-1{} hand size"
        }
    },
    config = { extra = { play_limit = 2, discard_limit = 2, h_size_mod = -1 } },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.play_limit, card.ability.extra.h_size_mod } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size_mod)
        SMODS.change_play_limit(card.ability.extra.play_limit)
        SMODS.change_discard_limit(card.ability.extra.discard_limit)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size_mod)
        SMODS.change_play_limit(-card.ability.extra.play_limit)
        SMODS.change_discard_limit(-card.ability.extra.discard_limit)
    end
}
SMODS.Joker{key = 'sleepy_joker',
    loc_txt = {
        name = 'Sleepy Joker',
        text = {
            "{C:mult}+8{} Mult for each played",
            "{C:attention}non-scored{} card",
            "in current hand"
        }
    },
    config = { extra_mult = 8 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.current_mult or 0 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local non_scoring_count = 0
            non_scoring_count = #context.full_hand - #context.scoring_hand
            if non_scoring_count > 0 then
                local total_mult = non_scoring_count * card.ability.extra_mult
                card.ability.current_mult = total_mult
                return {
                    message = '+' .. total_mult .. ' Mult',
                    mult_mod = total_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = 'nuclear_bomb',
    loc_txt = {
        name = 'Nuclear Bomb',
        text = {
            "POV: you realise that you can put anything",
            "into joker description and effect still works",
            "so you put this and now you don't know what it does",
            "i like kvass and yahiamice"
        }
    },
    config = { x_mult = 3, last_hand = 'None' },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_hand = context.scoring_name
            if current_hand ~= card.ability.last_hand then
                return {
                    message = '?',
                    Xmult_mod = card.ability.x_mult,
                    colour = G.C.MULT
                }
            else
                return {
                    message = '?',
                    colour = G.C.FILTER
                }
            end
        end
        if context.after and not context.blueprint then
            card.ability.last_hand = context.scoring_name
        end
    end
}
SMODS.Joker{key = 'desperate_hope',
    loc_txt = {
        name = "Desperate Hope",
        text = {
            "{C:green}1 in 1,000,000,000{} chance",
            "to give {C:mult}+10{} Mult",
            "else give {C:mult}-10{} Mult",
            "{C:inactive}(chance cant be changed){}"
        }
    },
    config = { extra_mult = 10 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '-10 Mult',
                mult_mod = card.ability.extra_mult,
                colour = G.C.RED
            }
        end
    end
}
SMODS.Joker{key = 'watermelon_paradox',
    loc_txt = {
        name = 'Watermelon Paradox',
        text = {
            "Gives {C:blue}+#1#{} Chips and {C:mult}+#2#{} Mult",
            "At end of round, dries {C:blue}chips{}",
            "of this Joker by {C:attention}1%{}",
            "while {C:mult}mult{} remains the same",
            "{C:inactive}(Currently {C:blue}#3#%{C:inactive} chips){}"
        }
    },
    config = { dry_mass_val = 10, water_percent = 99, drier_done = false },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'watermelon_paradox',
    loc_vars = function(self, info_queue, card)
        local dry_percent = 100 - card.ability.water_percent
        local total_weight = (card.ability.dry_mass_val * 100) / dry_percent
        local chips = math.max(0, math.floor(total_weight - card.ability.dry_mass_val))
        return { vars = { chips, card.ability.dry_mass_val, card.ability.water_percent } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.drier_done = false
        end
        if context.joker_main then
            local dry_percent = 100 - card.ability.water_percent
            local total_weight = (card.ability.dry_mass_val * 100) / dry_percent
            local chips = math.max(0, math.floor(total_weight - card.ability.dry_mass_val))
            
            return {
                chip_mod = chips,
                mult_mod = card.ability.dry_mass_val,
                message = 'Fresh!'
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition then
            if not card.ability.drier_done and card.ability.water_percent > 1 then
                card.ability.water_percent = card.ability.water_percent - 1
                card.ability.drier_done = true
                return {
                    message = '-1% Water',
                    colour = G.C.ATTENTION
                }
            end
        end
    end
}
SMODS.Joker{key = 'plunger',
    loc_txt = {
        name = 'Plunger',
        text = {
            "Earn {C:money}$#1#{} if played",
            "hand contains a {C:attention}Flush{}"
        }
    },
    rarity = 1,
    cost = 4,
    config = { money = 2 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'plunger',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name and string.find(context.scoring_name, 'Flush') then
                ease_dollars(card.ability.money)
                return {
                    message = '+$' .. card.ability.money,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'utility_belt',
    loc_txt = {
        name = 'Utility Belt',
        text = {
            "{C:attention}+#1#{} slot(s) for consumables.",
            "Increases by {C:attention}+#2#{} when",
            "{C:attention}Boss Blind{} is defeated."
        }
    },
    rarity = 2,
    cost = 6,
    config = { extra = 0, gain = 1 },
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.gain } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.boss then
                card.ability.extra = card.ability.extra + card.ability.gain
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.gain
                return {
                    message = 'Upgrade!',
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra
    end
}
SMODS.Joker{key = 'ace_in_hole',
    loc_txt = {
        name = 'Ace in the Hole',
        text = {
            "This joker gains {C:chips}+#2#{} Chips",
            "when each {C:attention}Ace{} is scored.",
            "{C:inactive}(Currently {}{C:chips}+#1#{} {C:inactive}Chips){}"
        }
    },
    rarity = 1,
    cost = 4,
    config = { extra = 0, gain = 6 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra, card.ability.gain } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 then
                card.ability.extra = card.ability.extra + card.ability.gain
                return {
                    extra = { focus = card, message = 'Upgrade!' },
                    colour = G.C.ATTENTION,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra > 0 then
            return {
                chip_mod = card.ability.extra,
                message = '+' .. card.ability.extra .. ' Chips',
                colour = G.C.CHIPS
            }
        end
    end
}
SMODS.Joker{key = 'muscle_memory',
    loc_txt = {
        name = 'Muscle Memory',
        text = {
            "Gains {X:mult,C:white} X#2# {} Mult when your",
            "{C:attention}most played hand{} is discarded.",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {} {C:inactive}Mult)"
        }
    },
    rarity = 2,
    cost = 6,
    config = { extra = 1, gain = 0.1 },
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local hand_name = "None"
        if G.GAME and G.GAME.hands then
            local most_played_hand = "High Card"
            local max_plays = -1
            for k, v in pairs(G.GAME.hands) do
                if v.played > max_plays then
                    max_plays = v.played
                    most_played_hand = k
                end
            end
            hand_name = localize(most_played_hand, 'poker_hands')
        end
        return { vars = { card.ability.extra, card.ability.gain, hand_name } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            local poker_hands = evaluate_poker_hand(context.full_hand)
            local discard_name = "High Card"
            for _, v in ipairs(G.handlist) do
                if poker_hands[v] and next(poker_hands[v]) then
                    discard_name = v
                    break
                end
            end
            local most_played_hand = "High Card"
            local max_plays = -1
            if G.GAME and G.GAME.hands then
                for k, v in pairs(G.GAME.hands) do
                    if v.played > max_plays then
                        max_plays = v.played
                        most_played_hand = k
                    end
                end
            end
            if discard_name == most_played_hand then
                card.ability.extra = card.ability.extra + card.ability.gain
                return {
                    message = 'Upgrade!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra > 1 then
            return {
                message = 'x' .. card.ability.extra,
                Xmult_mod = card.ability.extra
            }
        end
    end
}
SMODS.Joker{key = 'mob_spawner',
    loc_txt = {
        name = 'Mob Spawner',
        text = {
            "Press {C:attention}'S'{} to spawn a random",
            "{C:attention}Perishable{} Joker.",
            "{C:inactive}(Must have room){}",
            "{C:inactive}(created jokers sells for {}{C:money}$0{}{C:inactive}){}"
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    update = function(self, card, dt)
        local is_pressed = love.keyboard.isDown('s')
        if is_pressed and not card.last_s_pressed 
        and #G.jokers.cards < G.jokers.config.card_limit + G.GAME.joker_buffer then
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'spawner')
                    new_card:set_perishable(true)
                    new_card.sell_cost = 0
                    new_card.ability.extra_value = 0
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    return true
                end
            }))
            local colors = {G.C.FILTER, G.C.RED, G.C.BLUE, G.C.GOLD, G.C.PURPLE, G.C.GREEN}
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = 'Spawn!',
                colour = colors[math.random(#colors)],
                instant = true
            })
            card:juice_up(0.3, 0.1)
        end
        card.last_s_pressed = is_pressed
    end
}
SMODS.Joker{key = 'grindstone',
    loc_txt = {
        name = 'Grindstone',
        text = {
            "Gives {X:chips,C:white}x#1#{} Chips for each",
            "{C:attention}Enhanced card{} in played hand.",
            "{C:inactive}(even if not debuffed){}"
        }
    },
    config = { extra = 0.5 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_hand then
            local enhanced_count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].config.center ~= G.P_CENTERS.c_base then
                    enhanced_count = enhanced_count + 1
                end
            end
            local total_x_chips = 1 + (enhanced_count * card.ability.extra)
            if total_x_chips > 1 then
                return {
                    message = 'x' .. total_x_chips .. ' Chips',
                    Xchip_mod = total_x_chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker{key = 'hedge',
    loc_txt = {
        name = 'Hedge',
        text = {
            "Played {C:attention}Steel Cards{} give",
            "{X:mult,C:white}x#1#{} Mult when scored."
        }
    },
    config = { extra = 1.75 },
    rarity = 2,
    cost = 6,
    atlas = 'hedge',
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.config.center == G.P_CENTERS.c_steel or context.other_card.ability.name == 'Steel Card' then
                return {
                    x_mult = card.ability.extra,
                    card = context.other_card
                }
            end
        end
    end
}
SMODS.Joker{key = 'echo_chamber',
    loc_txt = {
        name = 'Echo Chamber',
        text = {
            "Retrigger each played card n times,",
            "where n is the number of cards",
            "with that {C:attention}rank{} in the played hand."
        }
    },
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local count = 0
            if context.scoring_hand then
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == context.other_card:get_id() then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                return {
                    message = 'Again!',
                    repetitions = count,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'introvert_joker',
    loc_txt = {
        name = 'Introvert Joker',
        text = {
            "Gives {C:mult}+#1#{} Mult for each",
            "{C:attention}non-Face card{} in your deck",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
    config = { extra = { mult_per_card = 1 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.playing_cards then
            for _, v in pairs(G.playing_cards) do
                if not v:is_face() then
                    count = count + 1
                end
            end
        end
        local total_mult = count * (card.ability.extra.mult_per_card or 1)
        return { vars = { card.ability.extra.mult_per_card, total_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if G.playing_cards then
                for _, v in pairs(G.playing_cards) do
                    if not v:is_face() then
                        count = count + 1
                    end
                end
            end
            local mult_to_add = count * (card.ability.extra.mult_per_card or 1)
            if mult_to_add > 0 then
                return {
                    message = '+' .. mult_to_add .. ' Mult',
                    mult_mod = mult_to_add,
                    colour = G.C.MULT
                }
            end
        end
        return nil
    end
}
SMODS.Joker{key = 'repeater',
    loc_txt = {
        name = 'Repeater',
        text = {
            "Retriggers the {C:attention}last card{}",
            "in the current hand",
            "{C:attention}1{} time for each card",
            "in {C:attention}current hand{}"
        }
    },
    config = { extra = {} },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local hand_size = #context.scoring_hand
            local last_card = context.scoring_hand[hand_size]
            if context.other_card == last_card then
                return {
                    message = 'Again!',
                    repetitions = hand_size,
                    card = card
                }
            end
        end
        return nil
    end
}
SMODS.Joker{key = 'scales',
    loc_txt = {
        name = 'Scales',
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult if",
            "number of {C:attention}scored cards{} in current hand",
            "equals to number of {C:attention}jokers{} you own",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)"
        }
    },
    config = { extra = { current_x_mult = 1, increase = 0.1 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'scales',
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_x_mult, card.ability.extra.increase } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current_x_mult ~= 1 then
                return {
                    message = 'X' .. card.ability.extra.current_x_mult .. ' Mult',
                    Xmult_mod = card.ability.extra.current_x_mult
                }
            end
        end
        if context.before and not context.blueprint and context.scoring_hand then
            local hand_size = #context.scoring_hand
            local joker_count = #G.jokers.cards
            if hand_size == joker_count then
                if joker_count >= 10 then check_for_unlock({ type = "ultimate_balance" }) end
                card.ability.extra.current_x_mult = card.ability.extra.current_x_mult + card.ability.extra.increase
                return {
                    message = 'Upgrade!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        return nil
    end
}
SMODS.Joker{key = 'alchemist',
    config = {extra = 0.1},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_txt = {
        name = "Alchemist Joker",
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult for every",
            "level of played poker hand",
            "{C:inactive}(last given mult: {X:mult,C:white}X#2#{}{C:inactive})"
        }
    },
    loc_vars = function(self, info_queue, card)
        local current_hand = G.GAME.last_hand_played or 'High Card'
        local hand_level = 1
        if G.GAME.hands[current_hand] and G.GAME.hands[current_hand].level then
            hand_level = G.GAME.hands[current_hand].level
        end
        local current_xmult = 1 + (hand_level * card.ability.extra)
        return {vars = {card.ability.extra, current_xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_hand = context.scoring_name or G.GAME.last_hand_played or 'High Card'
            local hand_level = 1
            if G.GAME.hands[current_hand] and G.GAME.hands[current_hand].level then
                hand_level = G.GAME.hands[current_hand].level
            end
            local final_xmult = 1 + (hand_level * card.ability.extra)
            if final_xmult > 1 then
                return {
                    message = 'X' .. to_number(final_xmult) .. ' Mult',
                    Xmult_mod = final_xmult
                }
            end
        end
    end
} 
SMODS.Joker{key = 'milky_way',
    rarity = 'uv_super_rare',
    cost = 15,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    config = { extra = { level_mult = 3 } },
    loc_txt = {
        name = "Milky Way",
        text = {
            "When a {C:planet}Planet{} card is used,",
            "it {X:attention,C:white}X#1#{} the level of",
            "the upgraded poker hand.",
            "{C:inactive}(ex: {C:attention}4{C:inactive} -> {C:attention}5{C:inactive}[planet itself] -> {C:attention}#2#{C:inactive}[Milky Way]){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        local final_level = 4 * card.ability.extra.level_mult
        return { vars = { number_format(card.ability.extra.level_mult), final_level } }
    end,
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    calculate = function(self, card, context)
        if context.using_consumeable then
            local consumeable = context.consumeable
            if consumeable.ability.set == 'Planet' then
                local hand_type = consumeable.config.center.config.hand_type
                if hand_type and G.GAME.hands[hand_type] then
                    local current_level = to_number(G.GAME.hands[hand_type].level) or 1
                    local levels_to_add = current_level * (card.ability.extra.level_mult - 1) - card.ability.extra.level_mult
                    if levels_to_add > 0 then
                        level_up_hand(card, hand_type, nil, levels_to_add)
                        return {
                            message = 'Leveled up!',
                            colour = G.C.ATTENTION
                        }
                    end
                end
            end
        end
    end
}
SMODS.Joker{key = 'homeless',
    config = { extra = { mult = 0, gain = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_txt = {
        name = "Homeless Joker",
        text = {
            "Gains {C:mult}+#2#{} Mult after each played hand.",
            "Resets if played hand is a {C:attention}Full House{}",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = '+' .. to_number(card.ability.extra.mult) .. ' Mult',
                mult_mod = card.ability.extra.mult
            }
        end
        if context.before and not context.blueprint then
            if context.scoring_name == 'Full House' then
                if card.ability.extra.mult > 0 then
                    card.ability.extra.mult = 0
                    return {
                        message = 'Reset!',
                        colour = G.C.RED
                    }
                end
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                return {
                    message = '+' .. tostring(card.ability.extra.gain) .. ' Mult',
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = 'cyan_concrete',
    config = { extra = { dollars_per_discard = 1 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    loc_txt = {
        name = "Cyan Concrete",
        text = {
            "Earn {C:money}$#1#{} for every",
            "{C:red}discard{} left at end of round.",
            "{C:inactive,s:0.7}7.8/10, to much cyan"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars_per_discard } }
    end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.current_round.discards_left > 0 then
            local bonus = G.GAME.current_round.discards_left * card.ability.extra.dollars_per_discard
            return bonus
        end
    end
}
SMODS.Joker{key = 'horseman',
    config = {extra = {xmult_gain = 0.5}},
    loc_txt = {
        name = "Horseman Joker",
        text = {
            "Gains {X:mult,C:white} x#1# {} Mult for",
            "every {C:attention}Horse Seal{} in your deck",
            "{C:inactive}(Currently {X:mult,C:white} x#2# {}{C:inactive} Mult)",
            "{C:dark_edition}Yahimod cross-mod joker{}"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local current_xmult = 1
        if SMODS.Mods["Yahimod"] and G.playing_cards then
            local count = 0
            for _, v in ipairs(G.playing_cards) do
                if v.seal == 'yahimod_horse_seal' then
                    count = count + 1
                end
            end
            current_xmult = current_xmult + (count * card.ability.extra.xmult_gain)
        end
        return {vars = {card.ability.extra.xmult_gain, current_xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_xmult = 1
            if SMODS.Mods["Yahimod"] and G.playing_cards then
                local count = 0
                for _, v in ipairs(G.playing_cards) do
                    if v.seal == 'yahimod_horse_seal' then
                        count = count + 1
                    end
                end
                current_xmult = current_xmult + (count * card.ability.extra.xmult_gain)
            end
            if current_xmult > 1 then
                return {
                    message = 'x' .. current_xmult .. ' Mult',
                    Xmult_mod = current_xmult
                }
            end
        end
    end
}
SMODS.Joker{key = 'tooth_fairy',
    config = {extra = {money = 6}},
    loc_txt = {
        name = "Tooth Fairy",
        text = {
            "Every played card gives {C:money}$#1#{}",
            "if current blind is {C:attention}The Tooth{}"
        }
    },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if G.GAME.blind and (G.GAME.blind.name == 'The Tooth' or G.GAME.blind.key == 'bl_tooth') then
                ease_dollars(card.ability.extra.money)
                return {
                    message = '$' .. card.ability.extra.money,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'spirit_joker',
    loc_txt = {
        name = "Spirit Joker",
        text = {
            "Played cards with {C:purple}Purple Seals{}",
            "create a random {C:spectral}Spectral{} card",
            "{C:inactive}(Must have room)"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.seal == 'Purple' and #G.consumeables.cards < G.consumeables.config.card_limit + G.GAME.consumeable_buffer then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local spectral_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'spirit_joker')
                        spectral_card:add_to_deck()
                        G.consumeables:emplace(spectral_card)
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                        return true
                    end)
                }))
                return {
                    message = 'Spectral!',
                    colour = G.C.SECONDARY_SET.Spectral,
                    card = card
                }
            end
        end
    end
}
SMODS.Joker{key = 'teo',
    config = {extra = {xchips_gain = 0.1, xchips = 1, odds = 5}},
    loc_txt = {
        name = "Teo",
        text = {
            "Gains {X:chips,C:white}x#1#{} chips",
            "for every played {C:attention}Glass Card{},",
            "has a {C:green}#2# in #3#{} chance to",
            "destroy itself at end of round.",
            "{C:attention}Teo{} can't break if",
            "you have {C:attention}Photograph{}",
            "{C:inactive}(Currently {X:chips,C:white}x#4#{C:inactive} chips)"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xchips_gain, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.xchips}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Glass Card' then
                card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_gain
                return {
                    message = 'Upgrade!',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.xchips > 1 then
            return {
                message = 'x' .. card.ability.extra.xchips .. ' Chips',
                Xchip_mod = card.ability.extra.xchips,
                colour = G.C.CHIPS
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if next(SMODS.find_card('j_photograph')) then
                return {
                    message = 'Saved!',
                    colour = G.C.ATTENTION
                }
            else
                if pseudorandom('teo_break') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot2')
                            card:start_dissolve()
                            return true
                        end
                    }))
                    return {
                        message = 'Broken!'
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'digital_green',
    config = {extra = {}},
    loc_txt = {
        name = "Digital Green",
        text = {
            "Scored cards with {C:green}Green Seals{}",
            "create a random {C:dark_edition}Negative{} {C:green}Code Card{}",
            "{C:dark_edition}Cryptid cross-mod joker{}"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        if SMODS.Mods["Cryptid"] then
            info_queue[#info_queue+1] = {key = 'code_cards', set = 'Other', vars = {}}
        end
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if SMODS.Mods["Cryptid"] then
            if context.individual and context.cardarea == G.play then
                if context.other_card.seal == 'cry_green' then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            local code_card = create_card('Code', G.consumeables, nil, nil, nil, nil, nil, 'digital_green')
                            code_card:set_edition({negative = true}, true, false)
                            code_card:add_to_deck()
                            G.consumeables:emplace(code_card)
                            return true
                        end)
                    }))
                    return {
                        message = 'Code!',
                        colour = G.C.GREEN,
                        card = card
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'sus',
    config = { x_mult = 3.32, odds = 4 },
    loc_txt = {
        name = 'Sus Joker',
        text = {
            "Gives {X:mult,C:white}x#1#{} Mult.",
            "At the end of round, {C:green}#2# in #3#{} chance",
            "to rickroll you"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info, card)
        return { vars = { card.ability.x_mult, (G.GAME.probabilities.normal or 1), card.ability.odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'x' .. card.ability.x_mult .. ' Mult',
                Xmult_mod = card.ability.x_mult
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('rickroll_trigger') < G.GAME.probabilities.normal / card.ability.odds then
                love.system.openURL("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
            end
        end
    end
}
SMODS.Joker{key = 'moon_joker',
    config = { extra = { x_mult = 3 } },
    loc_txt = {
        name = 'Moon Joker',
        text = {
            "Gives {X:mult,C:white}X#1#{} Mult",
            "if current time is",
            "between {C:attention}11:00 PM{} and {C:attention}7:00 AM{}",
            "Status: {C:attention}#2#"
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info, card)
        local current_hour = os.date("*t").hour
        local status_text = ""
        if current_hour >= 23 or current_hour < 7 then
            status_text = "Active"
        else
            status_text = "Inactive"
        end
        return { vars = { card.ability.extra.x_mult, status_text } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_hour = os.date("*t").hour
            if current_hour >= 23 or current_hour < 7 then
                return {
                    message = 'x' .. card.ability.extra.x_mult .. ' Mult',
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.PURPLE
                }
            end
        end
    end
}
SMODS.Joker{key = 'system32',
    config = { extra = 1 },
    loc_txt = {
        name = 'System 32',
        text = {
            "Gives {C:mult}+#1#{} Mult for every",
            "Gigabyte of free space on your {C:attention}Drive C:{}",
            "{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)"
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info, card)
        local current_mult = G.SYSTEM32_FREE_GB * card.ability.extra
        return { vars = { card.ability.extra, current_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_mult = G.SYSTEM32_FREE_GB * card.ability.extra
            if current_mult > 0 then
                return {
                    message = '+' .. current_mult .. ' Mult',
                    mult_mod = current_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = 'task_manager',
    config = { extra = 4 },
    loc_txt = {
        name = 'The Task Manager',
        text = {
            "Gives {C:mult}+#1#{} Mult for every active",
            "process running on your computer.",
            "{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult)"
        }
    },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info, card)
        local current_mult = G.SYSTEM_PROCESS_COUNT * card.ability.extra
        return { vars = { card.ability.extra, current_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_mult = G.SYSTEM_PROCESS_COUNT * card.ability.extra
            if current_mult > 0 then
                return {
                    message = '+' .. current_mult .. ' Mult',
                    mult_mod = current_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = 'hyper_volume',
    config = { extra = 2 },
    loc_txt = {
        name = 'Hyper-Volume',
        text = {
            "Gives {C:chips}+#1#{} Chips for every {C:attention}Gigabyte{}",
            "of games installed in your Steam library {C:inactive}(Drive C:)",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info, card)
        local current_chips = G.STEAM_GAMES_GB * card.ability.extra
        return { vars = { card.ability.extra, current_chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_chips = G.STEAM_GAMES_GB * card.ability.extra
            if current_chips > 0 then
                return {
                    message = '+' .. current_chips .. ' Chips',
                    chip_mod = current_chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker{key = 'domino',
    loc_txt = {
        name = 'Domino',
        text = {
            "Card gives {X:mult,C:white}X#1#{} Mult if",
            "scored card is the exact same {C:attention}rank{}",
            "and {C:attention}suit{} as the previously scored card"
        }
    },
    config = { extra = { x_mult = 2 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local scoring_hand = context.scoring_hand
            if scoring_hand and #scoring_hand > 1 then
                for i = 1, #scoring_hand do
                    if scoring_hand[i] == context.other_card then
                        if i > 1 then
                            local prev_card = scoring_hand[i - 1]
                            if prev_card.base.suit == context.other_card.base.suit and prev_card.base.value == context.other_card.base.value then
                                return {
                                    message = message,
                                    x_mult = card.ability.extra.x_mult,
                                    card = card
                                }
                            end
                        end
                        break
                    end
                end
            end
        end
    end
}
SMODS.Joker{key = 'shredder',
    loc_txt = {
        name = 'Shredder',
        text = {
            "Destroys all scored cards",
            "Gains {X:mult,C:white}XMult{} equal to",
            "the ID of each destroyed card",
            "{C:attention}enhaced{} card gives {C:attention}#2#x{} much",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = { x_mult = 1, enhaced_mult = 2 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.enhaced_mult } }
    end,
    calculate = function(self, card, context)
        if context.destroying_card and not context.blueprint then
            if context.scoring_hand then
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i] == context.destroying_card then
                        local card_id = context.destroying_card.base.id or 0
                        if context.destroying_card.config.center.set == 'Enhanced' then
                            card_id = card_id * card.ability.extra.enhaced_mult
                        end
                        card.ability.extra.x_mult = card.ability.extra.x_mult + card_id
                        return true
                    end
                end
            end
        end
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = 'X' .. card.ability.extra.x_mult .. ' Mult',
                Xmult_mod = card.ability.extra.x_mult
            }
        end
        if card.ability.extra.x_mult >= 1000 then
            check_for_unlock({ type = "what_cost" })
        end
    end
}
SMODS.Joker{key = 'quantum_immortality',
    loc_txt = {
        name = 'Quantum Immortality',
        text = {
            "Gives {X:mult,C:white}^Ante{} Mult",
            "on the {C:attention}last hand{} of round"
        }
    },
    config = { extra = {} },
    rarity = 'uv_super_rare',
    cost = 15,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            local ante_power = G.GAME.round_resets.ante or 1
            return {
                message = '^' .. ante_power .. ' Mult',
                Emult_mod = ante_power
            }
        end
    end
}
SMODS.Joker{key = 'absolute_zero',
    rarity = 'uv_super_rare',
    cost = 15,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    loc_txt = {
        name = 'Absolute Zero',
        text = {
            "set {C:attention}blind requirement{} to {C:attention}0{} chips",
        }
    },
    config = {},
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.GAME.blind.chips = 0
            G.GAME.blind.chip_text = number_format(new_chips)
            return {
                message = "-100% blind requirement",
                colour = G.C.ATTENTION,
                card = card,
            }
        end
    end
}
SMODS.Joker{key = 'bitwise_shift',
    loc_txt = {
        name = 'Bitwise Shift',
        text = {
            "Gives {X:blue,C:white}<<Chips{} equal to",
            "level of played poker hand",
        }
    },
    config = { extra = {} },
    rarity = 'uv_super_rare',
    cost = 15,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            local hand_type = context.scoring_hand_name or G.GAME.last_hand_played
            if hand_type and G.GAME.hands[hand_type] then
                local hand_level = G.GAME.hands[hand_type].level or 1
                return {
                    message = '<<' .. hand_level .. ' Chips',
                    Xchip_mod = 2 ^ hand_level,
                    colour = G.C.BLUE
                }
            end
        end
    end
}
SMODS.Joker{key = 'bmm',
    loc_txt = {
        name = 'Balatro Mod Manager',
        text = {
            "Gives {X:mult,C:white}xMult{} equal to the",
            "number of installed mods, disabled or not",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
        }
    },
    config = { extra = {} },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'bmm',
    loc_vars = function(self, info_queue, card)
        local mod_count = 0
        if SMODS and SMODS.Mods then
            for _ in pairs(SMODS.Mods) do
                mod_count = mod_count + 1
            end
        end
        if mod_count == 0 then mod_count = 1 end
        return { vars = { mod_count - 1 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local mod_count = 0
            if SMODS and SMODS.Mods then
                for _ in pairs(SMODS.Mods) do
                    mod_count = mod_count + 1
                end
            end
            if mod_count <= 1 then mod_count = 1 end
            return {
                message = 'X' .. mod_count - 1 .. ' Mult',
                Xmult_mod = mod_count - 1
            }
        end
    end
}
SMODS.Joker{key = "DR34MC0R3",
    config = { extra = { exp1 = 1.35, faceX = 24, aceX = 96, oddMN = 1.2, exp2 = 1.4  } }, 
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
        loc_txt = {
                name = "DR34MC0R3",
                text = { 
                    "Scored even cards gives {X:chips,C:white}<<Chips{} equal to their rank",
                    "Every card in hand gives {X:mult,C:white}^#1#{} Mult",
                    "Scored face cards gives {X:chips,C:white}x#2#{} Chips",
                    "Scored aces gives {X:mult,C:white}x#3#{} Mult",
                    "Scored odd cards gives {X:money,C:white}x$#4#{}",
                    "Each joker gives {X:chips,C:white}^#5#{} Chips",
                    "Disables {C:attention}The Void{}"
                }
            },
    atlas = 'DR34MC0R3',
    soul_pos = {x=0,y=1},
    loc_vars = function(self, info_queue, card)
        return { vars = {
                    card.ability.extra.exp1, card.ability.extra.faceX,
                    card.ability.extra.aceX, card.ability.extra.oddMN, card.ability.extra.exp2
                        } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 0 then
                return {
                    message = '<<' .. context.other_card:get_id() .. ' Chips',
                    Xchip_mod = 2 ^ context.other_card:get_id(),
                    card = context.other_card,
                    colour = G.C.BLUE
                }
            elseif context.other_card:get_id() <= 13 and context.other_card:get_id() >= 11 then
                return {
                    message = 'x' .. card.ability.extra.faceX .. ' Chips',
                    Xchip_mod = card.ability.extra.faceX,
                    card = context.other_card,
                    colour = G.C.BLUE
                }
            elseif context.other_card:get_id() == 14 then
                return {
                    Xmult = card.ability.extra.aceX,
                    card = context.other_card
                }
            elseif ((context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 1) or (context.other_card:get_id() == 14)) then
                local current_dollars = G.GAME.dollars or 0
                local bonus_money = math.floor(current_dollars * (card.ability.extra.oddMN - 1))
                if bonus_money < 1 then bonus_money = 1 end
                return {
                    message = 'x$' .. card.ability.extra.oddMN,
                    dollars = bonus_money,
                    card = context.other_card,
                    colour = G.C.MONEY
                }
            end
        end
        if context.individual and context.cardarea == G.hand then
            if context.other_card.debuff then
                            return {
                                message = 'Debuffed',
                                colour = G.C.RED,
                                card = context.other_card,
                            }
            else
                if context.end_of_round then
                    return false
                else
                    return {
                        message = '^' .. card.ability.extra.exp1 .. ' Mult',
                        Emult_mod = card.ability.extra.exp1,
                        card = context.other_card,
                        colour = G.C.RED
                            }
                end
            end
        end
        if context.other_joker then
            if self ~= context.other_joker then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                })) 
                return {
                    message = '^' .. card.ability.extra.exp2 .. ' Chips',
                    Echip_mod = card.ability.extra.exp2,
                    colour = G.C.BLUE
                }
            end
        end
    end
}
SMODS.Joker{key = 'all_9s',
    loc_txt = {
        name = 'Oops! All 9s',
        text = {
            "square numerator of",
            "all {C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}4 in 10{} {C:inactive}->{} {C:green,E:1,S:1.1}16 in 10{}{C:inactive}){}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_9s',
	pools = { ["Oops!"] = true },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal ^ 2
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal ^ 0.5
    end
}
SMODS.Joker{key = 'D6',
    loc_txt = {
        name = 'Regular D6',
        text = {
            "{C:green}#1# in #2#{} chance to",
            "Double all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{}",
            "when sold",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}2 in 3{}{C:inactive}){}"
        }
    },
    config = { odds = 6 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'D6',
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.odds } }
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if pseudorandom('D6_roll') < G.GAME.probabilities.normal / card.ability.odds then
                            play_sound('coin6')
                            G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
                            return true
                    else
                        play_sound('glass6')
                        return true
                    end
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'all_4s',
    loc_txt = {
        name = 'Oops! All 4s',
        text = {
            "Increases all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{} by {C:attention}#1#{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}2 in 4{} {C:inactive}->{} {C:green,E:1,S:1.1}3 in 4{}{C:inactive}){}"
        }
    },
    config = { extra = 1 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_4s',
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal + card.ability.extra
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal - card.ability.extra
    end
}
SMODS.Joker{key = 'all_1s',
    loc_txt = {
        name = 'Oops! All 1s',
        text = {
            "halves all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}2 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}1 in 3{}{C:inactive}){}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_1s',
	pools = { ["Oops!"] = true },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / 2
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
    end
}
SMODS.Joker{key = 'forgot_cube',
    loc_txt = {
        name = 'Oops! I forgot the cube',
        text = {
            "Scored {C:attention}7s{} Increase all",
            "listed {C:green,E:1,S:1.1}probabilities{} by {C:green}#1#{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}#2# in 3{}{C:inactive}){}",
            "{C:inactive,s:0.7}Timmy! How the freak are we gonna play monopoly?!{}"
        }
    },
    config = { g7 = 0.2 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'forgot_cube',
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.g7, (1 + card.ability.g7) } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 7 then
                G.GAME.probabilities.normal = G.GAME.probabilities.normal + card.ability.g7
                return {
                    message = '+' .. card.ability.g7,
                    card = context.other_card,
                    colour = G.C.GREEN
                }
            end
        end
        if context.selling_self and next(SMODS.find_card('j_uv_missing_cube')) and not context.blueprint then
            check_for_unlock({ type = "other_way" })
        end
    end
}
SMODS.Joker{key = 'missing_cube',
    loc_txt = {
        name = "Oops! I found the missing cube",
        text = {
            "sell it to have permanent {X:green,C:white}^3{} bonus",
            "for all {C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "if you have {C:green}Oops! I for got the cube{}",
            "{C:inactive,s:0.7}oh, so that's were he was!{}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'missing_cube',
    soul_pos = {x=0,y=0},
	pools = { ["Oops!"] = true },
    display_size = { w = 44.5, h = 44.5 },
    calculate = function(self, card, context)
        if context.selling_self and next(SMODS.find_card('j_uv_forgot_cube')) then
            G.GAME.probabilities.normal = G.GAME.probabilities.normal ^ 3
            return {
                message = '^3',
                colour = G.C.GREEN
            }
        end
    end
}
SMODS.Joker{key = 'all_inf',
    loc_txt = {
        name = "Oops! All Inf's",
        text = {
            "All {C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "are {C:dark_edition}guaranteed{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}1.000e9 in 3{}{C:inactive}){}"
        }
    },
    config = {},
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_inf',
	pools = { ["Oops!"] = true },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * (1e9)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / (1e9)
    end
}
SMODS.Joker{key = 'all_0s',
    loc_txt = {
        name = 'Oops! All 0s',
        text = {
            "Reduces all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{} by {C:attention}#1#{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}3 in 4{} {C:inactive}->{} {C:green,E:1,S:1.1}2 in 4{}{C:inactive}){}"
        }
    },
    config = { extra = 1 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_0s',
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal - card.ability.extra
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal + card.ability.extra
    end
}
SMODS.Joker{key = 'all_oops',
    loc_txt = {
        name = 'Oops! All Oops!',
        text = {
            "Creates random {C:green}Oops!{} joker",
            "when sold",
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_oops',
	pools = { ["Oops!"] = true },
    calculate = function(self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local oops_pool = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Joker' and v.pools and v.pools['Oops!'] then
                            oops_pool[#oops_pool + 1] = v.key
                        end
                    end
                    if #oops_pool > 0 then
                        local forced_key = pseudorandom_element(oops_pool, pseudoseed('all_oops_sell' .. (G.GAME.round_resets.ante or 1)))
                        local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'all_oops')
                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                    end
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'all_legendary',
    loc_txt = {
        name = "Oops! I'm legendary now",
        text = {
            "{C:green}#1# in #2#{} chance to create",
            "random {C:dark_edition}negative{} {C:red}rare{} joker",
            "at end of round",
            "otherwise creates {C:dark_edition}negative{} {C:green}Oops! All Oops!{}"
        }
    },
    config = { extra = { odds = 33 } },
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'all_rares',
    soul_pos = {x=0,y=1},
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local forced_key = nil
                    if pseudorandom('all_rares_roll') < G.GAME.probabilities.normal / card.ability.extra.odds then
                        local rare_pool = {}
                        for k, v in pairs(G.P_CENTERS) do
                            if v.set == 'Joker' and v.rarity == 3 then
                                rare_pool[#rare_pool + 1] = v.key
                            end
                        end
                        if #rare_pool > 0 then
                            forced_key = pseudorandom_element(rare_pool, pseudoseed('all_rares_success'))
                        end
                    else
                        forced_key = 'j_uv_all_oops'
                    end
                    if forced_key and G.P_CENTERS[forced_key] then
                        local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'all_rares')
                        new_card:set_edition({negative = true}, true, true)
                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'all_misprints',
    loc_txt = {
        name = 'Oops! All misprints',
        text = {
            "{C:green}#1##2#{} to all",
            "{C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}#3# in 3{}{C:inactive}){}",
            "{C:inactive}(Changes every round){}"
        }
    },
    config = { extra = { op = 'X', n = 1, original_prob = 1, ex = 1 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_misprints',
    pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        local display_op = card.ability.extra.op
        if display_op == 'X' then display_op = 'x' end
        return { vars = { display_op, card.ability.extra.n, card.ability.extra.ex } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.original_prob = G.GAME.probabilities.normal
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = card.ability.extra.original_prob
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and not card.debuff then
            local operators = {'+', '-', 'X', '/', '^'}
            card.ability.extra.op = pseudorandom_element(operators, pseudoseed('misprint_op' .. G.GAME.round_resets.ante))
            local random_n = pseudorandom('misprint_n' .. G.GAME.round_resets.ante) * 4.5 + 0.5
            card.ability.extra.n = tonumber(string.format("%.1f", random_n))
            local base_prob = card.ability.extra.original_prob or 1
            if card.ability.extra.op == '+' then
                G.GAME.probabilities.normal = base_prob + card.ability.extra.n
                card.ability.extra.ex = 1 + card.ability.extra.n
            elseif card.ability.extra.op == '-' then
                G.GAME.probabilities.normal = base_prob - card.ability.extra.n
                card.ability.extra.ex = 1 - card.ability.extra.n
            elseif card.ability.extra.op == 'X' then
                G.GAME.probabilities.normal = base_prob * card.ability.extra.n
                card.ability.extra.ex = 1 * card.ability.extra.n
            elseif card.ability.extra.op == '/' then
                G.GAME.probabilities.normal = card.ability.extra.n ~= 0 and (base_prob / card.ability.extra.n) or base_prob
                card.ability.extra.ex = 1 / card.ability.extra.n
            elseif card.ability.extra.op == '^' then
                G.GAME.probabilities.normal = base_prob ^ card.ability.extra.n
                card.ability.extra.ex = 1 ^ card.ability.extra.n
            end
            return {
                message = 'Oops!',
                colour = G.C.GREEN
            }
        end
    end
}
SMODS.Joker{key = 'all_is',
    loc_txt = {
        name = "Oops! All i's",
        text = {
            "square root numerator of",
            "all {C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}16 in 20{} {C:inactive}->{} {C:green,E:1,S:1.1}4 in 20{}{C:inactive}){}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_is',
	pools = { ["Oops!"] = true },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal ^ 0.5
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal ^ 2
    end
}
SMODS.Joker{key = 's6_lla',
    loc_txt = {
        name = "s6 llA !spoO",
        text = {
            "{C:green}#1# in 12{} chance to permanetly double all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{} at end of round",
            "increases {C:green,E:1,S:1.1}probability{} by {C:green}0.5{} every time roll is failed",
            "{C:green,E:1,S:1.1}probability{} set back to {C:green}1{} when chance is sucsessfully rolled",
            "chance can't be changed in any other way"
        }
    },
    config = {},
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 's6_lla',
    soul_pos = {x=0,y=1},
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        local chance = (G.GAME and G.GAME.EULAV_S6_LLA) or 1
        return { vars = { chance } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            G.GAME.EULAV_S6_LLA = G.GAME.EULAV_S6_LLA or 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    if pseudorandom('llor_6D') < G.GAME.EULAV_S6_LLA / 12 then
                        play_sound('coin6')
                        G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
                        G.GAME.EULAV_S6_LLA = 1
                        card:juice_up()
                    else
                        G.GAME.EULAV_S6_LLA = G.GAME.EULAV_S6_LLA + 0.5
                        play_sound('glass6')
                        card:juice_up()
                    end
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'all_negative',
    loc_txt = {
        name = "Oops! All negative",
        text = {
            "{X:green,C:white}X-1{} to all",
            "{C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}1 in 3{} {C:inactive}->{} {C:green,E:1,S:1.1}-1 in 3{}{C:inactive}){}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_negative',
	pools = { ["Oops!"] = true },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * -1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * -1
    end
}
SMODS.Joker{key = 'all_a',
    loc_txt = {
        name = "Oops! A",
        text = {
            "{X:green,C:white}X1.5{} to all",
            "{C:attention}listed{} {C:green,E:1,S:1.1}probabilities{}",
            "{C:inactive}(ex:{} {C:green,E:1,S:1.1}6 in 10{} {C:inactive}->{} {C:green,E:1,S:1.1}9 in 10{}{C:inactive}){}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    atlas = 'all_a',
	pools = { ["Oops!"] = true },
    display_size = { w = 44, h = 95 },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * 1.5
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / 3 * 2
    end
}
SMODS.Joker{key = 'all_berries',
    loc_txt = {
        name = "Oops! All berries",
        text = {
            "gives {X:mult,C:white}XMult{} equal to",
            "value of {C:green,E:1,S:1.1}probabilities{} divided by {C:attention}100{}",
            "{C:inactive}(currently {X:mult,C:white}X#1#{C:inactive} Mult)",
        }
    },
    config = {},
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
	pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        local mult = (((G.GAME and G.GAME.probabilities.normal) or 1) / 100) + 1
        return { vars = { mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'X' .. number_format((G.GAME.probabilities.normal / 100) + 1) .. ' Mult',
                Xmult_mod = (G.GAME.probabilities.normal / 100) + 1,
                colour = G.C.RED
                
            }
        end
    end
}
SMODS.Joker{key = 'all_in',
    loc_txt = {
        name = 'Oops! All In',
        text = {
            "Permanently doubles all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{} if blind is",
            "defeated in {C:attention}1{} hand",
            "otherwise sets all {C:attention}listed{} {C:green,E:1,S:1.1}probabilities{} to {C:attention}0{}"
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    pools = { ["Oops!"] = true },
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.blueprint and not context.individual then
            if G.GAME.hands_played == 1 then
                G.GAME.probabilities.normal = G.GAME.probabilities.normal * 2
                return {
                    message = 'X2 Probs.',
                    colour = G.C.GREEN
                }
            else
                G.GAME.probabilities.normal = 0
                return {
                    message = 'X0 Probs.',
                    colour = G.C.RED
                }
            end
        end
    end
}
SMODS.Joker{key = 'all_double_it',
    loc_txt = {
        name = 'Oops! It and give it to the next person',
        text = {
            'permanently doubles value of',
            'this joker when it {C:attention}sold{}',
            '{C:inactive}(currently {X:green,C:white}X#1#{C:inactive} to all listed probabilities)'
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    pools = { ["Oops!"] = true },
    atlas = 'next_person',
    loc_vars = function(self, info_queue, card)
        G.GAME.double_it_mult = G.GAME.double_it_mult or 1
        return { vars = { G.GAME.double_it_mult } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.double_it_mult = G.GAME.double_it_mult or 1
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * G.GAME.double_it_mult
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.double_it_mult = G.GAME.double_it_mult or 1
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / (G.GAME.double_it_mult / 2)
    end,
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            G.GAME.double_it_mult = G.GAME.double_it_mult or 1
            G.GAME.double_it_mult = G.GAME.double_it_mult * 2
            return {
                message = 'X' .. G.GAME.double_it_mult,
                colour = G.C.GREEN
            }
        end
    end
}
SMODS.Joker{key = 'all_madnesss',
    loc_txt = {
        name = 'Oops! All madnesss',
        text = {
            "{C:green}#1# in{} {C:blue}#2# out of{} {C:purple}#3#{} chance",
            "to get {X:chips,C:white}^green banana{} Chips,",
            "with a {C:green}#4# in FOUR{} chance to",
            "re-index the matrix by {X:mult,C:white}^#5#{} mult.",
            "Every time {C:green}New-York in 12.673e$!* {C:blue}between jokir12 {C:purple}out 6",
            "{C:red}inside sideway potato {C:attention}with i for range(chance){} chance is triggered",
            "this joker gains {C:green}+#6# probability{} if {C:attention}1 in cow{} chance not triggered.",
            "If {C:red}System.Error(void){} == {C:blue}true{}, formats {C:attention}G.GAME.hands['NaN']{}",
            "into {X:mult,C:white}^#7#{} mult inside your actual {C:inactive}windows/system32/{}",
            "{C:red}FATAL ERROR:{} Unhandled potato exception in {C:attention}G.FUNCS.collide_cow(){}",
            "Multiply Ante by {X:purple,C:white}^0.0001%{} for each {C:money}sub-atomic cent{} owned",
            "Convert {C:hearts}Hearts{} into {C:diamonds}Diamonds{} sideways",
            "If played hand contains exactly {C:attention}3.54 of a Kind{}, delete {C:joker}Joker 4{} from reality Number 907",
            "Execute {C:purple}for _, v in ipairs(G.GALAXY) do void() end{}",
            "{X:mult,C:white}^cucumber{} mult if system clock is divisible by {C:attention}green{}",
            "{C:green}sqrt(-1) out of pi{} chance to trigger all of this",
            "each frame there are a {C:green}* inside #8#{} chance for {C:green}backflip in q order 84 chances {C:blue}with geometrical finger{} chance",
            "for {C:green}el primo in vortex {C:blue}in ^2^ {C:purple}out {C:red}inside {C:attention}between {}{C:money}under {}{C:inactive}on WASD{} chance of",
            "{C:green}#9# on shardium{} chance to trigger {C:red}+1-1{} Mult",
            "otherwise:",
            "{C:green}blueberry in milky way Number D{} chance of {C:green}!! in !!!!!!{} chance for {C:green}yaguar in white pants {C:blue}in australia{} chance",
            "to do {C:dark_edition}NOTHING{} if {C:green}socks in butterfly {C:blue}with leaf {C:purple}out lighter{} chance not triggered {C:attention}328{} times in a row.",
            "{C:inactive}(Increases or decreases all variations of Luck, Potatoes, Bovines and Your Sanity){}"
        }
    },
    config = {
        extra = {
            madness_level = 3, apple_factor = 2, four_factorial = 24, banana_exponent = 1.5, mult_power = 0.77,
            cow_prob = 1, potato_power = 999, socks_streak = 0
        }
    },
    rarity = 'uv_super_rare',
    cost = 15,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pools = { ["Oops!"] = true },
    add_to_deck = function(self, card, from_debuff)
        check_for_unlock({ type = "getting_somewhere" })
    end,
    loc_vars = function(self, info_queue, card)
        local vars = (card and card.ability and card.ability.extra) and card.ability.extra or self.config.extra
        return { vars = { 
            vars.madness_level, vars.apple_factor, "apple", 
            vars.banana_exponent, vars.mult_power, vars.cow_prob, vars.potato_power,
            "([{*!*}])", "{C:green}"
        } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('cow_chance') > (G.GAME.probabilities.normal / 10) then
                card.ability.extra.cow_prob = card.ability.extra.cow_prob + 1
                if pseudorandom('sideway_potato') < 0.90 then
                    local shift_amount = math.random(1, 4)
                    local sub_atomic_cents = (G.GAME.dollars % 1) * 1000
                    if sub_atomic_cents > 0 then
                        ease_ante(sub_atomic_cents * 0.00001)
                    end
                    local cucumber_mult = 1
                    if os.time() % 2 == 0 then
                        cucumber_mult = 1.5
                    end
                    if pseudorandom('backflip') < 0.50 then
                        SMODS.change_play_limit(math.random(-1, 1))
                        SMODS.change_discard_limit(math.random(-1, 1))
                    end
                    local final_emult = (card.ability.extra.mult_power ^ card.ability.extra.cow_prob) * cucumber_mult
                    return {
                        message = '+1-1 Mult',
                        Xchip_mod = 2 ^ shift_amount,
                        Emult_mod = final_emult,
                        colour = G.C.GREEN
                    }
                end
            else
                card.ability.extra.cow_prob = 1
                card.ability.extra.socks_streak = 0
                G.hand:change_size(-2)
                return {
                    message = 'COW COLLISION ERROR!',
                    colour = G.C.RED
                }
            end
            card.ability.extra.socks_streak = card.ability.extra.socks_streak + 1
            if card.ability.extra.socks_streak >= 328 then
                card.ability.extra.socks_streak = 0
                check_for_unlock({ type = "actual_nothing" })
                return {
                    message = 'ABSOLUTE NOTHINGNESS',
                    colour = G.C.DARK_EDITION
                }
            end
        end
        if context.discard and not context.blueprint then
            if #context.full_hand == 3 then
                for _, c in ipairs(G.hand.cards) do
                    if c.base.suit == 'Hearts' then
                        c:change_suit('Diamonds')
                    end
                end
                return { message = 'Hearts rotated 90°', colour = G.C.PURPLE }
            end
        end
    end
}
SMODS.Joker{key = 'all_gregs',
    loc_txt = {
        name = 'Oops! All Gregs',
        text = {
            "Adds {C:green}+#1#{} to all {C:attention}listed{}",
            "{C:green,E:1,S:1.1}probabilities{} for every",
            "{C:attention}Greg{} card in your deck",
            "{C:inactive}(Currently {C:green}+#2#{C:inactive}){}"
        }
    },
    config = { extra = { prob_per_greg = 4, last_applied = 0 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    pools = { ["Oops!"] = true },
    atlas = 'all_gregs',
    loc_vars = function(self, info_queue, card)
        local greg_count = 0
        if G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c.config.center and c.config.center.key == 'm_uv_greg' then
                    greg_count = greg_count + 1
                end
            end
        end
        local current_bonus = greg_count * card.ability.extra.prob_per_greg
        return { vars = { card.ability.extra.prob_per_greg, current_bonus } }
    end,
    update = function(self, card)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            local greg_count = 0
            if G.playing_cards then
                for _, c in ipairs(G.playing_cards) do
                    if c.config.center and c.config.center.key == 'm_uv_greg' then
                        greg_count = greg_count + 1
                    end
                end
            end
            local target_bonus = greg_count * card.ability.extra.prob_per_greg
            if target_bonus ~= card.ability.extra.last_applied then
                local diff = target_bonus - card.ability.extra.last_applied
                G.GAME.probabilities.normal = G.GAME.probabilities.normal + diff
                card.ability.extra.last_applied = target_bonus
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local greg_count = 0
        if G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c.config.center and c.config.center.key == 'm_uv_greg' then
                    greg_count = greg_count + 1
                end
            end
        end
        card.ability.extra.last_applied = greg_count * card.ability.extra.prob_per_greg
        G.GAME.probabilities.normal = G.GAME.probabilities.normal + card.ability.extra.last_applied
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal - card.ability.extra.last_applied
        card.ability.extra.last_applied = 0
    end
}
SMODS.Joker{key = 'all_ultraviolets',
    loc_txt = {
        name = 'Oops! All UltraViolets',
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult for every",
            "{C:green}Oops!{} Joker you own",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
        }
    },
    config = { extra = { x_mult_gain = 0.3 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pools = { ["Oops!"] = true },
    atlas = 'all_ultraviolets',
    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center and j.config.center.pools and j.config.center.pools["Oops!"] then
                    count = count + 1
                end
            end
        end
        local current_mult = 1 + (count * card.ability.extra.x_mult_gain)
        return { vars = { card.ability.extra.x_mult_gain, current_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center and j.config.center.pools and j.config.center.pools["Oops!"] then
                    count = count + 1
                end
            end
            local current_mult = 1 + (count * card.ability.extra.x_mult_gain)
            if current_mult > 1 then
                return {
                    message = 'X' .. current_mult .. ' Mult',
                    Xmult_mod = current_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = 'god_of_all_oops',
    loc_txt = {
        name = 'The God of all Oops!',
        text = {
            "Gains {X:chips,C:white}^#1#{} Chips whenever you buy,",
            "obtain, or sell an {C:green}Oops!{} Joker",
            "{C:inactive}(Currently {X:chips,C:white}^#2#{C:inactive} Chips)",
            "Creates {C:attention}#3#{} random {C:dark_edition}Negative{} {C:green}Oops!{} Jokers",
            "at the end of the round. This amount increases",
            "by {C:attention}1{} every time {C:green}Oops! All Oops!{} is sold"
        }
    },
    config = { extra = { gain = 0.03, current_e_chips = 1, base_negatives = 1, sold_bonus = 0, pack_mult = 9 } },
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    pools = { ["Oops!"] = true },
    loc_vars = function(self, info_queue, card)
        local total_negatives = card.ability.extra.base_negatives + card.ability.extra.sold_bonus
        return { vars = { card.ability.extra.gain, card.ability.extra.current_e_chips, total_negatives, card.ability.extra.pack_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.current_e_chips > 1 then
            return {
                message = '^' .. card.ability.extra.current_e_chips .. ' Chips',
                Echip_mod = card.ability.extra.current_e_chips,
                colour = G.C.BLUE
            }
        end
        if (context.buying_card and context.card and context.card.config.center and context.card.config.center.pools and context.card.config.center.pools['Oops!']) or
           (context.open_booster and context.card and context.card.config.center and context.card.config.center.pools and context.card.config.center.pools['Oops!']) then
            card.ability.extra.current_e_chips = card.ability.extra.current_e_chips + card.ability.extra.gain
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Upgrade!', colour = G.C.GREEN})
        end
        if context.selling_card and context.card and context.card.config.center then
            if context.card.config.center.pools and context.card.config.center.pools['Oops!'] then
                card.ability.extra.current_e_chips = card.ability.extra.current_e_chips + card.ability.extra.gain
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Upgrade!', colour = G.C.GREEN})
            end
            if context.card.config.center.key == 'j_uv_all_oops' then
                card.ability.extra.sold_bonus = card.ability.extra.sold_bonus + 1
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = '+1 Negative!', colour = G.C.DARK_EDITION})
            end
        end
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and not card.debuff then
            local total_negatives = card.ability.extra.base_negatives + card.ability.extra.sold_bonus
            local oops_pool = {}
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and v.pools and v.pools['Oops!'] then
                    oops_pool[#oops_pool + 1] = v.key
                end
            end
            for i = 1, total_negatives do
                if #G.jokers.cards < G.jokers.config.card_limit or true then -- Негативные могут превышать лимит слотов
                    local forced_key = #oops_pool > 0 and pseudorandom_element(oops_pool, pseudoseed('god_oops')) or nil
                    local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'god_oops')
                    new_card:set_edition({negative = true}, true)
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                end
            end
            return {
                message = 'Blessing!',
                colour = G.C.GREEN
            }
        end
    end
}
SMODS.Joker{key = 'roboker',
    loc_txt = {
        name = 'Roboker',
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Must solve a {C:blue}CAPTCHA{}",
            "before each blind"
        }
    },
    config = { extra = { Xmult = 4 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'X' .. card.ability.extra.Xmult .. ' Mult',
                Xmult_mod = card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
        if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    G.FUNCS.spawn_roboker_captcha()
                    return true
                end
            }))
        end
    end
}
SMODS.Joker{key = 'teacher',
    loc_txt = {
        name = 'Teacher Joker',
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Must solve math problem before each round",
            "Gains {X:mult,C:white}X#2#{} Mult for each correct answer",
            "reduces by {X:mult,C:white}X#3#{} on wrong answer",
            "{C:inactive}(currently level #4#)"
        }
    },
    config = { extra = { mult_mod = 0.5, reduce_mod = 0.75 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local current_mult = 1 + ((G.GAME.correct_answers or 0) * 0.5) - ((G.GAME.wrong_answers or 0) * 0.25)
        return { vars = { 
            current_mult, 
            card.ability.extra.mult_mod, 
            card.ability.extra.reduce_mod,
            G.GAME.teacher_level
        } }
    end,
    calculate = function(self, card, context)
        local current_mult = 1 + ((G.GAME.correct_answers or 0) * 0.5) - ((G.GAME.wrong_answers or 0) * 0.25)
        if context.setting_blind and not (context.blueprint_or_negative) then
            G.FUNCS.spawn_teacher_quiz(card)
        end
        if context.joker_main then
            if card.ability.extra.current_mult ~= 1 then
                return {
                    Xmult_mod = current_mult,
                    message = 'X' .. current_mult .. ' Mult',
                    colour = G.C.RED
                }
            end
        end
    end
}
SMODS.Joker{key = 'match',
    loc_txt = {
        name = 'Match',
        text = {
            "{C:green}#1# in #2#{} chance for each scored card",
            "to be destroyed and give {C:mult}+#3#{} Mult",
            "to this Joker",
            "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)"
        }
    },
    config = { extra = { odds = 6, mult_gain = 10, mult = 0 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.destroying_card and not context.blueprint then
            if pseudorandom('match') < G.GAME.probabilities.normal / card.ability.extra.odds then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return true
            end
        end
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = '+' .. card.ability.extra.mult .. ' Mult',
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}
SMODS.Joker{key = 'broken_mirror',
    loc_txt = {
        name = 'Broken Mirror',
        text = {
            "{C:green}#1# in #2#{} chance to apply a random",
            "{C:dark_edition}Edition{} to the second card",
            "If played hand is 2 {C:attention}identical{} cards"
        }
    },
    config = { extra = { odds_num = 4, odds_den = 7 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal * card.ability.extra.odds_num, card.ability.extra.odds_den } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand and #context.scoring_hand == 2 then
            local card1 = context.scoring_hand[1]
            local card2 = context.scoring_hand[2]

            local is_identical = card1.base.id == card2.base.id and
                                 card1.base.suit == card2.base.suit and
                                 card1.ability.name == card2.ability.name and
                                 (card1.seal or '') == (card2.seal or '') and
                                 ((card1.edition and card1.edition.key) or '') == ((card2.edition and card2.edition.key) or '')

            if is_identical then
                if pseudorandom('broken_mirror') < (G.GAME.probabilities.normal * card.ability.extra.odds_num) / card.ability.extra.odds_den then
                    local edition = poll_edition('broken_mirror', nil, true, true)
                    if edition then
                        card2:set_edition(edition, true)
                    end
                end
            end
        end
    end
}
SMODS.Joker{key = 'russian_roulette',
    loc_txt = {
        name = 'Russian Roulette',
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult after each round.",
            "Has a {C:green}#2# in #3#{} chance to be",
            "{C:red}destroyed{} at the end of every round",
            "{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)"
        }
    },
    config = { extra = { Xmult_gain = 0.5, Xmult = 1, odds = 6 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = 'X' .. card.ability.extra.Xmult .. ' Mult',
                Xmult_mod = card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            if pseudorandom('russian_roulette') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))
                return {
                    message = 'Bang!',
                    colour = G.C.RED
                }
            else
                return {
                    message = 'Save!',
                    colour = G.C.GREEN
                }
            end
        end
    end
}
SMODS.Joker{key = 'meteorologist',
    loc_txt = {
        name = 'Meteorologist',
        text = {
            "When a {C:planet}Planet{} card is obtained,",
            "has a {C:green}#1# in #2#{} chance to create",
            "a {C:dark_edition}Negative{} copy of it"
        }
    },
    config = { extra = { odds = 3 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.uv_planet_added and context.target and not context.blueprint then
            if pseudorandom('meteorologist') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        local copy = copy_card(context.target, nil, nil, G.consumeables)
                        copy.from_meteorologist = true
                        copy:set_edition({negative = true}, true)
                        copy:add_to_deck()
                        G.consumeables:emplace(copy)
                        return true
                    end
                }))
            end
        end
    end
}
SMODS.Joker{key = 'casino_royale',
    loc_txt = {
        name = 'Casino Royale',
        text = {
            "{C:green}#1# in #2#{} chance for each",
            "played {C:attention}face{} card to become {C:green}lucky{} card"
        }
    },
    config = { extra = { odds = 3 } },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand then
            for i = 1, #context.scoring_hand do
                local target_card = context.scoring_hand[i]
                if target_card:is_face() then
                    if pseudorandom('casino_royale') < G.GAME.probabilities.normal / card.ability.extra.odds then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.1,
                            func = function()
                                target_card:set_ability(G.P_CENTERS.m_lucky)
                                target_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end
}
SMODS.Joker{key = 'shuler',
    loc_txt = {
        name = 'Shuler',
        text = {
            "{C:green}#1# in #2#{} chance to give",
            "your discard back when",
            "you {C:red}discarding{} cards"
        }
    },
    config = { extra = { odds_num = 2, odds_den = 5, debt = 0 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal * card.ability.extra.odds_num, card.ability.extra.odds_den } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.debt = 0
        end
        if context.pre_discard and not context.blueprint then
            if pseudorandom('shuler') < (G.GAME.probabilities.normal * card.ability.extra.odds_num) / card.ability.extra.odds_den then
                card.ability.extra.debt = card.ability.extra.debt + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        ease_discard(1)
                        return true
                    end
                }))
            end
        end
        if context.end_of_round and not context.blueprint and not context.repetition then
            if card.ability.extra.debt > 0 then
                local current_debt = card.ability.extra.debt
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        ease_discard(-current_debt)
                        return true
                    end
                }))
                card.ability.extra.debt = 0
            end
        end
    end
}
SMODS.Joker{key = 'jackpot',
    loc_txt = {
        name = 'Jackpot',
        text = {
            "{C:green}#1# in #2#{} chance to",
            "give {C:money}+$#3#{} at the end of round"
        }
    },
    config = { extra = { odds_num = 7, odds_den = 77, money = 100 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal * card.ability.extra.odds_num, card.ability.extra.odds_den, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('jackpot') < (G.GAME.probabilities.normal * card.ability.extra.odds_num) / card.ability.extra.odds_den then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        ease_dollars(card.ability.extra.money)
                        return true
                    end
                }))
                return {
                    message = '+$' .. card.ability.extra.money,
                    colour = G.C.GOLD
                }
            end
        end
    end
}
SMODS.Joker{key = 'dvd',
    loc_txt = {
        name = 'DVD',
        text = {
            "{X:purple,C:white}X#1#{} Chult,",
            "but the game window",
            "bounces around your screen"
        }
    },
    config = { extra = { x_chult = 4, speed_x = 62.5, speed_y = 50, active = false } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_chult } }
    end,
    calculate = function(self, card, context)
        if card.ability.extra.speed_x ~= 62.5 then card.ability.extra.speed_x = 62.5 end
        if card.ability.extra.speed_y ~= 50 then card.ability.extra.speed_y = 50 end
        if context.joker_main then
            if not card.ability.extra.active then
                if not card.ability.extra.original_settings then
                    card.ability.extra.original_settings = {
                        screenmode = G.SETTINGS.WINDOW.screenmode,
                        w = G.SETTINGS.screen_res and G.SETTINGS.screen_res.w or love.graphics.getWidth(),
                        h = G.SETTINGS.screen_res and G.SETTINGS.screen_res.h or love.graphics.getHeight()
                    }
                end
                card.ability.extra.active = true
                local old_updateMode = love.window.updateMode
                love.window.updateMode = function(w, h, settings)
                    if card.ability.extra.active then
                        settings.resizable = false
                    end
                    return old_updateMode(w, h, settings)
                end
                G.SETTINGS.QUEUED_CHANGE = {
                    screenmode = 'Windowed',
                    screenres = { w = 640, h = 480 }
                }
                G.SETTINGS.WINDOW.screenmode = 'Windowed'
                if G.SETTINGS.screen_res then
                    G.SETTINGS.screen_res.w = 640
                    G.SETTINGS.screen_res.h = 480
                end
                G.FUNCS.apply_window_changes()
                love.window.updateMode = old_updateMode
            end
            if not card.ability.extra.dir_x then
                card.ability.extra.dir_x = math.random() > 0.5 and 1 or -1
                card.ability.extra.dir_y = math.random() > 0.5 and 1 or -1
            end
            return {
                message = 'X' .. card.ability.extra.x_chult .. ' Chult',
                Xchult_mod = card.ability.extra.x_chult
            }
        end
    end,
    update = function(self, card, dt)
        if card.ability.extra.active and not G.SETTINGS.paused then
            if G.SETTINGS.WINDOW.screenmode ~= 'Windowed' then
                G.SETTINGS.QUEUED_CHANGE = {
                    screenmode = 'Windowed',
                    screenres = { w = 640, h = 480 }
                }
                G.SETTINGS.WINDOW.screenmode = 'Windowed'
                if G.SETTINGS.screen_res then
                    G.SETTINGS.screen_res.w = 640
                    G.SETTINGS.screen_res.h = 480
                end
                local old_updateMode = love.window.updateMode
                love.window.updateMode = function(w, h, settings)
                    settings.resizable = false
                    return old_updateMode(w, h, settings)
                end
                G.FUNCS.apply_window_changes()
                love.window.updateMode = old_updateMode
            end
            local wx, wy = love.window.getPosition()
            local ww, wh = love.window.getMode()
            local dw, dh = love.window.getDesktopDimensions()
            local next_x = wx + card.ability.extra.speed_x * card.ability.extra.dir_x * dt
            local next_y = wy + card.ability.extra.speed_y * card.ability.extra.dir_y * dt
            if next_x <= 0 then
                card.ability.extra.dir_x = 1
                next_x = 0
            elseif next_x + ww >= dw then
                card.ability.extra.dir_x = -1
                next_x = dw - ww
            end
            if next_y <= 0 then
                card.ability.extra.dir_y = 1
                next_y = 0
            elseif next_y + wh >= dh then
                card.ability.extra.dir_y = -1
                next_y = dh - wh
            end
            love.window.setPosition(math.floor(next_x), math.floor(next_y))
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        card.ability.extra.active = false
        if card.ability.extra.original_settings then
            local orig = card.ability.extra.original_settings
            G.SETTINGS.QUEUED_CHANGE = {
                screenmode = orig.screenmode,
                screenres = { w = orig.w, h = orig.h }
            }
            G.SETTINGS.WINDOW.screenmode = orig.screenmode
            if G.SETTINGS.screen_res then
                G.SETTINGS.screen_res.w = orig.w
                G.SETTINGS.screen_res.h = orig.h
            end
            G.FUNCS.apply_window_changes()
        end
        local dw, dh = love.window.getDesktopDimensions()
        local ww, wh = love.window.getMode()
        love.window.setPosition(math.floor((dw - ww) / 2), math.floor((dh - wh) / 2))
    end
}
SMODS.Joker{key = 'greg_hitboxes',
    loc_txt = {
        name = 'Greg Hitboxes',
        text = {
            "Gains {X:purple,C:white}X#1#{} Chult for each",
            "{C:attention}Greg{} card in your deck",
            "{C:inactive}(Currently {X:purple,C:white}X#2#{C:inactive} Chult){}"
        }
    },
    config = { extra = { chult_per_greg = 0.1, current_chult = 1 } },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'greg_hitboxes',
    loc_vars = function(self, info_queue, card)
        local greg_count = 0
        if G.playing_cards then
            for _, c in ipairs(G.playing_cards) do
                if c.config.center and c.config.center.key == 'm_uv_greg' then
                    greg_count = greg_count + 1
                end
            end
        end
        card.ability.extra.current_chult = 1 + (greg_count * card.ability.extra.chult_per_greg)
        return { vars = { card.ability.extra.chult_per_greg, card.ability.extra.current_chult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local greg_count = 0
            if G.playing_cards then
                for _, c in ipairs(G.playing_cards) do
                    if c.config.center and c.config.center.key == 'm_uv_greg' then
                        greg_count = greg_count + 1
                    end
                end
            end
            card.ability.extra.current_chult = 1 + (greg_count * card.ability.extra.chult_per_greg)
            if card.ability.extra.current_chult > 1 then
                return {
                    message = 'X' .. card.ability.extra.current_chult .. ' Chult',
                    Xchult_mod = card.ability.extra.current_chult,
                    colour = G.C.PURPLE
                }
            end
        end
    end
}
SMODS.Joker{key = 'greg_box',
    loc_txt = {
        name = 'Greg Box',
        text = {
            "{C:green}#1# in #2#{} chance to create",
            "a {C:tarot}Greg tarot{}",
            "at the end of round",
            "{C:inactive}(Must have room){}"
        }
    },
    config = { extra = { odds = 6 } },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    atlas = 'greg_box',
    display_size = { w = 71, h = 71 },
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if #G.consumeables < G.consumeables.config.card_limit then
                if pseudorandom('greg_box') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_uv_greg_tarot', 'greg_box')
                    tarot:add_to_deck()
                    G.consumeables:emplace(tarot)
                    return {
                        message = 'Greg',
                        colour = G.C.PURPLE
                    }
                else
                    return {
                        message = 'Not Greg',
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}