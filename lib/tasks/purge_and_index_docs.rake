# frozen_string_literal: true

desc 'Clear EAD indexing history, destroy Solr docs, import all from AS'
task purge_and_index_docs: :environment do
  Rake::Task["clear_eads_history"].execute
  Rake::Task["arclight:destroy_index_docs"].execute
  Rake::Task["import_eads"].execute
end
