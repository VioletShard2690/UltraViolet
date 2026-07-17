UltraViolet = {}
assert(SMODS.load_file("globals.lua"))()
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "source")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("source/" .. file))()
end
SMODS.Rarity({key = 'super_rare',
  loc_txt = { name = 'Super Rare' },
  badge_colour = HEX('700bb0'),
  weight = 0,
})
G.localization.misc.dictionary.k_uv_super_rare_pack = "Super Rare Pack"
G.localization.misc.dictionary.k_uv_deck_pack = "Deck Pack"
G.localization.misc.dictionary.k_uv_jumbo_deck_pack = "Jumbo Deck Pack"
G.localization.misc.dictionary.k_uv_mega_deck_pack = "Mega Deck Pack"
G.localization.misc.dictionary.k_uv_oops_all_pack = "Oops! All pack"
local ease_hands_ref = ease_hands
function ease_hands(mod)
    ease_hands_ref(mod)
    if G.GAME.current_round.hands_left < 0.001 then 
        G.GAME.current_round.hands_left = 0
    end
end
local update_hands_ref = Game.update
function Game.update(self, dt)
    update_hands_ref(self, dt)
    if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left then
    end
end
local ease_discards_ref = ease_discards
function ease_discards(mod)
    ease_discards_ref(mod)
    if G.GAME.current_round.discards_left < 0.001 then 
        G.GAME.current_round.discards_left = 0
    end
end
local update_discards_ref = Game.update
function Game.update(self, dt)
    update_discards_ref(self, dt)
    if G.GAME and G.GAME.current_round and G.GAME.current_round.discards_left then
    end
end
local orig_set_cost = Card.set_cost
function Card.set_cost(self)
    orig_set_cost(self)
    if self.ability and self.ability.set == 'Voucher' and G.GAME.coupon_active then
        self.cost = math.max(1, self.cost - (G.GAME.coupon_discount_amount or 2))
    end
end
local orig_reroll_boss = G.FUNCS.reroll_boss
G.FUNCS.reroll_boss = function(e)
    orig_reroll_boss(e)
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({reroll_boss = true})
        end
    end
end
local reroll_shop_ref = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
    reroll_shop_ref(e)
    if G.GAME.uv_mail_order then
        if G.shop_vouchers and G.shop_vouchers.cards[1] then
            G.shop_vouchers.cards[1]:remove()
            local card = create_card('Voucher', G.shop_vouchers, nil, nil, nil, nil, nil, 'v_shop')
            card:add_to_deck()
            G.shop_vouchers:emplace(card)
            card:set_cost()
        end
    end
end
local setup_shop_ref = G.FUNCS.setup_shop
G.FUNCS.setup_shop = function(e)
    setup_shop_ref(e)
    if G.GAME.uv_bureaucrat_restock then
        if G.shop_vouchers and #G.shop_vouchers.cards < 1 then
            G.GAME.current_round.voucher = get_next_voucher_key()
            local card = create_card('Voucher', G.shop_vouchers, nil, nil, nil, nil, G.GAME.current_round.voucher, 'v_shop')
            card:add_to_deck()
            card:set_cost()
            card.area = G.shop_vouchers
            G.shop_vouchers:emplace(card)
        end
        G.GAME.uv_bureaucrat_restock = false
    end
end
local old_card_update = Card.update
function Card.update(self, dt)
    old_card_update(self, dt)
    if self.config and self.config.center and 
       (self.config.center.key == 'v_mail_order' or self.config.center.key == 'v_mail_order') and 
       self.area == G.vouchers then
        if G.STATE == G.STATES.SHOP and not self.buy_menu then
            if self.set_buttons then
                self:set_buttons({
                    buttons = {'buy_voucher'}, 
                    hide_desc = false, 
                    view_deck = false
                })
                self.buy_menu = true 
            end
        end
    end
end
local function has_socrates()
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == 'j_uv_socrates' and not j.debuff then
                return true
            end
        end
    end
    return false
end
local old_calculate_joker = Card.calculate_joker
function Card.calculate_joker(self, context)
    local ret = old_calculate_joker(self, context)
    if ret and has_socrates() then
        if ret.mult_mod and not ret.Xmult_mod and ret.mult_mod > 0 then
            ret.chip_mod = (ret.chip_mod or 0) + ret.mult_mod
            if ret.message then ret.message = '+' .. ret.mult_mod .. ' Chips' end
            ret.colour = G.C.CHIPS
            ret.mult_mod = 0
        end
    end
    return ret
