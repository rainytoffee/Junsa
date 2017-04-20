
class Renderer
  def self.render(matched_equipments,category)
    result = String.new

    case category
    when :accessory
  #  p matched_equipments
    matched_equipments.each do |i|
      result <<
      "-----------------\n#{i.name}#{i.series} ☆#{i.rarity}\n#{i.img_url}\n#{i.reinforce}\n"
      .gsub(/\nなし\n/,"耐性/軽減なし")
      end

    when :weapon
      count = 1
      matched_equipments.each do |i| #アイテムリスト回します
        result << "-----------------\n#{i.name}#{i.series} ★#{i.rarity}\n#{i.img_url}\n"
          i.numbers_hash.each do |key,value| #数値ハッシュ回します
            if value #数値ハッシュに値があればresultへ追記
            result << "#{key}:#{value} " if count.odd?
            result << "#{key}:#{value} \n" if count.even?
            count += 1
            end
          end
          result << "#{i.reinforce}\n:tsuyoi:#{i.finisher}\n"
        end
    end #case
    p result
    return result
  end #def
end #class

class String
  def uproot_n
    return self.gsub("\n","")
  end

  def opt_n
    return self.gsub(/[\n]+/,"\n").chomp
  end
end
