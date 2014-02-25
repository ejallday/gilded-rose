class ItemFactory
  def self.build(item)
    case item.name
    when /Backstage/ then BackstagePasses.new(item)
    when /Conjured/ then ConjuredItem.new(item)
    when /Sulfuras/ then Sulfuras.new(item)
    when /Aged Brie/ then AgedBrie.new(item)
    else StandardItem.new(item)
    end
  end
end

class StandardItem < Struct.new(:item)
  MAX_QUALITY = 50
  MIN_QUALITY = 0
  ONE_DAY = 1

  def update
    turn_clock_one_day!
    update_quality
  end

  private

  def update_quality
    return if expired?
    decrease_quality
    decrease_quality if passed_optimum_sale_date? && !expired?
  end

  def increase_quality
    item.quality += 1
  end

  def decrease_quality
    item.quality -= 1
  end

  def pristine?
    item.quality >= MAX_QUALITY
  end

  def expired?
    item.quality == MIN_QUALITY
  end

  def turn_clock_one_day!
    item.sell_in -= ONE_DAY
  end

  def passed_optimum_sale_date?
    item.sell_in < 0
  end
end

class Sulfuras < StandardItem
  def update_quality
  end

  def turn_clock_one_day!
  end
end

class AgedBrie < StandardItem
  def update_quality
    return if pristine?
    increase_quality
    increase_quality if passed_optimum_sale_date? && !pristine?
  end
end

class BackstagePasses < StandardItem
  FIRST_QUALITY_INCREASE_POINT = 10
  SECOND_QUALITY_INCREASE_POINT = 5

  def update_quality
    return if pristine?
    case
    when concert_over? then item.quality = 0
    when past_second_demand_increase? then item.quality += 3
    when past_first_demand_increase? then item.quality += 2
    else item.quality += 1
    end
  end

  private

  def concert_over?
    passed_optimum_sale_date?
  end

  def past_first_demand_increase?
    item.sell_in < FIRST_QUALITY_INCREASE_POINT
  end

  def past_second_demand_increase?
    item.sell_in < SECOND_QUALITY_INCREASE_POINT
  end
end

class ConjuredItem < StandardItem
  def decrease_quality
    item.quality -= 2
  end
end

def update_quality(items)
  items.each do |item|
    ItemFactory.build(item).update
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

