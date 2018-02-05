# Description
#   Retrieves top local news from Nashville media outlet RSS feeds.
#
# Commands:
#   hubot news - returns the latest Nashville news
#
# Author:
#   Stephen Yeargin <stephen.yeargin@gmail.com>

cheerio = require 'cheerio'
_ = require 'underscore'
fs = require 'fs'

# Configure the RSS feeds
rssFeeds = require './feeds.json'
storyCount = process.env.HUBOT_NEWS_ITEM_COUNT || 3

module.exports = (robot) ->
  # Use enhanced formatting?
  isSlack = robot.adapterName == 'slack'

  robot.respond /news$/i, (msg) ->
    msg.send 'Retrieving local news (this may take a bit) ...'
    promises = getAllFeeds(msg)
    Promise.all(promises).then (storyLists) ->
      for storyList in storyLists
        postMessage storyList, msg
    .catch (error) ->
      msg.send error

  ##
  # Gets a Single Feed
  #
  # @return Promise
  getFeed = (feed) ->
    return new Promise (resolve, reject) ->
      robot.http(feed.rss_url).get() (err, res, body) ->
        if err or res.statusCode != 200
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

          # Hack to grab the thumbnail url
          newsItem['media:thumbnail'] = $(xmlItem).children().filter('media\\:thumbnail').attr('url')

          # Attach feed item to each story item
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
        "text": "*#{storyList[0].feed.name}*",
        "attachments": [],
        "unfurl_links": false
      }
      robot.logger.debug storyList
      _(storyList).each (attachment, i) ->
        payload.attachments.push
          title: attachment.title
          title_link: attachment.link
          thumb_url: if attachment['media:thumbnail'] then attachment['media:thumbnail'] else false

      msg.send payload
    else
      payload = []
      for story in storyList
        payload.push "> #{story.title} - #{story.link}"

      msg.send "**#{storyList[0].feed.name}**\n" + payload.join("\n")

  ##
  # Gets All Feeds in a Loop
  getAllFeeds = (msg) ->
    promises = []
    for feed, id in rssFeeds
      promises.push getFeed(feed)
    return promises
