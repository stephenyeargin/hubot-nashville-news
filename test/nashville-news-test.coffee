Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/nashville-news.coffee')

describe 'nashville-news', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to news', ->
    @room.user.say('alice', '@hubot news').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot news']
        ['hubot', 'Retrieving local news (this may take a bit) ...']
      ]
