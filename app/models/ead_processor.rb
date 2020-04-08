# frozen_string_literal: true
class EadProcessor
  require 'nokogiri'
  require 'zip'
  require 'fileutils'
  require 'arclight'
  require 'benchmark'

  def self.import_eads
    uri = "https://aspacedev.dlib.indiana.edu/assets/ead_export/"
    page = Nokogiri::HTML(open(uri)) # Open web address with Nokogiri

    for file_link in page.css('a')
      link = uri + file_link.attributes['href'].value
      open(link, 'rb') do |file|
        directory = file_link.children.text
        extract_zip(file, directory)
      end
    end
  end

  def self.extract_zip(file, directory)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        path = "./data/#{directory}"
        FileUtils.mkdir_p path unless File.exist?(path)
        fpath = File.join(path, f.name)
        File.delete(fpath) if File.exist?(fpath)
        zip_file.extract(f, fpath)
        run_index_task(fpath, directory)
      end
    end
  end

  def self.run_index_task(filename, directory)
    repository = directory
    # TODO - run the indexer from model
    puts "#{filename}, #{repository}"
    solr_url = begin
      Blacklight.default_index.connection.base_uri
    rescue StandardError
      ENV['SOLR_URL'] || 'http://127.0.0.1:8983/solr/blacklight-core'
    end
    # `bundle exec traject -u #{solr_url} -i xml -c ./lib/ngao-arclight/traject/ead2_config.rb #{filename}`
  end
end
