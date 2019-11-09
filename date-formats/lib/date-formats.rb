# encoding: utf-8

require 'pp'
require 'time'
require 'date'

## 3rd party libs/gems
require 'logutils'


###
# our own code
require 'date-formats/version' # let version always go first
require 'date-formats/reader'
require 'date-formats/source'


module DateFormats

#############
# helpers for building format regex patterns
MONTH_EN       = build_names( MONTH_NAMES[:en] )
# e.g. Jan|Feb|March|Mar|April|Apr|May|June|Jun|...
DAY_EN         = build_names( DAY_NAMES[:en] )
# e.g.

MONTH_FR       = build_names( MONTH_NAMES[:fr] )
DAY_FR         = build_names( DAY_NAMES[:fr] )

MONTH_ES       = build_names( MONTH_NAMES[:es] )
MONTH_PT       = build_names( MONTH_NAMES[:pt] )
MONTH_DE       = build_names( MONTH_NAMES[:de] )
MONTH_IT       = build_names( MONTH_NAMES[:it] )

end  # module DateFormats



require 'date-formats/formats'
require 'date-formats/date'




puts DateFormats.banner   # say hello
