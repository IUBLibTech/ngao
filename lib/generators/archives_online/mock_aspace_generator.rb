# frozen_string_literal: true

require 'rails/generators'

module ArchivesOnline
  ##
  # Arclight install generator
  class MockAspace < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def mock_as_export
      directory 'as_export', 'public/as_export', force: true
    end
  end
end
