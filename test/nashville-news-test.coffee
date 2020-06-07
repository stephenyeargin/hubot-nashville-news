Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../src/nashville-news.coffee')

describe 'nashville-news', ->
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
    nock('https://www.wsmv.com')
      .get('/search/?f=rss&t=article&c=news/davidson_county&l=50&s=start_time&sd=desc')
      .replyWithFile(200, __dirname + '/fixtures/wsmv.xml')

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
          ['alice', '@hubot news']
          ['hubot', 'Retrieving local news (this may take a bit) ...']
          ['hubot', '**The Tennessean**\n> Predators\' secret weapon vs. Blackhawks? Harry Zolnierczyk - http://rssfeeds.tennessean.com/~/294030934/0/nashville/home~Predators-secret-weapon-vs-Blackhawks-Harry-Zolnierczyk/\n> Watch: Flash flooding, storms leave car stranded in Franklin - http://rssfeeds.tennessean.com/~/294034568/0/nashville/home~Watch-Flash-flooding-storms-leave-car-stranded-in-Franklin/\n> Haslam laments failure of undocumented immigrant tuition bill - http://rssfeeds.tennessean.com/~/294014088/0/nashville/home~Haslam-laments-failure-of-undocumented-immigrant-tuition-bill/']
          ['hubot', '**Nashville Scene**\n> Metro Schools Wants Someone Just to Tell Positive Stories - http://www.nashvillescene.com/news/pith-in-the-wind/article/20858448/metro-schools-wants-to-hire-someone-just-to-tell-positive-stories-about-the-district\n> Nashville Should Immediately Steal This Good Idea From Gallatin - http://www.nashvillescene.com/news/pith-in-the-wind/article/20858417/nashville-must-immediately-steal-this-good-idea-from-gallatin\n> Some Sanity in Naming Things Around Nashville - http://www.nashvillescene.com/news/pith-in-the-wind/article/20858243/some-sanity-in-naming-things-around-nashville']
          ['hubot', '**WPLN (Nashville Public Radio)**\n> After Protests And Arrests, Tennessee Activists Still Press Governor For Medicaid Expansion - http://nashvillepublicradio.org/post/after-protests-and-arrests-tennessee-activists-still-press-governor-medicaid-expansion\n> Capitol Hill Conversation: Open Container Ban And Other Bills That Quietly Fizzled - http://nashvillepublicradio.org/post/capitol-hill-conversation-open-container-ban-and-other-bills-quietly-fizzled\n> How Sen. Alexander\'s Health Insurance Bill Could Benefit One Organization In Tennessee  - http://nashvillepublicradio.org/post/how-sen-alexanders-health-insurance-bill-could-benefit-one-organization-tennessee']
          ['hubot', '**WTVF (CBS)**\n> Former Officer Charged; Allegedly Pawned Guns - http://www.newschannel5.com/news/former-waynesboro-officer-charged-for-allegedly-pawning-guns\n> Motorcycle Thieves Target Home Of Officer - http://www.newschannel5.com/news/motorcycle-thieves-target-home-of-officer\n> Nashville Farmer\'s Market To Get Parking Relief - http://www.newschannel5.com/news/nashville-farmers-market-to-get-parking-relief']
          ['hubot', '**WKRN (ABC)**\n> Construction worker shot during robbery in Edgehill - http://wkrn.com/2017/04/17/construction-worker-shot-during-robbery-in-edgehill/\n> Scattered storms lead to flash flooding in Franklin - http://wkrn.com/2017/04/17/scattered-storms-lead-to-flash-flooding-in-franklin/\n> Former Tenn. police officer accused of pawning department-issued guns - http://wkrn.com/2017/04/17/former-tenn-police-officer-accused-of-pawning-department-issued-guns/']
          ['hubot', '**WSMV (NBC)**\n> Former MTSU football player charged with animal cruelty - http://www.wsmv.com/story/35170189/former-mtsu-football-player-charged-with-animal-cruelty\n> Construction worker shot in leg in Edgehill - http://www.wsmv.com/story/35170816/construction-worker-shot-in-leg-in-edgehill\n> Former Waynesboro police officer faces theft, misconduct charges - http://www.wsmv.com/story/35170753/former-waynesboro-police-officer-faces-theft-misconduct-charges']
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
          ['alice', '@hubot news']
          ['hubot', 'Retrieving local news (this may take a bit) ...']
          ['hubot', '**The Tennessean**\n> Predators\' secret weapon vs. Blackhawks? Harry Zolnierczyk - http://rssfeeds.tennessean.com/~/294030934/0/nashville/home~Predators-secret-weapon-vs-Blackhawks-Harry-Zolnierczyk/\n> Watch: Flash flooding, storms leave car stranded in Franklin - http://rssfeeds.tennessean.com/~/294034568/0/nashville/home~Watch-Flash-flooding-storms-leave-car-stranded-in-Franklin/\n> Haslam laments failure of undocumented immigrant tuition bill - http://rssfeeds.tennessean.com/~/294014088/0/nashville/home~Haslam-laments-failure-of-undocumented-immigrant-tuition-bill/']
          ['hubot', '**Nashville Scene**\n> Unable to retrieve news for Nashville Scene :cry: - https://www.nashvillescene.com/feeds/news']
          ['hubot', '**WPLN (Nashville Public Radio)**\n> After Protests And Arrests, Tennessee Activists Still Press Governor For Medicaid Expansion - http://nashvillepublicradio.org/post/after-protests-and-arrests-tennessee-activists-still-press-governor-medicaid-expansion\n> Capitol Hill Conversation: Open Container Ban And Other Bills That Quietly Fizzled - http://nashvillepublicradio.org/post/capitol-hill-conversation-open-container-ban-and-other-bills-quietly-fizzled\n> How Sen. Alexander\'s Health Insurance Bill Could Benefit One Organization In Tennessee  - http://nashvillepublicradio.org/post/how-sen-alexanders-health-insurance-bill-could-benefit-one-organization-tennessee']
          ['hubot', '**WTVF (CBS)**\n> Former Officer Charged; Allegedly Pawned Guns - http://www.newschannel5.com/news/former-waynesboro-officer-charged-for-allegedly-pawning-guns\n> Motorcycle Thieves Target Home Of Officer - http://www.newschannel5.com/news/motorcycle-thieves-target-home-of-officer\n> Nashville Farmer\'s Market To Get Parking Relief - http://www.newschannel5.com/news/nashville-farmers-market-to-get-parking-relief']
          ['hubot', '**WKRN (ABC)**\n> Construction worker shot during robbery in Edgehill - http://wkrn.com/2017/04/17/construction-worker-shot-during-robbery-in-edgehill/\n> Scattered storms lead to flash flooding in Franklin - http://wkrn.com/2017/04/17/scattered-storms-lead-to-flash-flooding-in-franklin/\n> Former Tenn. police officer accused of pawning department-issued guns - http://wkrn.com/2017/04/17/former-tenn-police-officer-accused-of-pawning-department-issued-guns/']
          ['hubot', '**WSMV (NBC)**\n> Former MTSU football player charged with animal cruelty - http://www.wsmv.com/story/35170189/former-mtsu-football-player-charged-with-animal-cruelty\n> Construction worker shot in leg in Edgehill - http://www.wsmv.com/story/35170816/construction-worker-shot-in-leg-in-edgehill\n> Former Waynesboro police officer faces theft, misconduct charges - http://www.wsmv.com/story/35170753/former-waynesboro-police-officer-faces-theft-misconduct-charges']
        ]
        done()
      catch err
        done err
      return
    , 1000)
