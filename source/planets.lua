SMODS.Consumable{key = "planet_three_pair",
    set = "Planet",
    loc_txt = {
        name = "test three pair",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Three Pair{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_three_pair"] then
            local hand = G.GAME.hands["uv_three_pair"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                    (
                        to_big(G.GAME.hands["uv_three_pair"].level) == to_big(1) and G.C.UI.TEXT_DARK
                        or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_three_pair"].level))]
                    ),
                                },
                        },
                    }
        else
            return { vars = { 1, 3, 25 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_three_pair")
    end,can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_two_sets",
    set = "Planet",
    loc_txt = {
        name = "Two Sets",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Two Sets{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_two_sets"] then
            local hand = G.GAME.hands["uv_two_sets"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_two_sets"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_two_sets"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 4, 30 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_two_sets")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_flush_four",
    set = "Planet",
    loc_txt = {
        name = "Flush Four",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Flush Four{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_flush_four"] then
            local hand = G.GAME.hands["uv_flush_four"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_flush_four"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_flush_four"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 4, 40 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_flush_four")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_wild_forest",
    set = "Planet",
    loc_txt = {
        name = "Wild Forest",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Wild Forest{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_wild_forest"] then
            local hand = G.GAME.hands["uv_wild_forest"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_wild_forest"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_wild_forest"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 3, 30 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_wild_forest")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_flush_two_pair",
    set = "Planet",
    loc_txt = {
        name = "Flush Two Pair",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Flush Two Pair{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_flush_two_pair"] then
            local hand = G.GAME.hands["uv_flush_two_pair"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_flush_two_pair"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_flush_two_pair"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 2, 20 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_flush_two_pair")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_1234",
    set = "Planet",
    loc_txt = {
        name = "1234",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}1234{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_1234"] then
            local hand = G.GAME.hands["uv_1234"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_1234"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_1234"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 2, 20 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_1234")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_art_gallery",
    set = "Planet",
    loc_txt = {
        name = "Art Gallery",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Art Gallery{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_art_gallery"] then
            local hand = G.GAME.hands["uv_art_gallery"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_art_gallery"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_art_gallery"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 4, 40 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_art_gallery")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = "planet_flush_1234",
    set = "Planet",
    loc_txt = {
        name = "Flush 1234",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Flush 1234{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_flush_1234"] then
            local hand = G.GAME.hands["uv_flush_1234"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_flush_1234"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_flush_1234"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 4, 40 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_flush_1234")
    end,
    can_use = function(self, card)
        return true
    end,
}
SMODS.Consumable{key = 'meteorite',
    set = "Planet",
    loc_txt = {
        name = 'Meteorite',
        text = {
            "Upgrades random {C:attention}poker hand{}",
            "by {C:attention}1{} level",
            "{C:green}#1# in #2#{} chance to upgrade it",
            "by {C:attention}3{} levels instead"
        }
    },
    config = { extra = { odds = 3 } },
    cost = 3,
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
        return true
    end,
    loc_vars = function(self, info_queue, center)
        return { vars = { G.GAME.probabilities.normal, center.ability.extra.odds } }
    end,
    use = function(self, card, area, copier)
        local used_consumable = copier or card
        local random_hand
        while true do
            random_hand = pseudorandom_element(G.handlist, pseudoseed('meteorite' .. G.GAME.round_resets.ante))
            if G.GAME.hands[random_hand] and G.GAME.hands[random_hand].visible then
                break
            end
        end
        local levels_to_add = 1
        if pseudorandom('meteorite_chance') < G.GAME.probabilities.normal / card.ability.extra.odds then
            levels_to_add = 3
        end
        update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
            handname = localize(random_hand, "poker_hands"),
            chips = G.GAME.hands[random_hand].chips,
            mult = G.GAME.hands[random_hand].mult,
            level = G.GAME.hands[random_hand].level,
        })
        level_up_hand(used_consumable, random_hand, nil, levels_to_add)
        update_hand_text(
            { sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
            { mult = 0, chips = 0, handname = "", level = "" }
        )
    end
}
SMODS.Consumable{key = 'polar_star',
    set = 'Planet',
    loc_txt = {
        name = 'Polar Star',
        text = {
            "Levels up your",
            "{C:attention}most played{} Poker Hand",
            "{C:inactive}(Currently: {C:attention}#1#{C:inactive})"
        }
    },
    cost = 3,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
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
        local hand_name = G.GAME and G.GAME.hands[most_played_hand] and G.GAME.hands[most_played_hand].label or most_played_hand
        return { vars = { hand_name } }
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local most_played_hand = "High Card"
        local max_plays = -1
        for k, v in pairs(G.GAME.hands) do
            if v.played > max_plays then
                max_plays = v.played
                most_played_hand = k
            end
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname = G.GAME.hands[most_played_hand].label, level = G.GAME.hands[most_played_hand].level})
        level_up_hand(card, most_played_hand, nil, 1)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, level = ''})
    end
}
SMODS.Consumable{key = "planet_flush_1234",
    set = "Planet",
    loc_txt = {
        name = "Greg poker hand",
        text = {
            "({V:1}lvl.#1#{}) Level up",
            "{C:attention}Greg poker hand{}",
            "{C:mult}+#2#{} Mult and",
            "{C:chips}+#3#{} Chips"
        },
    },
    loc_vars = function(self, info_queue, card)
        if G.GAME and G.GAME.hands and G.GAME.hands["uv_greg_hand"] then
            local hand = G.GAME.hands["uv_greg_hand"]
            return {
                vars = {
                    hand.level,
                    hand.l_mult,
                    hand.l_chips,
                    colours = {
                        (
                            to_big(G.GAME.hands["uv_greg_hand"].level) == to_big(1) and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[to_number(math.min(7, G.GAME.hands["uv_greg_hand"].level))]
                        ),
                    },
                },
            }
        else
            return { vars = { 1, 5, 50 } }
        end
    end,
    unlocked = true,
    discovered = true,
    hidden = true,
    cost = 3,
    use = function(self, card, area, copier)
        SMODS.smart_level_up_hand(card, "uv_greg_hand")
    end,
    can_use = function(self, card)
        return true
    end,
}