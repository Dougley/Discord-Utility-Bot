###
# Info command
###
module.exports = (Bot) ->
  return (message, args) ->
    ###
    # We don't use the languages file, as it makes it easier to remove
    # attribution and other important info for users that don't know what
    # they're doing.
    ###

    msg = """
          Hi there, #{message.author.mention()}! My name is #{Bot.user.username} and I'm a robot coded by deansheather. I run on Node.js and I use the Discord API library Discord.js.

          Language: Node.js
          Discord API Library: Discord.js
          Creator (developer): <@134122930828214273>
          Owner of this bot: #{Bot.Owner.mention()}
          Uptime: #{Math.floor Bot.uptime / 1000} seconds

          If you need any help, use my help command: `#{Bot.user.username} #{Bot.Language.commands.help}`.

          If you're having any problems with me, talk to my owner.
          """

    Bot.sendMessage message.channel, msg
