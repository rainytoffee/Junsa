require 'Date'
require 'csv'

def holiday

########################################
#クソcsv読み込み
naikaku = CSV.read('public_holidays.csv')
naikaku.each do |day|
  day[1] = Date.parse(day[1])
 end
########################################

  d = Date.today
  last_d = Date.parse("2018-12-31")#調べる範囲の終端。可変。
  dayweek = ["日", "月", "火", "水", "木", "金", "土"] #曜日の返りに対応
  count = 1
  nearest_holiday =[]

catch(:find_holiday) do
 (d..last_d).each do |day| #日付が入ってくる
    naikaku.each do |name,date|
      if day == date
        if count == 1
          case date.wday
          when 0,6
              nearest_holiday << "直近の国民の休日は#{date}、#{name}。#{dayweek[date.wday]}曜日。！\n"
          else
              nearest_holiday << "直近の国民の休日は#{date}、#{name}。#{dayweek[date.wday]}曜日。\n"
              count += 1
          end
        else
          case date.wday
          when 0,6
            nearest_holiday << "その次は#{date}、#{name}。#{dayweek[date.wday]}曜日。！\n"
          else
            nearest_holiday << "その次は#{date}、#{name}。#{dayweek[date.wday]}曜日。\n"
            count += 1
          end
          throw (:find_holiday) if count == 5
       end
      end
    end
 end
end
     nearest_holiday.join
end
