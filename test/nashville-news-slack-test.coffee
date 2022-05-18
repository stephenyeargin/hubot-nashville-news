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

    nock('https://rssfeeds.tennessean.com')
      .get('/nashville/home&x=1')
      .replyWithFile(200, __dirname + '/fixtures/tennessean.xml')
    nock('https://www.newschannel5.com')
      .get('/news/local-news.rss')
      .replyWithFile(200, __dirname + '/fixtures/wtvf.xml')
    nock('https://wpln.org')
      .get('/feed/')
      .replyWithFile(200, __dirname + '/fixtures/wpln.xml')
    nock('https://www.wkrn.com/')
      .get('/feed/')
      .replyWithFile(200, __dirname + '/fixtures/wkrn.xml')

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  it 'returns the latest nashville news', (done) ->
    # Scoped here to allow for 404 test
    nock('https://www.nashvillescene.com')
      .get('/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc')
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
          ]
        ]
        done()
      catch err
        done err
      return
    , 1000)

  it 'returns an error when one of the sources fails.', (done) ->
    nock('https://www.nashvillescene.com')
      .get('/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc')
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
                  "title_link": "https://www.nashvillescene.com/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc"
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
          ]
        ]
        done()
      catch err
        done err
      return
    , 1000)
