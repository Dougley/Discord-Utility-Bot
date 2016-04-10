###
# Eval command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if not Utils.isOwner message.author
      return

    if args.length == 0
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} #{Bot.Language.commands.eval} <string to eval>"
        does: "Evals a string and prints output (if any) to chat."

    evalString = message.content.split ' '
    evalString.splice 0, 2
    evalString = evalString.join ' '

    try
      returned = eval evalString

      if returned == undefined
        Bot.Messenger.reply message, 'SUCCESS'
      else
        returned = String(returned).replace /@everyone/gi, '[at]everyone'
        message.reply "```\n#{returned}\n```"
    catch e
      Bot.Messenger.reply message, 'ERROR', err: e
