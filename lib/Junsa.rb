
require 'slack-ruby-client'
require 'dbi'
require './similar'
require './todays_comic'
require './order_comics'
require './antidote'


#TOKEN読み込み
TOKEN = ENV["SLACK_API_TOKEN"]
Slack.configure do |conf|
  conf.token = TOKEN
end

client = Slack::RealTime::Client.new

# おはようポイントDBをつくる、すでにあれば開く、points変数に代入
points = DBI.connect( 'DBI:SQLite3:junsa_points.db' )
points.do("drop table if exists points_table")

points.do("create table points_table (
  name      varchar     not null,
  point     int         not null,
  state     varchar     not null
  );")


# slackに接続できたときの処理
client.on :hello do
  puts 'CCC------CCCCC----------CCCCCCCCCC-----'
end

# message eventを受け取った時の処理
client.on :message do |data|
    you = "<@#{data['user']}>"


cmanager = ComicManage.new
begin

  case data['text']

###########################################################
  when /^cinit$/ #タイトル付で初期化
    client.message channel: data['channel'], text: COrder::cinit(you)
  when /^cadd (.*)/ #発言者Idにタイトル追加
    client.message channel: data['channel'], text: COrder::add(you,$1)
  when /^cremove all$/ #発言者idのタイトルリスト全消し
    client.message channel: data['channel'], text: COrder::remove_all_title(you)
  when /^cremove (.*)$/ #発言者idの指定タイトル消し
    client.message channel: data['channel'], text: COrder::remove_title(you,$1)
  when /^cshow$/
    client.message channel: data['channel'], text: COrder::show_table(you)
  when /^out_today$/
    client.message channel: data['channel'], text: "本日 #{Date.today.month}月#{Date.today.day}日 発売の漫画はこちら\n""\n#{cmanager.search_today}"
  when /^titles$/
    client.message channel: data['channel'], text: COrder::title_matcher(you)

###########################################################
  when /^hi$/
    client.message channel: data['channel'], text: "#{you}が麹町に住んでいることを知っているぞ"

############################################################
  when /similar (.*)/
    client.message channel: data['channel'], text: lee($1)
  when /^ないよ$/
    client.message channel: data['channel'], text: "あるよ！"
  when /^あるよ$/
    client.message channel: data['channel'], text: "ないよ！"

############################################################
when /^summary (.*)$/
  client.message channel: data['channel'], text: summary($1)
############################################################
  when /おはようポイントおねがいします/
    points.do("insert into points_table values (
    \'#{you}\',
    0,
    'BUSTED'
    );")
    client.message channel: data['channel'], text: "おはようカウントはじめます！#{you}！"
  when /巡査ちゃん、おはようございます/
    points.do("update points_table set point=point+1 where name=\'#{you}\';")
    client.message channel: data['channel'], text:"おはようございます、#{you}"

    your_state = points.do("select point from points_table where name=\'#{you}\';")
    points.do("update points_table set state='CITIZEN' where name=\'#{you}\';") if your_state > 2

  when /点数教えてください/
    your_data = points.execute("select * from points_table where name=\'#{you}\';")

    your_data.each do |row|

      your_point = row["point"]
      your_state = row["state"]

      client.message channel: data['channel'], text:
      if your_point == 0
        "ふざけるなよ"
      else
        "#{you}のおはようポイントは#{your_point}です！状態は#{your_state}です！"
      end
      end
  end
rescue UncaughtThrowError => e
   client.message channel: data['channel'], text:"#{e}\n君のリストが空か、ID登録されてない。cinitした？"
rescue SQLite3::ConstraintException => e
   client.message channel: data['channel'], text:"#{e}\n君のIDもうあるよ。caddで追加、cshowで確認ね"
end
end

client.start!
