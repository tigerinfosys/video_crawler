require 'net/http'
require 'nokogiri'
require 'open-uri'


home = 'http://www.soku.com/v'
serach_id='keyword'  #search_id indicates the text tag's name in form
until search_word=gets.chomp  #search_word indicates the value you want to use to do serach
end
postit =Net::HTTP.post_form(URI.parse(home), {serach_id=>search_word})

open(home+'?'+serach_id+'='+search_word) do |f|
video_url= f.read.scan(/<a title=".*?" href="(.*?)"/m).first[0].to_s

flvcd_index ='http://www.flvcd.com/parse.php?format=&'
id ='kw'
flvcd_html = flvcd_index+id+'='+video_url
 puts video_url
 puts flvcd_html

page = Nokogiri::HTML(open(flvcd_html))   
puts page.class
final_url=page.css('a')[6]['href']
exec "wget #{final_url}"
end
