-- Dismiss visible macOS notification banners via the keyboard.
--
-- How to use this script
-- 1. Open Shortcut app and create a new shortcut
-- 2. Add Run AppleScript
-- 3. Copy and Paste the code in this file 
-- 4. Add a Run with shortcode
-- 5. Run the Shortcut
-- 6. Open System Settings -> Privacy & Secrutiy -> Accessibility
-- 7. Enable Shortcuts.app  

on dismissOnce()
	tell application "System Events"
		if not (exists application process "NotificationCenter") then return false
		tell application process "NotificationCenter"
			if (count of windows) is 0 then return false
			set didSomething to false
			try
				set sa to scroll area 1 of group 1 of group 1 of window "Notification Center"
				-- Prefer "Clear All" on grouped stacks; otherwise close each banner.
				repeat with g in (UI elements of sa)
					repeat with a in (actions of g)
						set d to ""
						try
							set d to description of a
						end try
						if d is "Clear All" or d is "Close" or d is "Clear" then
							perform a
							set didSomething to true
							exit repeat
						end if
					end repeat
				end repeat
			end try
			return didSomething
		end tell
	end tell
end dismissOnce

repeat 25 times
	if not dismissOnce() then exit repeat
	delay 0.15
end repeat
