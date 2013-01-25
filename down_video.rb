require 'nokogiri'
require 'open-uri'
require 'logger'
require 'yaml'

VIDEOS = "videos.yml"

module Flvcd
  # get the download link from play link using the service provided by Flvcd
  def self.convert( url )
    convert_service = "http://www.flvcd.com/parse.php?format=&kw=#{url}"
    open(URI::encode(convert_service)) do |result|
      doc = Nokogiri::HTML(result, nil, 'gb2312')
      return doc.css('a')[6]['href']
    end
  end
end

module Soku
  class Video
    attr_accessor :title, :url, :user, :duration, :upload_time, :play_cnt, :flvcd_url
  end

  def self.search( keyword )
    search_url = "http://www.soku.com/search_video/q_#{keyword}"
    videos = []
    open(URI::encode(search_url)) do |result|
      doc = Nokogiri::HTML(result)
      # a "ul" with class "v" contains a search result
      doc.css('ul[class=v]').each_with_index do |ul, index|
        video = Video.new
        video.title       = ul.css('li.v_title').css('a')[0]['title'].strip  #css always returns a array so need [0]
        video.url         = ul.css('li.v_title').css('a')[0]['href'].strip  
        video.user        = ul.css('li.v_user').css('a').text.strip
        video.duration    = ul.css('li.v_time').css('span.num').text.strip
        video.upload_time = ul.css('li.v_pub').css('span').text.strip
        video.play_cnt    = ul.css('li.v_stat').css('span.num').text.strip
        video.flvcd_url   = Flvcd::convert( video.url )
        videos << video
        #puts "%4s : [ %s ]" % [index, video.title]
      end
    end
    File.open( VIDEOS, "w") do |io| 
        Psych.dump( videos, io) 
    end 
    puts "Pls see result at #{VIDEOS}"
  end
end

# The module is used to match and get the final downloadable url 
module DownloadableUrl
  def self_generate( content )
      Logger.new('log.yml').info content
  end
end
  class Regexp
  def scan str
    Enumerator.new do |y|
      str.scan(self) do
        y << Regexp.last_match
      end
    end
  end
end
Soku::search("ruby")
video_yml = YAML::load(File.open("#{VIDEOS}")) 
start_indexs = /http:\/\/f/.scan(video_yml.to_s).map{|m| m.offset(0)[0]}
start_indexs.each do |get_urls|
puts final_urls = video_yml.to_s[get_urls,154]

# TODO: download video using flvcd_url in VIDEOS 

#exec "wget -U Mozilla #{VIDEOS.flvcd_url} -O #{title}'_video'"
end