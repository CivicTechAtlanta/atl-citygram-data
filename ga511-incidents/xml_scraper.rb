require 'pry'
require 'csv'
require 'mechanize'

mechanize = Mechanize.new

items=mechanize.get('http://cdn.511ga.org/RSS/incidents.xml').search('item')

CSV.open("./file.csv", "wb") do |csv|
  csv << ["Event_ID","Title","Lat","Long","Description"]
  items.each do |item|
    guid = item.search("guid").text
    title = item.search("title").text
    link = item.search("link").text
    lats_longs=(link.scan(/(-?\d{2}.\d{6})/)).flatten
    description = (item.search("description").text).delete("<br>")
    csv << [guid,title,lats_longs[0],lats_longs[1],description]
  end
  binding.pry
end