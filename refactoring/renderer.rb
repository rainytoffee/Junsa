
class Renderer
def self.render(matched_items)
  result = String.new
  matched_items.each do |item|
    result <<
    "-----------------\n#{item.name}#{item.series} ☆#{item.rarity}\n#{item.img_url}\n#{item.reduct_and_resist}\n"
    .gsub(/\nなし\n/,"耐性/軽減なし")
    end
    return result
end
end
