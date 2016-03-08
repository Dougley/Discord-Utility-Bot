# Required libraries
debug = require('debug') 'utility-bot:message'
splitargs = require 'splitargs'

###
# On message
###
module.exports = (Bot) ->
  # Load commands.
  Commands = require('../Commands') Bot

  # Load utilities.
  Utils = require('../Utils') Bot

  ###
  # On 'message', runs every time a message is received by the bot.
  #
  # This function processes all commands and user input.
  ###
  Bot.on 'message', (message) ->
    if message.author.id == Bot.user.id
      # We don't process messages from ourself.
      return

    if (not Utils.isFriend message.author) and message.channel.isPrivate
      # Someone we don't know tried to talk to me in Private messages.
      return Bot.Messenger.reply message, 'INVALID_PERMISSIONS', perm: 'You cannot use private messages with me.'

    debug "#{message.author.id} (@#{message.author.username}): #{message.content}"
    msgContent = splitargs message.content

    if msgContent.length < 1
      return

    if ((msgContent[0].toLowerCase() == Bot.user.username.toLowerCase()) or (msgContent[0].toLowerCase() == Bot.user.username.toLowerCase() + ',')) and msgContent.length > 1
      # Someone sent a command
      command = msgContent[1].toLowerCase()
      args = msgContent
      args.splice 0, 2

      # Let the processing begin.
      if Commands.hasOwnProperty command
        # The command exists, let's hand control over.
        debug "Command '#{command}' issued by #{message.author.id} (@#{message.author.username})"
        Commands[command] message, args

    else if Utils.mentions message.content, Bot.user
      debug "I was mentioned by #{message.author.id} (@#{message.author.username})"

      if ((message.content.toLowerCase().indexOf "fuck #{Bot.user.mention()}") > -1) or ((message.content.toLowerCase().indexOf "fuck you #{Bot.user.mention()}") > -1)
        if Utils.isFriend message.author
          Bot.Messenger.sendMessage message.channel, 'SAD'
        else
          Bot.Messenger.sendMessage message.channel, 'FUCK_YOU', user: message.author.id

    # If none of that fired off, we don't need to worry about this message.
