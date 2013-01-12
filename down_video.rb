require 'nokogiri'
require 'open-uri'
require 'logger'

module Soku
  class Video
    attr_accessor :title, :url, :user, :duration, :upload_time, :play_cnt
  end

  def self.search( keyword )
    search_url = "http://www.soku.com/search_video/q_#{keyword}"
    videos = []
    open(URI::encode(search_url)) do |result|
      doc = Nokogiri::HTML(result)
      # a "ul" with class "v" contains a search result
      doc.css('ul[class=v]').each do |ul|
        video = Video.new
        video.title       = ul.css('li.v_title').css('a')[0]['title'].strip  #css always returns a array so need [0]
        video.url         = ul.css('li.v_title').css('a')[0]['href'].strip  
        video.user        = ul.css('li.v_user').css('a').text.strip
        video.duration    = ul.css('li.v_time').css('span.num').text.strip
        video.upload_time = ul.css('li.v_pub').css('span').text.strip
        video.play_cnt    = ul.css('li.v_stat').css('span.num').text.strip
        puts video.inspect
        videos << video
      end
    end
    return videos
  end
end
module Flvcd
  def self.convert( url )
    convert_service = "http://www.flvcd.com/parse.php?format=&kw=#{url}"
    open(URI::encode(convert_service)) do |result|
      doc = Nokogiri::HTML(result, nil, 'gb2312')
          doc.css('a')[6]['href']
          #get url
          #download video 
          #exec "wget -U Mozilla #{final_url} -O #{search_word}'_video'"}
    end
  end
end
module AdditionInfo
  class File
    attr_accessor :filename
  end
  def self.information( content )
    Logger.new('info.yml').info content
  end
end


videos = Soku::search("ruby")
    title = videos[0].title # use the first for test
    url = videos[0].url
    user = videos[0].user
    duration = videos[0].duration
    upload_time = videos[0].upload_time
    play_cnt = videos[0].play_cnt
    flvcd_url=Flvcd::convert( url )
content="\n"+'video info:'+"\n"+'title: '+title+"\n"+'url: '+url+"\n"+'user: '+user+"\n"+'duration: '+duration+"\n"+'upload time: '+upload_time+"\n"+'play cnt: '+play_cnt+"\n"+'flvcd url: '+flvcd_url    
info=AdditionInfo::information(content)

