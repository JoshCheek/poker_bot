class Pokerbot
  class Analyzer
    attr_accessor :tournament, :hand

    def initialize(tournament)
      self.tournament = tournament
      self.hand = Hand.new tournament.hand
    end

    def bet?
      hand.hand > Hand::TwoPair
    end

    def amount_to_bet
      amount = tournament.minimum_bet * hand.hand.value
      amount = tournament.maximum_bet if amount > tournament.maximum_bet
      amount
    end

    def cards_to_replace
      hand.to_discard
    end
  end
end
