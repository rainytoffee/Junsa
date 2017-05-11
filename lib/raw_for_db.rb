require 'open-uri'
require 'nokogiri'
require 'addressable/uri'
require 'dbi'
require 'sqlite3'

class Rawdata_all
  attr_reader :raw, :dbh
  def initialize
    @dbh = DBI.connect('DBI:SQLite3:ffrk.db')
    #@normalized_domain = "https://xn--ffrk-8i9hs14f.gamematome.jp"
    rarity_ary    = ["レア3","レア4","レア5","レア6"]
    series_ary    = ["FF1","FF2","FF3","FF4","FF5","FF6","FF7","FF8",
                     "FF9","FF10","FF11","FF12","FF13","FF14","FF15",
                     "零式","外伝","ジョブ","その他"]
    @raw = []
    rarity_ary.each do |rarity|
      series_ary.each do |series|
        url_eqps = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_#{rarity}_#{series}").normalize
        begin
             jump_ndividuals = Nokogiri::HTML(open(url_eqps)).xpath("//*[@id='content_block_2']/tr/td[2]")
        rescue;next;end
              jump_ndividuals.each do |item|
                p item
        begin
               @raw << Roughneck::snatch_and_build(:weapon,item)

        rescue;next;end
          end
        end
      end
  end

    def update_ffrk_db
        rebuild_table
        insert_values
    end

    def rebuild_table #新規作成もこれで
      @dbh.do("drop table if exists ffrk")
      @dbh.do("create table ffrk(
      name              text,
      series            text,
      rarity            text,
      p_atk             int,
      p_atk_limit       int,
      p_def             int,
      p_def_limit       int,
      m_atk             int,
      m_atk_limit       int,
      m_def             int,
      m_def_limit       int,
      mental            int,
      mental_limit      int,
      dodge             int,
      accuracy          int,
      finisher          text,
      reinforce         text,
      img_url           text);")
    end

    def insert_values
      @raw.each do |item|
        p item
        @dbh.do("insert into ffrk values (
        '#{item.name}',
        '#{item.series}',
        '#{item.rarity}',
        '#{item.p_atk}',
        '#{item.p_atk_limit}',
        '#{item.p_def}',
        '#{item.p_def_limit}',
        '#{item.m_atk}',
        '#{item.m_atk_limit}',
        '#{item.m_def}',
        '#{item.m_def_limit}',
        '#{item.mental}',
        '#{item.mental_limit}',
        '#{item.dodge}',
        '#{item.accuracy}',
        '#{item.finisher}',
        '#{item.reinforce}',
        '#{item.img_url}'
        );")
      end
    end
end
