##########################
## from CsvPackage



  def find_entries_by_season_n_division

      entries = {}
      ####
      # Example package:
      ##  note: uses season key (e.g. 2012/13 and NOT 2012-13)
      ##        AND uses division key (as string) and NOT level key e.g. "3 and not 3
      ##             possible division keys include "3a", "3b", "2n", "2s", etc.
      # { "2012/13" => { "1" => ["2012-13/1-proleague.csv"] },
      #   "2013/14" => { "1" => ["2013-14/1-proleague.csv"] },
      #   "2014/15" => { "1" => ["2014-15/1-proleague.csv"] },
      #   "2015/16" => { "1" => ["2015-16/1-proleague.csv"] },
      #   "2016/17" => { "1" => ["2016-17/1-proleague.csv"] },
      #   "2017/18" => { "1" => ["2017-18/1-proleague.csv"] }
      # }

     ## note: use full package path as root path
     ##  e.g. ./o/be-belgium or something
     root_path = @path
     pp root_path

     season_paths = Dir.glob( "#{root_path}/**/{#{SEASON_PATTERNS.join(',')}}" )
     season_paths.each_with_index do |season_path,i|


       ## note: cut-off in_root (to pretty print path)
       season_path_rel = season_path[root_path.length+1..-1]
       puts "season folder [#{i+1}/#{season_paths.size}]: >#{season_path_rel}< (#{season_path}):"

       season_basename = File.basename( season_path_rel )
       season_key      = SeasonUtils.key( season_basename )
       #   e.g. 2012-13   => 2012/13
       #    or  2012-2013 => 2012/13
       season = entries[ season_key ] ||= {}


       ## note: assume 1-,2- etc. gets us back sorted leagues
       ##  - use sort. (will not sort by default)
       datafile_paths = Dir.glob( "#{season_path}/*.csv").sort
       datafile_paths.each_with_index do |datafile_path,j|

           ## note: cut-off in_root (to pretty print path)
           datafile_path_rel = datafile_path[root_path.length+1..-1]
           puts "   datafile [#{j+1}/#{datafile_paths.size}]: >#{datafile_path_rel}< (#{datafile_path})"

           ## get level/tier for datafile
           ##  todo/fix:
           ##    allow datafiles without level/tier   - use "x" or something for key -why? why not?
           ##    allow datafiles with level/tier AND divisions e.g. 3a,3b, 2n,2s, etc.
           ##      - note: always use division as string for lookup!!

           ## get level/tier (division really)
           datafile_basename = File.basename( datafile_path_rel, '.csv' ) ## todo/check .csv correct?
           division_key      = LevelUtils.division( datafile_basename )

           ## todo/fix:  check if divison is present
           ##              if not use '?' - why? why not?
           season[ division_key ] ||= []
           season[ division_key ] <<  datafile_path_rel
       end  # each datafile_paths

     end # each season_paths
     entries
   end # method find_entries_by_season_n_division
