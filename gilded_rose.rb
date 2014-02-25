MAX_QUALITY = 50
MIN_QUALITY = 0
FIRST_BACKSTAGE_PASS_QUALITY_INCREASE_POINT = 10
SECOND_BACKSTAGE_PASS_QUALITY_INCREASE_POINT = 5
ONE_DAY = 1
def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if !expired?(item)
        if item.name != 'Sulfuras, Hand of Ragnaros'
          decrease_quality(item)
        end
      end
    else
      if not_pristine?(item)
        increase_quality(item)
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in <= FIRST_BACKSTAGE_PASS_QUALITY_INCREASE_POINT
            if not_pristine?(item)
              increase_quality(item)
            end
          end
          if item.sell_in <= SECOND_BACKSTAGE_PASS_QUALITY_INCREASE_POINT
            if not_pristine?(item)
              increase_quality(item)
            end
          end
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      turn_clock_one_day!(item)
    end
    if passed_optimum_sale_date?(item)
      if item.name == 'Aged Brie'
        increase_quality(item) if not_pristine?(item)
        next
      end

      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        item.quality = item.quality - item.quality
        next
      end

      if !expired?(item)
        if item.name != 'Sulfuras, Hand of Ragnaros'
          decrease_quality(item)
        end
      end
    end
  end
end

def increase_quality(item)
  item.quality += 1
end

def decrease_quality(item)
  item.quality -= 1
end

def not_pristine?(item)
  item.quality < MAX_QUALITY
end

def expired?(item)
  item.quality == MIN_QUALITY
end

def turn_clock_one_day!(item)
  item.sell_in -= ONE_DAY
end

def passed_optimum_sale_date?(item)
  item.sell_in < 0
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

