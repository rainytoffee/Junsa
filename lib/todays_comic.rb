require 'nokogiri'
require 'open-uri'
require 'date'


class ComicManage

  MONTH = Date.today.month
  DAY   = Date.today.day
  TODAY = "#{MONTH}月#{DAY}日"

  NEW_DOC = Nokogiri::HTML(open('https://honto.jp/netstore/calender.html'))#来月
  OLD_DOC = Nokogiri::HTML(open('https://honto.jp/netstore/calender/old.html'))#今月

  def initialize
    @n_obj_begin = NEW_DOC.xpath("//*[@id='pbBlock2645183']/table[1]/tbody/tr")
    @n_obj_mid = NEW_DOC.xpath("//*[@id='pbBlock2645183']/table[2]/tbody/tr")
    @n_obj_late = NEW_DOC.xpath("//*[@id='pbBlock2645183']/table[3]/tbody/tr")

    @o_obj_begin = OLD_DOC.xpath("//*[@id='pbBlock2645201']/table[1]/tbody/tr")
    @o_obj_mid = OLD_DOC.xpath("//*[@id='pbBlock2645201']/table[2]/tbody/tr")
    @o_obj_late = OLD_DOC.xpath("//*[@id='pbBlock2645201']/table[3]/tbody/tr")
    #trまでxpath指定しないと配列にならないよ！
    #tbodyまでしか指定しなかったのでひとまとまりでobjが生成されて、eachかけても1line扱いでハマったから注意
  end
  attr_accessor :n_obj_begin, :n_obj_mid, :n_obj_late, :o_obj_begin, :o_obj_mid, :o_obj_late

  def search_today
    say = String.new
    #//はルートノードを指します。以下のline.xpath("内")を//から始めるとobj内全ノードが対象になりえらいことになるので注意。
    #./で現在位置のノードを指す。
########来月をあたる##############
    @n_obj_begin.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        say << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
        say << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
      end
      end
    @n_obj_mid.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        say << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
        say << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
      end
      end
    @n_obj_late.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        say << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
        say << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
      end
      end

########今月をあたる############
      @o_obj_begin.each do |line|
        if line.xpath("./td[1]").text.match(TODAY)
          say << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
          say << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
        end
        end
      @o_obj_mid.each do |line|
        if line.xpath("./td[1]").text.match(TODAY)
          say << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
          say << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
        end
        end
      @o_obj_late.each do |line|
        if line.xpath("./td[1]").text.match(TODAY)
          say << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
          say << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
        end
        end
    return "本日 #{TODAY} 発売の漫画はこちら\n""\n#{say}"
  end
end

  def out_today
    manager = ComicManage.new
    manager.search_today
  end
=begin
  def out_title
    manager = ComicManage.new
    manager.
  end
=end
