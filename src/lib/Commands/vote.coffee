###
# Vote command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if message.channel.isPrivate
      return

    if args.length == 0
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} #{Bot.Language.commands.vote} <vote option | start | end>"
        does: "Starts, ends, or votes for an option in a vote."

    voteName = "#{message.channel.server.id}_#{message.channel.id}"

    if args[0].toLowerCase() == 'start'
      if not Utils.isFriend message.author
        return

      if args.length < 4
        return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
          usage: "#{Bot.user.username} #{Bot.Language.commands.vote} start <\"Question\"> <\"Response 1\"> <\"Response 2\"> [\"Response 3\"]"
          does: "Starts a vote in chat."

      if not Bot.HelperBotInternal[voteName]
        Bot.HelperBotInternal[voteName] =
          inProgress: false
          question: ''
          options: [
            # {
            #   title: 'Option title.'
            #   votes: 0
            #   voters: []
            # }
          ]

      if Bot.HelperBotInternal[voteName].inProgress
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like a vote is already happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} status."

      for option in args.slice 2, 12
        if option != 'start' and option != 'end' and option != 'status'
          Bot.HelperBotInternal[voteName].options.push
            title: option
            internalTitle: option.toLowerCase()
            votes: 0
            voters: []
        else
          Bot.HelperBotInternal[voteName].options = []
          return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "You used a reserved keyword as an option. You cannot use 'start', 'end', or 'status' as options in your votes."

      Bot.HelperBotInternal[voteName].inProgress = true
      Bot.HelperBotInternal[voteName].question = args[1]

      Bot.Messenger.sendMessage message.channel, 'VOTE_START',
        vote: Bot.HelperBotInternal[voteName]

    else if args[0].toLowerCase() == 'status'
      if not Bot.HelperBotInternal[voteName]
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like no vote is happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} start."

      if not Bot.HelperBotInternal[voteName].inProgress
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like no vote is happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} start."

      Bot.HelperBotInternal[voteName].options.sort (a, b) ->
        if a.votes < b.votes
          return -1

        if a.votes > b.votes
          return 1

        return 0

      Bot.Messenger.sendMessage message.channel, 'VOTE_STATUS',
        vote: Bot.HelperBotInternal[voteName]

    else if args[0].toLowerCase() == 'end'
      if not Utils.isFriend message.author
        return

      if not Bot.HelperBotInternal[voteName]
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like no vote is happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} start."

      if not Bot.HelperBotInternal[voteName].inProgress
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like no vote is happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} start."

      Bot.HelperBotInternal[voteName].inProgress = false

      Bot.HelperBotInternal[voteName].options.sort (a, b) ->
        if a.votes < b.votes
          return -1

        if a.votes > b.votes
          return 1

        return 0

      winner = { votes: -1 }

      # Find the winner
      for option in Bot.HelperBotInternal[voteName].options
        if option.votes > winner.votes
          winner = option

        else if option.votes == winner.votes
          winner =
            title: "A TIE BETWEEN #{winner.title} AND #{option.title}"
            votes: option.votes

      Bot.Messenger.sendMessage message.channel, 'VOTE_END',
        vote: Bot.HelperBotInternal[voteName]
        winner: winner

    else
      # No options specified, lets see if this is an actual option
      if not Bot.HelperBotInternal[voteName]
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like no vote is happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} start."

      if not Bot.HelperBotInternal[voteName].inProgress
        return Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like no vote is happening in chat. Try #{Bot.user.username} #{Bot.Language.commands.vote} start."

      voted = Bot.HelperBotInternal[voteName].options.filter (opt) ->
        for user in opt.voters
          if user.id == message.author.id
            return true

        return false

      if voted.length == 0
        # They haven't voted yet.
        matched = Bot.HelperBotInternal[voteName].options.filter (option) ->
          if option.internalTitle == args[0].toLowerCase()
            return true

          return false

        if matched.length > 0
          # We have a match!
          option = matched[0]

          option.votes++
          option.voters.push message.author

          Bot.Messenger.sendMessage message.channel, 'SUCCESS'
        else
          Bot.Messenger.sendMessage message.channel, 'ERROR', err: "I couldn't find that option for you to vote for. Check #{Bot.user.username} #{Bot.Language.commands.vote} status for the options."
      else
        # They've already voted...
        Bot.Messenger.sendMessage message.channel, 'ERROR', err: "Looks like you've already voted..."
