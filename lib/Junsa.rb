
require 'slack-ruby-client'
require 'dbi'
require './similar'
require './todays_comic'
require './order_comics'
require './antidote'
require './weapons.rb'

help=
"
===============================================================================================================
/similar <(+ or -)query>/  -<query>の類語を表示します 語頭に+||-が必要です
===============================================================================================================
/out_today/           -きょうでる漫画
/cinit/               -あなたのIDでDBを新規作成
/cadd <title>/     -あなたのDBに<title>を追加
/cremove <title>/  -あなたのDBから<title>を削除（完全一致）
/cremove all/         -あなたのDBをきれいに削除
/cshow/               -DBの中身を表示します
/titles/              -DBの中にきょうでるのがあれば叫びます（とりつくろい機能）
================================================================================================================
/summary <boss>/    -<boss>の情報を表示(部分一致OK、イベント、ナイトメア、マルチに対応。ダンジョン名でもいけそう)
/eqp ff<number> <equipment>/   -FF<number>の装備一覧を対象に、<eqpuipment>の情報を表示します。
                               （equipment部分は部分一致OK。照会対象は★5,6のみ。）
/eqp acc(或はaccy) <equipment(名前、或は軽減属性、状態異常等)>/  -<equipment>にマッチしたアクセサリを表示。
                                部分一致OK。複数クエリ不可。レアリティは全アクセサリを照会。
================================================================================================================
"

#TOKEN読み込み
TOKEN = ENV["SLACK_API_TOKEN"]
Slack.configure do |conf|
  conf.token = TOKEN
end
client = Slack::RealTime::Client.new

# slackに接続できたときの処理
client.on :hello do
  puts 'CONNECT!'
end


# message eventを受け取った時の処理
client.on :message do |data|
    you = "<@#{data['user']}>"

cmanager = ComicManage.new
begin

  case data['text']
###########################################################
  when /^help$/
    client.message channel: data['channel'], text: help
###########################################################

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
    client.message channel: data['channel'], text: cmanager.search_today
  when /^titles$/
    client.message channel: data['channel'], text: COrder::title_matcher(you)

###########################################################
  when /^hi$/
    client.message channel: data['channel'], text: ":jun3::sa3::kiku:"

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
  when /^eqp (.*) (.*)$/
    client.message channel: data['channel'], text: hojikuri_weapon($1,$2)
############################################################
  end

rescue UncaughtThrowError => e
   client.message channel: data['channel'], text:"#{e}\n君のリストが空か、ID登録されてない。cinitした？"
rescue SQLite3::ConstraintException => e
   client.message channel: data['channel'], text:"#{e}\n君のIDもうあるよ。caddで追加、cshowで確認"
rescue => e
    client.message channel: data['channel'], text:"#{e}\n情報元が死んでるか、たぶんまだ更新されてない。ぷろばぶりー"

end
end

client.start!
