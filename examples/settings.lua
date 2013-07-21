----------------------------------------------------------------------
-- Settings Example File.
-- The `Solstice/settings.lua` file will be read into a global table
-- OPT.  The file must be present or the system will throw an error.

-- The following are only those used by the Solstice library.
-- Those marked 'REQUIRED:' *must* be set.  Those marked 'OPTIONAL:'
-- are optional.  One can add any other server specific setting they
-- wish and have it available via the global table OPT.

-- REQUIRED: Log directory.
LOG_DIR = "../logs.0"

-- OPTIONAL: Preload file for server specific lua files.
PRELOAD = "ta.preload"

-- OPTIONAL: 
-- If set to false all CEP specific variables, baseitems, etc
-- will be ignored.  If set to a CEP version number without dots
-- (e,g 2.3c -> 23) CEP resources will be available.
USING_CEP = 23

----------------------------------------------------------------------
-- Fake server specific setting.
WHATEVER = "whatever"