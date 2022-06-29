# frozen_string_literal: true

##### COPIED FROM ARCLIGHT TO ADD CAMPUS LEVEL #####

module Arclight
  # Controller for our /repositories index page
  ##### Added group by campus and sorting alphabetically for campus and repository #####
  class RepositoriesController < ApplicationController
    def index
      @repositories = Arclight::Repository.all
      # sort by the resolved campus name, not the campus id
      @campuses = @repositories
          .group_by{ |campus| campus.campus }
          .sort{|a,b| helpers.convert_campus_id(a.first).downcase <=> helpers.convert_campus_id(b.first).downcase}
      load_collection_counts
    end

    def show
      @repository = Arclight::Repository.find_by!(slug: params[:id])
      search_service = Blacklight.repository_class.new(blacklight_config)
      @response = search_service.search(
        q: "level_sim:Collection repository_sim:\"#{@repository.name}\"",
        rows: 50,
        sort: 'title_sort asc'
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
