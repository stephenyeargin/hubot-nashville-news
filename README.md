# Nashville News [![Build Status](https://travis-ci.org/stephenyeargin/hubot-nashville-news.svg?branch=master)](https://travis-ci.org/stephenyeargin/hubot-nashville-news)

Retrieves top news from local RSS feeds.

- The Nashville Scene
- The Tennessean
- WPLN (Nashville Public Radio)
- WSMV (NBC)
- WKRN (ABC)
- WTVF (CBS)

These sources do not have linked RSS feeds:
- WZTZ (Fox)

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
