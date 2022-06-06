# frozen_string_literal: true

namespace :ngao do
  desc 'Clear single EAD from Solr'
  task delete_ead: :environment do
    raise 'Please specify your EAD document, ex. ead.xml' unless ENV['FILE']

    filename = ENV['FILE']
    solr_id = File.basename(filename)

    print "NGAO-Arclight deleting #{ENV['FILE']}...\n"

    if Rails.env == 'development'
      solr_url = 'http://localhost:8983/solr/blacklight-core'
    else
      solr_url = begin
                  Blacklight.default_index.connection.base_uri.to_s
                rescue StandardError
                  ENV['SOLR_URL'] || 'http://localhost:8983/solr/blacklight-core'
                end
    end
    # one slash per segment only please
    solr_url.chomp!('/')

    solr_elapsed_time = Benchmark.realtime do
      cmd = %Q{curl -X POST "#{solr_url}/update?commit=true" -H "Content-Type: text/xml" --data-binary "<delete><id>#{solr_id}</id></delete>"}
      puts cmd
      `#{cmd}`
    end

    print "NGAO-Arclight deleted #{filename} from solr index (in #{solr_elapsed_time.round(3)} secs).\n"

    postgres_elapsed_time = Benchmark.realtime do
      EadProcessor.remove_ead_from_db(filename)
    end

    print "NGAO-Arclight deleted #{filename} from postgres database (in #{postgres_elapsed_time.round(3)} secs).\n"
  end
end
