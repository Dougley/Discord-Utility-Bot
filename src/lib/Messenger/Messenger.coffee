# Required libraries
debug = require('debug') 'utility-bot:messenger'
Mustache = require 'mustache'

###
# Creates a message sender which uses language files.
###
Messenger = (Bot) ->
  if not Bot
    throw new Error 'No Discord.js object was passed into the Messenger.'

  ###
  # Reply to a message following language template.
  ###
  reply: (message, template, data) ->
    @getTemplateData template
    .then (templateData) ->
      msg = Mustache.render templateData, data

      message.reply msg

    .catch (err) ->
      msg = """
            An error occurred while generating a message using the language templates in the languages file.
            ```
            #{err}
            ```
            """

      Bot.sendMessage Bot.Owner, msg

    return

  ###
  # Send a message following language template.
  ###
  sendMessage: (channel, template, data) ->
    @getTemplateData template
    .then (templateData) ->
      msg = Mustache.render templateData, data

      Bot.sendMessage channel, msg

    .catch (err) ->
      msg = """
            An error occurred while generating a message using the language templates in the languages file.
            ```
            #{err}
            ```
            """

      Bot.sendMessage Bot.Owner, msg

    return

  ###
  # Get data from file or from 'this' for use in Mustache.
  ###
  getTemplateData: (templateName) ->
    new Promise (resolve, reject) ->
      template = templateName.split ':'
      language = Bot.Language.phrases

      i = 0

      while i < template.length
        if language.hasOwnProperty template[i]
          if i == template.length - 1
            if typeof language[template[i]] == 'string' or language[template[i]] instanceof String
              return resolve language[template[i]]
            else
              return reject "The template #{templateName} is not a string."
          else
            language = language[template[i]]
            i++
        else
          return reject "The template #{templateName} does not exist."

###
# Expose Messenger.
###
module.exports = Messenger
