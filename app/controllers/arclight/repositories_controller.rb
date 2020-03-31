# frozen_string_literal: true

##### COPIED FROM ARCLIGHT TO ADD CAMPUS LEVEL #####

module Arclight
  # Controller for our /repositories index page
  ##### Added group by campus and sorting alphabetically for campus and repository #####
  class RepositoriesController < ApplicationController
    def index
      @repositories = Arclight::Repository.all
      @campuses = @repositories.sort_by{ |repository| repository.name }.group_by{ |campus| campus.campus }.sort
      load_collection_counts
    end

    def show
      @repository = Arclight::Repository.find_by!(slug: params[:id])
      search_service = Blacklight.repository_class.new(blacklight_config)
      @response = search_service.search(
        q: "level_sim:Collection repository_sim:\"#{@repository.name}\"",
        rows: 100
      )
      @collections = @response.documents
    end

    private

    def load_collection_counts
      counts = fetch_collection_counts
      @repositories.each do |repository|
        repository.collection_count = counts[repository.name] || 0
      end
    end

    def fetch_collection_counts
      search_service = Blacklight.repository_class.new(blacklight_config)
      results = search_service.search(
        q: 'level_sim:Collection',
        'facet.field': 'repository_sim',
        rows: 0
      )
      Hash[*results.facet_fields['repository_sim']]
    end
  end
end
