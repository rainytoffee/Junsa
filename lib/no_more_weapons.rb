require 'nokogiri'
require 'open-uri'
require 'addressable/uri'
##########################################################################
def generate_docs(series,name)

  case series
  when "acc","accy"
     url_acc = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_アクセサリ").normalize
     docacc = Nokogiri::HTML(open(url_acc)).xpath("//table[@id='content_block_2']/tr")
     return docacc

  else
    url_rarity5 = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_レア5_#{series}").normalize
    url_rarity6 = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_レア6_#{series}").normalize

    doc5 = Nokogiri::HTML(open(url_rarity5))
    doc6 = Nokogiri::HTML(open(url_rarity6))

    doc5 = doc5.xpath("//*[@id='content_block_2']/tr/td")
    doc6 = doc6.xpath("//*[@id='content_block_2']/tr/td")
    return doc5, doc6
  end
end
##########################################################################
def sugiuchi?(eqp_num)
  if eqp_num > 20
    return "結果多杉内 欲張杉内"
  end
end
##########################################################################
def hitting(series,name)

  #completion = "https://ffrk攻略.gamematome.jp/"
  completion = "https://xn--ffrk-8i9hs14f.gamematome.jp"
  hitting_acc = String.new #返り値
  hitting_eqp = Array.new
  acc_num = 0 #多杉内？

  case series
  when "acc","accy"
  docacc = generate_docs(series,name)

  docacc.each do |acc|
  #puts "#{weapon}LINE!!!"
    if acc.text.match(/#{name}/)
     acc_imgurl = acc.xpath("./td[1]/a/@href").text
       hitting_acc << "-------------\n#{acc_imgurl}\n#{acc.text}\n".gsub(/\n\d\n\n/,"\n")
                                                  .gsub(/なし/,"軽減/耐性なし")
                                                  .gsub(/【大】/,":lv-dai:")
                                                  .gsub(/【中】/,":lv-chuu:")
                                                  .gsub(/【小】/,":lv-shou:")
          acc_num += 1
          if sugiuchi?(acc_num)
            hitting_acc = sugiuchi?(acc_num)
            break
          end
        end
    end
    #p hitting_acc
    return hitting_acc

  else
  doc5, doc6 = generate_docs(series,name)

  doc5.each do |weapon|
    #puts "#{weapon}LINE!!!"
     if weapon.text.match(/#{name}/)
       weapon.css('a').each do |weaponlink|
       hitting_eqp << "#{completion}#{weaponlink[:href]}"
      end
    end
  end

  doc6.each do |weapon|
  #puts "#{weapon}LINE!!!"
   if weapon.text.match(/#{name}/)
     weapon.css('a').each do |weaponlink|
     hitting_eqp << "#{completion}#{weaponlink[:href]}"
      end
    end
  end

end
  return hitting_eqp

end
#########################################################################

#########################################################################

def hojikuri_weapon(series,name)
  result = String.new
  eqp_info = Array.new

  case series
  when "acc","accy"
    hitting_acc = hitting(series,name)
    # hitting_acc
    return hitting_acc ##############アクセサリの時はここでreturn############

    ##################以下はeqp ff○ eqpnameの場合##############
  else
    series.upcase!#代入先URLが大文字のため
  end

  hitting_eqp = hitting(series,name)
  hitting_eqp.each do |link|

#############################################
  eqp_info = Nokogiri::HTML(open(link))##
#############################################

 title = eqp_info.title

 eqp_imgurl = Nokogiri::HTML(open(link)).xpath("//html/body/div[1]/div[3]/div[1]/div[1]/div[2]/div/div[1]/div/a/@href").text
 #img = imgurl.css('img').each { |image| image.attribute("src").value }
  status = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_3']").text
  effect = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_8']").text
  finisher_title = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_18-body']/a[1]").text
  finisher_info = Nokogiri::HTML(open(link)).xpath("//*[@id='content_block_20']/tr[1]").text

 a_result =["---------",title,eqp_imgurl,status,effect,finisher_title,finisher_info]

 case series
 when "acc","accy"
 result << a_result.join.gsub(/ \| 公式【FFRK】FINAL FANTASY Record Keeper最速攻略Wiki 0\n/,"---------").gsub(/\n \n/,"\n")
.gsub("ステータス","").gsub("効果","")
.gsub(/\n\n命中\n\w{2,3}\n\w{2,3}\n\w{2,3}\n\n\n\n\n/,"")
.gsub(/[\n]{2,}/,"\n")
.gsub("特殊","")
.gsub(/攻撃力\n(\w{1,3}\n)\w{1,3}/){|m| m.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/魔力\n(\w{1,3}\n)\w{1,3}/){|m| m.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/防御力\n(\w{1,3}\n)\w{1,3}/){|m| m.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/魔防\n(\w{1,3}\n)\w{1,3}/){|m| m.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/精神\n(\w{1,3}\n)\w{1,3}/){|m| m.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/回避\n(\w{1,3}\n)\w{1,3}/){|m| m.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/\n(.{1,15})必殺技変更[\n]*/){|m| m.gsub("#{match}","必殺技変更(#{$1}):")}
.gsub(/\(：(.)\)/){"(#{$1})"}
.gsub(/初期値\n/,"")
.gsub(/最大値\(進化後\)\n/,"進化:tsuyosou: ")
.gsub(/最大値\(超進化後\)/,"超進化:tsuyoi:")
.gsub(/最大値\n/,"")
else
result << a_result.join.gsub(/ \| 公式【FFRK】FINAL FANTASY Record Keeper最速攻略Wiki /,"---------\n").gsub(/\n \n/,"\n")
.gsub("ステータス","").gsub("効果","")
.gsub(/\n\n命中\n\w{2,3}\n\w{2,3}\n\w{2,3}\n\n\n\n\n/,"")
.gsub(/[\n]{2,}/,"\n")
.gsub("特殊","")
.gsub(/攻撃力\n(\w{1,3}\n)\w{1,3}\n\w{1,3}/){|match| match.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/魔力\n(\w{1,3}\n)\w{1,3}\n\w{1,3}/){|match| match.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/防御力\n(\w{1,3}\n)\w{1,3}\n\w{1,3}/){|match| match.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/魔防\n(\w{1,3}\n)\w{1,3}\n\w{1,3}/){|match| match.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/精神\n(\w{1,3}\n)\w{1,3}\n\w{1,3}/){|match| match.gsub("#{$1}","").gsub("\n"," ")}
.gsub(/回避\n\w{1,3}\n\w{1,3}\n\w{1,3}\n/,"")
.gsub(/\n(.{1,15})必殺技変更[\n]*/){|match| match.gsub("#{match}","必殺技変更(#{$1}):")}
.gsub(/\(：(.)\)/){"(#{$1})"}
.gsub(/初期値\n/,"")
.gsub(/最大値\(進化後\)\n/,"進化:tsuyosou: ")
.gsub(/最大値\(超進化後\)/,"超進化:tsuyoi:")
.gsub(/最大値\n/,"")
  end
  end
  #p result
return result
end
#hojikuri_weapon("acc","マント")
