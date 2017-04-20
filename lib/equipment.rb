

class Equipment
  attr_accessor :name, :series, :rarity, :p_atk, :p_atk_limit, :p_def, :p_def_limit,
                :m_atk, :m_atk_limit, :m_def, :m_def_limit, :mental, :mental_limit,
                :dodge, :accuracy,:finisher, :reinforce, :img_url
  attr_reader :numbers_hash
  def initialize
    @name         #お名前
    @series       #作品
    @rarity       #☆いくつ
    @p_atk        #物攻最大
    @p_atk_limit  #物攻超進化後
    @p_def        #物防最大
    @p_def_limit  #物防超進化後
    @m_atk        #魔攻最大
    @m_atk_limit  #魔攻超進化後
    @m_def        #魔防最大
    @m_def_limit  #魔防超進化後
    @mental       #精神
    @mental_limit #精神超進化後
    @dodge        #回避
    @accuracy     #命中
    @finisher     #必殺技
    @reinforce    #属性強化
    @img_url      #サムネイルuri
    @numbers_hash = Hash.new
  end

  def generate_hash
      @numbers_hash = {"物攻" => @p_atk, "物攻超" => @p_atk_limit, "物防"=>@p_def, "物防超" => @p_def_limit,
                       "魔力" => @m_atk, "魔力超" => @m_atk_limit, "魔防" => @m_def, "魔防超" => @m_def_limit,
                       "精神" => @mental, "精神超" => @mental_limit, "回避" => @dodge, "命中" => @accruracy}
  end
end

class Weapon < Equipment;end
class Accessory < Equipment;end
class BuddhistAltarEquipment < Equipment;end
