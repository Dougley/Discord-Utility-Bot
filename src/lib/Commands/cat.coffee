# Required libraries
request = require 'request'

###
# Cat command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if not Utils.isFriend message.author
      return

    request 'http://random.cat/meow', (error, response, body) ->
      if error or response.statusCode != 200
        return Bot.Messenger.reply message, 'ERROR', err: "Couldn't fetch a cat from http://random.cat/meow..."

      try
        body = JSON.parse body
        Bot.sendMessage message.channel, body.file
      catch e
        Bot.Messenger.reply message, 'ERROR', err: "Couldn't fetch a cat from http://random.cat/meow..."
