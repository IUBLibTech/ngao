# frozen_string_literal: true

desc 'Import and Index EADs'
task import_eads: :environment do
  EadProcessor.import_eads
end
