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
        name = 'Red Deck Card',
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
                ease_discard(1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'yellow_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Yellow Deck Card',
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
        name = 'Blue Deck Card',
        text = { "{C:blue}+1{} hand",
                 "every round"
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
                ease_hands_played(1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'green_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Green Deck Card',
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
                G.GAME.modifiers.money_per_hand = 2
                G.GAME.modifiers.money_per_discard = 1
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'black_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Black Deck Card',
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
                ease_hands_played(-1)
                ease_joker_slots(1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'prologue_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Prologue Deck Card',
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
        name = 'Gray Deck Card',
        text = { 
            "{C:attention}+1{} consumable slot", 
            "{C:red}-1{} discard every round" 
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'gray_deck',
    in_pool = function(self)
        return true
    end,
    can_use = function(self, card)
        return G.GAME.round_resets.discards > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_consumable_slots(1)
                ease_discard(-1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'anaglyph_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Anaglyph Deck Card',
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
        name = 'Painted Deck Card',
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
                ease_joker_slots(-1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'abandoned_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Abandoned Deck Card',
        text = { 
            "{C:attention}removes{} all",
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
        name = 'Russian Deck Card',
        text = { 
            "{C:attention}removes{} all",
            "{C:attention}2, 3, 4,{} and {C:attention}5{} in your deck"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = '36_cards',
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
        name = 'Gamble Deck Card',
        text = { 
            "create {C:attention}Lucky Block{}",
            "and {C:tarot}The Wheel of Fortune{}",
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'gamble_deck',
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
        name = 'Orange Deck Card',
        text = { 
            "{C:attention}+1{} hand size"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'orange_deck',
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
        name = 'Checkered Deck Card',
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
                    if G.playing_cards[i].base.suit == 'Clubs' then
                        G.playing_cards[i]:change_suit('Spades')
                        G.playing_cards[i]:juice_up()
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
        name = 'Erratic Deck Card',
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
        name = 'Ghost Deck Card',
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
        name = 'Magic Deck Card',
        text = { 
            "{C:attention}+1{} consumable slot",
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
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
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
        name = 'Nebula Deck Card',
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
        name = 'Plasma Deck Card',
        text = { 
            "{X:attention,C:white}x0.5{} blind requirement"
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
SMODS.Consumable {key = 'purple_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Purple Deck Card',
        text = { 
            "{C:enhanced}+1{} card selection limit",
            "every round"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'purple_deck',
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
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'light_blue_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Light Blue Deck Card',
        text = { 
            "{C:attention}+1{} consumable slot",
            "every round"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'light_blue_deck',
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
                ease_consumable_slots(1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'rainbow_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Rainbow Deck Card',
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
            "{C:attention}+1{} boosterpack slot",
            "{C:blue}+1{} card play limit",
            "{C:red}+1{} card discard limit",
            "{C:attention}+1{} hand size",
            "{C:attention}+1{} ante to win",
            "{C:money}+$1{} per hand",
            "{C:money}+$1{} per discard",
            "{C:money}+$1{} of interest",
            "{C:green}+1{} probability",
            "{C:money}+$1{} reroll cost",
            "{C:attention}+1{} cost of items in shop",
            "{C:attention}+1{} boss blind in ante",
            "{C:attention}+1{} level to all hands"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'rainbow_deck',
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
                ease_discard(1)
                ease_hands_played(1)
                ease_ante(1)
                ease_consumeable_slots(1)
                ease_joker_slots(1)
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
                ease_reroll_cost(1)
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
    end
}
SMODS.Consumable {key = 'tyrants_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Tyrants Deck Card',
        text = { 
            "Every {C:attention}Blind{} becomes a",
            "{C:attention}Boss Blind{}"
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
                G.GAME.round_resets.blind_choices.Small = get_new_boss()
                local new_big = get_new_boss()
                while new_big == G.GAME.round_resets.blind_choices.Small do
                    new_big = get_new_boss()
                end
                G.GAME.round_resets.blind_choices.Big = new_big
                if G.FUNCS and G.FUNCS.set_blind_select and G.STATE == G.STATES.BLIND_SELECT then 
                    G.FUNCS.set_blind_select()
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'joker_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Joker Deck Card',
        text = { 
            "{X:attention,C:white}x0.25{} blind requirement",
            "{C:red}-1{} joker slot"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'joker_deck',
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
                G.GAME.modifiers.uv_plasma_reduction = 0.25
                if G.GAME.blind and G.GAME.blind.chips then
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 0.25)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                end
                ease_joker_slots(-1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'royal_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Royal Deck Card',
        text = { 
            "turn every {C:attention}Queen{} and",
            "{C:attention}Jack{} turned into a {C:attention}Kings{}"
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
SMODS.Consumable {key = 'deck_deck_card',
    set = 'DeckCard',
    config = { deck_cards = 2 },
    loc_txt = {
        name = 'Deck Deck Card',
        text = { 
            "create {C:attention}2{} random {C:green}Deck Cards{}"
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
                local valid_pool = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'DeckCard' then
                        table.insert(valid_pool, k)
                    end
                end
                for i = 1, self.config.deck_cards do
                    local chosen_key = nil
                    if #valid_pool > 0 then
                        chosen_key = pseudorandom_element(valid_pool, pseudoseed('uv_deck_deck_card'))
                    else
                        local backup_pool = {}
                        for k, v in pairs(G.P_CENTERS) do
                            if v.set == 'Tarot' then
                                table.insert(backup_pool, k)
                            end
                        end
                        chosen_key = pseudorandom_element(backup_pool, pseudoseed('uv_deck_deck_card_backup'))
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
SMODS.Consumable {key = 'sandbox_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Sandbox Deck Card',
        text = { 
            "creates",
            "{C:green}Perkeo{} and",
            "{C:spectral}POINTER://{}",
            "{C:dark_edition}Cryptid cross-mod deck card{}"
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
SMODS.Consumable {key = 'chimps_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'CHIMPS Deck Card',
        text = { 
            "{C:red}-2{} consumable slots",
            "{C:red}-3{} Hands",
            "no {C:attention}Interest",
            "{C:red}-$14{}",
            "{C:attention}+2{} antes",
            "{C:red}-1{} hand size"
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
                ease_consumable_slots(-2)
                ease_hands_played(-3)
                G.GAME.modifiers.no_interest = true
                ease_antes(2)
                ease_dollars(-14)
                G.hand:change_size(-1)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = '7lb2vpk_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = '7LB2WVPK Deck Card',
        text = { 
            "Every card in your deck",
            "becomes the exact same card"
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
                local random_card_key = pseudorandom_element(G.P_CARDS, pseudoseed('broken_seed'))
                for k, v in pairs(G.playing_cards) do
                    v:set_base(random_card_key)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'subscription_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Subscription Deck Card',
        text = { 
            "{C:red}-2{} {C:attention}booster pack{} slots",
            "{C:attention}+2 voucher{} slots"
        }
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    atlas = 'purple_deck',
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
                SMODS.change_voucher_limit(2)
                SMODS.change_booster_limit(-2)
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'desktop_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Desktop Deck Card',
        text = { 
            "{C:money}+$1{} for every",
            "{C:attention}50 files{} on your Desktop.",
            "{C:inactive}(Currently {C:money}+$#1#{C:inactive})"
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
    loc_vars = function(self, info)
        local money_bonus = math.floor(G.DESKTOP_FILE_COUNT / 50)
        return { vars = { money_bonus } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local money_bonus = math.floor(G.DESKTOP_FILE_COUNT / 50)
                if money_bonus > 0 then
                    ease_dollars(money_bonus)
                end
                return true
            end
        }))
    end
}
SMODS.Consumable {key = 'supermarket_deck_card',
    set = 'DeckCard',
    loc_txt = {
        name = 'Supermarket Deck Card',
        text = { 
            "blind gives no money from {C:blue}hands{}",
            "no {C:attention}interest",
            "{C:attention}+2 voucher{} slots",
            "{C:attention}+1 booster{} slot",
            "{C:attention}+3 card{} slots in the shop",
            "rerolls cost {C:red}$3{} less"
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
                SMODS.change_voucher_limit(2)
                SMODS.change_booster_limit(1)
                G.GAME.modifiers.no_interest = true
                G.GAME.modifiers.money_per_hand = 0
                change_shop_size(3)
                G.GAME.modifiers.reroll_cost = (G.GAME.modifiers.reroll_cost or 0) - 3
                G.GAME.round_resets.reroll_cost = math.max(0, G.GAME.round_resets.reroll_cost - 3)
                return true
            end
        }))
    end
}