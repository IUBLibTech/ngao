# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]
  include Arclight::SearchBehavior
  include BlacklightRangeLimit::RangeLimitBuilder


  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end

  self.default_processor_chain += [:return_all_fields_in_collection_context]

  ##
  # For the collection_context views, return all stored fields
  def return_all_fields_in_collection_context(solr_params)
    if %w[collection_context].include? blacklight_params[:view]
      solr_params[:fl] = '*'
    end
    solr_params
  end
end
