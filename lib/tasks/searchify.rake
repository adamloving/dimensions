require 'indextank'

namespace :searchify do

  task :index => :environment do

    # Obtain an IndexTank client
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_indices']['locations'])
    
    FeedEntry.find_each do |entry|
      begin
        if entry.localized?
          puts "======================================================================"
          raise("Entry has no locations") if entry.entities.locations.first.nil?
          serialized_hash = entry.entities.locations.first.serialized_data
          length = serialized_hash.length
          keys = 0.upto(length - 1).to_a
          location = Hash[[keys, serialized_hash.values].transpose]
          index.document(entry.id).add(:text => entry.name, :variables => location.to_s)
          entry.tag
          entry.save
          puts "Succesfully indexed #{entry.name}"
          puts "======================================================================"
        else
          return nil
        end
  
      rescue
        print "Error: ",$!,"\\n"
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
