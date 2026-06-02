SMODS.Booster {key = 'super_rare_pack',
    loc_txt = {
        name = 'Super Rare Buffoon Pack',
        text = {
            "Choose {C:attention}#1#{} of",
            "up to {C:attention}#2#{} {C:spades}Super Rare{} Jokers"
        }
    },
    config = {extra = 2, choose = 1},
    weight = 0.1,
    kind = 'Joker',
    cost = 30,
    atlas = 'super_rare_pack',
    unlocked = true,
    discovered = true,
    group_key = 'k_uv_super_rare_pack',
    display_size = { w = 56, h = 95 },
    create_card = function(self, card, i)
        return {set = 'Joker', area = G.pack_cards, skip_materialize = true, rarity = 'uv_super_rare'}
    end,
    draw_probs = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.config.center.config.choose, card.config.center.config.extra} }
    end
}
SMODS.Booster {key = 'deck_normal_1',
    set = 'Booster',
    kind = 'DeckCard',
    config = { extra = 2, choose = 1 },
    cost = 4,
    weight = 0.8,
    unlocked = true,
    discovered = true,
    group_key = 'k_uv_deck_pack',
    loc_txt = {
        name = 'Deck Pack',
        text = { 
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:green}Deck{} Cards to",
            "be used immediately"
        }
    },
    create_card = function(self, card)
        return create_card('DeckCard', G.pack_cards, nil, nil, true, true, nil, 'deck_p')
    end,
    draw_probs = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.config.center.config.choose, card.config.center.config.extra} }
    end
}
SMODS.Booster {key = 'deck_normal_2',
    set = 'Booster',
    kind = 'DeckCard',
    config = { extra = 2, choose = 1 },
    cost = 4,
    weight = 0.8,
    unlocked = true,
    discovered = true,
    group_key = 'k_uv_deck_pack',
    loc_txt = {
        name = 'Deck Pack',
        text = { 
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:green}Deck{} Cards to",
            "be used immediately"
        }
    },
    create_card = function(self, card)
        return create_card('DeckCard', G.pack_cards, nil, nil, true, true, nil, 'deck_p')
    end,
    draw_probs = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.config.center.config.choose, card.config.center.config.extra} }
    end
}
SMODS.Booster {key = 'deck_jumbo_1',
    set = 'Booster',
    kind = 'DeckCard',
    config = { extra = 4, choose = 1 },
    cost = 6,
    weight = 0.4,
    unlocked = true,
    discovered = true,
    group_key = 'k_uv_jumbo_deck_pack',
    loc_txt = {
        name = 'Jumbo Deck Pack',
        text = { 
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:green}Deck{} Cards to",
            "be used immediately"
        }
    },
    create_card = function(self, card)
        return create_card('DeckCard', G.pack_cards, nil, nil, true, true, nil, 'deck_p')
    end,
    draw_probs = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.config.center.config.choose, card.config.center.config.extra} }
    end
}
SMODS.Booster {key = 'deck_mega_1',
    set = 'Booster',
    kind = 'DeckCard',
    config = { extra = 4, choose = 2 },
    cost = 8,
    weight = 0.2,
    unlocked = true,
    discovered = true,
    group_key = 'k_uv_mega_deck_pack',
    loc_txt = {
        name = 'Mega Deck Pack',
        text = { 
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:green}Deck{} Cards to",
            "be used immediately"
        }
    },
    create_card = function(self, card)
        return create_card('DeckCard', G.pack_cards, nil, nil, true, true, nil, 'deck_p')
    end,
    draw_probs = function(self)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.config.center.config.choose, card.config.center.config.extra} }
    end
}