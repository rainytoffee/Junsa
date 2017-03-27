require 'nokogiri'
require 'open-uri'
require 'date'
require './todays_comic'

    #漫画発売日用DBがなければつくる、すでにあれば開く
    comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
    #テーブルもつくる、if not exists付      ########↓スペース必須#######
    comics.do("create table if not exists reg_c_table (
        user    varchar  not null,
        titles  varchar  not null
        );")

    def register(user,baggage)
      comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
      comics.do("insert into reg_c_table values (
        \'#{user}\',
        \'#{baggage}\'
        );")
    end

    def add(user,new_title)
      comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
      comics.do("update reg_c_table set titles=titles||\'#{new_title}\' where user=\'#{user}\';")
    end

    def remove_mylist(user)
      comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
      comics.do ( "drop table if exists reg_c_table" )
    end

    def show_table(user)
      comics = DBI.connect( 'DBI:SQLite3:reg_comics.db' )
      exe = comics.execute ( "select * from reg_c_table where user=\'#{user}\';" )
  
      exe.each do |row|
        user = row["user"]
        titles = row["titles"]
        return "#{user}->#{titles}"
      end

    end
