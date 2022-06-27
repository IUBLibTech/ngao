<%= render(Blacklight::SearchBarComponent.new(
      url: search_action_url,
      params: search_state.params_for_search.except(:qt),
      search_fields: search_fields,
      presenter: presenter,
      autocomplete_path: search_action_path(action: :suggest))) %>



<div>
  <%= link_to 'More options', blacklight_advanced_search_engine.advanced_search_path(search_state.to_h), class: 'advanced_search btn btn-secondary'%>
</div>
