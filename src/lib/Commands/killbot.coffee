###
# Killbot command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if not Utils.isOwner message.author
      return

    Bot.Messenger.reply message, 'KILLING_BOT'

    setTimeout (->
      process.exit 1
      ), 2000
