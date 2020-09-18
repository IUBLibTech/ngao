# frozen_string_literal: true

desc 'Clear database entries for EADs to clear indexing history'
task clear_eads_history: :environment do
  Ead.delete_all
end
