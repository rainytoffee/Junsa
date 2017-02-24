require 'Date'
require 'csv'

def holiday(input_number)
  input_number = input_number

########################################
#ふざけてるんじゃないの裁判
unless (input_number.nil?) || ((1..30).include? input_number.to_i)
    return "ふざけんなよ"
end

########################################
#クソcsv読み込み
naikaku = CSV.read('public_holidays.csv')
naikaku.each do |holiday|
  holiday[1] = Date.parse(holiday[1])
 end

########################################

  d = Date.today
  last_d = Date.parse("2018-12-31")#調べる範囲の終端。可変。
  dayweek = ["日", "月", "火", "水", "木", "金", "土"] #曜日の返りに対応
  count = 1
  nearest_holiday =[]

catch(:found_holiday) do
 (d..last_d).each do |day| #日付が入ってくる
    naikaku.each do |name,date|
      if day == date
        if count == 1
          case date.wday
          when 0,6
              nearest_holiday << "直近の国民の休日は#{date}、#{name}。#{dayweek[date.wday]}曜日。！\n"
              count += 1
          else
              nearest_holiday << "直近の国民の休日は#{date}、#{name}。#{dayweek[date.wday]}曜日。\n"
              count += 1
          end
        else
          case date.wday
          when 0,6
            nearest_holiday << "その次は#{date}、#{name}。#{dayweek[date.wday]}曜日。！\n"
            count += 1
          else
            nearest_holiday << "その次は#{date}、#{name}。#{dayweek[date.wday]}曜日。\n"
            count += 1
          end
        end
          throw (:found_holiday) if count == 2 && input_number == nil
          throw (:found_holiday) if count == input_number.to_f + 1
      end
    end
 end
end
     nearest_holiday.join
end
