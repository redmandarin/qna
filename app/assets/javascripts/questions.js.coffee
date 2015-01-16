# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').on 'click', (e) ->
    $(this).hide()
    $('.edit_question').show()
    e.preventDefault()

  $('.question').on 'ajax:success', '.destroy-question-file', ->
    $(this).parent().hide()

  PrivatePub.subscribe "/questions", (data, channel) ->
    console.log(data)
    question = $.parseJSON(data['question'])
    date = moment(question.created_at).format('D.M.YYYY')
    question.created_at = date    
    $('.questions').append(HandlebarsTemplates["questions/question_link"](question))