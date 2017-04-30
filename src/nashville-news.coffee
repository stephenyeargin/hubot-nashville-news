# Description
#   Retrieves top local news from Nashville media outlet RSS feeds.
#
# Commands:
#   hubot news - returns the latest Nashville news
#
# Author:
#   Stephen Yeargin <stephen.yeargin@gmail.com>

# Configure the RSS feeds
RSSFeeds = [
  {
    short_name: "tennessean",
    name: "The Tennessean",
    rss_url: "http://rssfeeds.tennessean.com/nashville/home&x=1"
  },
  {
    short_name: "scene",
    name: "Nashville Scene",
    rss_url: "http://www.nashvillescene.com/feeds/news"
  },
  {
    short_name: "wpln",
    name: "WPLN (Nashville Public Radio)",
    rss_url: "http://nashvillepublicradio.org/news/rss.xml"
  },
  {
    short_name: "wtvf",
    name: "WTVF (CBS)",
    rss_url: "http://www.newschannel5.com/feeds/rssFeed?obfType=RSS_FEED&siteId=100116&categoryId=20000"
  },
  {
    short_name: "wkrn",
    name: "WKRN (ABC)",
    rss_url: "http://wkrn.com/feed/"
  },
  {
    short_name: "wkrn",
    name: "WSMV (NBC)",
    rss_url: "http://www.wsmv.com/category/208528/news?clienttype=rss"
  }
]

storyCount = process.env.HUBOT_NEWS_ITEM_COUNT || 3

cheerio = require 'cheerio'
_ = require 'underscore'

module.exports = (robot) ->
  # Use enhanced formatting?
  isSlack = robot.adapterName == 'slack'

  robot.respond /news$/i, (msg) ->
    msg.send 'Retrieving local news (this may take a bit) ...'
    promises = getAllFeeds(msg)
    Promise.all(promises).then (storyLists) ->
      for storyList in storyLists
        postMessage storyList, msg

  ##
  # Gets a Single Feed
  #
  # @return Promise
  getFeed = (feed) ->
    return new Promise (resolve, reject) ->
      robot.http(feed.rss_url).get() (err, res, body) ->
        if err
          reject("Unable to retrieve feed for #{feed.name}. :cry:")
          return

        $ = cheerio.load(body, { ignoreWhitespace : true, xmlMode : true})

        storyList = []

        # Loop through every item
        $('item').each (i, xmlItem) ->
          # Peel off the top stories
          if i+1 > storyCount
            return

          # array to hold each item being converted into an array
          newsItem = []

          # Loop through each child of <item>
          $(xmlItem).children().each (i, xmlItem) ->
            # Get the name and set the contents
            newsItem[$(this)[0].name] = $(this).text()

          newsItem['feed'] = feed

          # Add to list
          storyList.push newsItem

        resolve(storyList)

  ##
  # Post Message
  postMessage = (storyList, msg) ->

    # Build the payload and send
    if isSlack
      payload = {
        "text": "*#{story.feed.name}*",
        "attachments": [],
        "unfurl_links": false
      }
      robot.logger.debug storyList
      _(storyList).each (attachment, i) ->
        payload.attachments.push
          title: attachment.title
          title_link: attachment.link

      msg.send payload
    else
      payload = []
      for story in storyList
        payload.push "> #{story.title} - #{story.link}"

      msg.send "**#{story.feed.name}**\n" + payload.join("\n")

  ##
  # Gets All Feeds in a Loop
  getAllFeeds = (msg) ->
    promises = []
    for feed, id in RSSFeeds
      promises.push getFeed(feed)
    return promises
