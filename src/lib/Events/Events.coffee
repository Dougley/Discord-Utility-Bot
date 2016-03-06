###
# Add events to the Bot.
###
module.exports = (Bot) ->
  # On ready
  require('./ready') Bot

  # On message
  require('./message') Bot

  # On error
  require('./error') Bot

  # On disconnected
  require('./disconnected') Bot
