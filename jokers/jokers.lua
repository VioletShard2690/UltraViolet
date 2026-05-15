function shakecard(self)
    G.E_MANAGER:add_event(Event({
        func = function()
            self:juice_up(0.5, 0.5)
            return true
        end
    }))
end
SMODS.Atlas({
    key = "chaotic",
    path = "c_chaotic.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "broken_clock",
    path = "j_broken_clock.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "sample_test_joker",
    path = "j_sample_test_joker.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "sad_piggybank",
    path = "j_sad_piggybank.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "pavel",
    path = "j_pavel.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "torn_banknote",
    path = "j_torn_banknote.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "valavo",
    path = "j_valavo.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "mr_two",
    path = "j_mr_two.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "second_second",
    path = "j_second_second.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "tea_for_two",
    path = "j_tea_for_two.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "smart_magnifying_glass",
    path = "j_smart_magnifying_glass.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "36_cards",
    path = "36_cards.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "gamble_deck",
    path = "gamble_deck.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "diamond_pickaxe",
    path = "j_diamond_pickaxe.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "shadow",
    path = "j_shadow.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "math_draft",
    path = "j_math_draft.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "holographic_stickers",
    path = "j_holographic_stickers.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "brick",
    path = "j_brick.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "broken_brick",
    path = "j_broken_brick.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "lucky_block",
    path = "j_lucky_block.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34
})
SMODS.Joker {
    key = 'valavo',
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
SMODS.Joker {
    key = 'second_second',
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
SMODS.Joker {
    key = 'tea_for_two',
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
SMODS.Joker {
    key = 'mr_two',
    loc_txt = {
        name = 'Mr. Two',
        text = { "Gives {X:mult,C:white} X#1# {} Mult if played hand",
                 "contains exactly {C:attention}two 2's{}",
    }
    },
    config = { extra = 2.2 },
    rarity = 2,
    pos = { x = 0, y = 0 }, 
    atlas = 'mr_two',
    cost = 6,
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
                    message = 'x' .. card.ability.extra .. '!',
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
}
SMODS.Joker{
    key = 'torn_banknote',
    config = { extra = { chips_per_5 = 150 } },
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
            "{C:money}$5{} of debt you have",
            "{C:inactive}(Currently {C:chips}+#3# {C:inactive} Chips){}",
            "{C:red}Only works if balance is below $0{}"
        }
    },

    loc_vars = function(self, info_queue, card)
        local money = (G.GAME and G.GAME.dollars) or 0
        local debt_bonus = 0
        if money < 0 then
            debt_bonus = math.floor(math.abs(money) / 5) * card.ability.extra.chips_per_5
        end
        return { vars = { card.ability.extra.chips_per_5, 5, debt_bonus } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local money = (G.GAME and G.GAME.dollars) or 0
            if money < 0 then
                local current_chips = math.floor(math.abs(money) / 5) * card.ability.extra.chips_per_5
                
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
SMODS.Joker{
    key = 'pavel',
    config = { extra = { odds = 4, neg_odds = 32 } },
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
SMODS.Consumable{
    key = 'chaotic',
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
SMODS.Joker{
    key = 'sad_piggybank',
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
SMODS.Joker{
    key = "broken_clock",
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
SMODS.Joker{
    key = "sample_test_joker",
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
SMODS.Joker {
    key = 'smart_magnifying_glass',
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
SMODS.Back {
    name = "Russian Deck",
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
SMODS.Joker {
    key = 'diamond_pickaxe',
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
SMODS.Joker {
    key = 'shadow',
    loc_txt = {
        name = 'Shadow',
        text = {
                   "Copies the ability of {C:attention}rightmost{} Joker",
                   "but with {C:attention}half{} the effectiveness",
                   "{C:inactive}(if possible){}"
        }
    },
    config = { extra = { type = 'Shadow' } },
    rarity = 2,
    blueprint_compat = false,
    pos = { x = 0, y = 0 },
    cost = 6,
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
            if res.mult_mod then res.mult_mod = math.floor(res.mult_mod / 2) end
            if res.chips_mod then res.chips_mod = math.floor(res.chips_mod / 2) end
            if res.Xmult_mod then res.Xmult_mod = 1 + (res.Xmult_mod - 1) / 2 end
            if res.chips then res.chips = math.floor(res.chips / 2) end
            if res.mult then res.mult = math.floor(res.mult / 2) end
            if res.x_mult then res.x_mult = 1 + (res.x_mult - 1) / 2 end
            if res.dollars then res.dollars = math.floor(res.dollars / 2) end
            if res.dollars or context.individual or context.repetition then
                res.message = nil 
            else
                if res.mult_mod then res.message = '+' .. res.mult_mod .. ' Mult'
                elseif res.chips_mod then res.message = '+' .. res.chips_mod .. ' Chips'
                elseif res.Xmult_mod then res.message = 'X' .. res.Xmult_mod
                end
            end
            res.card = card
            return res

        end
    end
  end
}
SMODS.Joker {
    key = 'math_draft',
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
SMODS.Joker {
    key = 'lucky_block',
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
SMODS.Joker {
    key = 'broken_brick',
    loc_txt = {
         name = 'Broken Brick',
          text = {
             "{C:mult}+5{} mult" 
            } 
        },
    config = { extra = 5 },
    rarity = 1,
    cost = 2,
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
SMODS.Joker {
    key = 'brick',
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
SMODS.Joker {
    key = 'holo_stickers',
    loc_txt = {
        name = 'Holographic Stickers',
        text = {
            "This Joker gives {X:mult,C:white} X0.5 {} Mult",
            "for every Joker with {C:attention}Edition{}",
            "what you own",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {}{C:inactive} Mult)"
        }
    },
    config = { extra = 0.5 },
    rarity = 3, cost = 8,
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
SMODS.Back {
    name = "Gamble Deck",
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