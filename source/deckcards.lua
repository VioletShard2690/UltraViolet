SMODS.ConsumableType {key = 'DeckCard',
    primary_colour = HEX("65a118"),
    secondary_colour = HEX("4d7d10"),
    loc_txt = {
        name = 'Deck Card',
        collection = 'Deck Cards',
    },
    shop_rate = 0.0,
    collection_rows = { 5, 6 }
}
SMODS.Consumable {key = 'red_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Red Deck',
        text = { "{C:red}+1{} discard",
                 "every round"
    }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.starting_params.discards = G.GAME.starting_params.discards + 1
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
                if G.STATE == G.STATES.SELECT_HAND or G.STATE == G.STATES.PLAYER_INPUT then
                    G.discards:change_config('card_limit', 1)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'yellow_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Yellow Deck',
        text = { "Gives {C:money}$10{}" }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
		return true
	end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_dollars(10)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'blue_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Blue Deck',
        text = { "{C:blue}+1{} hand", "every round" }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card) return true end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.starting_params.hands = G.GAME.starting_params.hands + 1
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                if G.STATE == G.STATES.SELECT_HAND or G.STATE == G.STATES.PLAYER_INPUT then
                    G.hands:change_config('card_limit', 1)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'green_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Green Deck',
        text = { "{C:money}$2{} per remaining {C:blue}Hand{}",
                 "{C:money}$1{} per remaining {C:red}Discard{}",
                 "and {C:money}$0{} from {C:attention}interest{}",
                 "at end of round"
                }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card) return true end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.no_interest = true
                G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 0) + 2
                G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + 1
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'black_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Black Deck',
        text = { 
            "{C:attention}+1{} Joker slot", 
            "{C:blue}-1{} hand every round" 
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.joker_slots = (G.GAME.modifiers.joker_slots or 5) + 1
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                G.GAME.starting_params.hands = G.GAME.starting_params.hands - 1
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
                if G.hands then
                    G.hands:change_config('card_limit', -1)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'prologue_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Prologue',
        text = { 
            "{C:attention}-1{} Ante" 
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_ante(-1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'gray_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Gray Deck',
        text = { 
            "{C:attention}+1{} consumable slot", 
            "{C:red}-1{} discard every round" 
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return G.GAME.round_resets.discards > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.consumable_slots = (G.GAME.modifiers.consumable_slots or 2) + 1
                if G.consumeables then 
                    G.consumeables.config.card_limit = G.GAME.modifiers.consumable_slots 
                end
                G.GAME.starting_params.discards = G.GAME.starting_params.discards - 1
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
                if G.discards then
                    G.discards:change_config('card_limit', -1)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'anaglyph_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Anaglyph Deck',
        text = { 
            "Gives {C:attention}8 Double Tags{}"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 8 do
                    local tag = Tag('tag_double')
                    add_tag(tag)
                end
                card:juice_up(0.6, 0.6)
                play_sound('generic1', 0.9 + math.random()*0.2)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'painted_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Painted Deck',
        text = { 
            "{C:attention}+2{} hand size",
            "{C:red}-1{} Joker slot"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:change_size(2)
                G.GAME.modifiers.joker_slots = (G.GAME.modifiers.joker_slots or 5) - 1
                G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'abandoned_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Abandoned Deck',
        text = { 
            "{C:attention}destroys{} all",
            "{C:attention}Face{} cards in your deck"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local destroyed_cards = {}
                for i = #G.playing_cards, 1, -1 do
                    if G.playing_cards[i]:is_face() then
                        destroyed_cards[#destroyed_cards+1] = G.playing_cards[i]
                        G.playing_cards[i]:remove()
                    end
                end
                if #destroyed_cards > 0 then
                    for i = 1, #destroyed_cards do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                destroyed_cards[i]:juice_up()
                                return true
                            end
                        }))
                    end
                    play_sound('slice1', 0.9 + math.random()*0.2)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'russian_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Russian Deck',
        text = { 
            "{C:attention}destroys{} all",
            "{C:attention}2, 3, 4,{} and {C:attention}5{} in your deck"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local destroyed_cards = {}
                for i = #G.playing_cards, 1, -1 do
                    local rank = G.playing_cards[i]:get_id()
                    if rank >= 2 and rank <= 5 then
                        destroyed_cards[#destroyed_cards+1] = G.playing_cards[i]
                        G.playing_cards[i]:remove()
                    end
                end
                if #destroyed_cards > 0 then
                    for i = 1, #destroyed_cards do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                destroyed_cards[i]:juice_up()
                                return true
                            end
                        }))
                    end
                    play_sound('slice1', 0.9 + math.random()*0.2)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'gamble_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Gamble Deck',
        text = { 
            "create {C:attention}Lucky Block{}",
            "and {C:tarot}The Wheel of Fortune{}",
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit or #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local wheel = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'gamble_card')
                wheel:add_to_deck()
                G.consumeables:emplace(wheel)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local lucky_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_uv_lucky_block', 'gamble_card')
                lucky_joker:add_to_deck()
                G.jokers:emplace(lucky_joker)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'orange_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Orange Deck',
        text = { 
            "{C:attention}+1{} hand size"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:change_size(1)
                play_sound('card1', 0.9 + math.random()*0.2)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'checkered_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Checkered Deck',
        text = { 
            "Converts all {C:clubs}Clubs{} to {C:spades}Spades{},",
            "and all {C:diamonds}Diamonds{} to {C:hearts}Hearts{}"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                for i = 1, #G.playing_cards do
                    -- Если карта Трефы -> делаем Пикой
                    if G.playing_cards[i].base.suit == 'Clubs' then
                        G.playing_cards[i]:change_suit('Spades')
                        G.playing_cards[i]:juice_up()
                    -- Если карта Бубны -> делаем Червой
                    elseif G.playing_cards[i].base.suit == 'Diamonds' then
                        G.playing_cards[i]:change_suit('Hearts')
                        G.playing_cards[i]:juice_up()
                    end
                end
                play_sound('tarot2', 1.2, 0.6)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'erratic_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Erratic Deck',
        text = { 
            "Randomizes the {C:attention}rank{} and",
            "{C:attention}suit{} of every card in your deck"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local suits = {'S', 'H', 'C', 'D'}
                local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
                for i = 1, #G.playing_cards do
                    local random_suit = suits[pseudorandom(pseudoseed('erratic_s'), 1, 4)]
                    local random_rank = ranks[pseudorandom(pseudoseed('erratic_r'), 1, 13)]
                    G.playing_cards[i]:set_base(G.P_CARDS[random_suit .. '_' .. random_rank])
                    G.playing_cards[i]:juice_up()
                end
                play_sound('tarot2', 0.7, 0.4)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'ghost_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Ghost Deck',
        text = { 
            "creates a {C:spectral}Hex{} and",
            "a random {C:spectral}Spectral{} card"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local hex_card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_hex', 'ghost_card')
                hex_card:add_to_deck()
                G.consumeables:emplace(hex_card)
                local random_spectral = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'ghost_comp')
                random_spectral:add_to_deck()
                G.consumeables:emplace(random_spectral)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'magic_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Magic Deck',
        text = { 
            "Creates the {C:attention}Crystal Ball{} voucher,",
            "creates {C:attention}2 The Fool's{}"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local voucher = create_card('Voucher', G.consumeables, nil, nil, nil, nil, 'v_crystal_ball', 'magic_v')
                voucher:apply_to_run()
                for i = 1, 2 do
                    local fool = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_fool', 'magic_f')
                    fool:add_to_deck()
                    G.consumeables:emplace(fool)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'nebula_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Nebula Deck',
        text = { 
            "Creates {C:attention}every{} Planet card",
            "including {C:spectral}Black Hole{}"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local planets = {
                    'c_mercury', 'c_venus', 'c_earth', 'c_mars', 'c_jupiter', 
                    'c_saturn', 'c_uranus', 'c_neptune', 'c_pluto', 'c_planet_x', 
                    'c_ceres', 'c_eris', 'c_black_hole'
                }
                for _, v in ipairs(planets) do
                    local p_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, v, 'nebula_p')
                    p_card:add_to_deck()
                    G.consumeables:emplace(p_card)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'plasma_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Plasma Deck',
        text = { 
            "{C:attention}x0.5{} blind requirement"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.GAME.modifiers.uv_plasma_reduction = 0.5
                if G.GAME.blind and G.GAME.blind.chips then
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 0.5)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                end
                return true
            end
        }))
    end
}