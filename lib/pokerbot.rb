# => {"name"=>"George Laffel",
#  "initial_stack"=>250,
#  "your_turn"=>true,
#  "current_bet"=>20,
#  "minimum_bet"=>25,
#  "maximum_bet"=>250,
#  "hand"=>["6D", "5C", "AS", "5H", "9H"],
#  "betting_phase"=>"deal",                    // deal, draw, post_draw, or showdown.
#  "players_at_table"=>
#   [{"player_name"=>"Jesse Smith",
#     "initial_stack"=>250,
#     "current_bet"=>25,
#     "actions"=>
#      [{"action"=>"ante", "amount"=>20}, {"action"=>"bet", "amount"=>25}]},
#    {"player_name"=>"Sally Pausin",
#     "initial_stack"=>250,
#     "current_bet"=>20,
#     "actions"=>[{"action"=>"ante", "amount"=>20}]}],
#  "total_players_remaining"=>100,
#  "table_id"=>88,
#  "round_id"=>105,
#  "round_history"=>[{"round_id"=>105, "table_id"=>88, "stack_change"=>nil}],
#  "lost_at"=>nil}

require 'json'
require 'rest-client'

require 'pokerbot/hand'
require 'pokerbot/player'
require 'pokerbot/analyzer'
require 'pokerbot/tournament'
