# Required libraries
debug = require('debug') 'utility-bot:error'

###
# On error
###
module.exports = (Bot) ->
  lastError = new Date 0

  Bot.on 'error', (err) ->
    debug 'An error occurred:\n' + err

    Bot.Messenger.sendToOwner 'PHRASE:ERROR',
      err: err

    # Kill process if two errors occur within 30 seconds.
    if ((new Date) - lastError) > 30000
      # Kill process with error code.
      process.exit 1

    lastError = new Date
