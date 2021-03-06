# encoding: utf-8

module SportDb
  module Importer

class Country

    ### todo/fix:
    ##  add ALTERNATE / ALTERNATIVE COUNTRY KEYS!!!!
    ##   e.g. d => de, a => at, en => eng, etc.
    ##   plus  add all fifa codes too   aut => at, etc.  - why? why not?


def self.find!( q )   ## e.g. key = 'eng' or 'de' etc.
   ## note: use built-in countries for mapping country keys/codes
   country_data = SportDb::Import.config.countries[ q ]
   if country_data
     if country_data.key != q.to_s
       puts "** note: mapping (normalizing) country key >#{q}< to >#{country_data.key}<"
     end
     key = country_data.key
   else
     puts "** !!! ERROR !!! unknown / invalid country for key >#{q}<; sorry - add to COUNTRIES table"
     exit 1
   end

   rec = WorldDb::Model::Country.find_by( key: key )
   if rec.nil?
       puts "** !!! ERROR !!! - country for key >#{key}< not found; sorry - add to COUNTRIES table"
       exit 1
   end
   rec
end


def self.find_or_create_builtin!( q )   ## e.g. key = 'eng' or 'de' etc.
  ## note: use built-in countries for mapping country keys/codes
  country_data = SportDb::Import.config.countries[ q ]
  if country_data
    if country_data.key != q.to_s
      puts "** note: mapping (normalizing) country key >#{q}< to >#{country_data.key}<"
    end
    key = country_data.key
  else
    puts "** !!! ERROR !!! unknown / invalid country for key >#{q}<; sorry - add to COUNTRIES table"
    exit 1
  end

   rec = WorldDb::Model::Country.find_by( key: key )
   if rec.nil?
      rec = WorldDb::Model::Country.create!(
              key:  country_data.key,
              name: country_data.name,
              code: country_data.fifa,  ##   fix:  uses fifa code now (should be iso-alpha3 if available)
              fifa: country_data.fifa,
              area: 1,
              pop:  1)
   end
   rec
end

end # class Country



### add season
class Season

def self.find_or_create_builtin( key )  ## e.g. key = '2017-18'

  ## note:  "normalize" season key
  ##   always use 2017/18  (and not 2017-18 or 2017-2018 or 2017/2018)
  ## 1) change 2017-18 to 2017/18
  key = key.tr( '-', '/' )
  ## 2) check for 2017/2018 - change to 2017/18
  if key.length == 9
    key = "#{key[0..3]}/#{key[7..8]}"
  end

  season = SportDb::Model::Season.find_by( key: key )
  if season.nil?
     season = SportDb::Model::Season.create!(
       key:   key,
       title: key
     )
  end
  pp season
  season
end
end # class Season



class League

def self.find!( key )  ## e.g. key = 'en' or 'en.2' etc.
  ##  en,    English Premier League
  key = key.to_s
  rec = SportDb::Model::League.find_by( key: key )
  if rec.nil?
    puts "** unknown league for key >#{key}<; sorry - add to LEAGUES table"
    exit 1
  end
  rec
end

def self.find_or_create( key, name:, **more_attribs )
   key = key.to_s
   rec = SportDb::Model::League.find_by( key: key )
   if rec.nil?

     ## add convenience lookup for country  e.g. country: 'eng' or country: 'at', etc.
     if more_attribs[:country].is_a?( String )
       country_key = more_attribs.delete( :country )
       more_attribs[ :country_id ] = SportDb::Importer::Country.find_or_create_builtin!( country_key ).id
     end

     ## use title and not name - why? why not?
     ##  quick fix:  change name to title
     attribs = { key:   key,
                 title: name }.merge( more_attribs )
     rec = SportDb::Model::League.create!( attribs )
   end
   rec
end



###
##  todo/fix:  move LEAGUES to sportdb-config

## built-in countries for (quick starter) auto-add
LEAGUES = {    ## rename to AUTO or BUILTIN_LEAGUES or QUICK_LEAGUES  - why? why not?
  ## en:  'English Premier League',    ## use eng why? why not?
  eng: 'English Premier League',    ## use en why? why not?
  sco: 'Scottish Premiership',
  fr:  'Ligue 1',
  at:  'Österr. Bundesliga',
  de:  '1. Bundesliga',
  'de.2': '2. Bundesliga',
}

def self.find_or_create_builtin!( key )  ## e.g. key = 'eng' or 'eng.2' etc.
  ##  en,    English Premier League
  key = key.to_s
  league = SportDb::Model::League.find_by( key: key )
  if league.nil?
     ### check quick built-in auto-add league data
      league_data = LEAGUES[ key.to_sym ]
     if league_data
       ## note: assume first part in key is country key e.g. eng, sco, de, at, etc.
       country_key =  key.split( '.' )[0]
       league = SportDb::Model::League.create!(
                   key:        key,
                   title:      league_data,  # e.g. 'English Premier League'
                   country_id: SportDb::Importer::Country.find_or_create_builtin!( country_key ).id,
                   ## club: true
                )
     else
       puts "** unknown league for key >#{key}<; sorry - add to LEAGUES table"
       exit 1
     end
  end
  league
end
end # class League


end # module Importer
end # module SportDb
