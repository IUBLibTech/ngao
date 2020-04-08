# frozen_string_literal: true
class UniversalViewer
  def initialize(document)
    @document = document
  end

  def manifest_url
    @document.digital_objects.first.href
  end
end
