require 'slack-ruby-bot'
require './trans_j-a'
require './mog_trans_j-a'
require './nanj_trans_j-a'
require './iyango'
require './next_holiday'

class Junsa < SlackRubyBot::Bot

  help do
     title 'JUNSA'
     desc 'PRIORITY IS HIGH.'

     command 'jtoa <ひらがな>' do
       desc '日本語をアルベド語に変換します。'
     end

     command 'atoj <カタカナ>' do
       desc 'アルベド語を日本語に変換します。'
     end

     command 'mog_jtoa <ひらがな>' do
       desc '日本語をアルベド語に変換します。<モグ用>'
     end

     command 'mog_atoj <カタカナ>' do
       desc 'アルベド語を日本語に変換します。<モグ用>'
     end

     command 'nanj_jtoa <ひらがな>' do
       desc '日本語をアルベド語に変換します。<ンゴ用>'
     end

     command 'nanj_atoj <カタカナ>' do
       desc 'アルベド語を日本語に変換します。<ンゴ用>'
     end

     command 'next_holiday' do
       desc "内閣府CSVの息吹"
     end

     command '来なさい||来るんだ' do
       desc 'pull doge'
     end
   end

#commandは被自己@id信じゃないと反応しない
=begin  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end
=end

#matchは全体の発言に反応
  match /^jtoa (.+)/ do |client, data, match|
    client.say(channel: data.channel, text: Albhed.translate(match[1], :a))
  end

  match /^atoj (.+)/ do |client, data, match|
    client.say(channel: data.channel, text: Albhed.translate(match[1], :j))
  end

  match /^mog_jtoa (.+)/ do |client, data, match|
    client.say(channel: data.channel, text: Albhed_Mog.mog_translate(match[1], :a))
  end

  match /^mog_atoj (.+)/ do |client, data, match|
    client.say(channel: data.channel, text: Albhed_Mog.mog_translate(match[1], :j))
  end

  match /^nanj_jtoa (.+)/ do |client, data, match|
    client.say(channel: data.channel, text: Albhed_Nanj.nanj_translate(match[1], :a))
  end

  match /^nanj_atoj (.+)/ do |client, data, match|
    client.say(channel: data.channel, text: Albhed_Nanj.nanj_translate(match[1], :j))
  end

  match /^How is the weather in (?<location>\w*)\?$/ do |client, data, match|
    client.say(channel: data.channel, text: "The weather in #{match[:location]} is nice.")
  end

  match /酸の海/ do |client, data, match|
    client.say(channel: data.channel, text: "溶ける～")
  end

  match /かしこい|賢い/ do |client, data, match|
    client.say(channel: data.channel, text: "照れる～")
  end

  match /長いものには$/ do |client, data, match|
    client.say(channel: data.channel, text: "巻かれる～")
  end

  match /ねむい/ do |client, data, match|
    client.say(channel: data.channel, text: "ねむれる～？")
  end

  match /かわいい/ do |client, data, match|
    client.say(channel: data.channel, text: "そういうのは大丈夫です")
  end

  match /攻略/ do |client, data, match|
    client.say(channel: data.channel, text: "あっあっあっ")
  end

  match /温水洋一/ do |client, data, match|
    client.say(channel: data.channel, text: "けったくそわるい")
  end

  match /疲れた/ do |client, data, match|
    client.say(channel: data.channel, text: "つかれた～")
  end

  match /巡査ちゃんのせい/ do |client, data, match|
    client.say(channel: data.channel, text: "ごめんね～")
  end

  match /だけじゃねえか/ do |client, data, match|
    client.say(channel: data.channel, text: "そんなことないですけど？")
  end

  match /クロちゃん/ do |client, data, match|
    client.say(channel: data.channel, text: "似てる～？")
  end

  match /きれそう|キレそう|戦争/ do |client, data, match|
    client.say(channel: data.channel, text: "戦争、戦争しかない")
  end

  match /0[1-9]\d{0,3}[-(]\d{1,4}[-)]\d{3,4}/ do |client, data, match|
    client.say(channel: data.channel, text: "あっ個人情報ですね")
  end

  match /きたく|きたっく|^戻り$|帰ってきた|かえってきた|帰宅|ただいま|^戻った$/ do |client, data, match|
    client.say(channel: data.channel, text: "おかえり～")
  end

  match /かえる|帰る|かえろ|帰ろ|帰ります|かえります|帰れません|帰りたい|帰れない/ do |client, data, match|
    client.say(channel: data.channel, text: "もうかえるぞ！")
  end

  match /行ってくる|いってくる|行ってきます|いってきます/ do |client, data, match|
    client.say(channel: data.channel, text: "発進！")
  end

  match /鍵忘れ/ do |client, data, match|
    client.say(channel: data.channel, text: "ポケットみた？")
  end

  match /鍵.*あった|鍵.*持って/ do |client, data, match|
    client.say(channel: data.channel, text: "な")
  end

  match /準備いい|準備できた|準備OK|準備ok|準備おｋ|準備おっけ/ do |client, data, match|
    client.say(channel: data.channel, text: "いいぞ")
  end

  match /いくぞ|行くぞ|いきますよ|行きますよ/ do |client, data, match|
    client.say(channel: data.channel, text: "おやつ買ってきて")
  end

  match /来なさい|来るんだ/ do |client, data, match|
    client.say(channel: data.channel, text: pull_dog)
  end

  match /next_holiday/ do |client, data, match|
    client.say(channel: data.channel, text: holiday )
  end


end

  Junsa.run
