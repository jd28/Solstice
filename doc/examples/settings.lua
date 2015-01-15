----------------------------------------------------------------------
-- Settings Example File.
-- The `settings.lua` file will be read into a global table
-- OPT.  The file must be present or the system will throw an error.
--
-- The following are only those used by the Solstice library.
-- Those marked 'REQUIRED:' *must* be set.  Those marked 'OPTIONAL:'
-- are optional.  One can add any other server specific setting they
-- wish and have it available via the global table OPT.
--
-- Note: These needn't be set manually.  You can use
-- os.getenv() and read environment variables.  E,g.
-- `LOG_FILE = os.getenv('MYSERVER_LOG_FILE').
-- If you do set them manually, make sure not to check this file into
-- your version control.

-- REQUIRED: Log
LOG_FILE = "/opt/nwn/logs.0/mylogfile.txt"

-- OPTIONAL: Log file date pattern, see os.date() for options.  I recommend
-- this as the default is quite verbose.
LOG_DATE_PATTERN = "[%Y-%m-%d %X]"

-- REQUIRED: Consant loader.
CONSTANTS = "constants"

-- OPTIONAL:
DISABLE_CIRCLE_KICK = true

-- OPTIONAL:
DEVCRIT_DISABLE_ALL = true

-- OPTIONAL: Delete these if you don't want to use luadbi.  Not all
-- databases require the DATABASE_PORT to be set.
-- Database types: MySQL, PostgreSQL, SQLite3
DATABASE_TYPE = 'MySQL'
DATABASE_HOSTNAME = 'localhost'
DATABASE_USER = 'nwn'
DATABASE_PASSWORD = 'nwndb'
DATABASE_NAME = 'nwn'
--DATABASE_PORT = 23432

----------------------------------------------------------------------
-- You can add any settings that you'd like globally available/required
-- by your libraries or scripts and they will be available in the global
-- OPT table.
