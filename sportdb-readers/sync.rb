# encoding: UTF-8

module SportDb

module Sync
  class Country
    def self.find_or_create( country )
       rec = WorldDb::Model::Country.find_by( key: country.key )
       if rec.nil?
         attribs = {
           key:  country.key,
           name: country.name,
           code: country.fifa,  ## fix:  uses fifa code now (should be iso-alpha3 if available)
           fifa: country.fifa,
           area: 1,
           pop:  1
         }
         rec = WorldDb::Model::Country.create!( attribs )
       end
       rec
    end
  end # class Country

  class League
    def self.find!( league )
      SportDb::Model::League.find_by!( key: league.key )
    end
    def self.find_or_create( league )
       rec = SportDb::Model::League.find_by( key: league.key )
       if rec.nil?
         ## use title and not name - why? why not?
         ##  quick fix:  change name to title
         attribs = { key:   league.key,
                     title: league.name }
         if league.country
           attribs[ :country_id ] = Country.find_or_create( league.country ).id
         end

         rec = SportDb::Model::League.create!( attribs )
       end
       rec
    end
  end # class League

  class Season
    def self.find!( key )
      ## note:  "normalize" season key
      ##   always use 2017/18  (and not 2017-18 or 2017-2018 or 2017/2018)
      ## 1) change 2017-18 to 2017/18
      key = key.tr( '-', '/' )
      ## 2) check for 2017/2018 - change to 2017/18
      if key.length == 9
        key = "#{key[0..3]}/#{key[7..8]}"
      end
      SportDb::Model::Season.find_by!( key: key )
    end
    def self.find_or_create( key )  ## e.g. key = '2017-18'

      ## note:  "normalize" season key
      ##   always use 2017/18  (and not 2017-18 or 2017-2018 or 2017/2018)
      ## 1) change 2017-18 to 2017/18
      key = key.tr( '-', '/' )
      ## 2) check for 2017/2018 - change to 2017/18
      if key.length == 9
        key = "#{key[0..3]}/#{key[7..8]}"
      end

      rec = SportDb::Model::Season.find_by( key: key )
      if rec.nil?
         attribs = { key:   key,
                     title: key  }
         rec = SportDb::Model::Season.create!( attribs )
      end
      rec
    end
  end # class Season

  class Club
    def self.find_or_create( club )
      rec = SportDb::Model::Team.find_by( title: club.name )
      if rec.nil?
        ## remove all non-ascii a-z chars
        key  = club.name.downcase.gsub( /[^a-z]/, '' )
        puts "add club: #{key}, #{club.name}, #{club.country.name} (#{club.country.key})"

        attribs = {
          key:       key,
          title:     club.name,
          country_id: Country.find_or_create( club.country ).id,
          club:       true,
          national:   false  ## check -is default anyway - use - why? why not?
          ## todo/fix: add city if present - why? why not?
        }
        if club.alt_names.empty? == false
          attribs[:synonyms] = club.alt_names.join('|')
        end

        rec = SportDb::Model::Team.create!( attribs )
      end
      rec
    end
  end # class Club

  class Event
    def self.find!( league:, season: )
      SportDb::Model::Event.find_by!( league_id: league.id, season_id: season.id  )
    end
    def self.find_or_create( league:, season: )
      rec = SportDb::Model::Event.find_by( league_id: league.id, season_id: season.id  )
      if rec.nil?
        ## quick hack/change later !!
        ##  todo/fix: check season  - if is length 4 (single year) use 2017, 1, 1
        ##                               otherwise use 2017, 7, 1
        ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
        ## hack:  fix/todo1!!
        ##   add "fake" start_at date for now
        if season.key.size == '4'   ## e.g. assume 2018 etc.
          year = season.key.to_i
          start_at = Date.new( year, 1, 1 )
        else  ## assume 2014/15 etc.
          year = season.key[0..3].to_i
          start_at = Date.new( year, 7, 1 )
        end

        attribs = {
          league_id: league.id,
          season_id: season.id,
          start_at:  start_at  }

        rec = SportDb::Model::Event.create!( attribs )
      end
      rec
    end
  end  # class Event

  class Round
    def self.find_or_create( round, event: )
       rec = SportDb::Model::Round.find_by( title: round.title, event_id: event.id )
       if rec.nil?
         attribs = { event_id: event.id,
                     title:    round.title,
                     pos:      round.pos,
                     start_at: event.start_at.to_date
                   }
         rec = SportDb::Model::Round.create!( attribs )
       end
       rec
    end
  end # class Round

  class Match
    def self.create_or_update( match, event: )
       ## note: MUST find round, thus, use bang (!)
       round_rec = SportDb::Model::Round.find_by!( event_id: event.id,
                                                   title:    match.round.title )

       rec = SportDb::Model::Game.find_by( round_id: round_rec.id,
                                           team1_id: match.team1.id,
                                           team2_id: match.team2.id )
       if rec.nil?
         attribs = { round_id: round_rec.id,
                     team1_id: match.team1.id,
                     team2_id: match.team2.id,
                     pos:      999,    ## make optional why? why not? - change to num?
                     play_at:  match.date.to_date,
                     score1:   match.score1,
                     score2:   match.score2,
                     score1i:  match.score1i,
                     score2i:  match.score2i }
         rec = SportDb::Model::Game.create!( attribs )
       else
         # update - todo
       end
       rec
    end
  end # class Match

end # module Sync
end # module SportDb
