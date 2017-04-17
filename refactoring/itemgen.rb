require './raw.rb'
require './equipment.rb'
require './renderer.rb'
require './snatch_and_build.rb'
#Note: Rawdata instance has attr_reader
#:url_accys,   :url_weapons_rarity5,  :url_weapons_rarity6,
#:noko_accys,  :noko_weapons_rarity5, :noko_weapons_rarity6
#:domain
##########################################
  def accept(series,query)      #front-end
    raw = Rawdata.new(series)

    case series
    when "acc"||"accy" #アクセサリ
      matched_accessories = inquiry_about(:accessory,query,raw)
      return "結果大杉内" if matched_accessories.length > 14
      return render(matched_accessories)

    else #ff1..ff15,ffT,零式,外伝,ジョブ,その他
      matched_weapons = inquiry_about(:weapon,query,raw)
      return render(matched_weapons)

    end
  end
##########################################

##########################################
  def inquiry_about(category,query,raw)
    matched_equipments = []

    case category
    when :accessory
        raw.noko_accys.each do |accy|
          matched_equipments << snatch_and_build(:accessory,accy,raw) if accy.text.match(/#{query}/)
          end
    when :weapon
        raw.noko_weapons_rarity5.each do |weapon|
          #print weapon if weapon.text.match(/#{query}/)
          matched_equipments << snatch_and_build(:weapon,weapon,raw) if weapon.text.match(/#{query}/)
          end
        raw.noko_weapons_rarity6.each do |weapon|
          matched_equipments << snatch_and_build(:weapon,weapon,raw) if weapon.text.match(/#{query}/)
          end
    end
    #p matched_equipments
    return matched_equipments
  end
#########################################


accept("ff8","風切り")
