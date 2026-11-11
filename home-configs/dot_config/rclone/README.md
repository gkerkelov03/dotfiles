This is the tool that we use to sync a local folder with a Google Drive folder
the setup involves a systemd service and a timer located in
~/dotfiles/home-configs/dot_config/systemd/user/
google-drive-sync.service
google-drive-sync.timer

the timer file only tells how often should the service run for example every 5 minutes and the service just runs a command. This command is the script google-drive-sync.sh with argument run. Basically the service is doing

~/dotfiles/scripts/google-drive-sync.sh run

check the script to see how it works. Btw it needs a google cloud console app setup
because it needs access to your Drive so there need to be an app registered and we need
its client_id and client_secret. The script reads those from keepassxc there is an entry named rclone
