require "rubygems"
require "tire"
require "time"
require "crack"
require "action_view"
include ActionView::Helpers::SanitizeHelper  



#random_hashes=[{"type"=>"article","title"=>"title","body"=>"body one","address"=>"address","created_at"=>(Time.now).strftime("%FT%TZ"),"city"=>"seattle","zipcode"=>"98103","tags"=>[{"name"=>"one"},{"name"=>"tag2"}],"owner"=>"owner","source"=>"source","id"=>"1"}]
if(!ARGV[0] || !File.exist?(ARGV[0]))
  raise "like this: ruby script/es/load_file.rb data/articles.json http://107.22.249.45:9200/"
end
if(ARGV[1])
  host=ARGV[1]
else
  host="http://localhost:9200"
end
random_hashes = Crack::JSON.parse(File.read(ARGV[0]))
articles=[]
Tire.configure do
  url host
end
count = 0 
Tire.index 'news' do
  random_hashes.each{|hash|
    if(articles.size>200)
      import articles
      articles=[]
    end
    count+=1
    hash["title"]= hash.delete("article_title")
    body= hash.delete("article_text")
    sum = hash.delete("article_summary")
    hash["photo_url"]=hash.delete("article_image") 
    hash["body"]=body||sum
    hash["no_tag_body"]=strip_tags(hash["body"].to_s)
    hash["summary"]=sum
    date = nil
    hash["owner"]=["geeks","family","coworkers"][rand(3)]
    hash["created_at"]=(date=DateTime.parse(hash.delete("article_date")).new_offset(0)).strftime("%FT%TZ") rescue nil
    hash["created_date"]=date.to_i if date
    hash["source"]=hash.delete("feed")
    hash["id"]= Digest::MD5.hexdigest("#{hash["source"]}_#{hash["title"]}")
    hash["_type"]="article"
    hash["tags"]=hash.delete("article_tags").to_s.split(",")
    hash["topics"]=hash.delete("article_topics").to_s.split(",")
    if(hash["article_location"])
    lat,long  = hash.delete("article_location").to_s.split(",").map{|x| x.to_f}
    
      puts lat
      puts long 
    hash["location"]=[long,lat] if long && lat<90 && lat>-90 && long>-180 && long<180
    end
    articles.push(hash)
  }
  puts articles
  import articles
end
puts "found"
puts count
Tire.index 'news' do
  refresh
end

