require 'pokerbot/hand'

class Pokerbot::Hand
  describe self do
    describe 'the hands' do
      specify 'they are ordered by poker ordering' do
        [RoyalFlush,
         StraightFlush,
         Quads,
         FullHouse,
         Flush,
         Straight,
         Trips,
         TwoPair,
         OnePair,
         HighCard
        ].shuffle.sort.should == [RoyalFlush,
                                  StraightFlush,
                                  Quads,
                                  FullHouse,
                                  Flush,
                                  Straight,
                                  Trips,
                                  TwoPair,
                                  OnePair,
                                  HighCard]
      end
    end

    specify 'they know their name' do
      RoyalFlush.name.should    == 'RoyalFlush'
      StraightFlush.name.should == 'StraightFlush'
      Quads.name.should         == 'Quads'
      FullHouse.name.should     == 'FullHouse'
      Flush.name.should         == 'Flush'
      Straight.name.should      == 'Straight'
      Trips.name.should         == 'Trips'
      TwoPair.name.should       == 'TwoPair'
      OnePair.name.should       == 'OnePair'
      HighCard.name.should      == 'HighCard'
    end

    describe 'hand knows what it is and what cards it does not care about' do
      def hand(cards)
        described_class.new(cards).hand
      end

      def to_discard(cards)
        described_class.new(cards).to_discard
      end

      example 'royal flush' do
        hand(%w[10D AD KD JD QD]).should == RoyalFlush
        to_discard(%w[10D AD KD JD QD]).should == []
      end

      example 'straight flush' do
        hand(%w[2H 3H 4H 5H 6H]).should  == StraightFlush
        hand(%w[10D 9D 7D JD 8D]).should == StraightFlush

        to_discard(%w[2H 3H 4H 5H 6H]).should  == []
        to_discard(%w[10D 9D 7D JD 8D]).should == []
      end

      example 'quads where kicker is not an ace discards kicker' do
        hand(%w[9H 9C 4S 9S 9D]).should == Quads
        hand(%w[8H 3D 3S 3C 3H]).should == Quads
        hand(%w[KH KD 4S KC KS]).should == Quads

        to_discard(%w[9H 9C 4S 9S 9D]).should == ['4S']
        to_discard(%w[8H 3D 3S 3C 3H]).should == ['8H']
        to_discard(%w[KH KD 4S KC KS]).should == ['4S']
      end

      example 'quads where kicker is ace discards nothing' do
        hand(%w[9H 9C AS 9S 9D]).should == Quads
        to_discard(%w[9H 9C AS 9S 9D]).should == []
      end

      example 'full house' do
        hand(%w[9H 4D 4S 4C 9D]).should == FullHouse
        hand(%w[9H 3D 3S 9C 9D]).should == FullHouse
        hand(%w[JH AD AS AC JD]).should == FullHouse

        to_discard(%w[9H 4D 4S 4C 9D]).should == []
        to_discard(%w[9H 3D 3S 9C 9D]).should == []
        to_discard(%w[JH AD AS AC JD]).should == []
      end

      example 'flush' do
        hand(%w[2H 3H JH 5H 6H]).should  == Flush
        hand(%w[10D 9D 7D 2D 8D]).should == Flush
        hand(%w[AC KC QC 2C 10C]).should == Flush
        hand(%w[AS KS QS 2S 10S]).should == Flush

        to_discard(%w[2H 3H 4H 5H JH]).should  == []
        to_discard(%w[10D 9D 7D JD 2D]).should == []
        to_discard(%w[AC KC QC JC 2C]).should == []
        to_discard(%w[AS KS QS JS 2S]).should == []
      end

      example 'straight' do
        hand(%w[2H 3C 4S 5C 6D]).should  == Straight
        hand(%w[10H 9D 7S JC 8D]).should == Straight
        hand(%w[AH KD QS JC 10C]).should == Straight

        to_discard(%w[2H 3C 4S 5C 6D]).should  == []
        to_discard(%w[10H 9D 7S JC 8D]).should == []
        to_discard(%w[AH KD QS JC 10C]).should == []
      end

      example 'trips' do
        hand(%w[9H 9C 4S 5C 9D]).should == Trips
        hand(%w[8H 3D 3S 3C 9D]).should == Trips
        hand(%w[3H 3D 4S 5C 3C]).should == Trips

        to_discard(%w[9H 9C 4S 5C 9D]).should =~ %w[4S 5C]
        to_discard(%w[8H 3D 3S 3C 9D]).should =~ %w[8H 9D]
        to_discard(%w[3H 3D 4S 5C 3C]).should =~ %w[4S 5C]
      end

      example 'two pair' do
        hand(%w[9H 4D 4S 5C 9D]).should == TwoPair
        hand(%w[8H 3D 3S 9C 9D]).should == TwoPair
        hand(%w[3H 3D 4S 5C 4D]).should == TwoPair

        to_discard(%w[9H 4D 4S 5C 9D]).should =~ %w[5C]
        to_discard(%w[8H 3D 3S 9C 9D]).should =~ %w[8H]
        to_discard(%w[3H 3D 4S 5C 4D]).should =~ %w[5C]
      end

      example 'one pair' do
        hand(%w[9H 3D 4S 5C 9D]).should == OnePair
        hand(%w[8H 3D 3S 5C 9D]).should == OnePair
        hand(%w[9H 3D 4S 5C 4D]).should == OnePair
        hand(%w[9H 3D 4S 5C 5D]).should == OnePair

        to_discard(%w[9H 3D 4S 5C 9D]).should =~ %w[3D 4S 5C]
        to_discard(%w[8H 3D 3S 5C 9D]).should =~ %w[8H 5C 9D]
        to_discard(%w[9H 3D 4S 5C 4D]).should =~ %w[9H 3D 5C]
        to_discard(%w[9H 3D 4S 5C 5D]).should =~ %w[9H 3D 4S]
      end

      example 'high card' do
        cards = %w[9H 3D 4S 5C]
        hand(cards + ['QH']).should == HighCard
        to_discard(cards + ['AH']).should =~ cards
        to_discard(cards + ['KH']).should =~ cards
        to_discard(cards + ['QH']).should =~ cards
        to_discard(cards + ['JH']).should =~ cards
        to_discard(cards + ['10H']).should =~ cards
        to_discard(cards + ['8H']).should =~ %w[8H 3D 4S 5C]
      end
    end
  end
end
