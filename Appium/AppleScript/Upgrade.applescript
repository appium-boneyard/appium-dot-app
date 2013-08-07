on run argv
	set dmgPath to item 1 of argv
	set mountPath to item 2 of argv
	set source to item 3 of argv
	set appPath to item 4 of argv
	set destination to item 5 of argv
	if length of appPath < 3 or appPath is equal to "/Applications" or appPath is equal to "/Applications/" or appPath is equal to "/" or appPath does not end with ".app" then
		log("CANNOT UPDATE APPIUM")
		return
	end if
	try
		do shell script "hdiutil detach \"" & mountPath & "\""
	end try
	do shell script "hdiutil attach \"" & dmgPath & "\""
	do shell script "rm -rf " & "\"" & appPath & "/\"" with administrator privileges
	do shell script "cp -R \"" & source & "\" \"" & destination & "\""
	do shell script "hdiutil detach \"" & mountPath & "\""
	do shell script "rm -f /tmp/appium-updater"
end run