def snatch_and_build(category,item,raw)
  case category
  when :accessory
    accy = Accessory.new
    #アクセサリのatk,def類は現状割愛
    accy.name               = item.xpath("./td[2]/a/text()").text.gsub(/【.*】/,"")
    accy.series             = item.xpath("./td[2]/a/text()").text.match(/(【.*】)/)
    accy.rarity             = item.xpath("./td[4]/a/text()").text
    accy.reduct_and_resist  = item.xpath("./td[3]").text
    accy.img_url            = item.xpath("./td[1]/a/@href").text
    return accy

 when :weapon
   weapon = Weapon.new
   item = Nokogiri::HTML(open("#{raw.domain}#{item.xpath("./a/@href")}"))

   weapon.name              = item.xpath("//*[@class='headline-5']/span").text.gsub(/【.*】/,"")
   weapon.series            = item.xpath("//*[@class='headline-5']/span").text.match(/(【.*】)/)
   weapon.rarity            = item.xpath("//*[@class='main-contents n-mt-b2']/div/b/a/text()")
   #ものによって上昇対象が違うので、何のカテゴリ持ってるかさがします
   achievements             =  item.xpath("//*[@id='content_block_5']/tr").text
      achievements

   weapon.p_atk             =
 end
end
