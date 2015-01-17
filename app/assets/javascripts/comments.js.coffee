# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-comment').on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    $(this).prev(".new_comment").show()

  $('.comments').on 'ajax:success', '[data-action="destroy"]', (e, data, status, xhr) ->
    id = $(e.target).data('commentId')
    $(e.target).parent().remove()
    $(e.target).parent().next().remove()

  $('.comments').on 'click', '[data-action="edit"]', (e) ->
    e.preventDefault()
    $(this).hide()
    parent_name = $(this).data('parentName')
    parent_id = $(this).data('parentId')
    id = $(this).data('commentId')
    body = $(".comment##{id} > .comment-body").text()
    data = { parent_name: parent_name, parent_id: parent_id, comment_id: id, body: body }
    $(".comments").find("#" + id).append(HandlebarsTemplates["comments/form"](data))     

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe "/questions/#{questionId}/comments", (data, channel) ->
    $('.new_comment textarea').val('')
    comment = data['comment']
    $(".#{comment.parent_name} ##{comment.parent_id} .comments").append(HandlebarsTemplates["comments/new_comment"](comment))
    console.log($(".#{comment.parent_name} ##{comment.parent_id} .comments"))
    
  $('.new_comment').bind 'ajax:error', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    $(e.target).find('.comment-errors').html(errors.comments[0])

  $('.comments').on 'ajax:success', '.edit_comment', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText).comment
    console.log(comment)
    $(".comments").find("##{comment['id']}").html(HandlebarsTemplates["comments/comment"](comment))
    $(e.target).find('.edit-comment').show()
    $(e.target).remove()
    $(e.target).find('[data-action="edtit"]').show()
  .on 'ajax:error', '.edit_comment', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    console.log(errors)
    $(e.target).find('.comment-errors').html(errors.comments[0])
