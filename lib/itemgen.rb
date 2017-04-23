require './raw.rb'
require './equipment.rb'
require './renderer.rb'
require './snatch_and_build.rb'

class Frontman
  ROMAN_NUMERALS = { "I" => 1, "II" => 2, "III" => 3, "IV" => 4, "V" => 5, "VI" => 6, "VII" => 7, "VIII" => 8, "IX" => 9, "X" => 10, "XI" => 11, "XII" => 12, "XIII" => 13, "XIV" => 14, "XV" => 15}

  def self.accept(series,query)     #front-end
      series.upcase!
      ROMAN_NUMERALS.each { |r,n| if series.include?(r); series = "FF#{n}" end}
      raw = Rawdata.new(series)
    case series
    when "ACC"||"ACCY" #アクセサリ
      matched_accessories = inquiry_about(:accessory,query,raw)
      return "結果大杉内" if matched_accessories.length > 10
      return Renderer::render(matched_accessories,:accessory)
    else #ff1..ff15,ffT,零式,外伝,ジョブ,その他
      matched_weapons = inquiry_about(:weapon,query,raw)
      return Renderer::render(matched_weapons,:weapon)
    end
  end


  def self.inquiry_about(category,query,raw)
    matched_equipments = []
    case category
    when :accessory
        raw.noko_accys.each do |accy|
          matched_equipments << Roughneck::snatch_and_build(:accessory,accy,raw) if accy.text.match(/#{query}/)
          end
    when :weapon
        raw.noko_weapons_rarity5.each do |weapon|
          matched_equipments << Roughneck::snatch_and_build(:weapon,weapon,raw) if weapon.text.match(/#{query}/)
          end
        raw.noko_weapons_rarity6.each do |weapon|
          matched_equipments << Roughneck::snatch_and_build(:weapon,weapon,raw) if weapon.text.match(/#{query}/)
          end
    end
    return matched_equipments
  end
end

#########################################
#Frontman::accept("ffx","ラズマ")
