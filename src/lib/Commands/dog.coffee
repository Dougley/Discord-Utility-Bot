# Required libraries
request = require 'request'

###
# Dog command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if not Utils.isFriend message.author
      return

    request 'https://www.reddit.com/r/dogpictures.json', (error, response, body) ->
      if error or response.statusCode != 200
        return Bot.Messenger.reply message, 'ERROR', err: "Couldn't fetch dogs from https://www.reddit.com/r/dogpictures.json..."

      try
        body = JSON.parse body
        body = body.data.children

        items = body.filter (element) ->
          # 't3' is a link according to Reddit API docs. Let's hope it's an image.
          return element.kind == 't3'

        item = items[Math.floor Math.random() * items.length]

        Bot.sendMessage message.channel, item.data.url
      catch e
        Bot.Messenger.reply message, 'ERROR', err: "Couldn't fetch dogs from https://www.reddit.com/r/dogpictures.json..."
