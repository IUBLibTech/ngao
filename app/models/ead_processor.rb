# frozen_string_literal: true
class EadProcessor

  # calls all the methods
  def self.import_eads(args = {})
    process_files(args)
  end

  # sets the url
  def self.client(args = {})
    args[:url] || 'https://aspacedev.dlib.indiana.edu/assets/ead_export/'
  end

  # Open web address with Nokogiri
  def self.page(args = {})
    Nokogiri::HTML(open(client(args)))
  end

  # open file and call extract
  def self.process_files(args={})
    for file_link in page(args).css('a')
      directory = file_link.children.text
      link = client(args) + file_link.attributes['href'].value
      next unless should_process_file(args, directory)

      open(link, 'rb') do |file|
        directory = directory.parameterize.underscore
        extract_and_index(file, directory)
      end
    end
  end

  # unzip the file and call index
  def self.extract_and_index(file, directory)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        path = "./data/#{directory}"
        FileUtils.mkdir_p path unless File.exist?(path)
        fpath = File.join(path, f.name)
        File.delete(fpath) if File.exist?(fpath)
        zip_file.extract(f, fpath)
        index_file(fpath, directory)
      end
    end
  end

  # index a file
  def self.index_file(filename, repository)
    ENV['REPOSITORY_ID'] = repository
    ENV['FILE'] = filename
    solr_url = begin
      Blacklight.default_index.connection.base_uri
    rescue StandardError
      ENV['SOLR_URL'] || 'http://127.0.0.1:8983/solr/blacklight-core'
    end
    `bundle exec rake arclight:index`
  end

  # get list of zip files to show on admin import page
  def self.get_repository_names(args = {})
    repositories = []
    for repository in page(args).css('a')
      name = repository.children.text
      repositories << name
    end
    return repositories
  end

  # check if should process file
  # if args are nil, process all zip files
  # otherwise, only process the specified file
  def self.should_process_file(args, name)
    args[:files].nil? || args[:files].include?(name)
  end
end
