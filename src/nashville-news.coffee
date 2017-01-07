# Description
#   Retrieves news from local RSS feeds.
#
# Commands:
#   hubot news - returns the latest Nashville news
#
# Author:
#   Stephen Yeargin <stephen.yeargin@gmail.com>

# Configure the RSS feeds
RSSFeeds = {
  "tennessean": {
    name: "The Tennessean",
    rss_url: "http://rssfeeds.tennessean.com/nashville/home&x=1"
  },
  "scene": {
    name: "Nashville Scene",
    rss_url: "http://www.nashvillescene.com/feeds/news"
  },
  "wpln": {
    name: "WPLN (Nashville Public Radio)",
    rss_url: "http://nashvillepublicradio.org/news/rss.xml"
  },
  "wtvf": {
    name: "WTVF (CBS)",
    rss_url: "http://www.newschannel5.com/feeds/rssFeed?obfType=RSS_FEED&siteId=100116&categoryId=20000"
  },
  "wkrn": {
    name: "WKRN (ABC)",
    rss_url: "http://wkrn.com/feed/"
  },
  "wsmv": {
    name: "WSMV (NBC)",
    rss_url: "http://www.wsmv.com/category/208528/news?clienttype=rss"
  }
}

cheerio = require 'cheerio'
_ = require 'underscore'

module.exports = (robot) ->
  # Use enhanced formatting?
  isSlack = robot.adapterName == 'slack'

  robot.respond /news$/i, (msg) ->
    msg.send 'Retrieving local news (this may take a bit) ...'
    getAllFeeds(msg)

  ##
  # Gets a Single Feed
  getFeed = (feed, msg) ->
    msg.http(feed.rss_url).get() (err, res, body) ->
      if err
        msg.send "Unable to retrieve feed for #{feed.name}. :cry:"
        return

      $ = cheerio.load(body, { ignoreWhitespace : true, xmlMode : true})

      storyList = []

      # Loop through every item
      $('item').each (i, xmlItem) ->
        # Peel off the top three stories
        if i > 2
          return

        # array to hold each item being converted into an array
        newsItem = []

        # Loop through each child of <item>
        $(xmlItem).children().each (i, xmlItem) ->
          # Get the name and set the contents
          newsItem[$(this)[0].name] = $(this).text()

        # Format the text or create the object
        if isSlack
          storyList.push newsItem
        else
          storyList.push "> #{newsItem.title} - #{newsItem.link}"

      # Build the payload and send
      if isSlack
        payload = {
          "text": "*#{feed.name}*",
          "attachments": [],
          "unfurl_links": false
        }
        robot.logger.debug storyList
        _(storyList).each (attachment, i) ->
          robot.logger.debug 'attachment', attachment
          robot.logger.debug 'i', i
          payload.attachments.push
            title: attachment.title
            title_link: attachment.link

        msg.send payload
      else
        msg.send "**#{feed.name}**\n" + storyList.join("\n")

  ##
  # Gets All Feeds in a Loop
  getAllFeeds = (msg) ->
    for id, feed of RSSFeeds
      getFeed(feed, msg)
