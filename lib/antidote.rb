require 'nokogiri'
require 'open-uri'

class Summary
def get_glance(beatit)

#現行通常イベント一覧
eventdoc = Nokogiri::HTML(open('http://altema.jp/ffrk/eventdugeon'))
e_glance = eventdoc.xpath("//*[@id='main-contents']/div[1]/div/div/table[1]/tbody/tr[3]/td/ul/li")

#ナイトメア一覧
nightmaredoc = Nokogiri::HTML(open('http://altema.jp/ffrk/nightmaredungeon-34400'))
n_glance = nightmaredoc.xpath("//*[@id='main-contents']/div[1]/div/div/table/tbody/tr/td[@style='text-align: center;']")

multidoc = Nokogiri::HTML(open('http://altema.jp/ffrk/multistage-35714'))
m_glance = multidoc.xpath("//*[@id='main-contents']/div[1]/div/div/table[1]/tbody/tr/td/a")


e_bosses = Array.new#イベントボス配列
n_bosses = Array.new#ナイトメアボス配列
m_bosses = Array.new#マルチボス配列

links = Array.new #クエリにマッチしたボスの攻略URLが入るのですね


#ナイトメアボス照会
n_glance.each do |line|
  if line.text.match(/#{beatit}/)
    n_bosses << line
  #  puts "n_glanceのマッチ済みlineを表示しています => #{line} <=ここまで"
  end
end
#マッチしたnokogiriobjのhrefだけほじってlinks(array)へ流す(なぜ配列index1にURLが入ってくるのかわからん。0は"href"が入ってた)
n_bosses.each do |bosslinks|
  bosslinks.css('a').each do |bosslink|

    links << bosslink[:href]
    #puts "#{links}37行目"
  end
end

#イベントボス照会
e_glance.each do |line|
  if line.text.match(/#{beatit}/)
    e_bosses << line
  #  puts "e_glanceのマッチ済みlineを表示しています => #{line} <=ここまで"
  end
end
#こちらもhrefだけほじってlinksへ流す
e_bosses.each do |bosslinks|
  bosslinks.css('a').each do |bosslink|
  links << bosslink[:href]
  end
end


#multiboss inquiry
m_glance.each do |line|
  if line.text.match(/#{beatit}/)
    m_bosses << line
    #puts "m_glanceのマッチ済みlineを表示しています => #{line} <=ここまで"
  end
end
m_bosses.each do |boss|
  boss.each do |link|
    links << link[1]
  end
end
      #p "links => #{links}"
      return links
end


def summary(beatit)
  result = String.new

  links = get_glance(beatit)
  links.each do |link|
    summary = Nokogiri::HTML(open("#{link}"))
    specialscore = summary.xpath("//*[@id='main-contents']/div[1]/div/div/table[1]/tbody/tr")
    weakness = summary.xpath("//*[@id='main-contents']/div[1]/div/div/table[2]/tbody/tr")
    result << specialscore.inner_text.gsub("\n\n","\n").gsub("スペスコ",":su::pe::su::ko:").gsub("水",":mizu:").gsub("雷",":kaminari:").gsub("氷",":koori:").gsub("炎",":honoo:").gsub("聖",":sei:").gsub("風",":kaze:").gsub("地",":chi:").gsub(/[^暗]闇/,":yami:").gsub("毒",":doku:")
    result << weakness.inner_text.gsub("\n\n","\n").gsub("ボス名",":bo::su:").gsub("弱点属性",":jaku::ten::zoku::sei2:").gsub("属性耐性",":zoku::sei2::tai::sei2:").gsub("有効な状態異常",":yuu::kou::na::jou::tai2::i2::jou2:").gsub("ブレイク耐性",":bu::re::i::ku::tai::sei2:").gsub("水",":mizu:").gsub("雷",":kaminari:").gsub("氷",":koori:").gsub("炎",":honoo:").gsub("聖",":sei:").gsub("風",":kaze:").gsub("地",":chi:").gsub(/[^暗]闇/,":yami:").gsub("毒",":doku:")
  #  result << ":tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi::tsuyoi:\n"
  end

  return "NO INFORMATION. (JIDAI OKURE)" if result.empty?
  return result
end
end
get_glance("めがみ")
#summary("ヒドゥン")
