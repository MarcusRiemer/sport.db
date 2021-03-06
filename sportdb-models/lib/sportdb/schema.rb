
module SportDb

class CreateDb

def up
  ActiveRecord::Schema.define do

create_table :teams do |t|
  t.string  :key,   null: false   # import/export key
  t.string  :title, null: false
  t.string  :title2
  t.string  :code     # make it not null?  - three letter code (short title)
  t.string  :synonyms  # comma separated list of synonyms
  t.references :country,   null: false
  t.references :city     # NB: city is optional (should be required for clubs e.g. non-national teams)
  t.boolean  :club,     null: false, default: false  # is it a club (not a national team)?

  t.integer :since     # founding year
  t.string  :address
  t.string  :web

  t.references :assoc   # optional: national football assoc(iation), for example - used for national teams

  ### fix: remove and add virtual attribute in model instead
  t.boolean  :national, null: false, default: false  # is it a national selection team (not a club)?
  t.timestamps
end

add_index :teams, :key, unique: true

###########
# check: use table (rename to) venues / stadiums - why? why not?
create_table :grounds do |t|
  t.string     :key,      null: false   # import/export key
  t.string     :title,    null: false
  t.string     :synonyms   # comma separated list of synonyms

  t.references :country,  null: false
  t.references :city     # todo: make city required ???

  t.integer :since     # founding year
  t.integer :capacity  # attentence capacity e.g. 10_000 or 50_000 etc.
  t.string  :address


  ### fix/todo: add since/founded/opened/build attrib  eg. 2011 or 1987
  ##   - add capacity e.g. 40_000
  ##  fix: add address !!!! etc

  ## add region ??? or just use region from city ??

  t.timestamps
end

add_index :grounds, :key, unique: true


# join table: person+game(team1+team2+event(season+league))
create_table :goals do |t|
  t.references  :person,   null: false
  t.references  :game,     null: false
  t.references  :team,     null: false     ##  use integer instead w/ values 1 or 2  for team1 or team2 ?? why? why not?

  t.integer   :minute
  t.integer   :offset,  null: false, default: 0    # e.g. 45' +3 or 90' +2

  t.integer   :score1
  t.integer   :score2

  ## type of goal (penalty, owngoal)
  t.boolean   :penalty,   null: false, default: false
  t.boolean   :owngoal,   null: false, default: false  # de: Eigentor -> # todo: find better name?

  t.timestamps
end


################
#  fix/todo: rename to squads / lineups

# join table -> person+team+event(season+league)
create_table :rosters do |t|   # use squads as an alternative name? why? why not??
  t.references :person,  null: false
  t.references :team,    null: false
  t.references :event      # make required?
  t.integer    :pos,      null: false

  t.timestamps
end


create_table :events do |t|
  t.string      :key,      null: false   # import/export key
  t.references  :league,   null: false
  t.references  :season,   null: false
  t.date        :start_at, null: false    # NB: only use date (w/o time)
  t.date        :end_at   # make it required???  # NB: only use date (w/o time)
  t.boolean     :team3,    null: false, default: true   ## e.g. Champions League has no 3rd place (only 1st and 2nd/final)

  #### track 1-n sources (from repos)  - # todo move to its own table later
  ## NB: relative to event.yml - use mapper to "resolve" to full path w/ repo; use league+season keys
  t.string      :sources    #  e.g. cup or bl,bl_ii   # NB: for now store all in on string separated by comma
  t.string      :config  # e.g. cup or bl #  e.g assumes cup.yml, bl.yml etc. for now


  t.timestamps
end

add_index :events, :key, unique: true


create_table :rounds do |t|
  t.references :event,    null: false, index: false  ## Note: do NOT auto-add index
  t.string     :title,    null: false
  t.string     :title2
  t.integer    :pos,      null: false
  ## add new table stage/stages for grouping rounds in group rounds and playoff rounds, for example???
  ## # "regular" season (group) games or post-season (playoff) knockouts (k.o's)
  t.boolean    :knockout, null: false, default: false
  t.date   :start_at, null: false     # NB: only use date (w/o time)
  t.date   :end_at    # todo: make it required e.g. :null => false    # NB: only use date (w/o time)

  ## auto-added flag (e.g. start_at n end_at dates got calculated)
  ##  if auto-added flag is false - do NOT auto-update start_at, end_at etc.
  t.boolean    :auto, null: false, default: true

  t.timestamps
end

add_index :rounds, :event_id  # fk event_id index


