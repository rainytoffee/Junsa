#Make accessory or weapon instance and set values.
class Roughneck
  def self.snatch_and_build(category,item)

    case category
    when :accessory
      accy = Accessory.new
      #アクセサリのatk,def類は現状割愛
      accy.name               = item.xpath("./td[2]/a/text()").text.gsub(/【.*】/,"")
      accy.series             = item.xpath("./td[2]/a/text()").text.match(/(【.*】)/)
      accy.rarity             = item.xpath("./td[4]/a/text()").text
      accy.reinforce          = item.xpath("./td[3]").text
      accy.img_url            = item.xpath("./td[1]/a/@href").text
      return accy

    when :weapon
      weapon = Weapon.new
      #"itempath!#{item.xpath("a/@href")}"
      item = Nokogiri::HTML(open("https://xn--ffrk-8i9hs14f.gamematome.jp#{item.xpath("./a/@href")}"))
      ##########文字列scrape#############
      weapon.name                = item.xpath("//*[@class='headline-5']/span").text.gsub(/【.*】/,"")
      weapon.series              = item.xpath("//*[@class='headline-5']/span").text.match(/(【.*】)/)[1]
      weapon.rarity              = item.xpath("//*[@class='main-contents n-mt-b2']/div/b/a/text()").text
      weapon.img_url             = item.xpath("//*[@class='img-box']/div/a/@href").text

      #特殊効果整形
      weapon.reinforce           = item.xpath("//*[@id='content_block_8-body']").text
      md = weapon.reinforce.match(/(.属性強化.*】)/)
      weapon.reinforce = md[1] if md
      weapon.reinforce << "遠距離攻撃" if weapon.reinforce.include?("遠距離攻撃")

      #必殺は整形挟んで取得
      title_f                    = item.xpath("//*[@id='content_block_18-body']/a[1]/text()").text.uproot_n
      whose_f                    = item.xpath("//*[@id='content_block_18-body']/a[2]/text()").text.uproot_n
      effect_f                   = item.xpath("//*[@id='content_block_20']/tr[1]").text.gsub("効果","").uproot_n
      burst_ability1            = item.xpath("//*[@id='content_block_25']/tr[2]").text.opt_n
      burst_ability2            = item.xpath("//*[@id='content_block_25']/tr[3]").text.opt_n
      weapon.finisher            = title_f + "--" +whose_f + "\n" + effect_f + "\n" + burst_ability1 +  burst_ability2

      ############数値scrape#############
      factorcode               =  item.xpath("//*[@id='content_block_5']/tr").text

      weapon.p_atk       = factorcode[/攻撃力\n\w*\n(\w*)\n(\w*)/,1] #1個目の()のなかみ
      weapon.p_atk_limit = factorcode[/攻撃力\n\w*\n(\w*)\n(\w*)/,2] #2個目の()のなかみ
      weapon.p_def       = factorcode[/防御力\n\w*\n(\w*)\n(\w*)/,1]
      weapon.p_def_limit = factorcode[/防御力\n\w*\n(\w*)\n(\w*)/,2]
      weapon.m_atk       = factorcode[/魔力\n\w*\n(\w*)\n(\w*)/,1]
      weapon.m_atk_limit = factorcode[/魔力\n\w*\n(\w*)\n(\w*)/,2]
      weapon.m_def       = factorcode[/魔防\n\w*\n(\w*)\n(\w*)/,1]
      weapon.m_def_limit = factorcode[/魔防\n\w*\n(\w*)\n(\w*)/,2]
      weapon.mental      = factorcode[/精神\n\w*\n(\w*)\n(\w*)/,1]
      weapon.mental_limit= factorcode[/精神\n\w*\n(\w*)\n(\w*)/,2]
      weapon.dodge       = factorcode[/回避\n\w*\n(\w*)\n(\w*)/,1]
      weapon.accuracy    = factorcode[/命中\n\w*\n(\w*)\n(\w*)/,2]

      weapon.generate_hash #instance変数読込、数値ハッシュ生成
      return weapon
    end
  end
end
