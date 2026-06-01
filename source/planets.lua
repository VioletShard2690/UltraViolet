SMODS.Consumable{key = "planet_three_pair",
    set = "Planet",
    object_type = "Consumable",
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
    object_type = "Consumable",
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
SMODS.Consumable {key = "planet_flush_four",
    set = "Planet",
    object_type = "Consumable",
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
SMODS.Consumable {key = "planet_wild_forest",
    set = "Planet",
    object_type = "Consumable",
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
SMODS.Consumable {key = "planet_flush_two_pair",
    set = "Planet",
    object_type = "Consumable",
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
SMODS.Consumable {key = "planet_1234",
    set = "Planet",
    object_type = "Consumable",
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
SMODS.Consumable {key = "planet_art_gallery",
    set = "Planet",
    object_type = "Consumable",
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
SMODS.Consumable {key = "planet_flush_1234",
    set = "Planet",
    object_type = "Consumable",
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