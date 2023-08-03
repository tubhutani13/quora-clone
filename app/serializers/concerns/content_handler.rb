module ContentHandler
  def content
    object.content.to_plain_text
  end
end
