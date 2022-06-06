Arclight::SolrDocument.class_eval do
  def containers
    fetch('containers_ssim', [])
  end
end
