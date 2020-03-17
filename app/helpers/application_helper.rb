module ApplicationHelper
  include Blacklight::LocalePicker::LocaleHelper

  def additional_locale_routing_scopes
    [blacklight, arclight_engine]
  end

  CAMPUSES = {
    "US-InU" => "Indiana University, Bloomington",
    "US-InU-Sb" => "Indiana University South Bend",
    "US-InU-Se" => "Indiana University Southeast",
    "US-inrmiue" => "Indiana University East",
    "US-InU-K" => "Indiana University Kokomo",
    "US-iniu" => "Indiana University-Purdue University, Indianapolis",
    "US-InU-N" => "Indiana University Northwest"
  }

  def render_campus_name args
    value = args[:value] || []
    return CAMPUSES[value[0]]
  end

  def convert_campus_id value
    return CAMPUSES[value]
  end

end
