require "rubygems"
require "tire"
require "time"
require "crack"



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
Tire.index 'news' do
  random_hashes.each{|hash|
    if(articles.size>200)
      import articles
      articles=[]
    end
    hash["title"]= hash.delete("article_title")
    body= hash.delete("article_text")
    sum = hash.delete("article_summary")
    
    hash["body"]=body||sum
    hash["summary"]=sum
    hash["created_at"]=Date.parse(hash.delete("article_date")).strftime("%FT%TZ") rescue nil
    hash["source"]=hash.delete("feed")
    hash["id"]= Digest::MD5.hexdigest("#{hash["source"]}_#{hash["title"]}")
    hash["_type"]="article"
    articles.push(hash)
  }
  puts articles
  import articles
end
Tire.index 'news' do
  refresh
end

