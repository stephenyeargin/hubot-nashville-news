Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

helper = new Helper [
  'adapters/slack.coffee',
  '../src/nashville-news.coffee'
]

describe 'nashville-news slack', ->
  beforeEach ->
    @room = helper.createRoom()
    nock.disableNetConnect()

    nock('http://rssfeeds.tennessean.com')
      .get('/nashville/home&x=1')
      .replyWithFile(200, __dirname + '/fixtures/tennessean.xml')
    nock('http://www.newschannel5.com')
      .get('/feeds/rssFeed?obfType=RSS_FEED&siteId=100116&categoryId=20000')
      .replyWithFile(200, __dirname + '/fixtures/wtvf.xml')
    nock('http://nashvillepublicradio.org')
      .get('/news/rss.xml')
      .replyWithFile(200, __dirname + '/fixtures/wpln.xml')
    nock('http://wkrn.com/')
      .get('/feed/')
      .replyWithFile(200, __dirname + '/fixtures/wkrn.xml')
    nock('http://www.wsmv.com')
      .get('/category/208528/news?clienttype=rss')
      .replyWithFile(200, __dirname + '/fixtures/wsmv.xml')
    nock('https://patch.com')
      .get('/feeds/tennessee/nashville')
      .replyWithFile(200, __dirname + '/fixtures/patch.xml')

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  it 'returns the latest nashville news', (done) ->
    nock('https://www.nashvillescene.com')
      .get('/feeds/news')
      .replyWithFile(200, __dirname + '/fixtures/scene.xml')

    selfRoom = @room
    selfRoom.user.say('alice', '@hubot news')
    setTimeout(() ->
      try
        expect(selfRoom.messages).to.eql [
          ['alice', '@hubot news'],
          ['hubot', "Retrieving local news (this may take a bit) ..."],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Predators' secret weapon vs. Blackhawks? Harry Zolnierczyk",
                  "title_link": "http://rssfeeds.tennessean.com/~/294030934/0/nashville/home~Predators-secret-weapon-vs-Blackhawks-Harry-Zolnierczyk/"
                },
                {
                  "thumb_url": false,
                  "title": "Watch: Flash flooding, storms leave car stranded in Franklin",
                  "title_link": "http://rssfeeds.tennessean.com/~/294034568/0/nashville/home~Watch-Flash-flooding-storms-leave-car-stranded-in-Franklin/"
                },
                {
                  "thumb_url": false,
                  "title": "Haslam laments failure of undocumented immigrant tuition bill",
                  "title_link": "http://rssfeeds.tennessean.com/~/294014088/0/nashville/home~Haslam-laments-failure-of-undocumented-immigrant-tuition-bill/"
                }
              ],
              "text": "*The Tennessean*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Metro Schools Wants Someone Just to Tell Positive Stories",
                  "title_link": "http://www.nashvillescene.com/news/pith-in-the-wind/article/20858448/metro-schools-wants-to-hire-someone-just-to-tell-positive-stories-about-the-district"
                },
                {
                  "thumb_url": false,
                  "title": "Nashville Should Immediately Steal This Good Idea From Gallatin",
                  "title_link": "http://www.nashvillescene.com/news/pith-in-the-wind/article/20858417/nashville-must-immediately-steal-this-good-idea-from-gallatin"
                },
                {
                  "thumb_url": false,
                  "title": "Some Sanity in Naming Things Around Nashville",
                  "title_link": "http://www.nashvillescene.com/news/pith-in-the-wind/article/20858243/some-sanity-in-naming-things-around-nashville"
                }
              ],
              "text": "*Nashville Scene*",
              "unfurl_links": false
            }
          ],
          [
            "hubot"
            {
              "attachments": [
                {
                  "thumb_url": "https://mediad.publicbroadcasting.net/p/wpln/files/styles/big_story/public/201601/13085809213_91d2eef4a2_z.jpg",
                  "title": "After Protests And Arrests, Tennessee Activists Still Press Governor For Medicaid Expansion",
                  "title_link": "http://nashvillepublicradio.org/post/after-protests-and-arrests-tennessee-activists-still-press-governor-medicaid-expansion"
                },
                {
                  "thumb_url": "https://nashvillepublicradio.org/sites/wpln/files/styles/big_story/public/201702/tn_legislature_for_wpln_by_stephen_jerkins-180.jpg",
                  "title": "Capitol Hill Conversation: Open Container Ban And Other Bills That Quietly Fizzled",
                  "title_link": "http://nashvillepublicradio.org/post/capitol-hill-conversation-open-container-ban-and-other-bills-quietly-fizzled"
                },
                {
                  "thumb_url": "https://nashvillepublicradio.org/sites/wpln/files/styles/big_story/public/201704/flickr_lamar_alexander.jpg",
                  "title": "How Sen. Alexander's Health Insurance Bill Could Benefit One Organization In Tennessee ",
                  "title_link": "http://nashvillepublicradio.org/post/how-sen-alexanders-health-insurance-bill-could-benefit-one-organization-tennessee"
                }
              ],
              "text": "*WPLN (Nashville Public Radio)*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Former Officer Charged; Allegedly Pawned Guns",
                  "title_link": "http://www.newschannel5.com/news/former-waynesboro-officer-charged-for-allegedly-pawning-guns"
                },
                {
                  "thumb_url": false,
                  "title": "Motorcycle Thieves Target Home Of Officer",
                  "title_link": "http://www.newschannel5.com/news/motorcycle-thieves-target-home-of-officer"
                },
                {
                  "thumb_url": false,
                  "title": "Nashville Farmer's Market To Get Parking Relief",
                  "title_link": "http://www.newschannel5.com/news/nashville-farmers-market-to-get-parking-relief"
                }
              ],
              "text": "*WTVF (CBS)*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": "https://mgtvwkrn.files.wordpress.com/2017/04/13thavesouth-shooting-2.jpg",
                  "title": "Construction worker shot during robbery in Edgehill",
                  "title_link": "http://wkrn.com/2017/04/17/construction-worker-shot-during-robbery-in-edgehill/"
                },
                {
                  "thumb_url": "https://mgtvwkrn.files.wordpress.com/2017/04/11.jpg",
                  "title": "Scattered storms lead to flash flooding in Franklin",
                  "title_link": "http://wkrn.com/2017/04/17/scattered-storms-lead-to-flash-flooding-in-franklin/"
                },
                {
                  "thumb_url": "https://mgtvwkrn.files.wordpress.com/2017/04/robert-jason-gann.jpg",
                  "title": "Former Tenn. police officer accused of pawning department-issued guns",
                  "title_link": "http://wkrn.com/2017/04/17/former-tenn-police-officer-accused-of-pawning-department-issued-guns/"
                }
              ]
              "text": "*WKRN (ABC)*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Former MTSU football player charged with animal cruelty",
                  "title_link": "http://www.wsmv.com/story/35170189/former-mtsu-football-player-charged-with-animal-cruelty"
                },
                {
                  "thumb_url": false,
                  "title": "Construction worker shot in leg in Edgehill",
                  "title_link": "http://www.wsmv.com/story/35170816/construction-worker-shot-in-leg-in-edgehill"
                },
                {
                  "thumb_url": false,
                  "title": "Former Waynesboro police officer faces theft, misconduct charges",
                  "title_link": "http://www.wsmv.com/story/35170753/former-waynesboro-police-officer-faces-theft-misconduct-charges"
                }
              ],
              "text": "*WSMV (NBC)*",
              "unfurl_links": false
            }
          ],
          [
            'hubot',
            {
              "attachments": [
                {
                  "thumb_url": "https://cdn20.patch.com/users/22893192/20170501/095007/styles/T600x450/public/article_images/nashville-predator-logo-1493646374-3454.jpg",
                  "title": "Fake Predators Tickets Lead To Arrest",
                  "title_link": "http://patch.com/tennessee/nashville/fake-predators-tickets-lead-arrest?utm_source=article-mostrecent&utm_medium=rss&utm_term=police%20%26%20fire&utm_campaign=recirc&utm_content=normal"
                }
                {
                  "thumb_url": "https://cdn20.patch.com/users/22893192/20170430/083357/styles/T600x450/public/article_images/police_lights_shutterstock_108854663-1493598639-4317.jpg",
                  "title": "Storm-Tossed Soccer Goal Kills 2-Year-Old In Antioch",
                  "title_link": "http://patch.com/tennessee/nashville/s/g3wwq/storm-tossed-soccer-goal-kills-2-year-old-antioch?utm_source=article-mostrecent&utm_medium=rss&utm_term=police%20%26%20fire&utm_campaign=recirc&utm_content=normal"
                }
                {
                  "thumb_url": "https://cdn20.patch.com/users/22893192/20170430/121159/styles/T600x450/public/article_images/week-ahead-weather_rain_1200x900-1493568707-5595.jpg",
                  "title": "Nashville Weather Forecast: Rain Threatens All Week",
                  "title_link": "http://patch.com/tennessee/nashville/nashville-weather-forecast-rain-threatens-all-week?utm_source=article-mostrecent&utm_medium=rss&utm_term=weather&utm_campaign=recirc&utm_content=normal"
                }
              ],
              "text": "*Patch Nashville*",
              "unfurl_links": false
            }
          ]
        ]
        done()
      catch err
        done err
      return
    , 1000)

  it 'returns an error when one of the sources fails.', (done) ->
    nock('https://www.nashvillescene.com')
      .get('/feeds/news')
      .reply(404)

    selfRoom = @room
    selfRoom.user.say('alice', '@hubot news')
    setTimeout(() ->
      try
        expect(selfRoom.messages).to.eql [
          ['alice', '@hubot news'],
          ['hubot', "Retrieving local news (this may take a bit) ..."],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Predators' secret weapon vs. Blackhawks? Harry Zolnierczyk",
                  "title_link": "http://rssfeeds.tennessean.com/~/294030934/0/nashville/home~Predators-secret-weapon-vs-Blackhawks-Harry-Zolnierczyk/"
                },
                {
                  "thumb_url": false,
                  "title": "Watch: Flash flooding, storms leave car stranded in Franklin",
                  "title_link": "http://rssfeeds.tennessean.com/~/294034568/0/nashville/home~Watch-Flash-flooding-storms-leave-car-stranded-in-Franklin/"
                },
                {
                  "thumb_url": false,
                  "title": "Haslam laments failure of undocumented immigrant tuition bill",
                  "title_link": "http://rssfeeds.tennessean.com/~/294014088/0/nashville/home~Haslam-laments-failure-of-undocumented-immigrant-tuition-bill/"
                }
              ],
              "text": "*The Tennessean*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Unable to retrieve news for Nashville Scene :cry:",
                  "title_link": "https://www.nashvillescene.com/feeds/news"
                }
              ],
              "text": "*Nashville Scene*",
              "unfurl_links": false
            }
          ],
          [
            "hubot"
            {
              "attachments": [
                {
                  "thumb_url": "https://mediad.publicbroadcasting.net/p/wpln/files/styles/big_story/public/201601/13085809213_91d2eef4a2_z.jpg",
                  "title": "After Protests And Arrests, Tennessee Activists Still Press Governor For Medicaid Expansion",
                  "title_link": "http://nashvillepublicradio.org/post/after-protests-and-arrests-tennessee-activists-still-press-governor-medicaid-expansion"
                },
                {
                  "thumb_url": "https://nashvillepublicradio.org/sites/wpln/files/styles/big_story/public/201702/tn_legislature_for_wpln_by_stephen_jerkins-180.jpg",
                  "title": "Capitol Hill Conversation: Open Container Ban And Other Bills That Quietly Fizzled",
                  "title_link": "http://nashvillepublicradio.org/post/capitol-hill-conversation-open-container-ban-and-other-bills-quietly-fizzled"
                },
                {
                  "thumb_url": "https://nashvillepublicradio.org/sites/wpln/files/styles/big_story/public/201704/flickr_lamar_alexander.jpg",
                  "title": "How Sen. Alexander's Health Insurance Bill Could Benefit One Organization In Tennessee ",
                  "title_link": "http://nashvillepublicradio.org/post/how-sen-alexanders-health-insurance-bill-could-benefit-one-organization-tennessee"
                }
              ],
              "text": "*WPLN (Nashville Public Radio)*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Former Officer Charged; Allegedly Pawned Guns",
                  "title_link": "http://www.newschannel5.com/news/former-waynesboro-officer-charged-for-allegedly-pawning-guns"
                },
                {
                  "thumb_url": false,
                  "title": "Motorcycle Thieves Target Home Of Officer",
                  "title_link": "http://www.newschannel5.com/news/motorcycle-thieves-target-home-of-officer"
                },
                {
                  "thumb_url": false,
                  "title": "Nashville Farmer's Market To Get Parking Relief",
                  "title_link": "http://www.newschannel5.com/news/nashville-farmers-market-to-get-parking-relief"
                }
              ],
              "text": "*WTVF (CBS)*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": "https://mgtvwkrn.files.wordpress.com/2017/04/13thavesouth-shooting-2.jpg",
                  "title": "Construction worker shot during robbery in Edgehill",
                  "title_link": "http://wkrn.com/2017/04/17/construction-worker-shot-during-robbery-in-edgehill/"
                },
                {
                  "thumb_url": "https://mgtvwkrn.files.wordpress.com/2017/04/11.jpg",
                  "title": "Scattered storms lead to flash flooding in Franklin",
                  "title_link": "http://wkrn.com/2017/04/17/scattered-storms-lead-to-flash-flooding-in-franklin/"
                },
                {
                  "thumb_url": "https://mgtvwkrn.files.wordpress.com/2017/04/robert-jason-gann.jpg",
                  "title": "Former Tenn. police officer accused of pawning department-issued guns",
                  "title_link": "http://wkrn.com/2017/04/17/former-tenn-police-officer-accused-of-pawning-department-issued-guns/"
                }
              ]
              "text": "*WKRN (ABC)*",
              "unfurl_links": false
            }
          ],
          [
            "hubot",
            {
              "attachments": [
                {
                  "thumb_url": false,
                  "title": "Former MTSU football player charged with animal cruelty",
                  "title_link": "http://www.wsmv.com/story/35170189/former-mtsu-football-player-charged-with-animal-cruelty"
                },
                {
                  "thumb_url": false,
                  "title": "Construction worker shot in leg in Edgehill",
                  "title_link": "http://www.wsmv.com/story/35170816/construction-worker-shot-in-leg-in-edgehill"
                },
                {
                  "thumb_url": false,
                  "title": "Former Waynesboro police officer faces theft, misconduct charges",
                  "title_link": "http://www.wsmv.com/story/35170753/former-waynesboro-police-officer-faces-theft-misconduct-charges"
                }
              ],
              "text": "*WSMV (NBC)*",
              "unfurl_links": false
            }
          ],
          [
            'hubot',
            {
              "attachments": [
                {
                  "thumb_url": "https://cdn20.patch.com/users/22893192/20170501/095007/styles/T600x450/public/article_images/nashville-predator-logo-1493646374-3454.jpg",
                  "title": "Fake Predators Tickets Lead To Arrest",
                  "title_link": "http://patch.com/tennessee/nashville/fake-predators-tickets-lead-arrest?utm_source=article-mostrecent&utm_medium=rss&utm_term=police%20%26%20fire&utm_campaign=recirc&utm_content=normal"
                }
                {
                  "thumb_url": "https://cdn20.patch.com/users/22893192/20170430/083357/styles/T600x450/public/article_images/police_lights_shutterstock_108854663-1493598639-4317.jpg",
                  "title": "Storm-Tossed Soccer Goal Kills 2-Year-Old In Antioch",
                  "title_link": "http://patch.com/tennessee/nashville/s/g3wwq/storm-tossed-soccer-goal-kills-2-year-old-antioch?utm_source=article-mostrecent&utm_medium=rss&utm_term=police%20%26%20fire&utm_campaign=recirc&utm_content=normal"
                }
                {
                  "thumb_url": "https://cdn20.patch.com/users/22893192/20170430/121159/styles/T600x450/public/article_images/week-ahead-weather_rain_1200x900-1493568707-5595.jpg",
                  "title": "Nashville Weather Forecast: Rain Threatens All Week",
                  "title_link": "http://patch.com/tennessee/nashville/nashville-weather-forecast-rain-threatens-all-week?utm_source=article-mostrecent&utm_medium=rss&utm_term=weather&utm_campaign=recirc&utm_content=normal"
                }
              ],
              "text": "*Patch Nashville*",
              "unfurl_links": false
            }
          ]
        ]
        done()
      catch err
        done err
      return
    , 1000)
