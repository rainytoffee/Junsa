require 'open-uri'
require 'nokogiri'
require 'addressable/uri'

class Rawdata
  def initialize(series)

    case series
    when "ACC"||"ACCY"
      @url_accys = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_アクセサリ").normalize
      @noko_accys = Nokogiri::HTML(open(url_accys)).xpath("//table[@id='content_block_2']/tr")
    else
      @domain = "https://xn--ffrk-8i9hs14f.gamematome.jp"
      @url_weapons_rarity5 = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_レア5_#{series}").normalize
      @url_weapons_rarity6 = Addressable::URI.parse("https://ffrk攻略.gamematome.jp/game/780/wiki/装備品_レア6_#{series}").normalize
      @noko_weapons_rarity5 = Nokogiri::HTML(open(url_weapons_rarity5)).xpath("//*[@id='content_block_2']/tr/td")
      @noko_weapons_rarity6 = Nokogiri::HTML(open(url_weapons_rarity6)).xpath("//*[@id='content_block_2']/tr/td")
    end
  end
  attr_reader :url_accys, :url_weapons_rarity5, :url_weapons_rarity6, :noko_accys, :noko_weapons_rarity5, :noko_weapons_rarity6, :domain
end
