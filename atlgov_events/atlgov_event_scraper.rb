require 'csv'
require 'mechanize'
require 'date'

class CityEvent

  def initialize file_name
    @base = 'http://www.atlantaga.gov/'
    @file_name = file_name
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
    events = []
    @event_list.each_with_index do |x,i|
      date = parse_date((@date_list[i].text).strip)
      event = (x.css('a').text).strip
      time = parse_time((x.css('span').text).strip)
      link = (@base + x.children[3]['href']).strip
      events.push(event, date, time, link)
    end
    return events
  end

  def parse_time(line)
    if line =~ /\d+:\d+\W(am|pm)/i
      line = line[/\d+:\d+\W(am|pm)\s-\s\d+:\d+\W(am|pm)/i]
    else
      p "error"
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
    todays_date = Time.now
    if todays_date.year >= event_date.year
      year = todays_date.year + 1
    else
      year = event_date.year
    end
    return year
  end

## In next iteration will change output to CSV upon getting clarification on mapping coordinates
  def output data
    file = File.open(@file_name, "w" )
    file << data
  end


  def get_event
    event_page
    find_events
    data = parse_event
    output data
  end
end

event = CityEvent.new "./output.txt"
event.get_event

