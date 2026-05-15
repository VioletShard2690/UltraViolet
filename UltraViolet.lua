UltraViolet = {}
assert(SMODS.load_file("globals.lua"))()
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "source")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("source/" .. file))()
end

assert(SMODS.load_file("globals.lua"))()
 SMODS.Rarity({
    key = 'super_rare',
    loc_txt = { name = 'Super Rare' },
    badge_colour = HEX('700bb0'),
    default_weight = 0.02,
 })
 local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "source")
 for _, file in ipairs(joker_src) do
    if file:match("%.lua$") then
        assert(SMODS.load_file("source/" .. file))()
    end
 end
 local old_poll_rarity = poll_rarity
 function poll_rarity(_type, _key)
    if _type == 'Joker' and pseudorandom('sj_sr') > 0.98 then
        return 'sj_super_rare'
    end
    return old_poll_rarity(_type, _key)
end
local function load_source(file_name)
    local status, err = pcall(SMODS.load_file, file_name)
    if not status then
        sendDebugMessage("Ошибка в файле " .. file_name .. ": " .. tostring(err))
    end
 end
 load_source("source/blinds.lua")
 load_source("source/atlases.lua")
 load_source("globals.lua")
 load_source("source/tarot.lua")
 load_source("source/jokers.lua")
 load_source("source/vouchers.lua")
load_source("source/decks.lua")