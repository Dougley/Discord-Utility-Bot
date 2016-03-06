###
# Command definitions for commands anyone can use.
###
module.exports = (Bot) ->
  Commands = {}

  Commands[Bot.Language.commands.cat] = require('./Commands/cat') Bot
  Commands[Bot.Language.commands.choose] = require('./Commands/choose') Bot
  Commands[Bot.Language.commands.dog] = require('./Commands/dog') Bot
  Commands[Bot.Language.commands.eval] = require('./Commands/eval') Bot
  Commands[Bot.Language.commands.find] = require('./Commands/find') Bot
  Commands[Bot.Language.commands.help] = require('./Commands/help') Bot
  Commands[Bot.Language.commands.id] = require('./Commands/id') Bot
  Commands[Bot.Language.commands.info] = require('./Commands/info') Bot
  Commands[Bot.Language.commands.join] = require('./Commands/join') Bot
  Commands[Bot.Language.commands.killbot] = require('./Commands/killbot') Bot
  Commands[Bot.Language.commands.next] = require('./Commands/next') Bot
  Commands[Bot.Language.commands.perms] = require('./Commands/perms') Bot
  Commands[Bot.Language.commands.ping] = require('./Commands/ping') Bot
  Commands[Bot.Language.commands.rolldice] = require('./Commands/rolldice') Bot
  Commands[Bot.Language.commands.status] = require('./Commands/status') Bot
  Commands[Bot.Language.commands.tags] = require('./Commands/tags') Bot
  Commands[Bot.Language.commands.vote] = require('./Commands/vote') Bot

  return Commands
