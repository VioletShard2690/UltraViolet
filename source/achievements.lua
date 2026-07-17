SMODS.Achievement{key = "other_way",
    loc_txt = {
        name = "The Other Way!",
        description = {
            "Sell Oops! I forgot the cube while",
         "you have Oops! I found the missing cube"
        }
    },
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
      if args.type == "other_way" then return true end
    end
}
SMODS.Achievement{key = "big_boi",
    loc_txt = {
        name = "Big Boi",
        description = {
            "Obtain Small Joker"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
      if args.type == "big_boi" then return true end
    end
}
SMODS.Achievement{key = "what_cost",
    loc_txt = {
        name = "At What Cost?",
        description = {
            "Get Shredder to X1000 Mult"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
      if args.type == "what_cost" then return true end
    end
}
SMODS.Achievement{key = "beyond_limit",
    loc_txt = {
        name = "Beyond The Limit",
        description = {
            "Have more jokers than joker slots"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if G.jokers and G.jokers.cards then
            if #G.jokers.cards > G.jokers.config.card_limit then return true end
        end
    end
}
SMODS.Achievement{key = "n1_greg_fan",
    loc_txt = {
        name = "#1 Greg Fan",
        description = {
            "Turn every card in your",
            "deck into Gregs"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if G.playing_cards and #G.playing_cards > 0 then
            local greg_count = 0
            for k, v in pairs(G.playing_cards) do 
                if v.config and v.config.center and v.config.center.key == 'm_uv_greg' then
                    greg_count = greg_count + 1
                end
            end
            if greg_count == #G.playing_cards then 
                return true 
            end
        end
    end
}
SMODS.Achievement{key = "homosexsual",
    loc_txt = {
        name = "Homosexsual",
        description = {
            "Win a run at rainbow deck",
            "without playing any",
            "straights and straight flushes"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'win' and G.GAME.hands['Straight'].played == 0 
        and G.GAME.hands['Straight Flush'].played == 0 and G.GAME.selected_back
        and G.GAME.selected_back.effect.center.key == 'b_uv_rainbow_deck' then return true end
    end
}
SMODS.Achievement{key = "homophobic",
    loc_txt = {
        name = "Homophobic",
        description = {
            "Win a run at rainbow deck",
            "by only playing straights",
            "and straight flushes"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'win'
        and G.GAME.selected_back 
        and G.GAME.selected_back.effect.center.key == 'b_uv_rainbow_deck' then
            for handname, hand in pairs(G.GAME.hands) do
                if handname ~= 'Straight' and handname ~= 'Straight Flush' then
                    if hand.played > 0 then return false end
                end
            end
            return true
        end
    end
}
SMODS.Achievement{key = "all_naneinf",
    loc_txt = {
        name = "Oops! All naneinf",
        description = {
            "Hit naneinf value on",
            "all listed probabilities"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if G.GAME and G.GAME.probabilities
        and G.GAME.probabilities.normal
        and G.GAME.probabilities.normal >= 1.8e308
        then return true end
    end
}
SMODS.Achievement{key = "no_u_dont",
    loc_txt = {
        name = "No you don't",
        description = {
            "Win a run with CHIMPS deck",
            "on a golden stake"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'win_stake'
        and G.GAME.selected_back 
        and G.GAME.selected_back.effect.center.key == 'b_uv_chimps_deck'
        and G.GAME.stake >= 8
        then return true end
    end
}
SMODS.Achievement{key = "genius",
    loc_txt = {
        name = "Genius",
        description = {
            "Reach level 50 or higher",
            "on teacher joker"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if G.GAME
        and G.GAME.teacher_level
        and G.GAME.teacher_level >= 50
        then return true end
    end
}
SMODS.Achievement{key = "actual_nothing",
    loc_txt = {
        name = "Actual nothing!",
        description = {
            "Not trigger socks in butterfly",
            "with leaf out lighter",
            "chance 328 times in a row"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'actual_nothing' then return true end
    end
}
SMODS.Achievement{key = "spacebar_warrior",
    loc_txt = {
        name = "Spacebar Warrior",
        description = {
            "reach 1000 or more chips",
            "on bouncy ball"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'spacebar_warrior' then return true end
    end
}
SMODS.Achievement{key = "superfactorial",
    loc_txt = {
        name = "Superfactorial",
        description = {
            "play a hand with 50",
            "or more cards while",
            "having Pascal"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'superfactorial' then return true end
    end
}
SMODS.Achievement{key = "time_machine",
    loc_txt = {
        name = "Time Machine",
        description = {
            "have Pascal and Socrates",
            "at the exact same time"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if next(SMODS.find_card('j_uv_socrates')) and next(SMODS.find_card('j_uv_pascal')) then return true end
    end
}
SMODS.Achievement{key = "divide_0",
    loc_txt = {
        name = "Dividing by 0",
        description = {
            "Hit -naneinf value on",
            "all listed probabilities"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if G.GAME and G.GAME.probabilities
        and G.GAME.probabilities.normal
        and G.GAME.probabilities.normal <= -1.8e308
        then return true end
    end
}
SMODS.Achievement{key = "dead_end",
    loc_txt = {
        name = "Dead End",
        description = {
            "Encounter The Overkill blind",
            "while having Doomsday"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'dead_end' then return true end
    end
}
SMODS.Achievement{key = "need_glasses",
    loc_txt = {
        name = "Need Glasses?",
        description = {
            "Defeat The Microscope blind",
            "while having Smart Magnifying Glass"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'need_glasses' then return true end
    end
}
SMODS.Achievement{key = "digital_hoarder",
    loc_txt = {
        name = "Digital Hoarder",
        description = {
            "Get $50 or more from",
            "the Desktop Deck effect"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'digital_hoarder' then return true end
    end
}
SMODS.Achievement{key = "htf",
    loc_txt = {
        name = "HOW THE F-",
        description = {
            "Defeat The Void Blind"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'htf' then return true end
    end
}
SMODS.Achievement{key = "ultimate_balance",
    loc_txt = {
        name = "Ultimate Balance",
        description = {
            "Trigger scales with 10",
            "or more jokers"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'ultimate_balance' then return true end
    end
}
SMODS.Achievement{key = "getting_somewhere",
    loc_txt = {
        name = "Now We Getting Somewhere",
        description = {
            "Obtain Super Rare joker"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'getting_somewhere' then return true end
    end
}
SMODS.Achievement{key = "why",
    loc_txt = {
        name = "Why?",
        description = {
            "Skip Super Rare Bufoon Pack"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'why' then return true end
    end
}
SMODS.Achievement{key = "u_stupid",
    loc_txt = {
        name = "U stoopid",
        description = {
            "What's 9 + 10?"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'u_stupid' then return true end
    end
}
SMODS.Achievement{key = "where_melon",
    loc_txt = {
        name = "Where's my watermelon?",
        description = {
            "Reach 0% chips on",
            "Watermelon Paradox"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if args.type == 'where_melon' then return true end
    end
}
SMODS.Achievement{key = "rainbow_cubed",
    loc_txt = {
        name = "Rainbow^3",
        description = {
            "use Rainbow Deck Card on",
            "Rainbow Deck with",
            "Rainbow Sleeve"
        }
    },
    bypass_all_unlocked = true,
    hidden_name = true,
    unlock_condition = function(self, args)
        if G.GAME and G.GAME.rainbow_sleeve_applied
        and G.GAME.rainbow_deck_applied
        and G.GAME.rainbow_deck_card_used then return true end
    end
}