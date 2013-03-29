on run argv
	set dmgPath to item 1 of argv
	set mountPath to item 2 of argv
	set source to item 3 of argv
	set destination to item 4 of argv
	if length of destination < 3 or destination is equal to "/Applications" or destination is equal to "/Applications/" or destination is equal to "/" then
		log("CANNOT UPDATE APPIUM")
		return
	end if
	try
		do shell script "hdiutil detach \"" & mountPath & "\""
	end try
	do shell script "hdiutil attach \"" & dmgPath & "\""
	do shell script "rm -rf " & "\"" & destination & "/*\"" with administrator privileges
	do shell script "sudo cp -rvp \"" & source & "\" \"" & destination & "\"" with administrator privileges
	do shell script "hdiutil detach \"" & mountPath & "\""
	do shell script "rm -f /tmp/appium-updater"
end run