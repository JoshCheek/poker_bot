class Pokerbot
  class Hand
    Type = Struct.new :value, :name do
      include Comparable
      def <=>(other_type)
        other_type.value <=> value
      end
    end

    RoyalFlush    = Type.new 10, 'RoyalFlush'
    StraightFlush = Type.new 9,  'StraightFlush'
    Quads         = Type.new 8,  'Quads'
    FullHouse     = Type.new 7,  'FullHouse'
    Flush         = Type.new 6,  'Flush'
    Straight      = Type.new 5,  'Straight'
    Trips         = Type.new 4,  'Trips'
    TwoPair       = Type.new 3,  'TwoPair'
    OnePair       = Type.new 2,  'OnePair'
    HighCard      = Type.new 1,  'HighCard'

    def initialize(cards)
      self.cards = cards.sort_by { |card| value_for card }
    end

    def hand
      return RoyalFlush    if consecutive_cards? && same_suit? && ace?(highest_card)
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
        kicker = (cards - quads.flatten).first
        ace?(kicker) ? [] : [kicker]
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

    attr_accessor :cards

    def ace?(card)
      value_for(card) == value_for('A?')
    end

    def same_suit?
      cards.map { |card| suit_for card }.uniq.size == 1
    end

    def consecutive_cards?
      cards.each_cons(2)
           .map { |card1, card2| value_for(card2) - value_for(card1) }
           .all? { |difference| difference == 1 }
    end

    def quads
      groups_of 4
    end

    def pairs
      groups_of 2
    end

    def trips
      groups_of 3
    end

    def groups_of(n)
      grouped_by_value.select { |value, cards| cards.size == n }.map(&:last)
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

    def grouped_by_value
      cards.group_by { |card| value_for card }
    end
  end
end
