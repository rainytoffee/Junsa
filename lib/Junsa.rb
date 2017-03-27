
require 'slack-ruby-client'
require 'dbi'
require './similar'
require './todays_comic'
require './order_comics'


#TOKEN読み込み
TOKEN = ENV["SLACK_API_TOKEN"]
Slack.configure do |conf|
  conf.token = TOKEN
end

# RTM Clientのインスタンス生成
client = Slack::RealTime::Client.new

# おはようポイントDBをつくる、すでにあれば開く、points変数に代入
points = DBI.connect( 'DBI:SQLite3:junsa_points.db' )
#すでにテーブルがあれば削除
points.do("drop table if exists points_table")
#新しくpointsテーブルを作るのですね
################################!!!!↓ここ[table （]スペース入れないとエラる
points.do("create table points_table (
  name      varchar     not null,
  point     int         not null,
  state     varchar     not null
  );")


# slackに接続できたときの処理
client.on :hello do
  puts 'connected!'
end

# message eventを受け取った時の処理
client.on :message do |data|
    you = data['user']

  case data['text']

###########################################################
  when /^register (.*)/ #タイトル付で初期化
    client.message channel: data['channel'], text: register(you,$1)
  when /^add_comic (.*)/ #発言ユーザIdにタイトル追加
    client.message channel: data['channel'], text: add(you,$1)
  when /^remove_mylist$/ #テーブル全消し
    client.message channel: data['channel'], text: remove_mylist(you)
  when /^show_table$/
    client.message channel: data['channel'], text: show_table(you)
  when /^out_today$/
    client.message channel: data['channel'], text: out_today

###########################################################
  when /^hi$/
    client.message channel: data['channel'], text:'connect!'

############################################################
  when /similar (.*)/
    client.message channel: data['channel'], text: lee($1)

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
end


client.start!
