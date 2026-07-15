SMODS.Enhancement{key = 'greg',
    loc_txt = {
        name = 'Greg',
        text = {
            "#2#",
        }
    },
    config = { greg = true },
    unlocked = true,
    discovered = true,
    atlas = 'greg',
    loc_vars = function(self)
        local greg = self.config.greg
        local greg_greg = 'Greg.'
        return { vars = { greg, greg_greg } }
    end,
    evaluate = function(self, card, context)
        if context.main_scoring then
            return self.config.greg
        elseif context.individual then
            return self.config.greg
        elseif context.repetition then
            return self.config.greg
        elseif context.discard then
            return self.config.greg
        elseif context.end_of_round then
            return self.config.greg
        elseif context.before then
            return self.config.greg
        elseif context.after then
            return self.config.greg
        elseif context.joker_main then
            return self.config.greg
        elseif context.blueprint then
            return self.config.greg
        elseif context.selling_card then
            return self.config.greg
        elseif context.selling_self then
            return self.config.greg
        elseif context.edition then
            return self.config.greg
        elseif context.scoring_hand then
            return self.config.greg
        elseif context.pre_discard then
            return self.config.greg
        elseif context.ending_shop then
            return self.config.greg
        elseif context.greg then
            return self.config.greg
        end
    end
}