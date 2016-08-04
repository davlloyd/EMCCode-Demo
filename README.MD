RackHD, Mesos, Docker, Rexray and DVDi demo

<B>Requirements</B>
Enable Virtualbox web service
To enable The Virtualbox web service automatically change the disbled value to enabled in $HOME/Library/LaunchAgents/org.virtualbox.vboxwebsrv.plist
To enable manually run
- launchctl load ~/Library/LaunchAgents/org.virtualbox.vboxwebsrv.plist
/Applications/VirtualBox.app/Contents/MacOS/vboxwebsrv -H 0.0.0.0 -v
