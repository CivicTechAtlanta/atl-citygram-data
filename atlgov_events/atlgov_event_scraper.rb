require 'csv'
require 'mechanize'
require 'date'
require 'pry'

class CityEvent

  def initialize
    @base = 'http://www.atlantaga.gov/'
    @mechanize = Mechanize.new
  end

  def event_page
    @page = @mechanize.get @base
  end

  def find_events
    @event_list = @page.css('.home_right').css('.box_list').css('.clearfix').css('ul').css('li')
    @date_list = @page.css('.home_right').css('.box_list').css('.clearfix').css('.datebox')
  end

  def parse_event
    events = Array.new
    @event_list.each_with_index do |x,i|
      events << []
      date = parse_date((@date_list[i].text).strip)
      description = (x.css('a').text).strip
      time = parse_time((x.css('span').text).strip)
      link = (@base + x.children[3]['href']).strip
      events[i].push(description, date, time, link)
    end  
    return events
  end

  def parse_time(line)
    if line =~ /\d+:\d+\W(am|pm)/i
      line = line[/\d+:\d+\W(am|pm)\s-\s\d+:\d+\W(am|pm)/i]
    end
  end

  def parse_date(line)
    day = line[0]
    if line[1].to_i > 0
      day << line[1]
    end
    line.delete!(day)
    month = line.strip
    date = month + ' ' + day
    year = which_year(date)
    date += " " + year.to_s
    return date
  end

## The website lacks year in the date so this method determines most likely year of the event
  def which_year(date)
    event_date = Date.parse(date)
    todays_date = Date.parse(Time.now.to_s)
    diff = event_date.month - todays_date.month
    temp = event_date.year
    binding.pry
    if diff.between?(-5,6)
      year = todays_date.year
    elsif diff >= 7
      year = (event_date.year) -1
    elsif diff <=-6
      year = (event_date.year) + 1
    end
    return year
  end

  def get_event
    event_page
    find_events
    data = parse_event
    
    output data
  end

  def output data
    CSV.open("./file_atlgov_events.csv", "wb") do |csv|
      csv << ["Description","Date","Time","Link"]
      data.each do |item|
        csv << item
      end
    end
  end
end
event = CityEvent.new
event.get_event


