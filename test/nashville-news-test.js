const {
  describe, it, before, after,
} = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const nock = require('nock');
const { createTestBot } = require('./common/TestBot');

const FIXTURES = path.resolve(__dirname, 'fixtures');

function setupCommonNocks() {
  nock('http://rssfeeds.tennessean.com')
    .get('/nashville/home&x=1')
    .replyWithFile(200, `${FIXTURES}/tennessean.xml`);
  nock('https://www.newschannel5.com')
    .get('/news/local-news.rss')
    .replyWithFile(200, `${FIXTURES}/wtvf.xml`);
  nock('https://wpln.org')
    .get('/feed/')
    .replyWithFile(200, `${FIXTURES}/wpln.xml`);
  nock('https://www.wkrn.com/')
    .get('/feed/')
    .replyWithFile(200, `${FIXTURES}/wkrn.xml`);
}

describe('nashville-news', () => {
  let ctx;

  before(async () => {
    ctx = await createTestBot();
  });

  after(() => {
    ctx.shutdown();
  });

  it('returns the latest nashville news', async () => {
    setupCommonNocks();
    nock('https://www.nashvillescene.com')
      .get('/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc')
      .replyWithFile(200, `${FIXTURES}/scene.xml`);

    ctx.sends = [];
    await ctx.send('@hubot news');
    // Wait a bit more for all async RSS fetches to complete
    await new Promise((done) => { setTimeout(done, 200); });

    assert.equal(ctx.sends[0], 'Retrieving local news (this may take a bit) ...');
    assert.equal(ctx.sends[1], "**The Tennessean**\n> Predators' secret weapon vs. Blackhawks? Harry Zolnierczyk - http://rssfeeds.tennessean.com/~/294030934/0/nashville/home~Predators-secret-weapon-vs-Blackhawks-Harry-Zolnierczyk/\n> Watch: Flash flooding, storms leave car stranded in Franklin - http://rssfeeds.tennessean.com/~/294034568/0/nashville/home~Watch-Flash-flooding-storms-leave-car-stranded-in-Franklin/\n> Haslam laments failure of undocumented immigrant tuition bill - http://rssfeeds.tennessean.com/~/294014088/0/nashville/home~Haslam-laments-failure-of-undocumented-immigrant-tuition-bill/");
    assert.equal(ctx.sends[2], '**Nashville Scene**\n> Metro Schools Wants Someone Just to Tell Positive Stories - http://www.nashvillescene.com/news/pith-in-the-wind/article/20858448/metro-schools-wants-to-hire-someone-just-to-tell-positive-stories-about-the-district\n> Nashville Should Immediately Steal This Good Idea From Gallatin - http://www.nashvillescene.com/news/pith-in-the-wind/article/20858417/nashville-must-immediately-steal-this-good-idea-from-gallatin\n> Some Sanity in Naming Things Around Nashville - http://www.nashvillescene.com/news/pith-in-the-wind/article/20858243/some-sanity-in-naming-things-around-nashville');
    assert.equal(ctx.sends[3], "**WPLN (Nashville Public Radio)**\n> After Protests And Arrests, Tennessee Activists Still Press Governor For Medicaid Expansion - http://nashvillepublicradio.org/post/after-protests-and-arrests-tennessee-activists-still-press-governor-medicaid-expansion\n> Capitol Hill Conversation: Open Container Ban And Other Bills That Quietly Fizzled - http://nashvillepublicradio.org/post/capitol-hill-conversation-open-container-ban-and-other-bills-quietly-fizzled\n> How Sen. Alexander's Health Insurance Bill Could Benefit One Organization In Tennessee  - http://nashvillepublicradio.org/post/how-sen-alexanders-health-insurance-bill-could-benefit-one-organization-tennessee");
    assert.equal(ctx.sends[4], "**WTVF (CBS)**\n> Former Officer Charged; Allegedly Pawned Guns - http://www.newschannel5.com/news/former-waynesboro-officer-charged-for-allegedly-pawning-guns\n> Motorcycle Thieves Target Home Of Officer - http://www.newschannel5.com/news/motorcycle-thieves-target-home-of-officer\n> Nashville Farmer's Market To Get Parking Relief - http://www.newschannel5.com/news/nashville-farmers-market-to-get-parking-relief");
    assert.equal(ctx.sends[5], '**WKRN (ABC)**\n> Construction worker shot during robbery in Edgehill - http://wkrn.com/2017/04/17/construction-worker-shot-during-robbery-in-edgehill/\n> Scattered storms lead to flash flooding in Franklin - http://wkrn.com/2017/04/17/scattered-storms-lead-to-flash-flooding-in-franklin/\n> Former Tenn. police officer accused of pawning department-issued guns - http://wkrn.com/2017/04/17/former-tenn-police-officer-accused-of-pawning-department-issued-guns/');
  });

  it('returns an error when one of the sources fails', async () => {
    setupCommonNocks();
    nock('https://www.nashvillescene.com')
      .get('/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc')
      .reply(404);

    ctx.sends = [];
    await ctx.send('@hubot news');
    await new Promise((done) => { setTimeout(done, 200); });

    assert.equal(ctx.sends[0], 'Retrieving local news (this may take a bit) ...');
    assert.equal(ctx.sends[1], "**The Tennessean**\n> Predators' secret weapon vs. Blackhawks? Harry Zolnierczyk - http://rssfeeds.tennessean.com/~/294030934/0/nashville/home~Predators-secret-weapon-vs-Blackhawks-Harry-Zolnierczyk/\n> Watch: Flash flooding, storms leave car stranded in Franklin - http://rssfeeds.tennessean.com/~/294034568/0/nashville/home~Watch-Flash-flooding-storms-leave-car-stranded-in-Franklin/\n> Haslam laments failure of undocumented immigrant tuition bill - http://rssfeeds.tennessean.com/~/294014088/0/nashville/home~Haslam-laments-failure-of-undocumented-immigrant-tuition-bill/");
    assert.equal(ctx.sends[2], '**Nashville Scene**\n> Unable to retrieve news for Nashville Scene :cry: - https://www.nashvillescene.com/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc');
    assert.equal(ctx.sends[3], "**WPLN (Nashville Public Radio)**\n> After Protests And Arrests, Tennessee Activists Still Press Governor For Medicaid Expansion - http://nashvillepublicradio.org/post/after-protests-and-arrests-tennessee-activists-still-press-governor-medicaid-expansion\n> Capitol Hill Conversation: Open Container Ban And Other Bills That Quietly Fizzled - http://nashvillepublicradio.org/post/capitol-hill-conversation-open-container-ban-and-other-bills-quietly-fizzled\n> How Sen. Alexander's Health Insurance Bill Could Benefit One Organization In Tennessee  - http://nashvillepublicradio.org/post/how-sen-alexanders-health-insurance-bill-could-benefit-one-organization-tennessee");
    assert.equal(ctx.sends[4], "**WTVF (CBS)**\n> Former Officer Charged; Allegedly Pawned Guns - http://www.newschannel5.com/news/former-waynesboro-officer-charged-for-allegedly-pawning-guns\n> Motorcycle Thieves Target Home Of Officer - http://www.newschannel5.com/news/motorcycle-thieves-target-home-of-officer\n> Nashville Farmer's Market To Get Parking Relief - http://www.newschannel5.com/news/nashville-farmers-market-to-get-parking-relief");
    assert.equal(ctx.sends[5], '**WKRN (ABC)**\n> Construction worker shot during robbery in Edgehill - http://wkrn.com/2017/04/17/construction-worker-shot-during-robbery-in-edgehill/\n> Scattered storms lead to flash flooding in Franklin - http://wkrn.com/2017/04/17/scattered-storms-lead-to-flash-flooding-in-franklin/\n> Former Tenn. police officer accused of pawning department-issued guns - http://wkrn.com/2017/04/17/former-tenn-police-officer-accused-of-pawning-department-issued-guns/');
  });
});
