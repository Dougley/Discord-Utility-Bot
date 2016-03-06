###
# ID command
###
module.exports = (Bot) ->
  return (message, args) ->
    if args.length == 0
      Bot.Messenger.sendMessage message.channel, 'ID_AUTHOR', id: message.author.id
    else
      mention = args[0]

      if mention.toLowerCase() == 'server'
        return Bot.Messenger.sendMessage message.channel, 'ID_OTHER',
          id: message.channel.server.id
          user:
            id: message.channel.server.id
            username: 'This server'

      # Regex magic to find the name
      if /^<@[0-9]+>/.test mention
        id = /^<@([0-9]+)>/.exec mention

        if not id
          return Bot.Messenger.sendMessage message.channel, 'ID_NOTFOUND'

        if not id[1]
          return Bot.Messenger.sendMessage message.channel, 'ID_NOTFOUND'

        id = id[1]

        if id == message.author.id
          return Bot.Messenger.sendMessage message.channel, 'ID_AUTHOR', id: message.author.id

        mentioned = message.mentions.filter (user) ->
          return user.id == id

        if mentioned.length == 0
          return Bot.Messenger.sendMessage message.channel, 'ID_OTHER',
            id: id
            user: 'That user'

        mentioned = mentioned[0]

        if mentioned == null
          return Bot.Messenger.sendMessage message.channel, 'ID_OTHER',
            id: id
            user: 'That user'

        Bot.Messenger.sendMessage message.channel, 'ID_OTHER',
          id: id
          user: mentioned
      else
        message.reply "I couldn't resolve that user's ID... sorry!"
