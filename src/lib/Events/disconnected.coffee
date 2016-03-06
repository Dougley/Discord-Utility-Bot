# Required libraries
debug = require('debug') 'utility-bot:connection'

###
# On disconnected
###
module.exports = (Bot) ->
  Bot.on 'disconnected', (err) ->
    debug 'Disconnected from DiscordApp. Killing process...'

    # Kill process with error code.
    process.exit 1
