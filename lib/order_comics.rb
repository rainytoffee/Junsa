require 'nokogiri'
require 'open-uri'
require './todays_comic'


class COrder
    class << self
    #漫画発売日用DBがなければつくる、すでにあれば開く
    @@comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
    #テーブルもつくる、if not exists付
    @@comics.do("create table if not exists reg_c_table (
        user    varchar(12) unique,
        titles  varchar(30)
        );")

    def cinit(user)
        @@comics.do("insert into reg_c_table values (
        '#{user}',
        ''
        ); ")
      "ハロー、#{user} 。あなたの名前でリストをつくります。すでにあれば保持します。"
      #else
      #  return "きみのIDたぶんもうあるよ"
    end


    def add(user,new_title)
      @@comics.do("update reg_c_table set titles=titles||',#{new_title}' where user='#{user}';")
      exe = @@comics.execute( "select * from reg_c_table where user='#{user}';" )
      exe.each do |row|
        updated_titles = row["titles"].gsub(/^,/,"")
        @@comics.do("update reg_c_table set titles='#{updated_titles}' where user='#{user}';")
      end
    return "追加: #{new_title}"
    end

    def remove_all_title(user)
      @@comics.do ( "update reg_c_table set titles='';" )
      return "全タイトル削除しました"
    end

    def remove_title(user,title)
      exe = @@comics.execute ( "select * from reg_c_table where user='#{user}';" )
      exe.each do |row|
        user = row["user"]
        updated_titles = row["titles"].gsub("#{title}","").gsub(/^,/,"").gsub(/,$/,"").gsub(/,,/,",")
        @@comics.do("update reg_c_table set titles='#{updated_titles}' where user='#{user}';")
      end
      return "削除: #{title}"
    end

    def show_table(user)
      exe = @@comics.execute ( "select * from reg_c_table where user='#{user}';" )
      exe.each do |row|
        user = row["user"]
        titles = row["titles"]
        return "ID登録が必要です。cinitをつかってください。" if user == ""
        return "#{user} に関連付けられたタイトルはありません。cadd <TITLE>でタイトルを追加しろ。" if titles == ""
        return "#{user}さんのおたのみリスト\n#{titles}"
      end
    end

    def which_do_you_like(user)
      exe = @@comics.execute ( "select * from reg_c_table where user='#{user}';" )
      exe.each do |row|
        #user = row["user"]
        return row["titles"]
      end
    end

    def title_matcher(user) #今日発売のリストと個人リストを照らし合わせます
      cmanager = ComicManage.new

      todays_titles = cmanager.search_today_titles
      ind_titles = which_do_you_like(user).split(",")

      matched_titles = Array.new
      result = String.new

      ind_titles.each do |ot|
      matched_titles << todays_titles.find_all { |tt| tt =~ /#{ot}/ }
    end

      matched_titles.flatten.each do |t|
          result << "#{t}、本日発売！\n"
        end
=begin
      return_titles(user).split(",").each do |t|
        if say.include?(t)
          result << "#{t}、本日発売！\n"
        end
      end
=end
      return "今日はろくなものが発売されません" if result.empty?
      return result
    end

    def shout
    end


  end

end
