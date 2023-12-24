// Description:
//   Retrieves top local news from Nashville media outlet RSS feeds.
//
// Commands:
//   hubot news - returns the latest Nashville news
//
// Author:
//   Stephen Yeargin <stephen.yeargin@gmail.com>

const cheerio = require('cheerio');
const _ = require('underscore');

// Configure the RSS feeds
const rssFeeds = require('./feeds.json');

const storyCount = process.env.HUBOT_NEWS_ITEM_COUNT || 3;

module.exports = (robot) => {
  // Use enhanced formatting?
  const isSlack = robot.adapterName === 'slack';

  // Gets a Single Feed
  const getFeed = (feed) => new Promise((resolve) => {
    const storyList = [];
    robot.http(feed.rss_url)
      .get()((err, res, body) => {
        if (err || (res.statusCode !== 200)) {
          storyList.push({
            title: `Unable to retrieve news for ${feed.name} :cry:`,
            link: feed.rss_url,
            feed,
          });
          resolve(storyList);
          return;
        }

        const $ = cheerio.load(body, { ignoreWhitespace: true, xmlMode: true });

        // Empty or invalid RSS feed
        if ($('item').length === 0) {
          storyList.push({
            title: `Unable to retrieve news for ${feed.name} :cry:`,
            link: feed.rss_url,
            feed,
          });
          resolve(storyList);
        }

        // Loop through every item
        $('item').each((i, xmlItem) => {
        // Peel off the top stories
          if ((i + 1) > storyCount) {
            return;
          }

          // array to hold each item being converted into an array
          const newsItem = [];

          // Loop through each child of <item>
          // eslint-disable-next-line func-names
          $(xmlItem).children().each((_i2, xmlItem2) => {
            // Get the name and set the contents
            newsItem[xmlItem2.name] = $(xmlItem2).text();
          });

          // Hack to grab the thumbnail url
          newsItem['media:thumbnail'] = $(xmlItem).children().filter('media\\:thumbnail').attr('url');

          // Attach feed item to each story item
          newsItem.feed = feed;

          // Add to list
          storyList.push(newsItem);
        });

        resolve(storyList);
      });
  });

  // Post Message
  const postMessage = (storyList, msg) => {
    // Build the payload and send
    let payload;
    if (isSlack) {
      payload = {
        text: `*${storyList[0].feed.name}*`,
        attachments: [],
        unfurl_links: false,
      };
      robot.logger.debug(storyList);
      _(storyList).each((attachment) => payload.attachments.push({
        title: attachment.title,
        title_link: attachment.link,
        thumb_url: attachment['media:thumbnail'] ? attachment['media:thumbnail'] : false,
      }));

      msg.send(payload);
      return;
    }
    payload = [];
    storyList.forEach((story) => {
      payload.push(`> ${story.title} - ${story.link}`);
    });

    msg.send(`**${storyList[0].feed.name}**\n${payload.join('\n')}`);
  };

  // Gets All Feeds in a Loop
  const getAllFeeds = () => {
    const promises = [];
    rssFeeds.forEach((feed) => {
      promises.push(getFeed(feed));
    });
    return promises;
  };

  robot.respond(/news$/i, (msg) => {
    msg.send('Retrieving local news (this may take a bit) ...');
    const promises = getAllFeeds(msg);
    Promise.all(promises)
      .then((storyLists) => {
        storyLists.forEach((storyList) => {
          postMessage(storyList, msg);
        });
      })
      .catch((error) => msg.send(error));
  });
};
