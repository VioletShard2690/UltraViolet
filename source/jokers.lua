function shakecard(self)
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(0.5, 0.5)
            return true
        end
    }))
end
SMODS.Joker {key = 'valavo',
    loc_txt = {
        name = 'Valavo',
        text = { 
            "Played cards without a seal", 
            "get a {C:blue}Blue Seal{}",
        }
    },
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    atlas = 'valavo',
    pos = { x = 0, y = 0 },
        unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local target_card = context.other_card
            if not target_card.seal then
                target_card:set_seal('Blue', nil, true)
                return {
                    extra = { focus = card, message = 'Sealed!' },
                    card = card
                }
            end
        end
    end
}
SMODS.Joker {key = 'second_second',
    loc_txt = {
        name = '2nd Second',
        text = {
            "Each played {C:attention}2{}",
            "is retriggered {C:attention}2{} additional times"
        }
    },
    config = { extra = { repetitions = 2 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    atlas = 'second_second',
    cost = 8,
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
SMODS.Joker {key = 'tea_for_two',
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
    pos = { x = 0, y = 0 },
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
SMODS.Joker {key = 'mr_two',
    loc_txt = {
        name = 'Mr. Two',
        text = { "Gives {X:mult,C:white} X#1# {} Mult if played hand",
                 "contains exactly {C:attention}two 2's{}",
    }
    },
    config = { extra = 22 },
    rarity = "sj_super_rare",
    pos = { x = 0, y = 0 }, 
    atlas = 'mr_two',
    cost = 10,
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
SMODS.Joker{key = 'torn_banknote',
    config = { extra = { chips_per_dollar = 15 } }, 
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'torn_banknote',
    loc_txt = {
        name = "Torn Banknote",
        text = {
            "Gives {C:chips}+#1#{} Chips for every",
            "{C:money}$1{} of debt you have",
            "{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips){}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local money = (G.GAME and G.GAME.dollars) or 0
        local debt_bonus = 0
        if money < 0 then
            debt_bonus = math.abs(money) * card.ability.extra.chips_per_dollar
        end
        return { vars = { card.ability.extra.chips_per_dollar, debt_bonus } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local money = (G.GAME and G.GAME.dollars) or 0
            if money < 0 then
                local current_chips = math.abs(money) * card.ability.extra.chips_per_dollar
                
                if current_chips > 0 then
                    return {
                        message = '+' .. current_chips,
                        chip_mod = current_chips,
                        colour = G.C.CHIPS
                    }
                end
            end
        end
    end
}
SMODS.Joker{key = 'pavel',
    config = { extra = { odds = 4, neg_odds = 16 } },
    pos = { x = 0, y = 0 },
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
SMODS.Joker{key = 'sad_piggybank',
    config = { extra = { x_mult_per_10 = 1, tax = 5 } },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    atlas = 'sad_piggybank',
        loc_txt = {
                name = "Sad Piggybank",
                text = {
                    "Gives {X:mult,C:white} X1 {} mult for every {C:money}$10{} you have",
                    "{C:red}Debts reduce your Mult!{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult){}",
                    "Loses {C:money}$#2#{} at end of round."
                }
            },
    loc_vars = function(self, info_queue, card)
        local money = (G.GAME and G.GAME.dollars) or 0
        local bonus = math.floor(money / 10) * card.ability.extra.x_mult_per_10
        local total_xmult = math.max(0.01, 1 + bonus)
        return { vars = { card.ability.extra.x_mult_per_10, card.ability.extra.tax, total_xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local money = (G.GAME and G.GAME.dollars) or 0
            local bonus = math.floor(money / 10) * card.ability.extra.x_mult_per_10
            local final_xmult = math.max(0.01, 1 + bonus)
            return {
                message = 'X' .. final_xmult,
                Xmult_mod = final_xmult,
                colour = (final_xmult < 1 and G.C.RED or G.C.MULT)
            }
        end
            if context.end_of_round and not context.individual and not context.repetition then
            ease_dollars(-card.ability.extra.tax)
            return {
                message = '-$' .. card.ability.extra.tax,
                colour = G.C.MONEY
            }
        end
    end
}
SMODS.Joker{key = "broken_clock",
    config = { extra = { chips = 1200 } }, 
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    atlas = 'broken_clock',
        loc_txt = {
        name = "Broken Clock",
        text = {
            "Gives {C:chips}+#1#{} Chips.",
            "Loses {C:chips}1{} chip every second.",
            "{C:red}Destroys itself{} when chips reach {C:chips}0",
            "{C:inactive}(While held in hand){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { math.max(0, math.floor(card.ability.extra.chips)) } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers and not card.getting_sliced then
            if card.ability.extra.chips > 0 then
                card.ability.extra.chips = card.ability.extra.chips - dt
                if card.ability.extra.chips <= 0 then
                    card.ability.extra.chips = 0
                    card.getting_sliced = true
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('glass2', 1, 1)
                            attention_text({
                                text = "Time's up!",
                                scale = 1.2, 
                                hold = 1.5,
                                colour = G.C.RED,
                                align = 'cm',
                                offset = {x = 0, y = -1},
                                major = card
                            })
                            card:start_dissolve() 
                            return true
                        end
                    }))
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local chips_to_add = math.floor(card.ability.extra.chips)
            if chips_to_add > 0 then
                return {
                    message = '+' .. chips_to_add,
                    chip_mod = chips_to_add,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}
SMODS.Joker{key = "sample_test_joker",
    config = { x_mult = 15 }, 
    pos = { x = 0, y = 0 },
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
                    "Gives {X:mult,C:white} X15 {} mult",
                    "{C:inactive}how it even ended up here?"
                }
            },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'X' .. card.ability.x_mult,
                Xmult_mod = card.ability.x_mult
            }
        end
    end
}
SMODS.Joker {key = 'smart_magnifying_glass',
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
SMODS.Joker {key = 'diamond_pickaxe',
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
SMODS.Joker {key = 'shadow',
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
    pos = { x = 0, y = 0 },
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
SMODS.Joker {key = 'math_draft',
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
SMODS.Joker {key = 'broken_brick',
    loc_txt = {
         name = 'Broken Brick',
          text = {
             "{C:mult}+5{} mult" 
            } 
        },
    config = { extra = 5 },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    atlas = "broken_brick",
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra }
        end
    end
}
SMODS.Joker {key = 'brick',
    loc_txt = {
        name = 'Brick',
        text = {
            "{X:mult,C:white} X2 {} Mult",
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
            (G.GAME and G.GAME.probabilities.normal or 1), 
            (card and card.ability and card.ability.chance or 4) 
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
                            local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_sj_broken_brick')
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
SMODS.Joker {key = 'holo_stickers',
    loc_txt = {
        name = 'Holographic Stickers',
        text = {
            "This Joker gives {X:mult,C:white} X1 {} Mult",
            "for every Joker with {C:attention}Edition{}",
            "what you own",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {}{C:inactive} Mult)"
        }
    },
    config = { extra = 1 },
    rarity = 'sj_super_rare', cost = 10,
    blueprint_compat = true,
    atlas = "holographic_stickers",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.edition then count = count + 1 end
            end
        end
        return { vars = { 1 + (count * 0.5) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, v in ipairs(G.jokers.cards) do
                if v.edition then count = count + 1 end
            end
            if count > 0 then
                return { x_mult = 1 + (count * 0.5) }
            end
        end
    end
}
SMODS.Joker {key = 'prism',
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
SMODS.Joker {key = 'joker_lua',
    loc_txt = {
        name = 'SMODS.Joker',
        text = {"SMODS.Atlas({",
    'key = "joker_lua",',
    'path = "j_joker_lua.png",',
    "px = 71,",
    "py = 95",
 "})",
            "SMODS.Joker {",
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
                "message = 'X' .. card.ability.extra,",
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
                message = 'X' .. card.ability.extra,
                Xmult_mod = card.ability.extra
            }
        end
    end
}
SMODS.Joker{key = "russian_alphabet",
    config = { x_mult = 33 }, 
    pos = { x = 0, y = 0 },
    rarity = "sj_super_rare",
    cost = 12,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'russian_alphabet',
        loc_txt = {
                name = "Russian Alphabet",
                text = { 
                    "{X:mult,C:white}33{} letters"
                }
            },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'X' .. card.ability.x_mult,
                Xmult_mod = card.ability.x_mult
            }
        end
    end
}
SMODS.Joker {key = 'lucky_block',
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
SMODS.Joker {key = 'doomsday',
    loc_txt = {
        name = 'Doomsday',
        text = {
            "{X:mult,C:white} X10 {} Mult, but if blind is",
            "not defeated in {C:attention}1 hand{}",
            "{C:red}KABOOM GAME OVER{}"
        }
    },
    config = { extra = { x_mult = 10 } },
    rarity = "sj_super_rare",
    blueprint_compat = true,
    pos = { x = 0, y = 0 },
    cost = 10,
    atlas = "doomsday",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = 'X' .. card.ability.extra.x_mult,
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
SMODS.Joker {key = 'tax_haven',
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
SMODS.Joker {key = 'cube_joker',
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
    pos = { x = 0, y = 0 },
    cost = 5,
    atlas = 'cube_joker',
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand == 3 then
            return {
                message = 'X' .. card.ability.extra.x_mult,
                Xmult_mod = card.ability.extra.x_mult
            }
        end
    end
}
SMODS.Joker {key = 'exponential_growth',
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
    rarity = "sj_super_rare",
    cost = 12,
    atlas = 'exponential_growth',
    unlocked = true,
    discovered = true,
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
SMODS.Joker {key = 'doublet',
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
                    message = '+' .. (count * card.ability.extra) .. ' Mult!'
                }
            end
        end
    end
}
SMODS.Joker {key = 'second_chance',
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
SMODS.Joker {key = 'binary_code',
    loc_txt = {
        name = 'Binary Code',
        text = { "{X:mult,C:white} X2 {} Mult if played hand", "contains exactly {C:attention}2{} ranks", "and {C:attention}2{} suits" }
    },
    config = { extra = 2 },
    rarity = 2,
    atlas = 'binary_code',
    unlocked = true,
    discovered = true,
    cost = 6,
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
                    message = 'X' .. card.ability.extra .. '!'
                }
            end
        end
    end
}
SMODS.Joker {key = 'night_watch',
    loc_txt = {
        name = 'Night Watch',
        text = { 
            "Earn {C:money}$2{} at end of round",
        "if you have exactly {C:attention}2{} discards remaining" 
    }
    },
    config = { extra = 2 },
    rarity = 2,
    atlas = 'night_watch',
    unlocked = true,
    discovered = true,
    cost = 6,
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
    pos = { x = 0, y = 0 },
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
            else
                if card.debuff then
                    card:set_debuff(false)
                end
            end
        elseif card.debuff then
            card:set_debuff(false)
        end
    end,
    calculate = function(self, card, context)
        if card.debuff then return end
        if context.joker_main then
            return {
                message = '+' .. card.ability.chips,
                chip_mod = card.ability.chips
            }
        end
    end
}
SMODS.Joker {key = 'charm_joker',
    loc_txt = {
        name = 'Mega Arcana Pack',
        text = {
            "Gives {C:attention}Charm Tag{}",
            "at end of round"
        }
    },
    config = {},
    rarity = 2,
    pos = { x = 0, y = 0 },
    atlas = 'charm_joker',
    cost = 6,
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
SMODS.Joker {key = 'Imposter',
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
    pos = { x = 0, y = 0 },
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
SMODS.Joker {key = 'void_contract',
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
    pos = { x = 0, y = 0 },
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
            message = 'X' .. card.ability.extra.x_mult,
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
SMODS.Joker {key = 'joker_404',
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
    pos = { x = 0, y = 0 },
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
SMODS.Joker {key = 'schrodinger_cat',
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
    pos = { x = 0, y = 0 },
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
                    message = 'X' .. card.ability.extra.Xmult,
                    Xmult_mod = card.ability.extra.Xmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}
SMODS.Joker{key = "joker_outline",
    config = { mult = 1 }, 
    pos = { x = 0, y = 0 },
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
                    "{C:mult} +1{} mult"
                }
            },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '+' .. card.ability.mult,
                mult_mod = card.ability.mult
            }
        end
    end
}
SMODS.Joker{key = "small_joker",
    config = {}, 
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
        loc_txt = {
                name = "small joker",
                text = { 
                    "yay u found Easter Egg yippee"
                }
            },
    display_size = { w = 10000000, h = 10000000 },
}
SMODS.Joker{key = "code_joker", -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    config = { mult = 140.2 }, 
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'code_joker',
        loc_txt = {
                name = "Code joker",
                text = { 
                    "gives {C:mult}+0.1{} for every line of code in {C:blue}jokers.lua{}",
                    "{C:inactive}(currently{} {C:mult}+140.2{}{C:inactive} mult){}"
                }
            },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = '+' .. card.ability.mult,
                mult_mod = card.ability.mult
            }
        end
    end
}