create_table :groups do |t|     # Teamgruppe (zB Gruppe A, Gruppe B, etc.)
  t.references :event,    null: false, index: false    ## Note: do NOT auto-add index
  t.string     :title,    null: false
  t.integer    :pos,      null: false
  t.timestamps
end

add_index :groups, :event_id  # fk event_id index


create_table :stages do |t|     # e.g. regular season, champions round, etc.
  t.references :event,    null: false, index: false    ## Note: do NOT auto-add index
  t.string     :title,    null: false
  t.timestamps
end

add_index :stages, :event_id  # fk event_id index



###########################
# fix: rename table to matches
create_table :games do |t|
  t.string     :key          # import/export key
  t.references :round,    null: false, index: false   ## Note: do NOT auto-add index
  t.integer    :pos,      null: false
  t.references :group,                 index: false   ## Note: do NOT auto-add index  -- group is optional
  t.references :stage,                 index: false     # optional - regular seasion / champions round etc.
  t.references :team1,    null: false, index: false   ## Note: do NOT auto-add index
  t.references :team2,    null: false, index: false   ## Note: do NOT auto-add index

  t.datetime   :play_at,   null: false
  t.boolean    :postponed, null: false, default: false
  t.datetime   :play_at_v2   # optional old date (when postponed)
  t.datetime   :play_at_v3   # optional odl date (when postponed twice)

  t.references :ground    # optional - stadium (lets you get city,region,country,etc)
  t.references :city      # optional - convenience for ground.city_id ???


  t.boolean    :knockout, null: false, default: false
  t.boolean    :home,     null: false, default: true    # is team1 play at home (that is, at its home stadium)
  t.integer    :score1
  t.integer    :score2
  t.integer    :score1et  # extratime - team 1 (opt)
  t.integer    :score2et  # extratime - team 2 (opt)
  t.integer    :score1p   # penalty  - team 1 (opt)
  t.integer    :score2p   # penalty  - team 2 (opt) elfmeter (opt)
  t.integer    :score1i   # half time / first third (opt)
  t.integer    :score2i   # half time - team 2
  t.integer    :score1ii  # second third (opt)
  t.integer    :score2ii  # second third - team2 (opt)
  t.references :next_game, index: false   ## Note: do NOT auto-add index  -- for hinspiel bei rueckspiel in knockout game
  t.references :prev_game, index: false   ## Note: do NOT auto-add index

  t.integer    :winner      # 1,2,0,nil  calculate on save  - "real" winner (after 90 or extra time or penalty, aggregated first+second leg?)
  t.integer    :winner90    # 1,2,0,nil  calculate on save  - winner after 90 mins (or regugular play time depending on sport - add alias or find  a better name!)

  t.timestamps
end

add_index :games, :key,  unique: true
add_index :games, :round_id      # fk round_id index
add_index :games, :group_id      # fk group_id index
add_index :games, :next_game_id  # fk next_game_id index
add_index :games, :prev_game_id  # fk next_game_id index
add_index :games, :team1_id
add_index :games, :team2_id


# todo: remove id from join table (without extra fields)? why?? why not??
create_table :events_teams do |t|
  t.references :event, null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :events_teams, [:event_id, :team_id], unique: true
add_index :events_teams, :event_id


# todo: remove id from join table (without extra fields)? why?? why not??
create_table :stages_teams do |t|
  t.references :stage, null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :stages_teams, [:stage_id, :team_id], unique: true
add_index :stages_teams, :stage_id



# todo: remove id from join table (without extra fields)? why?? why not??
create_table :events_grounds do |t|
  t.references :event,   null: false, index: false    ## Note: do NOT auto-add index
  t.references :ground,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :events_grounds, [:event_id, :ground_id], unique: true
add_index :events_grounds, :event_id



create_table :groups_teams do |t|
  t.references :group, null: false, index: false    ## Note: do NOT auto-add index
  t.references :team,  null: false, index: false    ## Note: do NOT auto-add index
  t.timestamps
end

add_index :groups_teams, [:group_id, :team_id], unique: true
add_index :groups_teams, :group_id


### todo: add models and some seed data

create_table :seasons do |t|  ## also used for years
  t.string :key,   null: false
  t.string :title, null: false   # e.g. 2011/12, 2012/13 ### what to do w/ 2012? for world cup etc?
  t.timestamps
end

