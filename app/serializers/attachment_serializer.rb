class AttachmentSerializer < ActiveModel::Serializer
  attributes :filename, :url

  def filename
    object.file.file.filename
  end

  def url
    object.file.url
  end
end