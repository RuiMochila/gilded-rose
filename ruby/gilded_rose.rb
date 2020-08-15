class GildedRose

  def initialize(items)
    @items = items
  end

  def increase_quality(item, ammount: 1)
    return if item.name == "Sulfuras, Hand of Ragnaros"
    item.quality = [item.quality + ammount, 50].min 
  end

  def reduce_quality(item, ammount: 1)
    return if item.name == "Sulfuras, Hand of Ragnaros"
    item.quality = [item.quality - ammount, 0].max
  end

  def reduce_sell_in(item, ammount: 1)
    return if item.name == "Sulfuras, Hand of Ragnaros"
    item.sell_in = item.sell_in - 1
  end

  def update_quality
    @items.each do |item|
      
      case item.name
      when "Backstage passes to a TAFKAL80ETC concert"
        increase_quality(item)
        increase_quality(item) if item.sell_in < 11
        increase_quality(item) if item.sell_in < 6
      when "Aged Brie"
        increase_quality(item)
      when "Conjured Mana Cake"
        reduce_quality(item, ammount: 2)
      else
        reduce_quality(item)
      end
      
      reduce_sell_in(item)

      if item.sell_in < 0
        case item.name
        when "Aged Brie"
          increase_quality(item)
        when "Backstage passes to a TAFKAL80ETC concert"
          reduce_quality(item, ammount: item.quality)
        when "Conjured Mana Cake"
          reduce_quality(item, ammount: 2)
        else
          reduce_quality(item)
        end
      end

    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
