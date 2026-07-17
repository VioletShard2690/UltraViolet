if CardSleeves then
    CardSleeves.Sleeve{key = "russian_sleeve",
		loc_txt = {
        name = "Russian Sleeve",
        text = {
                    "Start run with",
                    "no {C:attention}2s, 3s, 4s, and 5s",
                    "in your deck"
            }
        },
		config = {},
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve', -- why does this required? ;_;
        pos = {x=0,y=0},
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
    CardSleeves.Sleeve{key = "gamble_sleeve",
		loc_txt = {
        name = "Gamble Sleeve",
        text = {
            "Start with {C:attention}Lucky Block{}",
            "and {C:tarot}The Wheel of Fortune{}",
            }
        },
		config = {},
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
		apply = function(self)
            G.E_MANAGER:add_event(Event({
            func = function()
                local lucky_block = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_uv_lucky_block', 'gamble')
                lucky_block:add_to_deck()
                G.jokers:emplace(lucky_block)
                local wheel = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'gamble')
                wheel:add_to_deck()
                G.consumeables:emplace(wheel)
                return true
            end
            }))
		end
	}
    CardSleeves.Sleeve{key = "prologue_sleeve",
		loc_txt = {
        name = "Prologue Sleeve",
        text = {
            "Start the run at {C:attention}Ante 0{}"
            }
        },
		config = {},
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
		apply = function(self)
            G.E_MANAGER:add_event(Event({
            func = function()
                ease_ante(-1)
                return true
            end
            }))
		end
	}
    CardSleeves.Sleeve{key = "gray_sleeve",
		loc_txt = {
        name = "Gray Sleeve",
        text = {
            "{C:attention}+1{} consumable slot",
            "{C:red}-1{} discard",
            "every round"
            }
        },
		config = { discards = -1, consumable_slot = 1 },
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0}
	}
    CardSleeves.Sleeve{key = 'orange_sleeve',
        loc_txt = {
            name = 'Orange Sleeve',
            text = {
                "{C:attention}+1{} hand size",
                "every round"
            }
        },
		config = { hand_size = 1 },
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0}
	}
    CardSleeves.Sleeve{key = "joker_sleeve",
		loc_txt = {
        name = "Joker Sleeve",
        text = {
            "{X:mult,C:white}x4{} Mult",
            "{C:red}-1{} Joker slot"
            }
        },
		config = { joker_slot = -1, x_mult = 4 },
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
		calculate = function(self, card, context)
            if context.main_scoring then
                return {
                    Xmult = self.config.x_mult,
                    update = true
                }
            end
        end
	}
    CardSleeves.Sleeve{key = "deck_sleeve",
		loc_txt = {
        name = "Deck Sleeve",
        text = {
            "Start run with",
            "{C:attention}2{} random {C:green}Deck Cards{}"
            }
        },
		config = {},
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
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
                            chosen_key = pseudorandom_element(valid_pool, pseudoseed('uv_deck_deck'))
                        else
                            local backup_pool = {}
                            for k, v in pairs(G.P_CENTERS) do
                                if v.set == 'Tarot' then
                                    table.insert(backup_pool, k)
                                end
                            end
                            chosen_key = pseudorandom_element(backup_pool, pseudoseed('uv_deck_deck_backup'))
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
    CardSleeves.Sleeve{key = "purple_sleeve",
		loc_txt = {
        name = "Purple Sleeve",
        text = {
            "{C:enhanced}+1{} card selection limit",
            "every round"
            }
        },
		config = {},
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
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
    CardSleeves.Sleeve{key = "light_blue_sleeve",
		loc_txt = {
        name = "Light Blue Sleeve",
        text = {
            "{C:attention}+1{} consumable slot",
            "every round"
            }
        },
		config = { consumable_slot = 1 },
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
		apply = function(self)
            G.E_MANAGER:add_event(Event({
            func = function()
                return true
            end
            }))
		end
	}
    CardSleeves.Sleeve{key = "rainbow_sleeve",
		loc_txt = {
        name = "Rainbow Sleeve",
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
		config = {},
		unlocked = true,
        discovered = true,
        atlas = 'placeholder_sleeve',
        pos = {x=0,y=0},
		apply = function(self)
            G.E_MANAGER:add_event(Event({
            func = function()
                ease_discard(1)
                ease_hands_played(1)
                ease_ante(1)
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                ease_joker_slots(1)
                ease_round(1)
                change_shop_size(1)
                ease_dollars(1)
                SMODS.change_voucher_limit(1)
                SMODS.change_booster_limit(1)
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
                G.hand:change_size(1)
                G.GAME.win_ante = G.GAME.win_ante + 1
                if G.GAME.rainbow_deck_applied then
                    G.GAME.modifiers.money_per_hand = 3
                    G.GAME.modifiers.money_per_discard = 2
                else
                    G.GAME.modifiers.money_per_hand = 2
                    G.GAME.modifiers.money_per_discard = 1
                end
                G.GAME.interest_amount = G.GAME.interest_amount + 1
                G.GAME.probabilities.normal = G.GAME.probabilities.normal + 1
                ease_reroll_cost(1)
                G.GAME.inflation = G.GAME.inflation + 1
                G.GAME.round_resets.blind_choices.Big = get_new_boss()
                if G.FUNCS and G.FUNCS.set_blind_select and G.STATE == G.STATES.BLIND_SELECT then 
                    G.FUNCS.set_blind_select()
                end
                for k, v in pairs(G.GAME.hands) do
                    level_up_hand(nil, k, true, 1)
                end
                if not G.GAME.rainbow_sleeve_applied then G.GAME.rainbow_sleeve_applied = true end
                return true
            end
            }))
		end
	}
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
    -- CardSleeves.Sleeve{key = "prologue_sleeve",
	-- 	loc_txt = {
    --     name = "Prologue Sleeve",
    --     text = {
    --         "Start the run at {C:attention}Ante 0{}"
    --         }
    --     },
	-- 	config = {},
	-- 	unlocked = true,
    --     discovered = true,
    --     atlas = 'placeholder_sleeve',
    --     pos = {x=0,y=0},
	-- 	apply = function(self)
    --         G.E_MANAGER:add_event(Event({
    --         func = function()
    --             ease_ante(-1)
    --             return true
    --         end
    --         }))
	-- 	end
	-- }
end