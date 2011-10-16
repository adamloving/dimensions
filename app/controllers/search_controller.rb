 class Article
  
  end
require "pp"
class SearchController < ApplicationController
   def index
    #build our main searcher tags or search text
   if(params["tag"] || params["search"])
     s=""
     s+="("+params["tag"].to_s.split(",").join(" OR ")+") #{'AND' if params["search"]} " if params["tag"]
     s+= " "+params["search"] if params["search"]
     match={"query_string"=>{
"fields"=> [ "no_tag_body" ], "query"=> s, "use_dis_max"=> true}}
       
     # match = {"and"=>[{ "text" => { "body"=> { "query"=> params["tag"].to_s.split(",").join(" "), "operator"=> "or" } } }, { "text_phrase" => { "body" => { "query" => params["search"].to_s} } }]}
    else
      match = {"match_all"=>{}}
    end
    geo_box = nil
    if(false && params["sw_long"])
      geo_box= {"geo_bounding_box"=>
        {"article.location"=>{"top_left"=>[params["sw_long"].to_f,params["ne_lat"].to_f ], "bottom_right"=>[params["ne_long"].to_f,params["sw_lat"].to_f]}}}
    end
    date_range=nil
    if(params["start_date"] || params["end_date"])
      #d= Date.parse("2011-10-15T21:56:10.678Z")
      #pp params
      date_range={
        "range"=> {
        "created_at"=> {
          "from"=> DateTime.parse(CGI.unescape(params["start_date"])).new_offset(0).strftime("%FT%TZ"),
          "to"=>(DateTime.parse(CGI.unescape(params["end_date"])).new_offset(0).strftime("%FT%TZ") rescue DateTime.now.new_offset(0).strftime("%FT%TZ"))
          }
        }
      }
    end
    owner=nil
    if(params["owner"] )
      owner={
        "terms"=> {
        "owner"=> params["owner"].split(",")
      }
      }
    end
    sources=nil
    if(params["source"] )
      sources={
        "terms"=> {
          "source"=> params["source"].split(",")
        }
      }
    end
    querys = [geo_box,date_range].compact
    if(querys.size==1)
      querys = querys.first
    else
      querys= {"and"=>querys}
    end
    facets = {
      "tags" => { "terms" => {"field" => "no_tag_body","size"=>30} },
      "source_tags" => { "terms" => {"field" => "tag","size"=>30} },
      "topics" => { "terms" => {"field" => "topics","size"=>30} },
      "articles" => {
        "date_histogram" => {
          "field" => "created_at",
          "interval" => "hour"
        }
      }
    }

    size = (params[:size]||25).to_i
    from = params["page"].to_i * size
    #real search json
    match["filtered"]= {
            "filter"=>querys} if !querys["and"] || querys["and"].size>0

    qu = {"size"=>size,
      "from"=>from,
      "facets"=>facets,
      "query"=>match,
      "sort"=>[{"created_date"=>{"reverse"=>true}}],
     "version"=>true
      
   }
    Tire.configure do
      url "http://107.22.249.45:9200/"#TODO:make config
    end
    puts JSON.generate(qu)
    @results = Tire.search("news",qu)
    #ruby do what i want coding
    r=@results.instance_variable_get(:@response)
    facets = {}
r["facets"].each{|k,v| facets[k]=v["terms"]}
    render :json=>{:results => r["hits"]["hits"].map{|x| x["_source"]},:facets=>r["facets"],:page=>from,:total_results=>@results.total,:size=>size}
  end

  def article
    qu= {"query"=>{
      "ids" => {
        "values" => params["ids"].split(",")
      }
      } 
    }
    Tire.configure do
      url "http://107.22.249.45:9200/"#TODO:make config
    end

    @results = Tire.search("news",qu)
    r=@results.instance_variable_get(:@response)
    
    render :json=>{:results =>  r["hits"]["hits"]}
  end
end
