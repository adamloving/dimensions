require 'indextank'

namespace :searchify do

  task :index => :environment do

    # Obtain an IndexTank client
    index = Dimensions::SearchifyApi.instance.indexes(APP_CONFIG['searchify_index'])
    
    FeedEntry.find_each do |entry|
      begin
        if entry.localized?
          raise("Entry has no locations") if entry.primary_location.nil?
          puts entry.index_in_searchify(index) ? "[\033[32mSuccesfully indexed #{entry.name}\033[0m]": "[\033[31m#{entry.name} has no latitude and longitude #{serialized_hash}\033[0m]"
        end
      rescue
        puts "[\033[31mError: #{$!}\033[0m]"
      end
    end
  end

  task :create_index => :environment do
    raise("Usage: rake searchify:create_index INDEX_NAME=<INDEX_NAME>") if ENV["INDEX_NAME"].nil?
    index = Dimensions::SearchifyApi.instance.indexes(ENV['INDEX_NAME'])
    index.add()

    print "\033[33mWaiting for index to be ready\033[0m"

    while not index.running?
        print "\033[32m.\033[0m"
        STDOUT.flush
        sleep 0.5
    end
    print "\\n"
    STDOUT.flush   
  end

  task :clean_index => :environment do
    raise("Usage: rake searchify:clean_index INDEX_NAME=<INDEX_NAME>") if ENV["INDEX_NAME"].nil?
    index = Dimensions::SearchifyApi.instance.indexes(ENV['INDEX_NAME'])

    FeedEntry.find_each do |entry|
      begin
        puts "===================================================================================="
        index.document(entry.id).delete
        puts "Succesfully removed #{entry.name}."
        puts "==================================================================================="
      rescue
        puts "Error: #{$!}"
      end
    end
  end

  task :delete_index => :environment do
    raise("Usage: rake searchify:delete_index INDEX_NAME=<INDEX_NAME>") if ENV["INDEX_NAME"].nil?
    begin
      index = Dimensions::SearchifyApi.instance.indexes(ENV['INDEX_NAME'])
      index.delete
      puts "Deleting index [ \033[32mDONE\033[0m ]"
    rescue IndexTank::NonExistentIndex => e
      puts " [ \033[31mIndex doesn't exist\033[0m ]"
    end
  end
end