create_table :leagues do |t|  ## also for cups/conferences/tournaments/world series/etc.
  t.string     :key,   null: false
  t.string     :title, null: false     # e.g. Premier League, Deutsche Bundesliga, World Cup, Champions League, etc.
  t.references :country   ##  optional for now ,   :null => false   ### todo: create "virtual" country for international leagues e.g. use int? or world (ww?)/europe (eu)/etc. similar? already taken??

  ## fix: rename to :clubs from :club
  t.boolean    :club,          null: false, default: false  # club teams or national teams?
  ## todo: add t.boolean  :national flag? for national teams?
  ## t.boolean  :international, :null => false, :default => false  # national league or international?
  ## t.boolean  :cup     ## or regular season league??
  t.timestamps
end

create_table :badges do |t|
  t.references  :team,  null: false
  ## todo/fix: use event insead of league+season ??
  ## t.references  :event, :null => false   # event => league+season
  t.references  :league, null: false
  t.references  :season, null: false
  t.string      :title,  null: false   # Meister, Weltmeister, Europameister, Cupsieger, Vize-Meister, Aufsteiger, Absteiger, etc.
  t.timestamps
end


create_table :assocs do |t|
  t.string     :key,   null: false
  t.string     :title, null: false     # e.g. Premier League, Deutsche Bundesliga, World Cup, Champions League, etc.

  t.integer    :since     # founding year
  t.string     :web

  ### if national assoc - has (optional) country ref
  t.references :country   # note: optional - only used/set (required) for national assocs (or subnational too?)
  t.boolean    :national,    null: false, default: false

  ## add :world flag for FIFA? - just check if parent is null? for root assoc(s)? why? why not?
  ## add :regional flag for continental subdivision?
  t.boolean :continental,      null: false, default: false
  t.boolean :intercontinental, null: false, default: false  # e.g. arab football league (africa+western asia/middle east)
  t.timestamps
end

add_index :assocs, :key, unique: true



create_table :assocs_assocs do |t|
  t.references :assoc1, null: false, index: false   ## Note: do NOT auto-add index  -- parent assoc
  t.references :assoc2, null: false, index: false   ## Note: do NOT auto-add index  -- child assoc is_member_of parent assoc
  t.timestamps
end

add_index :assocs_assocs, [:assoc1_id,:assoc2_id], unique: true
add_index :assocs_assocs, :assoc1_id
add_index :assocs_assocs, :assoc2_id



############################################
# stats tables

# use tables for standings e.g group_tables? - why? why not?
#
# todo: add group_standings per round with pos diffs e.g +1,+2, -3 etc.

create_table :group_standings do |t|
  t.references  :group,    null: false
  t.timestamps
end

### use items instead of entries - why (shorter! simple plural e.g. just add s)

create_table :group_standing_entries do |t|
  t.references  :group_standing,  null: false
  t.references  :team,            null: false
  t.integer     :pos
  t.integer     :played
  t.integer     :won
  t.integer     :lost
  t.integer     :drawn
  t.integer     :goals_for             # todo: find a short name - gf? why? why not?
  t.integer     :goals_against         # todo: find a shorter name - ga? why? why not?
  t.integer     :pts
  t.string      :comments
  t.timestamps
end


create_table :event_standings do |t|
  t.references  :event,   null: false
  t.timestamps
end

create_table :event_standing_entries do |t|
  t.references  :event_standing,  null: false
  t.references  :team,            null: false
  t.integer     :pos
  t.integer     :played
  t.integer     :won
  t.integer     :lost
  t.integer     :drawn
  t.integer     :goals_for             # todo: find a short name - gf? or for? why? why not?
  t.integer     :goals_against         # todo: find a shorter name - ga? or against? why? why not?
  t.integer     :pts
  t.string      :comments
  t.timestamps
end


## flex (free-style/form) standings table - lets you add as many events as you like (not bound to single event/season/etc.)
##  -use (find a better) a different name? why? why not?
create_table :alltime_standings do |t|
  t.string    :key,   null: false
  t.string    :title, null: false
  t.timestamps
end

create_table :alltime_standing_entries do |t|
  t.references  :alltime_standing,  null: false
  t.references  :team,              null: false
  t.integer     :pos
  t.integer     :played    # todo: use a different name - why? why not?
  t.integer     :won
  t.integer     :lost
  t.integer     :drawn
  t.integer     :goals_for             # todo: find a short name - gf? why? why not?
  t.integer     :goals_against         # todo: find a shorter name - ga? why? why not?
  t.integer     :pts
  t.integer     :recs               # note: specific to alltime - stats records counter (e.g. appearance counter)
  t.string      :comments
  t.timestamps
end


  end  # Schema.define
end # method up


end # class CreateDb

end # module SportDb
