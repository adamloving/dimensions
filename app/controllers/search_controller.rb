 class Article
  
  end

class SearchController < ApplicationController
   def index
    #build our main searcher tags or search text
   if(params["tags"])
      match = { "text" => { "body" => { "query" => params["tags"], "operator" => "or" } } }
    elsif(params["search"])
      match = { "text_phrase" => { "body" => { "query" => params["search"], "operator" => "or" } } }
    else
      match = {"match_all"=>{}}
    end
    geo_box = nil
    if(params["sw_long"])
      geo_box= {"geo_bounding_box"=>
        {"location"=>{"top_left"=>[params["sw_long"].to_f,params["ne_lat"].to_f ], "bottom_right"=>[params["ne_long"].to_f,params["sw_lat"].to_f]}}}
    end
    date_range=nil
    if(params["start_date"] || params["end_date"])
      date_range={
        "range"=> {
        "created_at"=> {
          "from"=> Date.parse(params["start_date"]).strftime("%FT%TZ"),
          "to"=>(Date.parse(params["end_date"]).strftime("%FT%TZ") rescue Time.now.strftime("%FT%TZ"))
          }
        }
      }
    end
    owner=nil
    if(params["owner"] )
      owner={
        "terms"=> {
        "owner"=> params["owner"]
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
    querys = [geo_box,date_range,owner,sources].compact
    if(querys.size==1)
      querys = querys.first
    else
      querys= {"and"=>querys}
    end
    facets = {
      "tags" => { "terms" => {"field" => "body"} },
      "articles" => {
        "date_histogram" => {
          "field" => "created_at",
          "interval" => "hour"
        }
      }
    }

    size = (params[:size]||10).to_i
    from = params["page"].to_i * size
    #real search json
    qu = {"size"=>size,
      "from"=>from,
      "facets"=>facets,
      "query"=>
       {"filtered"=>
          {
            "filter"=>querys,
            "query"=>match
          }
      }
    }
    Tire.configure do
      url "http://107.22.249.45:9200/"#TODO:make config
    end
    @results = Tire.search("news",qu)
    render :json=>{:results => @results.results,:facets=>@results.facets}
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
    puts  @results.results
    render :json=>{:results => @results.results}
  end
end
