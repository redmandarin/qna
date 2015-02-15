module SearchHelper
  def link_for_search(object)
    case object.class.name
    when 'Question'
      link_to(object.title, object)
    when 'Answer'
      link_to(object.question.title, object.question)
    when 'Comment'
      case object.commentable_type
      when 'Question'
        link_to(object.commentable.title, object.commentable)
      when 'Answer'
        link_to(object.commentable.question.title, object.commentable.question)
      end
    end
  end
end
