require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq "foo"
    end

    describe "legendary items" do
      subject { Item.new("Sulfuras, Hand of Ragnaros", 0, 80) }
      before  { GildedRose.new([subject]).update_quality }
      it "won't change in quality or sell_in" do
        expect(subject.sell_in).to eq 0
        expect(subject.quality).to eq 80
      end
    end

    context "when sell_in date is positive" do
      before(:each) { GildedRose.new([subject]).update_quality }
      
      describe "regular items" do
        subject { Item.new("Normal Item", 5, 4) }
        it "degrade as normal" do
          expect(subject.sell_in).to eq 4
          expect(subject.quality).to eq 3
        end
      end

      describe "Aged Brie" do
        subject { Item.new("Aged Brie", 5, 20) }
        it "increases in quality" do
          expect(subject.sell_in).to eq 4
          expect(subject.quality).to eq 21
        end
      end

      describe "Conjured items" do
        subject { Item.new("Conjured Mana Cake", 5, 4) }
        it "degrade quality twice as fast" do
          expect(subject.sell_in).to eq 4
          expect(subject.quality).to eq 2
        end
      end

      describe "Backstage passes" do
        describe "with concert date in 11 or more days" do
          subject { Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 20) }
          it "increases in quality" do
            expect(subject.quality).to eq 21
            expect(subject.sell_in).to eq 11
          end
        end

        describe "with concert date in less then 11 days" do
          subject { Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 20) }
          it "increases in quality twice as fast" do
            expect(subject.quality).to eq 22
            expect(subject.sell_in).to eq 10
          end
        end

        describe "with concert date in less then 6 days" do
          subject { Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20) }
          it "increases in quality 3 times as fast" do
            expect(subject.quality).to eq 23
            expect(subject.sell_in).to eq 4
          end
        end
      end
    end

    context "when sell_in date has passed" do
      before(:each) { GildedRose.new([subject]).update_quality }

      describe "regular items" do
        subject { Item.new("Normal Item", -1, 4) }
        it "degrade twice as normal" do
          expect(subject.quality).to eq 2
        end
      end

      describe "Backstage passes" do
        subject { Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 50) }
        it "become worthless" do
          expect(subject.quality).to eq 0
          expect(subject.sell_in).to eq -2
        end
      end

      describe "Aged Brie" do
        subject { Item.new("Aged Brie", -2, 20) }
        it "increase in quality twice as normal" do
          expect(subject.sell_in).to eq -3
          expect(subject.quality).to eq 22
        end
      end

      describe "Conjured items" do
        subject { Item.new("Conjured Mana Cake", -1, 5) }
        it "degrade in quality 4 times as fast" do
          expect(subject.sell_in).to eq -2
          expect(subject.quality).to eq 1
        end
      end
    end
  end

end
