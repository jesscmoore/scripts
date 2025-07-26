#!/usr/bin/osascript

# Get position of an application window

# Usage: osascript get_window_pos.applescript

# 20250726 jm: Tried resizing windows with applescript but hit permission problems, instead used rectangle

-- 20250726 jm: Take application name as arg and add
-- usage help
-- # Fetch arguments
-- on run argv

--     set argList to {}
--     repeat with arg in argv
--         set end of argList to quoted form of arg & space
--     end repeat

--     tell application "Terminal"
--         activate
--         do script "echo " & argList as string
--     end tell

-- end run

-- Log to stdout
log("Getting position of window Skim.app")


-- Get the window dimensions of the Skim window:
tell application "Skim.app" to set window_geometry0 to (get the bounds of the front window)
log(window_geometry0)


-- -- 20250726 jm: Resize application code - not working on macos15.5
-- tell application "System Events"
--     log("inside sys events call")
--     set position of first window of application process "Skim.app" to {100, 100}
--     -- set position of front window of process "Skim.app" to {100, 100}
-- end tell

-- -- Get the window dimensions of the Skim window:
-- tell application "Skim.app" to set window_geometry1 to (get the bounds of the front window)
-- log(window_geometry1)