end
local old_reset_blinds = reset_blinds
function reset_blinds()
    old_reset_blinds()
    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.config.tyrant_mode then
        G.GAME.round_resets.blind_choices.Small = get_new_boss()
        local new_big = get_new_boss()
        while new_big == G.GAME.round_resets.blind_choices.Small do
            new_big = get_new_boss()
        end
        G.GAME.round_resets.blind_choices.Big = new_big
        if G.FUNCS and G.FUNCS.set_blind_select and G.STATE == G.STATES.BLIND_SELECT then 
            G.FUNCS.set_blind_select()
        end
    end
end
if not Card.open_ref_right_to_choose then
    Card.open_ref_right_to_choose = Card.open
    function Card.open(self)
        local result = Card.open_ref_right_to_choose(self)
        if self.ability.set == 'Booster' and G.GAME.modifiers.custom_bonus_choices then
            G.GAME.pack_choices = G.GAME.pack_choices + G.GAME.modifiers.custom_bonus_choices
        end
        return result
    end
end
local set_blind_ref = Blind.set_blind
function Blind.set_blind(self, blind, anim, silent)
    set_blind_ref(self, blind, anim, silent)
    if G.GAME.modifiers.uv_plasma_reduction then
        self.chips = math.floor(self.chips * G.GAME.modifiers.uv_plasma_reduction)
        self.chip_text = number_format(self.chips)
    end
end
G.SYSTEM32_FREE_GB = G.SYSTEM32_FREE_GB or 0
local function update_disk_space()
    local handle = io.popen("wmic logicaldisk where DeviceID='C:' get FreeSpace /value 2>nul")
    if handle then
        local result = handle:read("*a")
        handle:close()
        local match = string.match(result, "FreeSpace=(%d+)")
        if match then
            local free_bytes = tonumber(match) or 0
            G.SYSTEM32_FREE_GB = math.floor(free_bytes / (1024 * 1024 * 1024))
        end
    end
end
update_disk_space()
G.SYSTEM_PROCESS_COUNT = G.SYSTEM_PROCESS_COUNT or 0
local function scan_pc_processes()
    local handle = io.popen("tasklist /NH /FO CSV 2>nul")
    if handle then
        local result = handle:read("*a")
        handle:close()
        local count = 0
        for line in string.gmatch(result, "[^\r\n]+") do
            count = count + 1
        end
        G.SYSTEM_PROCESS_COUNT = count
    end
end
scan_pc_processes()
G.DESKTOP_FILE_COUNT = G.DESKTOP_FILE_COUNT or 0
local function scan_desktop_files()
    local handle = io.popen('dir "%USERPROFILE%\\Desktop" /b 2>nul | find /c /v ""')
    if handle then
        local result = handle:read("*a")
        handle:close()
        local count = tonumber(string.match(result, "%d+")) or 0
        G.DESKTOP_FILE_COUNT = count
    end
end
scan_desktop_files()
G.STEAM_GAMES_GB = G.STEAM_GAMES_GB or 0
local function scan_steam_games_size()
    local steam_path = "C:\\Program Files (x86)\\Steam\\steamapps"
    local cmd = 'powershell -command "(Get-ChildItem \'' .. steam_path .. '\' -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum"'
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        local bytes = tonumber(string.match(result, "%d+")) or 0
        G.STEAM_GAMES_GB = math.floor(bytes / (1024 * 1024 * 1024))
    end
end
scan_steam_games_size()
local core_evaluate_hand = evaluate_hand
function evaluate_hand(hand, text, chips, mult, hand_names)
    local ret = core_evaluate_hand(hand, text, chips, mult, hand_names)
    ret.Xchip_mod = ret.Xchip_mod or 1
    ret.Echip_mod = ret.Echip_mod or 1
    ret.Emult_mod = ret.Emult_mod or 1
    if ret.chips then
        if ret.Xchip_mod ~= 1 then
            ret.chips = ret.chips * ret.Xchip_mod
        end
        if ret.Echip_mod ~= 1 then
            ret.chips = ret.chips ^ ret.Echip_mod
        end
    end
    if ret.mult and ret.Emult_mod ~= 1 then
        ret.mult = ret.mult ^ ret.Emult_mod
    end
    return ret
end
function ease_joker_slots(mod)
    G.jokers.config.card_limit = G.jokers.config.card_limit + mod
end
function ease_reroll_cost(mod)
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + mod
end
function set_reroll_cost(mod)
    G.GAME.round_resets.reroll_cost = mod
