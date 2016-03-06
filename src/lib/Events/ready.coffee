# Required libraries
debug = require('debug') 'utility-bot:init'

###
# On ready
###
module.exports = (Bot) ->
  ###
  # Run this when connected to Discord.
  ###
  Bot.on 'ready', ->
    debug 'Connected to chat.'

    if Array.isArray Bot.Config.personalization.defaultStatuses
      if Bot.Config.personalization.defaultStatuses.length > 0
        Bot.setStatus 'online', Bot.Config.personalization.defaultStatuses[Math.floor Math.random() * Bot.Config.personalization.defaultStatuses.length]

    Bot.HelperBotInternal =
      votes: {}
      next:
        user: {}
        channel: {}

    # Let's try to get a User object for the owner
    Owner = Bot.users.get 'id', Bot.Config.permissions.owner

    if not Owner
      # We can't find the owner...
      debug 'Could not find a User object for the owner...'
      process.exit 1
    else
      Bot.Owner = Owner

    Bot.Messenger = require('../Messenger/Messenger') Bot
