require 'nokogiri'
require 'open-uri'
require 'addressable/uri'
##########################################################################
def generate_docs(series,name)

 url_rarity5 = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_レア5_#{series}").normalize
 url_rarity6 = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_レア6_#{series}").normalize

  doc5 = Nokogiri::HTML(open(url_rarity5))
  doc6 = Nokogiri::HTML(open(url_rarity6))

  doc5 = doc5.xpath("//*[@id='content_block_2']/tr/td")
  doc6 = doc6.xpath("//*[@id='content_block_2']/tr/td")
  return doc5, doc6
end
##########################################################################

##########################################################################
def hitting(series,name)

  #completion = "https://ffrk攻略.gamematome.jp/"
  completion = "https://xn--ffrk-8i9hs14f.gamematome.jp"

  hitting_weapons = Array.new
  doc5, doc6 = generate_docs(series,name)

  doc5.each do |weapon|
    #puts "#{weapon}LINE!!!"
     if weapon.text.match(/#{name}/)
       weapon.css('a').each do |weaponlink|
       hitting_weapons << "#{completion}#{weaponlink[:href]}"
     end
  end
end

  doc6.each do |weapon|
  #puts "#{weapon}LINE!!!"
   if weapon.text.match(/#{name}/)
     weapon.css('a').each do |weaponlink|
     hitting_weapons << "#{completion}#{weaponlink[:href]}"
   end
 end
end

  return hitting_weapons

end
#########################################################################

#########################################################################

def hojikuri_weapon(series,name)
  result = Array.new

  hitting_weapons = hitting(series,name)
  hitting_weapons.each do |link|

#############################################
  weapons_info = Nokogiri::HTML(open(link))##
#############################################

   title = weapons_info.title

 imgurl = Nokogiri::HTML(open(link)).xpath("/html/body/div[1]/div[3]/div[1]/div[1]/div[2]/div/div[1]/div")
 img = imgurl.css('img').each { |image| image.attribute("src").value }
  status = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_3']").text
  effect = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_8']").text
  finisher_title = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_18-body']/a[1]").text
  finisher_info = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_20']/tr[1]").text

result =[title,img,status,effect,finisher_title,finisher_info]
#puts result.join
return result.join.gsub(" | 公式【FFRK】FINAL FANTASY Record Keeper最速攻略Wiki 0","").gsub("ステータス","").gsub("効果","")
  end
end
#hojikuri_weapon("FF6","グラディウス")
