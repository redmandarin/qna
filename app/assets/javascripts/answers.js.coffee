# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".edit-answer-link").on "click", (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data("answerId")
    $("form#edit-answer-" + answer_id).show()

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    files = ""
    $.each answer.attachments, (index, value) ->
      name = value.file["url"]
      parts = name.split('/')
      name = parts[parts.length-1]
      files += "<li><a href='" + value.file["url"] + "'>" + name + "</li>"
    $('.answers').append("<div class='answer'><p>" + answer.body + "<ul class='answer-files'>" + files + "</ul></p>" + "<p><a class='edit-answer-link' data-answer-id='#{answer.id}'' href target='_self'>редактировать ответ</a></p><hr/></div>")
  .bind 'ajax:error', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).hide()
    $(this).parent().find('.edit-answer-link').show()
    $(this).closest('.answer').children('.answer-body').html(answer.body)
    files = ""
    $.each answer.attachments, (index, value) ->
      name = value.file["url"]
      parts = name.split('/')
      name = parts[parts.length-1]
      files += "<li><a href='" + value.file["url"] + "'>" + name + "</li>"
    $(this).closest('.answer').children('.answer-files').html(files)
  .bind 'ajax:error', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(e.target).find('.answer-errors').append(value)