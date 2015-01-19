# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".answers").on "click", ".edit-answer-link", (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data("answerId")
    $("form#edit-answer-" + answer_id).show()

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe "/questions/#{questionId}/answers", (data, channel) ->
    $('.new_answer textarea').val('')
    answer = data['answer']
    $('.answers').append(HandlebarsTemplates["answers/answer"](answer))

  $('.answers').on 'ajax:success', 'form.edit_answer', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).hide()
    $(this).parent().find('.edit-answer-link').show()
    $(".answers").find("##{answer.id}").html(HandlebarsTemplates["answers/answer"](answer))
    # $(this).closest('.answer').children('.answer-body').html(answer.body)
    # files = ""
    # $.each answer.attachments, (index, value) ->
    #   name = value.file["url"]
    #   parts = name.split('/')
    #   name = parts[parts.length-1]
    #   files += "<li><a href='" + value.file["url"] + "'>" + name + "</li>"
    # $(this).closest('.answer').children('.answer-files').html(files)
  .bind 'ajax:error', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(e.target).find('.answer-errors').append(value)