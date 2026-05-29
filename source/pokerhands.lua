SMODS.PokerHand {key = 'three_pair',
    loc_txt = {
        name = 'Three Pair',
        description = {
            '3 pairs of cards with different ranks'
        }
    },
    chips = 80,
    mult = 8,
    l_chips = 25,
    l_mult = 3,
    visible = false,
    example = {
        { 'S_2',    true }, { 'D_2',    true },
        { 'H_3',    true }, { 'C_3',    true },
        { 'S_4',    true }, { 'D_4',    true }
    },
    evaluate = function(parts, hand)
        if #parts._2 >= 3 then
            local ret = {}
            for i = 1, 3 do
                for _, card in ipairs(parts._2[i]) do
                    table.insert(ret, card)
                end
            end
            return { ret }
        end
    end
}
SMODS.PokerHand {key = 'two_sets',
    loc_txt = {
        name = 'Two Sets',
        description = {
            '2 sets of 3 cards with different ranks'
        }
    },
    chips = 100,
    mult = 10,
    l_chips = 30,
    l_mult = 4,
    visible = false,
    example = {
        { 'S_2', true }, { 'D_2', true }, { 'C_2', true },
        { 'H_3', true }, { 'S_3', true }, { 'D_3', true }
    },
    evaluate = function(parts, hand)
        if #parts._3 >= 2 then
            local ret = {}
            for i = 1, 2 do
                for _, card in ipairs(parts._3[i]) do
                    table.insert(ret, card)
                end
            end
            return { ret }
        end
    end
}
SMODS.PokerHand {key = 'flush_three',
    loc_txt = {
        name = 'Flush Three',
        description = { '3 cards with the same rank and suit. They may',
                        'be played with 2 other unscored cards'
    }
    },
    chips = 80,
    mult = 8,
    l_chips = 25,
    l_mult = 3,
    visible = false,
    example = { { 'H_K', true }, { 'H_K', true }, { 'H_K', true }, { 'S_4', false }, { 'C_7', false } },
    evaluate = function(parts, hand)
        if #parts._3 > 0 then
            for _, three in ipairs(parts._3) do
                local suit = three[1].base.suit
                if three[2].base.suit == suit and three[3].base.suit == suit then 
                    return { three } 
                end
            end
        end
    end
}
SMODS.PokerHand {key = 'flush_four',
    loc_txt = {
        name = 'Flush Four',
        description = { '4 cards with the same rank and suit. They may',
                        'be played with 1 other unscored card'
    }
    },
    chips = 120,
    mult = 12,
    l_chips = 40,
    l_mult = 4,
    visible = false,
    example = { { 'S_A', true },
    { 'S_A', true },
    { 'S_A', true },
    { 'S_A', true },
    { 'D_3', false } },
    evaluate = function(parts, hand)
        if #parts._4 > 0 then
            for _, four in ipairs(parts._4) do
                local suit = four[1].base.suit
                local is_flush = true
                for i = 2, 4 do
                    if four[i].base.suit ~= suit then is_flush = false break end
                end
                if is_flush then return { four } end
            end
        end
    end
}
SMODS.PokerHand {key = 'wild_forest',
    loc_txt = { name = 'Wild Forest', description = { "5 cards with wild card enhancement" } },
    chips = 100,
    mult = 10,
    l_chips = 30,
    l_mult = 3,
    visible = false, priority = 10,
    example = {
        { 'S_2', true, enhancement = "m_wild" },
        { 'D_T', true, enhancement = "m_wild" },
        { 'H_J', true, enhancement = "m_wild" },
        { 'C_5', true, enhancement = "m_wild" },
        { 'S_A', true, enhancement = "m_wild" },
    },
    evaluate = function(parts, hand)
        local wild_cards = {}
        for i = 1, #hand do
            if hand[i].config.center == G.P_CENTERS.m_wild then
                table.insert(wild_cards, hand[i])
            end
        end
        if #wild_cards >= 5 then return {wild_cards} end
    end
}
SMODS.PokerHand {key = 'flush_two_pair',
    loc_txt = { name = 'Flush Two Pair', description = { "Two Pairs where all", "cards share the same suit" } },
    chips = 60,
    mult = 6,
    l_chips = 20,
    l_mult = 2,
    visible = false, priority = 8,
    example = {
        { 'S_3', true },
        { 'S_3', true },
        { 'S_5', true },
        { 'S_5', true },
        { 'D_7', false }
    },
    evaluate = function(parts, hand)
        if parts._2 and #parts._2 >= 2 then
            local scoring_cards = {}
            for i = 1, 2 do
                for _, card in ipairs(parts._2[i]) do
                    table.insert(scoring_cards, card)
                end
            end
            
            local suit = scoring_cards[1].base.suit
            local all_match = true
            for i = 2, #scoring_cards do
                if not scoring_cards[i]:is_suit(suit) then
                    all_match = false
                    break
                end
            end
            if all_match then return {scoring_cards} end
        end
    end
}
SMODS.PokerHand {key = '1234',
    loc_txt = {
        name = '1234',
        description = {
            "One 2 and three 4"
        }
    },
    visible = false,
    chips = 123,
    mult = 4,
    l_chips = 20,
    l_mult = 2,
    example = {
        { 'S_2',    true },
        { 'D_4',    true },
        { 'H_4',    true },
        { 'C_4',    true },
    },
    evaluate = function(parts, hand)
        local twos = {}
        local fours = {}
        for i=1, #hand do
            if hand[i]:get_id() == 2 then 
                table.insert(twos, hand[i])
            elseif hand[i]:get_id() == 4 then 
                table.insert(fours, hand[i])
            end
        end
        if #twos == 1 and #fours == 3 and #hand == 4 then
            local scoring_cards = {}
            for _, c in ipairs(twos) do table.insert(scoring_cards, c) end
            for _, c in ipairs(fours) do table.insert(scoring_cards, c) end
            return { scoring_cards }
        end
    end
}
SMODS.PokerHand {key = 'art_gallery',
    loc_txt = {
        name = 'Art Gallery',
        description = {
            "5 cards with different enhancements"
        }
    },
    visible = false,
    chips = 150,
    mult = 15,
    l_chips = 40,
    l_mult = 4,
    example = {
        { 'S_A',    true, enhancement = 'm_glass' },
        { 'H_T',   true, enhancement = 'm_gold' },
        { 'D_5',    true, enhancement = 'm_steel' },
        { 'C_3',    true, enhancement = 'm_stone' },
        { 'S_7',    true, enhancement = 'm_wild' }
    },
    evaluate = function(parts, hand)
        if #hand ~= 5 then return end
        local enhancements_found = {}
        for i = 1, #hand do
            local center = hand[i].config.center
            if center == G.P_CENTERS.c_base then return end
            if enhancements_found[center.key] then
                return
            else
                enhancements_found[center.key] = true
            end
        end
        return {hand}
    end
}