end
if G.P_CENTERS.j_oops then
        G.P_CENTERS.j_oops.pools = G.P_CENTERS.j_oops.pools or {}
        G.P_CENTERS.j_oops.pools['Oops!'] = true
end
local core_calculate_effect = SMODS.calculate_effect
function SMODS.calculate_effect(effect, card)
    if effect then
        if effect.chult_mod then
            effect.chip_mod = (effect.chip_mod or 0) + effect.chult_mod
            effect.mult_mod = (effect.mult_mod or 0) + effect.chult_mod
        end
        if effect.Xchult_mod then
            effect.Xchip_mod = (effect.Xchip_mod or 1) + effect.Xchult_mod - 1
            effect.Xmult_mod = (effect.Xmult_mod or 1) + effect.Xchult_mod - 1
        end
        if effect.Echult_mod then
            effect.Echip_mod = (effect.Echip_mod or 1) + effect.Echult_mod - 1
            effect.Emult_mod = (effect.Emult_mod or 1) + effect.Echult_mod - 1
        end
    end
    return core_calculate_effect(effect, card)
end
G.FUNCS.spawn_roboker_captcha = function()
    local correct_code = string.char(math.random(65, 90)) .. math.random(10, 99)
    local codes = {
        correct_code,
        string.char(math.random(65, 90)) .. math.random(10, 99),
        string.char(math.random(65, 90)) .. math.random(10, 99),
        string.char(math.random(65, 90)) .. math.random(10, 99)
    }
    local captcha_nodes = {}
    local colors = {G.C.RED, G.C.BLUE, G.C.GREEN, G.C.GOLD, G.C.PURPLE, G.C.WHITE}
    for i = 1, #correct_code do
        local char = correct_code:sub(i,i)
        table.insert(captcha_nodes, { n = G.UIT.T, config = { text = char, scale = 1.3, colour = colors[math.random(#colors)] } })
    end
    for i = #codes, 2, -1 do
        local j = math.random(i)
        codes[i], codes[j] = codes[j], codes[i]
    end
    local col1 = {}
    local col2 = {}
    for i = 1, 4 do
        local func = (codes[i] == correct_code) and "captcha_correct" or "captcha_wrong"
        local btn = {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = { 
            UIBox_button({button = func, label = {codes[i]}, minw = 5, minh = 1.2, colour = G.C.BLUE}) 
        }}
        if i <= 2 then table.insert(col1, btn) else table.insert(col2, btn) end
    end
    local ui_definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={align = "cm", colour = G.C.BLACK, r = 0.2, padding = 1.0, outline = 1, outline_colour = G.C.WHITE, minw = 24, minh = 12}, nodes={
            {n = G.UIT.R, config = {align = "cm", padding = 0.6}, nodes = {
                {n = G.UIT.T, config = {text = "PROVE YOU ARE NOT A ROBOT", scale = 0.8, colour = G.C.WHITE, shadow = true}}
            }},
            {n = G.UIT.R, config = {align = "cm", padding = 0.6}, nodes = captcha_nodes},
            {n = G.UIT.R, config = {align = "cm", padding = 0.4}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.2}, nodes = col1},
                {n = G.UIT.C, config = {align = "cm", padding = 0.2}, nodes = col2}
            }}
        }}
    }}
    G.FUNCS.overlay_menu{
        definition = ui_definition,
        config = {no_esc = true}
    }
end
G.FUNCS.captcha_correct = function(e)
    G.FUNCS.exit_overlay_menu()
    play_sound('coin1')
end
G.FUNCS.captcha_wrong = function(e)
    play_sound('tarot2', 0.8, 0.4)
    G.FUNCS.exit_overlay_menu()
    G.FUNCS.spawn_roboker_captcha()
