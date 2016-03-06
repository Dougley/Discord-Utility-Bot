# Required libraries
fs = require 'fs'
path = require 'path'

###
# Ping command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  # Load tags from disk
  tags = require '../../tags.json'

  return (message, args) ->
    if args.length == 0
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} #{Bot.Language.commands.tags} <add | remove | list | tag name>"
        does: "Adds, removes, lists, or displays a tag."

    if args[0].toLowerCase() == 'add'
      if args.length == 1
        return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
          usage: "#{Bot.user.username} #{Bot.Language.commands.tags} add <tag name> <\"tag content\">"
          does: "Adds a tag."

      tagname = args[1].toLowerCase()

      tagname = tagname.replace /[^\w\s_-]/gi, ''

      if (tagname.replace(/[\s]/gi, '').length < 4) or (tagname.length < 4)
        return Bot.Messenger.sendMessage message.channel, 'ERROR',
          err: "Your tag name '#{tagname}' is not over 3 characters in length."

      if (tagname.toLowerCase() == 'add') or (tagname.toLowerCase() == 'remove') or (tagname.toLowerCase() == 'list')
        return Bot.Messenger.sendMessage message.channel, 'ERROR',
          err: "You used a reserved keyword as your tag name. You cannot use 'add', 'remove', or 'list' as your tag name."

      if tags[tagname]
        # Tag exists
        return Bot.Messenger.sendMessage message.channel, 'ERROR',
          err: "That tag already exists."

      tags[tagname] =
        creator: message.author.id
        content: args[1]

      fs.writeFile path.join(__dirname, '..', '..', 'tags.json'), JSON.stringify(tags), 'utf8', (err) ->
        if err
          return Bot.Messenger.sendMessage message.channel, 'ERROR',
            err: "Couldn't save the tags file:\n #{err}"

        Bot.Messenger.sendMessage message.channel, 'SUCCESS'

    else if args[0].toLowerCase() == 'remove'
      if args.length == 1
        return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
          usage: "#{Bot.user.username} #{Bot.Language.commands.tags} remove <tag name>"
          does: "Removes a tag."

      tagname = args[1].toLowerCase()

      tagname = tagname.replace /[^\w\s_-]/gi, ''

      if (tagname.replace(/[\s]/gi, '').length < 4) or (tagname.length < 4)
        return Bot.Messenger.sendMessage message.channel, 'ERROR',
          err: "That tag does not exist."

      if not tags[tagname]
        # Tag doesn't exist
        return Bot.Messenger.sendMessage message.channel, 'ERROR',
          err: "That tag doesn't exist."

      delete tags[tagname]

      fs.writeFile path.join(__dirname, '..', '..', 'tags.json'), JSON.stringify(tags), 'utf8', (err) ->
        if err
          return Bot.Messenger.sendMessage message.channel, 'ERROR',
            err: "Couldn't save the tags file:\n #{err}"

        Bot.Messenger.sendMessage message.channel, 'SUCCESS'

    else if args[0].toLowerCase() == 'list'
      if tags.length == 0
        return Bot.Messenger.sendMessage message.channel, 'TAGS_NONE'

      return Bot.sendMessage message.channel, Object.keys(tags).join ', '

    else
      # No command given, let's see if there's a tag for this query
      tagname = args[0].toLowerCase()

      if tags.hasOwnProperty tagname
        # The tag exists, lets show it.
        return Bot.sendMessage message.channel, tags[tagname].content

      return Bot.Messenger.sendMessage message.channel, 'TAG_NONEXISTENT'
