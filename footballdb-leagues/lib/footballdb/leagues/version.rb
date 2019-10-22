# encoding: utf-8


module FootballDb
module Leagues

  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 0
  PATCH = 1
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "footballdb-leagues/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
  end

  def self.data_dir  ## rename to config_dir - why? why not?
    "#{root}/config"
  end

end # module Leagues
end # module FootballDb
