# frozen_string_literal: true

# Overrides for select ArcLight Core rake tasks
# https://github.com/projectblacklight/arclight/blob/master/lib/tasks/index.rake

require 'arclight'
require 'benchmark'

##### Override default arclight:index task to point to #####
##### NGAO-Arclight indexing rules (ead2_config.rb).   #####
Rake::Task['arclight:index'].clear

namespace :arclight do
  desc 'Index an EAD document, use FILE=<path/to/ead.xml> and REPOSITORY_ID=<myid>'
  task :index do
    raise 'Please specify your EAD document, ex. FILE=<path/to/ead.xml>' unless ENV['FILE']

    print "NGAO-Arclight loading #{ENV['FILE']} into index...\n"
    solr_url = begin
                 Blacklight.default_index.connection.base_uri
               rescue StandardError
                 ENV['SOLR_URL'] || 'http://127.0.0.1:8983/solr/blacklight-core'
               end
    elapsed_time = Benchmark.realtime do
      `bundle exec traject -u #{solr_url} -i xml -c ./lib/ngao-arclight/traject/ead2_config.rb #{ENV['FILE']}`
    end
    print "DUL-Arclight indexed #{ENV['FILE']} (in #{elapsed_time.round(3)} secs).\n"
  end
end
