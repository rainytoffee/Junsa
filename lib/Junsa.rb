
require 'slack-ruby-client'
require 'dbi'
require './similar'
require './todays_comic'
require './order_comics'
require './antidote'
require './help.rb'
require './itemgen.rb'

Slack.configure do |conf|
  conf.token = ENV["SLACK_API_TOKEN"]
end
client = Slack::RealTime::Client.new
cmanager = ComicManage.new

client.on :hello do
  puts 'CONNECT!'
end


client.on :message do |data|
    you = "<@#{data['user']}>"

begin
  case data['text']
###########################################################
  when /^help$/
    client.message channel: data['channel'], text: BotHelpMessage::help
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
############################################################
  when /^summary\s(\w+)$/
    client.message channel: data['channel'], text: Summary::summary($1)
  when /^eqp\s(.*)\s(.*) $/
    if data['text'].match(/-/)

    else
    client.message channel: data['channel'], text: Frontman::accept($1,$2)
############################################################
  else
    client.message channel: data['channel'], text: "なに？飯が炊けた？"
  end

rescue UncaughtThrowError => e
   client.message channel: data['channel'], text:"#{e}\n君のリストが空か、ID登録されてない。cinitした？"
rescue SQLite3::ConstraintException => e
   client.message channel: data['channel'], text:"#{e}\n君のIDもうあるよ。caddで追加、cshowで確認"
rescue => e
    client.message channel: data['channel'], text: e

end
end

client.start!
