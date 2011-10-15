require "rubygems"
require "tire"
require "net/http"
require "pp"
require "uri"
require "date"
require "time"
if(ARGV[0])
  host=ARGV[0]
else
  host="http://localhost:9200"
end

articles=[]
puts host
Tire.configure do
  url host
end
Tire.index 'news' do
  create :mappings=>{
    "article" => {
        "date_formats" => ["yyyy-MM-dd", "dd-MM-yyyy","basic_date_time_no_millis"],
        "_all" => {"enabled" => true},
        "properties" => {
            "_id" => {"index"=> "not_analyzed", "store" => "yes",:type=>'string'},
            "title" =>  {"type" => "string", "store" => "yes","analyzer"=>"standard","char_filter"=>["html_strip"]},
            "body" =>  {"type" => "string", "store" => "yes","analyzer"=>"standard","char_filter"=>["html_strip"]},
            "summary"=> {"type" => "string", "store" => "yes"},
            "photo_url" =>  {"type" => "string", "store" => "yes"},
            "article_link"=>  {"type" => "string", "store" => "yes"},
            "location" => {
                "type" => "geo_point"
            },
            "created_at"=>{"type" => "date"},
            "address"=>{"type"=>"string"},
            "city"=>{"type"=>"string"},
            "zipcode"=>{"type"=>"string"},
            "owner" => {"type" => "string"},
            "source"=>{"type"=>"string"},
            "tags" =>  {"type" => "string"},
            "topics" =>  {"type" => "string"},
            
        }
    }
  }
end
