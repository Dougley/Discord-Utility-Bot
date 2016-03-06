###
# Find command
###
module.exports = (Bot) ->
  # Load Utils.
  Utils = require('../Utils') Bot

  return (message, args) ->
    if (not Utils.isFriend message.author) or message.channel.isPrivate
      return

    if args.length == 0
      return Bot.Messenger.sendMessage message.channel, 'COMMAND_USAGE',
        usage: "#{Bot.user.username} #{Bot.Language.commands.find} <\"search string\"> [Messages amount] [@mention for user to lock to]"
        does: "Searches the channel used in for the search string. If given a user, only returns messages for that user."

    searchTerm = args[0].replace /[^\w\s_-]/gi, ''

    if (searchTerm.replace(/[\s]/gi, '').length < 4) or (searchTerm.length < 4)
      return Bot.Messenger.sendMessage message.channel, 'ERROR',
        err: "Your search term '#{searchTerm}' is not over 3 characters in length."

    searchTerm = searchTerm.toLowerCase()
    searchTerm = searchTerm.split ' '

    searchLimit = 100

    if args[1]
      searchLimit = parseInt args[1]

      if isNaN searchLimit
        searchLimit = 100

      if searchLimit > 10000
        searchLimit = 100

    if args[2]
      if ((args[2].indexOf '<@') == 0) and ((args[2].indexOf '>', args[2].length - 1 ) != -1)
        # We have a mention.
        searchID = args[2].substring 2, args[2].length - 1
      else
        # We might have an ID.
        searchID = args[2]
    else
      searchID = false

    Bot.Messenger.reply message, 'FIND_START',
      search: searchTerm.join ' '
      searchLimit: searchLimit
      user: if searchID then "user ID #{searchID}" else 'anyone'

    Bot.getChannelLogs message.channel, searchLimit, (err, messages) ->
      if err or messages.length == 0
        return Bot.Messenger.sendMessage message.author, 'ERROR',
          err: "Could not fetch message information for the channel '#{message.channel.name}'... Either there were no messages to check or I don't have the correct permissions to see message history.\n\nCheck to see if I have the right permissions and try again."

      results = []

      i = 0

      while i < messages.length
        currentMessage = messages[i]
        currentMessage.score = 0

        if searchID
          if currentMessage.author.id != searchID
            i++
            continue

        if currentMessage.id != message.id
          for term in searchTerm
            if (currentMessage.content.replace(/[^\w\s_-]/gi, '').toLowerCase().indexOf term) > -1
              currentMessage.score++

          if currentMessage.score > searchTerm.length - 1
            results.push currentMessage

        i++

      if 15 > results.length > 0
        Bot.Messenger.sendMessage message.author, 'FIND_RESULTS',
          search: searchTerm.join ' '
          searchLimit: searchLimit
          channel: message.channel
          results: results
          user: if searchID then "user ID #{searchID}" else 'anyone'

      else if 500 > results.length > 15
        Bot.HelperBotInternal.next.user[message.author.id] =
          command: Bot.Language.commands.next
          page: 2
          pageSize: 10
          data: results

          function: (Bot, msg) ->
            results = @data.slice (@pageSize * (@page - 1)), (@pageSize * @page)

            if results.length == 0
              # No more pages left
              Bot.Messenger.sendMessage msg.channel, 'NEXT_NONEXISTENT'
              return delete Bot.HelperBotInternal.next.user[message.author.id]

            Bot.Messenger.sendMessage message.author, 'FIND_CONTINUE',
              results: results
              page: @page
              pages: Math.round @data.length / @pageSize

            @page++

        Bot.Messenger.sendMessage message.author, 'FIND_RESULTSPAGE1',
          search: searchTerm.join ' '
          searchLimit: searchLimit
          channel: message.channel
          results: results.slice 0, 10
          totalResults: results.length
          pages: Math.round results.length / 10
          user: if searchID then "user ID #{searchID}" else 'anyone'

      else
        Bot.Messenger.sendMessage message.author, 'FIND_NORESULTS',
          search: searchTerm.join ' '
          searchLimit: searchLimit
          channel: message.channel
          user: if searchID then "user ID #{searchID}" else 'anyone'
