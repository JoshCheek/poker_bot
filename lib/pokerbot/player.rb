class Pokerbot
  class Player
    attr_accessor :tournament

    def initialize(tournament)
      self.tournament = tournament
    end

    def my_turn?
      tournament.game_state['your_turn']
    end

    def take_turn
      tournament.should_bet? ? bet_or_fold : replace
    end

    private

    def bet_or_fold
      if analyzer.bet?
        tournament.bet analyzer.amount_to_bet
      else
        tournament.fold
      end
    end

    def replace
      cards_to_replace = analyzer.cards_to_replace
      tournament.replace cards_to_replace
    end

    def analyzer
      @analyzer ||= Analyzer.new tournament
    end
  end
end
