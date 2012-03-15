require 'indextank'

namespace :searchify do

  task :index => :environment do

    # Obtain an IndexTank client
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_indices']['locations'])
    
    FeedEntry.find_each do |entry|
      begin
        if entry.localized?
          raise("Entry has no locations") if entry.entities.locations.first.nil?
          serialized_hash = entry.entities.locations.first.serialized_data
          if serialized_hash["latitude"] && serialized_hash["longitude"]
            puts "====================================================================================="
            location = {0 => serialized_hash["latitude"], 1 => serialized_hash["longitude"]}
            index.document(entry.id).add(:text => entry.name, :variables => location.to_s)
            entry.tag
            entry.save
            puts "Succesfully indexed #{entry.name}"
            puts "With latitude: #{location[0]}, longitude: #{location[1]}"
            puts "==================================================================================="
          else
            puts "==================================================================================="
            puts "#{entry.name} has no latitude and longitude #{serialized_hash}"
            puts "==================================================================================="
          end
        else
          puts "This entry is already processed #{entry.name}"
        end
  
      rescue
        puts "Error: #{$!}"
      end
    end
  end

  task :create_index => :environment do
    raise("Usage: rake searchify:create_index INDEX_NAME=<INDEX_NAME>") if ENV["INDEX_NAME"].nil?
    index = Dimensions::SearchifyApi.instance.indexes(ENV['INDEX_NAME'])
    index.add()

    print "Waiting for index to be ready"

    while not index.running?
        print "."
        STDOUT.flush
        sleep 0.5
    end
    print "\\n"
    STDOUT.flush   
  end

end
