require 'csv'
require 'date'
require 'nokogiri'
require 'json'
require 'net/http'
require "crack"

class CityEvents

	def initialize
		puts "initializing..."
		data = Net::HTTP.get_response(URI.parse('http://feeds.feedburner.com/ThingsToDoInAtlanta?format=xml')).body
		xml = Crack::XML.parse(data)
		puts xml.to_json
		# JSON.pretty_generate(Hash.from_xml(s).to_json)
		
    	# @xml_events_feed = 'http://feeds.feedburner.com/ThingsToDoInAtlanta?format=xml'
  	end

	def get_events
		
		puts "Getting events"
	end

end

events = CityEvents.new
events.get_events