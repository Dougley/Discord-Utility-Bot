###
# Status command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if not Utils.isOwner message.author
      return

    if args.length == 0
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} status <\"new status\">"
        does: "Sets my status to the given string."

    status = message.cleanContent.split ' '
    status.splice 0, 2
    status = status.join ' '

    Bot.setStatus 'online', status, (err) ->
      if err
        Bot.Messenger.reply message, 'ERROR', err: err
      else
        Bot.Messenger.reply message, 'SUCCESS'
