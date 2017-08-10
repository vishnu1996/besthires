
class Country < ActiveRecord::Base

  INDIA = 'india'
  UNITED_KINGDOM = 'united_kingdom'
  UNITED_STATES = 'united_states'

  def self.options_for_select
    self.all.order('"default" desc, key').map{ |country| [country.display_name, country.key] }
  end

end
