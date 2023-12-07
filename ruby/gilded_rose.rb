# old code
# class GildedRose
#   def initialize(items)
#     @items = items
#   end

#   def update_quality()
#     @items.each do |item|
#       byebug
#       if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
#         if item.quality > 0
#           if item.name != "Sulfuras, Hand of Ragnaros"
#             item.quality = item.quality - 1
#           end
#         end
#       else
#         if item.quality < 50
#           item.quality = item.quality + 1
#           if item.name == "Backstage passes to a TAFKAL80ETC concert"
#             if item.sell_in < 11
#               if item.quality < 50
#                 item.quality = item.quality + 1
#               end
#             end
#             if item.sell_in < 6
#               if item.quality < 50
#                 item.quality = item.quality + 1
#               end
#             end
#           end
#         end
#       end
#       if item.name != "Sulfuras, Hand of Ragnaros"
#         item.sell_in = item.sell_in - 1
#       end
#       if item.sell_in < 0
#         if item.name != "Aged Brie"
#           if item.name != "Backstage passes to a TAFKAL80ETC concert"
#             if item.quality > 0
#               if item.name != "Sulfuras, Hand of Ragnaros"
#                 item.quality = item.quality - 1
#               end
#             end
#           else
#             item.quality = item.quality - item.quality
#           end
#         else
#           if item.quality < 50
#             item.quality = item.quality + 1
#           end
#         end
#       end
#     end
#   end
# end

# new code with new requirment

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when "Aged Brie"
        update_aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert"
        update_backstage_passes(item)
      when "Sulfuras, Hand of Ragnaros"
        next # Legendary item, no change needed
      when "Conjured"
        degrade_quality(item, 2) # Conjured items degrade faster
      else
        degrade_quality(item) unless item.name == "Sulfuras, Hand of Ragnaros"
      end

      update_sell_in(item) unless item.name == "Sulfuras, Hand of Ragnaros"
      adjust_quality_after_sell_by(item) unless item.name == "Sulfuras, Hand of Ragnaros"
    end
  end

  private

  def degrade_quality(item, rate = 1)
    if item.name == "Conjured"
      rate *= 2 # Double the degradation rate for Conjured items
    end

    item.quality -= rate if item.quality > 0 && item.name != "Sulfuras, Hand of Ragnaros"
    item.quality = 0 if item.quality < 0
  end

  def increase_quality(item, amount = 1)
    max_quality = 50
    item.quality += amount if item.quality < max_quality - amount + 1
  end


  def update_aged_brie(item)
    increase_quality(item)
    update_sell_in(item)
    increase_quality(item) if item.sell_in < 0 # Aged Brie quality increases after sell-by date
  end

  def update_backstage_passes(item)
    if item.sell_in > 10
      increase_quality(item)
    elsif item.sell_in.between?(6, 10)
      increase_quality(item, 2)
    elsif item.sell_in.between?(1, 5)
      increase_quality(item, 3)
    else
      item.quality = 0
    end
    item.quality = 0 if item.sell_in < 0 # Quality drops to 0 after the concert
    update_sell_in(item)  # Update SellIn for Backstage passes
  end

  def update_sell_in(item)
    item.sell_in -= 1 unless item.name == "Sulfuras, Hand of Ragnaros"
  end

  def adjust_quality_after_sell_by(item)
    return unless item.sell_in < 0

    case item.name
    when "Aged Brie"
      increase_quality(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      item.quality = 0 # Quality drops to 0 after the concert
    else
      degrade_quality(item, 2) unless item.name == "Sulfuras, Hand of Ragnaros"
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
