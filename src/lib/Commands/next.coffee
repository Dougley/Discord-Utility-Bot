###
# Next command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if args.length > 0
      if args[0] == 'clear'
        if Bot.HelperBotInternal.next.user.hasOwnProperty message.author.id
          delete Bot.HelperBotInternal.next.user[message.author.id]
        else if not message.channel.isPrivate
          if Bot.HelperBotInternal.next.channel.hasOwnProperty "#{message.channel.server.id}_#{message.channel.id}"
            delete Bot.HelperBotInternal.next.channel["#{message.channel.server.id}_#{message.channel.id}"]

    if Bot.HelperBotInternal.next.user.hasOwnProperty message.author.id
      # User next found, passing control over...
      return Bot.HelperBotInternal.next.user[message.author.id].function Bot, message

    if not message.channel.isPrivate
      if Bot.HelperBotInternal.next.channel.hasOwnProperty "#{message.channel.server.id}_#{message.channel.id}"
        # Channel next found, passing control over...
        return Bot.HelperBotInternal.next.channel["#{message.channel.server.id}_#{message.channel.id}"].function Bot, message

    Bot.Messenger.reply message, 'NEXT_NONEXISTENT'
