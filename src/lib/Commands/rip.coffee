###
# RIP command
###
module.exports = (Bot) ->
  return (message, args) ->
    ripee = false

    if args.length > 0
      ripee = message.cleanContent.split ' '
      ripee.splice 0, 2
      ripee = ripee.join ' '
      ripee = encodeURIComponent ripee

    Bot.sendMessage message.channel, 'https://ripme.xyz' + (if ripee != false then '/' + ripee else '')
