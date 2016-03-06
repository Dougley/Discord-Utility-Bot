###
# Choose command
###
module.exports = (Bot) ->
  return (message, args) ->
    if args.length < 2
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} #{Bot.Language.commands.choose} <\"choice 1\"> <\"choice 2\"> [\"choice 3...\"]"
        does: "Randomly selects an item from the given choices."

    if args.length > 9999
      # Choices amount greater than 9999, we don't allow this.
      args = args.slice 0, 9998

    choice = args[Math.floor Math.random() * args.length]

    Bot.Messenger.sendMessage message.channel, 'CHOOSE_OUTPUT', choice: choice
