require 'date'
require './order_comics'

class ComicManage

      MONTH = Date.today.month
      DAY   = Date.today.day
      TODAY = "#{MONTH}月#{DAY}日"

      NEW_DOC = Nokogiri::HTML(open('https://honto.jp/netstore/calender.html'))#来月
      OLD_DOC = Nokogiri::HTML(open('https://honto.jp/netstore/calender/old.html'))#今月

  def initialize
    @n_begin = NEW_DOC.xpath("//*[@id='pbBlock2645183']/table[1]/tbody/tr")
    @n_mid = NEW_DOC.xpath("//*[@id='pbBlock2645183']/table[2]/tbody/tr")
    @n_late = NEW_DOC.xpath("//*[@id='pbBlock2645183']/table[3]/tbody/tr")

    @o_begin = OLD_DOC.xpath("//*[@id='pbBlock2645201']/table[1]/tbody/tr")
    @o_mid = OLD_DOC.xpath("//*[@id='pbBlock2645201']/table[2]/tbody/tr")
    @o_late = OLD_DOC.xpath("//*[@id='pbBlock2645201']/table[3]/tbody/tr")
    #trまでxpath指定しないと配列にならないよ！
    #tbodyまでしか指定しなかったのでひとまとまりでobjが生成されて、eachかけても1line扱いでハマったから注意
  end
  attr_reader :n_begin, :n_mid, :n_late, :o_begin, :o_mid, :o_late


  def search_today
    titles = String.new
    #//はルートノードを指します。以下のline.xpath("内")を//から始めるとobj内全ノードが対象になりえらいことになるので注意。
    #./で現在位置のノードを指す。
########来月をあたる##############
    @n_begin.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        titles << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
        titles << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
      end
      end
    @n_mid.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        titles << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
        titles << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
      end
      end
    @n_late.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        titles << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
        titles << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
      end
      end

########今月をあたる############
      @o_begin.each do |line|
        if line.xpath("./td[1]").text.match(TODAY)
          titles << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
          titles << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
        end
        end
      @o_mid.each do |line|
        if line.xpath("./td[1]").text.match(TODAY)
          titles << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
          titles << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
        end
        end
      @o_late.each do |line|
        if line.xpath("./td[1]").text.match(TODAY)
          titles << "#{line.xpath("./td[2]").text.gsub("　"," ")} /"
          titles << "#{line.xpath("./td[3]").text.gsub("　"," ")}\n"
        end
        end
      return "今日はなんにも出ませんから、もう寝なさい" if titles.empty?
      return "本日 #{Date.today.month}月#{Date.today.day}日 発売の漫画はこちら\n#{titles}" #本日発売タイトルarray"
  end
##############################################################
def search_today_titles
  titles = Array.new
########来月をあたる（今日の日付が来月分に含まれることがあるので）##############
  @n_begin.each do |line|
    if line.xpath("./td[1]").text.match(TODAY)
      titles << line.xpath("./td[2]").text.gsub("　"," ")
    end
    end
  @n_mid.each do |line|
    if line.xpath("./td[1]").text.match(TODAY)
      titles << line.xpath("./td[2]").text.gsub("　"," ")
    end
    end
  @n_late.each do |line|
    if line.xpath("./td[1]").text.match(TODAY)
      titles << line.xpath("./td[2]").text.gsub("　"," ")
    end
    end

########今月をあたる（真っ当）############
    @o_begin.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        titles << line.xpath("./td[2]").text.gsub("　"," ")
      end
      end
    @o_mid.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        titles << line.xpath("./td[2]").text.gsub("　"," ")
      end
      end
    @o_late.each do |line|
      if line.xpath("./td[1]").text.match(TODAY)
        titles << line.xpath("./td[2]").text.gsub("　"," ")
      end
      end
        return  titles
end
end
