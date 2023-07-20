# frozen_string_literal: true
class UniversalViewer
  def initialize(document)
    @document = document
  end

  def to_partial_path
    'viewers/_universal_viewer'
  end

  def manifest_url
    @document.digital_objects.first.href
  end

  def uv_host
    ENV['UV_HOST']
  end

  def uv_config_host
    ENV['UV_CONFIG_HOST']
  end
end
