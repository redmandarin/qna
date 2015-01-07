# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-comment').on 'click', (e) ->
    $(this).hide()
    e.preventDefault()
    $(this).prev(".new_comment").show()

  $('.comments').on 'click', '[data-action="edit"]', (e) ->
    e.preventDefault()
    $(this).hide()
    parent = $(this).data('parentName')
    parent_id = $(this).data('parentId')
    id = $(this).data('targetId')
    body = $(".comment##{id} > .comment-body").text()
    data = { "parent": parent, "parent_id": parent_id, "target_id": id, "body": body  }
    console.log(data)
    $(".comment##{id}").append(HandlebarsTemplates["comments/form"](data))

  $('.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText).comment
    $(e.target).closest('.question').find('.comments').append(HandlebarsTemplates["comments/new_comment"](comment))
    $(e.target).find('textarea').val('')
    $(e.target).hide()
    $('.add-comment').show()
    $(e.target).find('.comment-errors').html('')
  .bind 'ajax:error', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    $(e.target).find('.comment-errors').html(errors.comments[0])

  $('.comments').on 'ajax:success', '.edit_comment', (e, data, status, xhr) ->
    comment = $.parseJSON(xhr.responseText).comment
    $(".comment##{comment['id']}").html(HandlebarsTemplates["comments/comment"](comment))
    $(e.target).find('.edit-comment').show()
    $(e.target).remove()
    $(e.target).find('[data-action="edtit"]').show()
  .bind 'ajax:error', (e, xhr, status, errors) ->
    errors = $.parseJSON(xhr.responseText)
    $(e.target).find('.comment-errors').html(errors.comments[0])
