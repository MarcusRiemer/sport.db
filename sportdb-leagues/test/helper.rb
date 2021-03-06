## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code

require 'sportdb/leagues'




class Configuration
  def initialize
    recs      = SportDb::Import::CountryReader.read( "#{SportDb::Test.data_dir}/world/countries.txt" )
    @countries = SportDb::Import::CountryIndex.new( recs )
  end

  def countries() @countries; end
end

config = Configuration.new
SportDb::Import::LeagueReader.config = config
SportDb::Import::LeagueIndex.config  = config
