###
# Perms command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    user = message.author

    if Utils.isOwner user
      return Bot.Messenger.reply message, 'PERMS:OWNER'

    if Utils.isFriend user
      return Bot.Messenger.reply message, 'PERMS:FRIEND'

    return Bot.Messenger.reply message, 'PERMS:USER'
