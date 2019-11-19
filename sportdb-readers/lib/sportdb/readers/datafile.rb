

module Datafile


  ## todo/fix: move regex patterns upstream to datafile in sportdb-formats!!

  CONF_RE  = %r{ /\.conf\.txt$
               }x


  CLUB_PROPS_RE = %r{  (?:^|/)               # beginning (^) or beginning of path (/)
                         (?:[a-z]{1,4}\.)?   # optional country code/key e.g. eng.clubs.props.txt
                        clubs\.props\.txt$
                     }x
  def self.match_club_props( path, pattern: CLUB_PROPS_RE ) pattern.match( path ); end


  ZIP_RE = %r{ \.zip$
            }x
  def self.match_zip( path, pattern: ZIP_RE ) pattern.match( path ); end



class DirPackage    ## todo/check: find a better name e.g. UnzippedPackage, FilesystemPackage, etc. - why? why not?
class Entry
  def initialize( pack, path )
    @pack = pack  ## parent package
    @path = path
    ## todo/fix!!!!: calculate @name (cut-off pack.path!!!)
    @name =  path
  end
  def name()  @name; end
  def read()  File.open( @path, 'r:utf-8' ).read; end
end  # class DirPackage::Entry


  attr_reader :name, :path

  def initialize( path )
    @path = path   ## rename to root_path or base_path or somehting - why? why not?

    basename = File.basename( path )   ## note: ALWAYS keeps "extension"-like name if present (e.g. ./austria.zip => austria.zip)
    @name = basename
  end

  def each( pattern:,  extension: 'txt' )    ## todo/check: rename to glob or something - why? why not?
    ##   use just .* for extension or remove and check if File.file? and skip File.directory? - why? why not?
    ## note: incl. files starting with dot (.)) as candidates (normally excluded with just *)
    Dir.glob( "#{@path}/**/{*,.*}.#{extension}" ).each do |path|
      ## todo/fix: (auto) skip and check for directories
      if pattern.match( path )
        yield( Entry.new( self, path ))
      else
        ## puts "  skipping >#{path}<"
      end
    end
  end

  def find( name )
    Entry.new( self, "#{@path}/#{name}" )
  end
end  # class DirPackage


## helper wrapper for datafiles in zips
class ZipPackage
class Entry
  def initialize( pack, entry )
    @pack  = pack
    @entry = entry
  end

  def name()  @entry.name; end
  def read
    txt = @entry.get_input_stream.read
    ##  puts "** encoding: #{txt.encoding}"  #=> encoding: ASCII-8BIT
    txt = txt.force_encoding( Encoding::UTF_8 )
    txt
  end
end # class ZipPackage::Entry

  attr_reader :name, :path

  def initialize( path )
    @path = path

    extname  = File.extname( path )    ## todo/check: double check if extension is .zip - why? why not?
    basename = File.basename( path, extname )
    @name = basename
  end

  def each( pattern: )
    Zip::File.open( @path ) do |zipfile|
      zipfile.each do |entry|
        if entry.directory?
          next ## skip
        elsif entry.file?
          if pattern.match( entry.name )
            yield( Entry.new( self, entry ) )   # wrap entry in uniform access interface / api
          else
            ## puts "  skipping >#{entry.name}<"
          end
        else
          puts "** !!! ERROR !!! #{entry.name} is unknown zip file type in >#{@path}<, sorry"
          exit 1
        end
      end
    end
  end

  def find( name )
     entries = match_entry( name )
     if entries.empty?
       puts "** !!! ERROR !!! zip entry >#{name}< not found in >#{@path}<; sorry"
       exit 1
     elsif entries.size > 1
       puts "** !!! ERROR !!! ambigious zip entry >#{name}<; found #{entries.size} entries in >#{@path}<:"
       pp entries
       exit 1
     else
       Entry.new( self, entries[0] )    # wrap entry in uniform access interface / api
     end
  end

private
  def match_entry( name )
    ## todo/fix:  use Zip::File.glob or find_entry or something better/faster?  why? why not?

    pattern = %r{ #{Regexp.escape( name )}    ## match string if ends with name
                   $
                }x

    entries = []
    Zip::File.open( @path ) do |zipfile|
      zipfile.each do |entry|
        if entry.directory?
          next ## skip
        elsif entry.file?
          if pattern.match( entry.name )
            entries << entry
          end
        else
          puts "** !!! ERROR !!! #{entry.name} is unknown zip file type in >#{@path}<, sorry"
          exit 1
        end
      end
    end
    entries
  end
end  # class ZipPackage
end  # module Datafile
