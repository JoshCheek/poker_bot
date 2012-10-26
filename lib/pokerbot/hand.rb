class Pokerbot
  class Hand
    Type = Struct.new :value do
      include Comparable
      def <=>(other_type)
        other_type.value <=> value
      end
    end

    RoyalFlush    = Type.new 10
    StraightFlush = Type.new 9
    Quads         = Type.new 8
    FullHouse     = Type.new 7
    Flush         = Type.new 6
    Straight      = Type.new 5
    Trips         = Type.new 4
    TwoPair       = Type.new 3
    OnePair       = Type.new 2
    HighCard      = Type.new 1

    def initialize(cards)
      self.cards = cards.sort_by { |card| value_for card }
    end

    def hand
      return RoyalFlush    if consecutive_cards? && same_suit? && value_for(highest_card) == value_for('A?')
      return StraightFlush if consecutive_cards? && same_suit?
      return Quads         if quads.size == 1
      return FullHouse     if trips.size == 1 && pairs.size == 1
      return Flush         if same_suit?
      return Straight      if consecutive_cards?
      return Trips         if trips.size == 1
      return TwoPair       if pairs.size == 2
      return OnePair       if pairs.size == 1
      return HighCard
    end

    def to_discard
      case hand
      when Quads
        # makes sense to pull out a kicker method?
        kicker = (cards - quads.flatten).first
        value_for(kicker) == value_for('A?') ? [] : [kicker]
      when RoyalFlush, StraightFlush, FullHouse, Flush, Straight
        []
      when Trips
        cards - trips.flatten
      when OnePair, TwoPair
        cards - pairs.flatten
      when HighCard
        cards - [cards.max_by { |card| value_for card }]
      end
    end

    private

    def same_suit?
      cards.map { |card| suit_for card }.uniq.size == 1
    end

    def consecutive_cards?
      cards.each_cons(2).all? { |card1, card2| value_for(card2) - value_for(card1) == 1 }
    end

    # quads, pairs, trips are very similar
    def quads
      grouped_values.select { |value, cards| cards.size == 4 }.map(&:last)
    end

    def pairs
      grouped_values.select { |value, cards| cards.size == 2 }.map(&:last)
    end

    def trips
      grouped_values.select { |value, cards| cards.size == 3 }.map(&:last)
    end

    def highest_card
      cards.max_by { |card| value_for card }
    end

    def value_for(card)
      return 11 if card[0].downcase == 'j'
      return 12 if card[0].downcase == 'q'
      return 13 if card[0].downcase == 'k'
      return 14 if card[0].downcase == 'a'
      card.to_i
    end

    def suit_for(card)
      card[-1].downcase
    end

    def grouped_values
      cards.group_by { |card| value_for card }
    end

    attr_accessor :cards
  end
end
