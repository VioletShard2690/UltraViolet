SMODS.Consumable{key = 'greg_tarot',
    loc_txt = {
        name = 'Greg tarot',
        text = {
            "Turn up to {C:attention}#1#{} cards",
            "into {C:attention}Gregs{}"
        }
    },
    set = 'Tarot',
    config = { mod_conv = "m_uv_greg", max_highlighted = 3 },
    unlocked = true,
    discovered = true,
    atlas = 'greg_tarot',
    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS.m_uv_greg then
            info_queue[#info_queue + 1] = G.P_CENTERS.m_uv_greg
        end
        return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
    end
}