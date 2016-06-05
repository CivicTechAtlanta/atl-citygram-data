# Import BeautifulSoup, urllib.request, and csv modules
from bs4 import BeautifulSoup
import urllib.request
import csv

# Scrape xml file using BeautifulSoup
construction_xml = urllib.request.urlopen('http://cdn.511ga.org/RSS/construction.xml').read()
soup = BeautifulSoup(construction_xml, "xml")

# Create BeautifulSoup object containing individual construction events
items = soup.find_all("item")
scheduled_construction = {}

# Build Python dict with guid as keys for nested dictionaries
# Nested dictionaries contain link, title, description
for item in items:
    scheduled_construction[item.guid.get_text()] = {}
    link = item.link.get_text()
    scheduled_construction[item.guid.get_text()]["link"] = link
    title = item.title.get_text()
    scheduled_construction[item.guid.get_text()]["title"] = title
    description = item.description.get_text()
    scheduled_construction[item.guid.get_text()]["description"] = description

# NEED TO ADD: Automated extraction and format of coordinates: (lat, lon)
# ALSO: NEED TO CLEAN UP ALL DATA THAT APPEARS IN 

# Write info from Python dict to CSV file
with open("scheduled_construction.csv", "w") as toWrite:
    writer = csv.writer(toWrite, delimiter=",")
    writer.writerow(["guid", "title", "link", "description"])
    for a in scheduled_construction.keys():
        writer.writerow([a.encode("utf-8"), scheduled_construction[a]["title"], scheduled_construction[a]["link"], scheduled_construction[a]["description"]])