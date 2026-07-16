SMODS.Blind{key = 'weed',
    loc_txt = {
        name = "The Weed",
        text = { 
            "All numbered cards",
            "are debuffed"
    }
    },
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    atlas = 'weed',
    unlocked = true,
    discovered = true,
    boss_colour = HEX('ff4a4a'),
    recalc_debuff = function(self, card, from_blind)
    local id = card:get_id()
    if id and not (id > 10 or id == 14) then
        return true
    end
    end
}
SMODS.Blind{key = "skeptic",
    loc_txt = {
        name = "Skeptic",
        text = {
            "Must play 1 card"
        }
    },
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = HEX('6B7280'),
    atlas = 'skeptic',
    unlocked = true,
    discovered = true,
    debuff_hand = function(self, cards, hand, handname, check)
        return #cards ~= 1
    end,
    get_loc_debuff_text = function(self)
        return "Must play 1 card"
    end
}
SMODS.Blind{key = "roulette", 
    loc_txt = {
        name = "The Roulette",
        text = {
            "#1# in #2# chance for each card",
            "to be debuffed"
        }
    },
    dollars = 5,
    mult = 2,
    vars = {1, 4},
    boss = {min = 1},
    boss_colour = HEX('cf7b1b'),
    atlas = 'roulette',
    unlocked = true,
    discovered = true,
    loc_vars = function(self)
        local current_prob = (G.GAME and G.GAME.probabilities.normal) or 1
        return { vars = { current_prob, 4 } }
    end,
    debuff_card = function(self, card, from_blind)
        if not card.base or not card.base.suit then 
            return false 
        end
        if card.ability.roulette_debuffed == nil then
            if pseudorandom('roulette') < (G.GAME.probabilities.normal / 4) then
                card.ability.roulette_debuffed = true
            else
                card.ability.roulette_debuffed = false
            end
        end
        return card.ability.roulette_debuffed
    end,
    disable = function(self)
        for _, v in ipairs(G.playing_cards) do
            if v.ability then
                v.ability.roulette_debuffed = nil
            end
        end
    end
}
SMODS.Blind{key = "pass",
    loc_txt = {
        name = "The Pass",
        text = {
            "All numbered cards",
            "are drawn face down"
        }
    },
    dollars = 5,
    mult = 2,
    boss = {min = 1},
    boss_colour = HEX('3ec5e6'),
    atlas = 'pass',
    unlocked = true,
    discovered = true,
    is_numbered_card = function(self, card)
        if not card.base or not card.base.value then return false end
        local val = card.base.value
        if val == '2' or val == '3' or val == '4' or val == '5' or val == '6' or val == '7' or val == '8' or val == '9' or val == '10' then
            return true
        end
        return false
    end,
    stay_flipped = function(self, area, card)
        if area == G.hand and self:is_numbered_card(card) then
            return true
        end
    end,
    set_blind = function(self)
        for _, v in ipairs(G.hand.cards) do
            if self:is_numbered_card(v) then
                v:flip()
            end
        end
    end
}
SMODS.Blind{key = 'trademark',
    pos = {x = 0, y = 0},
    atlas = 'trademark',
    boss_colour = HEX('cfa36d'),
    mult = 2,
    dollars = 5,
    unlocked = true,
    discovered = true,
    vars = {},
    boss = {min = 1},
    loc_txt = {
        name = "The Trademark",
        text = {
            "All cards with",
            "Seals are debuffed"
        }
    },
    debuff_card = function(self, card, from_blind)
        if card.seal then
            return true
        end
    end
}
SMODS.Blind {key = 'eraser',
    pos = {x = 0, y = 0},
    atlas = 'eraser', 
    boss_colour = HEX('e649e3'),
    mult = 2,
    unlocked = true,
    discovered = true,
    vars = {},
    boss = {min = 1},
    dollars = 5,
    loc_txt = {
        name = "The Eraser",
        text = {
            "All Enhanced cards",
            "are debuffed"
        }
    },
    debuff_card = function(self, card, from_blind)
        if card.ability.set == 'Default' or card.ability.set == 'Enhanced' then
            if card.config.center ~= G.P_CENTERS.c_base then
                return true
            end
        end
    end
}
SMODS.Blind{key = 'planetarium',
    pos = {x = 0, y = 0},
    atlas = 'planetarium',
    boss_colour = HEX('1E1E1E'),
    mult = 2,
    unlocked = true,
    discovered = true,
    boss = {min = 1},
    dollars = 5,
    vars = {},
    loc_txt = {
        name = "The Planetarium",
        text = {
            "All cards with",
            "Seals are drawn face down"
        }
    },
    stay_flipped = function(self, area, card)
        if area == G.hand and card.seal then
            return true
        end
    end
}
SMODS.Blind{key = 'mask',
    pos = {x = 0, y = 0},
    atlas = 'mask',
    unlocked = true,
    discovered = true,
    boss_colour = HEX('4A90E2'),
    mult = 2,
    vars = {},
    boss = {min = 1},
    dollars = 5,
    loc_txt = {
        name = "The Mask",
        text = {
            "All Enhanced cards",
            "are drawn face down"
        }
    },
    stay_flipped = function(self, area, card)
        if area == G.hand and card.config.center ~= G.P_CENTERS.c_base then
            return true
        end
    end
}
SMODS.Blind{key = 'overkill',
    pos = {x = 0, y = 0},
    atlas = 'overkill',
    unlocked = true,
    discovered = true,
    boss_colour = HEX('8f1818'),
    mult = 2,
    boss = {min = 1},
    dollars = 5,
    vars = {},
    loc_txt = {
        name = "The Overkill",
        text = {
            "If defeated in 1",
            "hand you lose"
        }
    },
    set_blind = function(self, blind)
        if next(SMODS.find_card('j_uv_doomsday')) then
            check_for_unlock({ type = "dead_end" })
        end
    end,
    defeat = function(self)
        if G.GAME.current_round.hands_played == 1 then
            attention_text({
                text = "Overkill!",
                scale = 1.2,
                hold = 2,
                colour = G.C.RED,
                backdrop_colour = G.C.CLEAR,
                align = 'cm',
                offset = {x = 0, y = -1},
                major = G.play
            })
            G.STATE = G.STATES.GAME_OVER
            G.STATE_COMPLETE = false
        end
    end
}
SMODS.Blind{key = 'bigger',
    atlas = 'bigger',
    boss_colour = HEX('8d7c72'),
    mult = 2,
    boss = {min = 1},
    unlocked = true,
    discovered = true,
    vars = {},
    dollars = 5,
    loc_txt = {
        name = "Bigger blind",
        text = {
            ""
        }
    },
}
SMODS.Blind{key = 'anchor',
    loc_txt = {
        name = 'The Anchor',
        text = {
            "When defeated, a random",
            "Joker becomes eternal"
        }
    },
    boss = {min = 1},
    vars = {},
    mult = 2,
    unlocked = true,
    discovered = true,
    dollars = 5,
    atlas = 'anchor',
    boss_colour = HEX('9e9b9b'),
    defeat = function(self)
        local eligible_jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.eternal then
                table.insert(eligible_jokers, G.jokers.cards[i])
            end
        end
        if #eligible_jokers > 0 then
            local target_joker = pseudorandom_element(eligible_jokers, pseudoseed('anchor'))
            target_joker:set_eternal(true)
            target_joker:juice_up()
        end
    end
}
SMODS.Blind{key = 'fossil',
    loc_txt = {
        name = 'The Fossil',
        text = {
            "When defeated, a random",
            "Joker becomes rental"
        }
    },
    boss = {min = 1},
    vars = {},
    mult = 2,
    unlocked = true,
    discovered = true,
    dollars = 5,
    atlas = 'fossil',
    boss_colour = HEX('9e9b9b'),
    defeat = function(self)
        local eligible_jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.rental then
                table.insert(eligible_jokers, G.jokers.cards[i])
            end
        end
        if #eligible_jokers > 0 then
            local target_joker = pseudorandom_element(eligible_jokers, pseudoseed('fossil'))
            target_joker:set_rental(true)
            target_joker:juice_up()
        end
    end
}
SMODS.Blind{key = 'decay',
    loc_txt = {
        name = 'The Decay',
        text = {
            "When defeated, a random",
            "Joker becomes perishable"
        }
    },
    boss = {min = 1},
    vars = {},
    mult = 2,
    unlocked = true,
    discovered = true,
    dollars = 5,
    atlas = 'decay',
    boss_colour = HEX('568f8f'),
    defeat = function(self)
        local eligible_jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.perishable then
                table.insert(eligible_jokers, G.jokers.cards[i])
            end
        end
        if #eligible_jokers > 0 then
            local target_joker = pseudorandom_element(eligible_jokers, pseudoseed('decay'))
            target_joker:set_perishable(true)
            target_joker:juice_up()
        end
    end
}
SMODS.Blind{key = 'void',
    loc_txt = { name = 'The Void', text = { "Suffer." } }, -- game crashes if you have chicot, but this is fine
    dollars = 0,
    mult = 4,
    boss = {min = 100},
    boss_colour = HEX('000000'),
    atlas = 'void',
    stay_flipped = function(self, area, card)
        if next(SMODS.find_card('j_uv_DR34MC0R3')) then return end
        if area == G.hand then return true end
    end,
    set_blind = function(self)
        -- if next(SMODS.find_card('j_chicot')) then idk kill.chicot end
        if next(SMODS.find_card('j_uv_DR34MC0R3')) then return end
        for _, v in ipairs(G.hand.cards) do v:flip() end
        if G.jokers then
            for _, j in ipairs(G.jokers.cards) do j:set_debuff(true) end
        end
        self.hands_sub = G.GAME.round_resets.hands - 1
        ease_hands_played(-self.hands_sub)
        self.discards_sub = G.GAME.current_round.discards_left
        ease_discard(-self.discards_sub)
    end,
    disable = function(self)
        if self.hands_sub then ease_hands_played(self.hands_sub) end
        if self.discards_sub then ease_discard(self.discards_sub) end
        if next(SMODS.find_card('j_uv_DR34MC0R3')) then
            G.GAME.blind.disabled = true
            return true
        else 
            G.GAME.blind.disabled = false 
            return false
        end
    end,
    calculate = function(self, card, context)
        if next(SMODS.find_card('j_uv_DR34MC0R3')) then return end
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].debuff then G.jokers.cards[i]:set_debuff(true) end
            end
        end
    end,
    defeat = function(self, blind)
        check_for_unlock({ type = "htf" })
    end,
    debuff_hand = function(self, cards, hand, handname, check)
        local card_count = 0
        for _, card in ipairs(cards) do
            card_count = card_count + 1
        end
        if card_count ~= 1 then
            return true
        end
        return false
    end,
    get_loc_debuff_text = function(self)
        return "you can play only 1 card"
    end
}
SMODS.Blind{key = 'microscope',
    loc_txt = {
        name = 'The Microscope',
        text = {
            "Sets the game window",
            "size to 100x75"
        }
    },
    boss = {min = 1},
    boss_colour = HEX('72c4c0'),
    dollars = 5,
    mult = 2,
    unlocked = true,
    discovered = true,
    atlas = 'microscope',
    set_blind = function(self, blind)
        if not G.microscope_original_settings then
            G.microscope_original_settings = {
                screenmode = G.SETTINGS.WINDOW.screenmode,
                w = G.SETTINGS.screen_res and G.SETTINGS.screen_res.w or love.graphics.getWidth(),
                h = G.SETTINGS.screen_res and G.SETTINGS.screen_res.h or love.graphics.getHeight()
            }
        end
        self:enforce_microscope_size()
    end,
    update = function(self, dt)
        if G.SETTINGS.paused then return end
        local w, h, flags = love.window.getMode()
        if w ~= 100 or h ~= 75 or not flags.borderless or flags.resizable then
            self:enforce_microscope_size()
        end
    end,
    enforce_microscope_size = function(self)
        local old_getMin = love.window.getMin
        love.window.getMin = function()
            return 10, 10
        end
        local old_updateMode = love.window.updateMode
        love.window.updateMode = function(w, h, settings)
            settings.resizable = false
            settings.borderless = true
            settings.minwidth = 10
            settings.minheight = 10
            return old_updateMode(100, 75, settings)
        end
        G.SETTINGS.QUEUED_CHANGE = {
            screenmode = 'Windowed',
            screenres = { w = 100, h = 75 }
        }
        G.SETTINGS.WINDOW.screenmode = 'Windowed'
        if G.SETTINGS.screen_res then
            G.SETTINGS.screen_res.w = 100
            G.SETTINGS.screen_res.h = 75
        end
        love.window.setMode(100, 75, {resizable = false, borderless = true, minwidth = 10, minheight = 10})
        G.FUNCS.apply_window_changes()
        love.window.updateMode = old_updateMode
        love.window.getMin = old_getMin
    end,
    defeat = function(self, blind)
        if next(SMODS.find_card('j_uv_smart_magnifying_glass')) then
            check_for_unlock({ type = "need_glasses" })
        end
        if G.microscope_original_settings then
            local orig = G.microscope_original_settings
            G.SETTINGS.QUEUED_CHANGE = {
                screenmode = orig.screenmode,
                screenres = { w = orig.w, h = orig.h }
            }
            G.SETTINGS.WINDOW.screenmode = orig.screenmode
            if G.SETTINGS.screen_res then
                G.SETTINGS.screen_res.w = orig.w
                G.SETTINGS.screen_res.h = orig.h
            end
            local old_updateMode = love.window.updateMode
            love.window.updateMode = function(w, h, settings)
                settings.borderless = false
                settings.resizable = true
                return old_updateMode(w, h, settings)
            end
            G.FUNCS.apply_window_changes()
            love.window.updateMode = old_updateMode
            G.microscope_original_settings = nil
        end
        local dw, dh = love.window.getDesktopDimensions()
        local ww, wh = love.window.getMode()
        love.window.setPosition(math.floor((dw - ww) / 2), math.floor((dh - wh) / 2))
    end,
    disable = function(self, blind)
        if G.microscope_original_settings then
            local orig = G.microscope_original_settings
            G.SETTINGS.QUEUED_CHANGE = {
                screenmode = orig.screenmode,
                screenres = { w = orig.w, h = orig.h }
            }
            G.SETTINGS.WINDOW.screenmode = orig.screenmode
            if G.SETTINGS.screen_res then
                G.SETTINGS.screen_res.w = orig.w
                G.SETTINGS.screen_res.h = orig.h
            end
            local old_updateMode = love.window.updateMode
            love.window.updateMode = function(w, h, settings)
                settings.borderless = false
                settings.resizable = true
                return old_updateMode(w, h, settings)
            end
            G.FUNCS.apply_window_changes()
            love.window.updateMode = old_updateMode
            G.microscope_original_settings = nil
        end
        local dw, dh = love.window.getDesktopDimensions()
        local ww, wh = love.window.getMode()
        love.window.setPosition(math.floor((dw - ww) / 2), math.floor((dh - wh) / 2))
    end
}
SMODS.Blind{key = 'evil_greg',
    loc_txt = {
        name = 'Evil Greg',
        text = {
            "you can play",
            "only Greg cards"
        }
    },
    boss = {min = 1},
    boss_colour = HEX('969696'),
    dollars = 5,
    mult = 2,
    unlocked = true,
    discovered = true,
    atlas = 'evil_greg',
    debuff_hand = function(self, cards, hand, handname, check)
        for _, card in ipairs(cards) do
            if not (card.config.center and card.config.center.key == 'm_uv_greg') then
                return true
            end
        end
        return false
    end,
    get_loc_debuff_text = function(self)
        return "you can play only Greg cards"
    end
}