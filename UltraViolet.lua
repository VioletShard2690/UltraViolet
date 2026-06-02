UltraViolet = {}
assert(SMODS.load_file("globals.lua"))()
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "source")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("source/" .. file))()
end
SMODS.Rarity({key = 'super_rare',
  loc_txt = { name = 'Super Rare' },
  badge_colour = HEX('700bb0'),
  default_weight = 0,
})
G.localization.misc.dictionary.k_uv_super_rare_pack = "Super Rare Pack"
G.localization.misc.dictionary.k_uv_deck_pack = "Deck Pack"
G.localization.misc.dictionary.k_uv_jumbo_deck_pack = "Jumbo Deck Pack"
G.localization.misc.dictionary.k_uv_mega_deck_pack = "Mega Deck Pack"
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
local old_reroll_boss = G.FUNCS.reroll_boss
G.FUNCS.reroll_boss = function(e)
    if G.jokers and #SMODS.find_card('j_uv_noname') > 0 then
        G.GAME.round_resets.blind_choices.Boss = 'bl_uv_void'
        if G.GAME.blind_select then 
            G.GAME.blind_select:juice_up() 
        end
        return 
    end
    old_reroll_boss(e)
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
    if ret.Xchip_mod ~= 1 then
        ret.chips = ret.chips * ret.Xchip_mod
    end
    if ret.Echip_mod ~= 1 then
        ret.chips = ret.chips ^ ret.Echip_mod
    end
    if ret.Emult_mod ~= 1 then
        ret.mult = ret.mult ^ ret.Emult_mod
    end
    return ret
end
