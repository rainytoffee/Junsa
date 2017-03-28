require 'nokogiri'
require 'open-uri'
require 'date'
require './todays_comic'


class COrder
    class << self
    #漫画発売日用DBがなければつくる、すでにあれば開く
    @@comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
    #テーブルもつくる、if not exists付      ########↓スペース必須#######
    @@comics.do("create table if not exists reg_c_table (
        user    varchar  not null,
        titles  varchar  not null
        );")

    def register(user,baggage)
      @@comics.do("insert into reg_c_table values (
        '#{user}',
        '#{baggage}'
        );")
    end

    def add(user,new_title)
      @@comics.do("update reg_c_table set titles=titles||',#{new_title}' where user='#{user}';")
      "追加: #{new_title}"
    end

    def remove_all_title(user)
      @@comics.do ( "delete from reg_c_table where user = '#{user}';" )
      "全タイトル削除しました"
    end

    def remove_title(user,title)
      exe = @@comics.execute ( "select * from reg_c_table where user='#{user}';" )
      exe.each do |row|
        user = row["user"]
        updated_titles = row["titles"].gsub("#{title}","").gsub(/^,/,"").gsub(/,$/,"").gsub(/,,/,",")

        @@comics.do("update reg_c_table set titles='#{updated_titles}' where user='#{user}';")
      end
      "削除: #{title}"
    end


    def show_table(user)
      exe = @@comics.execute ( "select * from reg_c_table where user='#{user}';" )
      exe.each do |row|
        user = row["user"]
        titles = row["titles"]
        return "You need register [cinit TITLE] command) before use cshow command." if user == ""
        return "You have no titles.Use [cadd TITLE] command for tip tip la la." if titles == ""
        return "#{user}->#{titles}"
      end
    end
  end
end
