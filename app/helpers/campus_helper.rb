
module CampusHelper
  include ActiveSupport::Concern

  CAMPUSES = {
    "US-InU" => "Indiana University Bloomington",
    "US-InU-Sb" => "Indiana University South Bend",
    "US-InU-Se" => "Indiana University Southeast",
    "US-inrmiue" => "Indiana University East",
    "US-InU-K" => "Indiana University Kokomo",
    "US-iniu" => "Indiana University-Purdue University, Indianapolis",
    "US-InU-N" => "Indiana University Northwest"
  }

  def convert_campus_id value
    # returns a default value of "Indiana University" if there is no corresponding mainagencycode
    CAMPUSES[value] || "Indiana University"
  end
end