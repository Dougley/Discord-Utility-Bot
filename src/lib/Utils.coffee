###
# Expose a utilities object which can be used for a wide variety of purposes.
###
module.exports = (Bot) ->
  ###
  # Checks to see if the specified user was mentioned within the string.
  #
  # If no user is specified, this checks if the bot was mentioned within the
  # string.
  ###
  mentions: (string, user) ->
    if not string
      return false

    if not user
      user = Bot.user

    return if (string.indexOf "<@#{ user.id }>") > -1 then true else false

  ###
  # Checks to see if the user is the owner of the bot.
  ###
  isOwner: (user) ->
    if not user
      return false

    if user.id == Bot.Config.permissions.owner
      true
    else
      false

  ###
  # Checks to see if the user is a friend.
  ###
  isFriend: (user) ->
    if not user
      return false

    if @isOwner user
      return true

    if user.id in Bot.Config.permissions.friends
      return true
    else
      return false
