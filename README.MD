#RackHD, Mesos, Docker, Rexray and DVDi Vagrant Demo Setup

###Prerequisites:
- Install git (*https://git-scm.com/downloads*)
- Install Vagrant (*https://www.vagrantup.com/downloads.html*)
- Install Virtualbox (*https://www.virtualbox.org/wiki/Downloads*)
    - Either change to the directory that Virtualbox has been installed into (e.g. 'c:\program files\oracle\virtualbox' for Windows) or add the path to your Path variable. This is needed to run the following commands. 
    - Disable account authentication for virtualbox web server '*VBoxManage setproperty websrvauthlibrary null*'
    - Run Virtualbox web service '*vboxwebsrv -H 0.0.0.0* -v'
      - web service application found in /Applications/VirtualBox.app/Contents/MacOS/ on OSX and c:\program files\oracle\virtualbox in windows  
      - On OSX you can get it to start automatically by editing the file *$HOME/Library/LaunchAgents/org.virtualbox.vboxwebsrv.plist* and changing the run value from 'disabled' to 'enabled'
- Clone repository to local directory '*git clone https://github.com/davlloyd/EMCCode-Demo.git*

### Getting started
Run the Shell script *code-demo.sh* and select what you want to do... that easy. If you are using Windows then all my testing is doen within Git Bash Shell for shell scripting support.


### Notes
- RackHD port 8080 is redirected to local 9090 so to get to the UI you use the url http://localhost:9090/ui
- 

