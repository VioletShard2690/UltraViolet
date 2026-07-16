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
		-- loc_txt = {
        -- name = "Prologue Sleeve",
        -- text = {
        --     "Start the run at {C:attention}Ante 0{}"
        --     }
        -- },
		-- config = {},
		-- unlocked = true,
        -- discovered = true,
        -- atlas = 'placeholder_sleeve',
        -- pos = {x=0,y=0},
		-- apply = function(self)
        --     G.E_MANAGER:add_event(Event({
        --     func = function()
        --         ease_ante(-1)
        --         return true
        --     end
        --     }))
		-- end
	-- }
end