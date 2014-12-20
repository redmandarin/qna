module QuestionsHelper
  def tag_links(list)
    list.split(',').each { |tag| link_to tag.strip, tag_path(tag.strip) }.join(' ')
  end
end
