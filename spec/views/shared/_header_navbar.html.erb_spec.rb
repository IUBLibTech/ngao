RSpec.describe 'shared/_header_navbar.html.erb', type: :view do
  context 'header' do
    before do
      allow(view).to receive(:render_search_bar).and_return('')
      render
    end
    it 'renders iu branding' do
      expect(rendered).to render_template('layouts/_branding_bar')
    end
  end
end
