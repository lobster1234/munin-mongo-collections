#!/usr/bin/ruby
# Munin plugin for Mongo Collection Document Sizes
require 'rubygems'
require 'mongo'
#get the database here
db = Mongo::Connection.new("localhost",27017).db(ENV['dbname']);
#check if the server is requesting a config or data
if ARGV.size != 0 && ARGV[0].eql?("config")
        db.collection_names.each{|collection|
                coll = db.collection(collection)
                sanitized = collection.gsub('.','?') #Since Munin does not like periods here
                puts sanitized+".label "+ collection
                puts sanitized+".min 0"
                puts sanitized+".max 3000000"
                puts sanitized+".draw LINE1"
                puts sanitized+".type GAUGE"
                puts sanitized+".info Number of documents in " + collection
        }
        puts "graph_title MongoDB Collections in #{ENV['dbname']}"
        puts "graph_args --base 1000"
        puts "graph_vlabel documents"
        puts "graph_category MongoDB"
else #output the data here
                db.collection_names.each{ |collection|
                coll = db.collection(collection)
                puts collection.gsub('.','?')+'.value '+coll.count.to_s
        }
end

#Add this to your /etc/munin/plugin-conf.d/munin-node
#[mongo*]
#env.dbname test #Replace test with your database name!
                        
