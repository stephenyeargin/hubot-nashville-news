# Nashville News

[![npm version](https://badge.fury.io/js/hubot-nashville-news.svg)](http://badge.fury.io/js/hubot-nashville-news) [![Node CI](https://github.com/stephenyeargin/hubot-nashville-news/actions/workflows/nodejs.yml/badge.svg)](https://github.com/stephenyeargin/hubot-nashville-news/actions/workflows/nodejs.yml)

Retrieves top local news from Nashville media outlet RSS feeds.

- [_Nashville Scene_](http://nashvillescene.com/)
- [_The Tennessean_](http://tennessean.com/)
- [WPLN](http://nashvillepublicradio.org/) (Nashville Public Radio)
- [WSMV](http://www.wsmv.com/) (NBC)
- [WKRN](http://wkrn.com/) (ABC)
- [WTVF](http://www.newschannel5.com/) (CBS)

These sources do not have linked RSS feeds, so they are not included:

- [WZTV](http://fox17.com/) (Fox)

## Installation

In hubot project repo, run:

`npm install hubot-nashville-news --save`

Then add **hubot-nashville-news** to your `external-scripts.json`:

```json
[
  "hubot-nashville-news"
]
```

## Sample Interaction

This is how it looks in Slack:

![screen shot 2017-01-06 at 9 05 53 pm](https://cloud.githubusercontent.com/assets/80459/21738942/fef876ae-d453-11e6-97d0-4cd1156414b7.png)

This is how it looks in IRC or other not-Slack clients:

```
User> hubot news
Hubot> Retrieving local news (this may take a bit) ...
Hubot> **Nashville Scene**
Hubot> > Museum Commission Chair: Email a Violation of Open Meetings Law, but not Meetings - http://www.nashvillescene.com/news/pith-in-the-wind/article/20848340/museum-commission-chair-email-a-violation-of-open-meetings-law-but-not-meetings
Hubot> > The Weekend Links - http://www.nashvillescene.com/news/pith-in-the-wind/article/20848210/the-weekend-links
Hubot> > Want to Keep The Name 'Negro Creek Road'? You Might Be a Racist - http://www.nashvillescene.com/news/pith-in-the-wind/article/20848200/want-to-keep-the-name-negro-creek-road-you-might-be-a-racist
Hubot> > Stacked and Ready: The General Assembly Returns - http://www.nashvillescene.com/news/cover-story/article/20848176/stacked-and-ready-the-general-assembly-returns
Hubot> > Off the Mat: The Titans Picked Themselves Up - http://www.nashvillescene.com/news/sports/article/20848153/off-the-mat-the-titans-picked-themselves-up
Hubot> **WKRN (ABC)**
Hubot> > 5 dead, 8 wounded in airport shooting; US veteran arrested - http://wkrn.com/2017/01/06/reports-shots-fired-at-ft-lauderdale-airport/
Hubot> > Cold temperatures linger as Middle Tennessee sees 1st snowfall of 2017 - http://wkrn.com/2017/01/06/light-snow-expected-across-southern-middle-tennessee/
[...]
```

## NPM Module

https://www.npmjs.com/package/hubot-nashville-news