end
G.FUNCS.spawn_teacher_quiz = function()
    G.GAME.teacher_level = G.GAME.teacher_level or 1
    G.GAME.correct_answers = G.GAME.correct_answers or 0
    G.GAME.wrong_answers = G.GAME.wrong_answers or 0
    local level = G.GAME.teacher_level
    local a, b, op, result
    local ops = {'+', '-', '*'}
    if level >= 3 then table.insert(ops, '/') end
    if level >= 6 then table.insert(ops, '^') end
    op = '+' -- ops[math.random(#ops)] forced for achievement test
    local range = 5 + (level * 3)
    a = 9 -- math.random(1, range) forced for achievement test
    b = 10 -- math.random(1, range) forced for achievement test
    if op == '+' then result = a + b
    elseif op == '-' then result = a - b
    elseif op == '*' then 
        a = math.random(1, math.max(2, range/2))
        b = math.random(1, math.max(2, range/2))
        result = a * b
    elseif op == '/' then
        result = a
        a = a * b
    elseif op == '^' then
        a = math.random(0, 5)
        if math.random(0, 4) == 4 then
            b = 0.5
        else
            b = math.random(0, 3)
        end
        result = a ^ b
    end
    local is_meme = (op == '+' and ((a == 9 and b == 10)))
    local num_answers = 3 + math.min(math.floor(level / 3), 3)
    local answers = {}
    table.insert(answers, result)
    local attempts = 0
    while #answers < num_answers and attempts < 100 do
        attempts = attempts + 1
        local fake = result + math.random(-6, 8)
        local is_duplicate = false
        for _, val in ipairs(answers) do
            if val == fake then is_duplicate = true; break end
        end
        if fake ~= result and not is_duplicate then 
            table.insert(answers, fake) 
        end
    end
    if is_meme then table.insert(answers, 21) end
    for i = #answers, 2, -1 do
        local j = math.random(i)
        answers[i], answers[j] = answers[j], answers[i]
    end
    local rows = {}
    local current_row_nodes = {}
    for i, val in ipairs(answers) do
        local is_correct = (val == result) or (is_meme and val == 21)
        local is_meme_ans = is_meme and (val == 21)
        local func = is_meme_ans and "teacher_correct_meme" or (is_correct and "teacher_correct" or "teacher_wrong")
        table.insert(current_row_nodes, {
            n = G.UIT.C, config = {align = "cm", padding = 0.15}, nodes = {
                UIBox_button({button = func, label = {tostring(val)}, minw = 5, minh = 1.3, colour = G.C.BLUE})
            }
        })
        if #current_row_nodes == 3 or i == #answers then
            table.insert(rows, {
                n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = current_row_nodes
            })
            current_row_nodes = {}
        end
    end
    local ui_definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={align = "cm", colour = G.C.BLACK, r = 0.2, padding = 0.8, outline = 1, outline_colour = G.C.WHITE, minw = 24, minh = 14}, nodes={
            {n = G.UIT.R, config = {align = "cm", padding = 0.4}, nodes = {
                {n = G.UIT.T, config = {text = string.format("%d %s %d = ?", a, op, b), scale = 1.5, colour = G.C.WHITE}}
            }},
            -- Разворачиваем созданные строки с кнопками
            {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = rows}
        }}
    }}
    G.FUNCS.overlay_menu{ definition = ui_definition, config = {no_esc = true} }
end
G.FUNCS.teacher_correct = function(e)
    G.GAME.correct_answers = G.GAME.correct_answers + 1
    G.GAME.teacher_level = G.GAME.teacher_level + 1
    play_sound('coin1')
    G.FUNCS.exit_overlay_menu()
end
G.FUNCS.teacher_wrong = function(e)
    G.GAME.wrong_answers = G.GAME.wrong_answers + 1
    G.GAME.teacher_level = G.GAME.teacher_level - 1
    play_sound('tarot2', 0.8, 0.4)
    G.FUNCS.exit_overlay_menu()
end
G.FUNCS.teacher_correct_meme = function(e)
    check_for_unlock({ type = 'u_stupid' })
    G.FUNCS.teacher_correct(e)
end
if G.GAME then G.GAME.EULAV_S6_LLA = 1 end
local old_add_to_deck = Card.add_to_deck
function Card:add_to_deck(from_deblur)
    old_add_to_deck(self, from_deblur)
    if G.jokers and G.jokers.cards and self.ability and self.ability.set == 'Planet' then
        if not self.from_meteorologist then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({uv_planet_added = true, target = self})
            end
        end
    end
end
if G.GAME then G.GAME.double_it_mult = 1 end
local card_open_ref = Card.open
function Card:open()
    if self.ability.set == 'Booster' and self.config and self.config.center then
        G.GAME.current_booster_key = self.config.center.key
    end
    return card_open_ref(self)
end
local skip_booster_ref = G.FUNCS.skip_booster
G.FUNCS.skip_booster = function(e)
    skip_booster_ref(e)
    if G.GAME.current_booster_key == 'p_uv_super_rare_pack' then
        check_for_unlock({ type = 'why' })
    end
    G.GAME.current_booster_key = nil
end
if G.GAME then G.GAME.rainbow_sleeve_applied = false end
if G.GAME then G.GAME.rainbow_deck_applied = false end
if G.GAME then G.GAME.rainbow_deck_card_used = false end