require 'nokogiri'
require 'open-uri'

def get_glance(difficulty)

eventdoc = Nokogiri::HTML(open('http://altema.jp/ffrk/eventdugeon')) #イベント一覧
glance = eventdoc.xpath("//*[@id='main-contents']/div[1]/div/div/table[1]/tbody/tr[3]/td/ul/li")

bosses = Array.new
links = Array.new

glance.each do |line|
  if line.text.match(/#{difficulty}/)
    bosses << line
  end
end

bosses.each do |bosslinks|
  bosslinks.css('a').each do |link|
  links << link[:href]
  end
end
return links
end


def summary(difficulty)
  result = String.new

  links = get_glance(difficulty)
  links.each do |link|
    summary = Nokogiri::HTML(open("#{link}"))
    specialscore = summary.xpath("//*[@id='main-contents']/div[1]/div/div/table[1]/tbody/tr")
    weakness = summary.xpath("//*[@id='main-contents']/div[1]/div/div/table[2]/tbody/tr")
    result << specialscore.inner_text.gsub("\n\n","\n")
    result << weakness.inner_text.gsub("\n\n","\n")
end
  return result
end

#summary("滅")
