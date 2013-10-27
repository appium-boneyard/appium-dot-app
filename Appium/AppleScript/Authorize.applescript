on run argv
	do shell script "cp /tmp/appium_authorization \"" & (item 1 of argv as text) & "\"" with administrator privileges
end run