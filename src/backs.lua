---@diagnostic disable: undefined-global SMODS

SMODS.Atlas{
    key = "deckpeck_atlas",
    px = 71,
    py = 95,
    path = "DeckPecksArt.png"
}

SMODS.Back {
    key = "alloftheabove",
    atlas = "deckpeck_atlas",
    pos = { x = 0, y = 0 },
    config = { extra_hand_bonus = 2, 
        extra_discard_bonus = 1, 
        no_interest = true, 
        discards = 1, 
        dollars = 10, 
        consumables = { 'c_fool', 'c_fool', 'c_hex' }, 
        vouchers = {'v_crystal_ball','v_tarot_merchant', 'v_planet_merchant', 'v_overstock_norm','v_telescope'},
        consumable_slot = -1,
        spectral_rate = 2,
        hand_size = 2,
        ante_scaling = 2
        },
    calculate = function(self, back, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            }))
        end
        if context.final_scoring_step then
            return {
                balance = true
            }
        end
    end,
    apply = function(self, back)
        G.GAME.starting_params.erratic_suits_and_ranks = true
        G.GAME.starting_params.no_faces = true
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Clubs' then
                        v:change_suit('Spades')
                    end
                    if v.base.suit == 'Diamonds' then
                        v:change_suit('Hearts')
                    end
                end
                return true
            end
        }))
    end,
}

SMODS.Back {
    key = "bestoftheabove",
    atlas = "deckpeck_atlas",
    pos = { x = 1, y = 0 },
    config = { extra_hand_bonus = 2, 
        joker_slot = 1,
        extra_discard_bonus = 1, 
        discards = 1, 
        hands = 1,
        dollars = 10, 
        consumables = { 'c_fool', 'c_fool', 'c_hex' }, 
        vouchers = {'v_crystal_ball','v_tarot_merchant', 'v_planet_merchant', 'v_overstock_norm','v_telescope'},
        spectral_rate = 2,
        hand_size = 2
        },
    calculate = function(self, back, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end
            }))
        end
        if context.final_scoring_step then
            return {
                balance = true
            }
        end
    end,
    apply = function(self, back)
        G.GAME.starting_params.erratic_suits_and_ranks = true
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Clubs' then
                        v:change_suit('Spades')
                    end
                    if v.base.suit == 'Diamonds' then
                        v:change_suit('Hearts')
                    end
                end
                return true
            end
        }))
    end,
}

SMODS.Back {
    key = "worstoftheabove",
    atlas = "deckpeck_atlas",
    pos = { x = 2, y = 0 },
    config = { 
        no_interest = true, 
        joker_slot = -1,
        consumable_slot = -1,
        hands = -1,
        ante_scaling = 2
        },
    apply = function(self, back)
        G.GAME.starting_params.no_faces = true
    end,
}

SMODS.Back {
    key = "roulette",
    atlas = "deckpeck_atlas",
    pos = { x = 3, y = 0 },
    calculate = function(self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval then
            local oopsCount = #SMODS.find_card("j_oops")
            local totalRepeats = 1 + oopsCount  -- run once + once per oops card
            local pDollars = G.GAME.dollars

            for i = 1, totalRepeats do
                local randomValue = math.random()
                local text, color, amount, scale

                if randomValue < (1/38) then
                    text = "JACKPOT!"
                    color = G.C.GOLD
                    amount = pDollars * 9
                    scale = 2.0
                elseif randomValue < (2/38) then
                    text = "BANKRUPT!"
                    color = G.C.BLACK
                    amount = pDollars * -1
                    scale = 2.0
                elseif randomValue < (20/38) then
                    text = "WIN!"
                    color = G.C.GREEN
                    amount = pDollars
                    scale = 1.4
                else
                    text = "LOSE!"
                    color = G.C.RED
                    amount = math.ceil(pDollars/2)*-1
                    scale = 1.4
                end

                pDollars = amount + pDollars

                local event = Event({
                    blockable = true,
                    blocking = true,
                    trigger = "after",
                    delay = 2.1,
                    func = function()
                        ease_dollars(amount, true)
                        attention_text({
                            scale = scale,
                            text = text,
                            hold = 2,
                            align = 'cm',
                            offset = {x = 0, y = -2.7},
                            major = G.play,
                            backdrop_colour = color
                        })
                        play_sound('gong', 0.94, 0.3)
                        play_sound('gong', 0.94*1.5, 0.2)
                        play_sound('tarot1', 1.5)
                        return true
                    end
                })

                G.E_MANAGER:add_event(event)
            end
        end
    end,
}