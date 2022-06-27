# frozen_string_literal: true
class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory
  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelperonfig.cache_store = :memory_store
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
