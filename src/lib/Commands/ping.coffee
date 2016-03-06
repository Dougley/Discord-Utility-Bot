###
# Ping command
###
module.exports = (Bot) ->
  return (message, args) ->
    Bot.Messenger.reply message, 'PING_RESPONSE'
