require 'faraday'
require 'json'


def lee(args)
# "+東京 +台湾 -札幌"
  positives =[]
  negatives =[]
  say = String.new

  args = args.split
  #["+東京","+台湾","-札幌"]

  args.each do |arg|
    if arg.match(/\+/)
      positives << arg.gsub("+","")
    elsif arg.match(/-/)
      negatives << arg.gsub("-","")
    else
      return "クエリに+か-つけてね"
    end
  end

res = Faraday.get "https://bridgehead.co/api/similar?api_key=#{ENV["SIMILAR_API_KEY"]}&positive=#{positives.join(",")}&negative=#{negatives.join(",")}"

body = JSON.parse(res.body)

body["similarity"].each do |line|
say << "#{line.to_s.gsub(","," -> ").gsub("\"","")}\n"
end

say

end
