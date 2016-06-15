# atl-citygram-data
Scraping &amp; Collecting data to plug in to the [Atlanta Citygram App](www.github.com/codeforatlanta/citygram)

### What is Citygram?
Code For America developed the [Citygram App](http://www.citygram.org) to "subscribe to your city": providing a clean, reliable, customizable interface for people to get notifications of city-related location-specific events relevant to them.  Once the app is up and running for Atlanta, we'll be able to show Atlanta government personnel a clean platform to make open data useful, somewhat centralized, and exciting.

Code For Atlanta has 2 main github repos for this project:
- App (forked repo from Code For America): www.github.com/codeforatlanta/citygram
- Data (this repo)
    - Each data source will be stored in a subfolder in this repo.  Include the scraping/cleaning/munging code as well as the cleaned data, and whatever other files you need.  Any language welcome.  As of 6/15/16 we've use Ruby, Python, and R for a couple of the datasets :)

### How to Contribute:
- Join the Code For Atlanta citygram Slack Channel to discuss the project: http://codeforatlanta.slack.com/messages/citygram
- Check out the "Issues" section of this repo for next steps

### Project Phases
1. Get initial datasets & publish to the ATL Socrata Brigade
2. Set up http://github.com/codeforatlanta/citygram with code to map to the datasets on Socrata
3. Submit pull request to load the above into the Code For America citygram repo (this is the step when the app is deployed for Atlanta)

![](images/atl-citygram-data-flow.PNG "ATL Citygram Data Flow")

Code For Atlanta Open Data Brigade: https://brigades.opendatanetwork.com/brigade?brigade=Code%20for%20Atlanta
Image source (citygram getting started wiki): https://github.com/codeforamerica/citygram/wiki/Getting-Started-with-Citygram
