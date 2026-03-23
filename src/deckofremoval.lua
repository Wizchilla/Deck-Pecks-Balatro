---@diagnostic disable: undefined-global SMODS

SMODS.Joker:take_ownership('smiley',
    { 
        in_pool = function(self)
            return G.GAME.selected_back ~= "deckpecks_deckofcard"
        end
    },
    true
)