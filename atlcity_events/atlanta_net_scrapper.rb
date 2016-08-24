require 'csv'
require 'json'
require 'net/http'
require "crack"
require "csv"

class CityEvents

	def initialize
		# Get data from feed, parse XML, and convert to JSON
		data = Net::HTTP.get_response(URI.parse('http://feeds.feedburner.com/ThingsToDoInAtlanta?format=xml')).body
		xml = Crack::XML.parse(data)
		@json_data = JSON.parse(xml.to_json)
  	end

	def get_events
		# Write to CSV file
		CSV.open("./file_atlcity_events.csv", "wb") do |csv|
			csv << ["Description", "PubDate", "Link"]
			@json_data["rss"]["channel"]["item"].each do |event|
				csv << [event["title"], event["pubDate"], event["link"]]
			end
		end
	end

end

events = CityEvents.new
events.get_events