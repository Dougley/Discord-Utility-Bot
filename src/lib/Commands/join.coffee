###
# Join command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if not Utils.isFriend message.author
      return

    if args.length == 0
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} #{Bot.Language.command.join} <Discord Invite URL>"
        does: "Attempts to join the given server through the invite link provided."

    Bot.getInvite args[0], (err, invite) ->
      if err
        return Bot.Messenger.sendMessage message.author, 'ERROR', err: 'Could not retrieve invite information for the given invite:\n' + err

      servers = Bot.servers.getAll 'id', invite.server.id

      if servers.length > 0
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like I'm already in that server."

      Bot.joinServer args[0], (err, server) ->
        if err
          return Bot.Messenger.sendMessage message.author, 'ERROR', err: 'Could not join the given server:\n' + err

        Bot.Messenger.sendMessage message.channel, 'SERVER_JOINED', server: server
