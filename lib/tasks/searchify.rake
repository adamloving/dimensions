require 'indextank'

namespace :searchify do

  task :index => :environment do
    FeedEntry.find_each do |entry|

      if entry.localized?
        puts "======================================================================"
        api = IndexTank::Client.new "http://:8c3vN9XtuEPi53@do1vj.api.searchify.com"
        index = api.indexes "idx"
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
    end
  end
end
