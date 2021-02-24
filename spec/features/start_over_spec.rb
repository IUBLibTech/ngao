# frozen_string_literal: true

RSpec.describe 'Start Over', type: :feature do
  context 'from catalog search' do
    it 'has correct url' do
      visit search_catalog_path q: 'a brief', search_field: 'all_fields'
      expect(page).to have_link('Start Over', href: '/')
    end
  end
end
