###
# Rolldice command
###
module.exports = (Bot) ->
  return (message, args) ->
    dice = 6

    if args[0]
      if not isNaN parseInt args[0]
        dice = parseInt args[0]

    if dice > 9999
      # Number greater than 9999, we don't allow this.
      dice = 9999

    roll = Math.round(Math.random() * dice)

    Bot.Messenger.sendMessage message.channel, 'ROLLDICE_OUTPUT',
      roll: roll
      dice: dice
