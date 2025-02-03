Simple bash script to split backup files from CNC machines with Fanuc controller, possibly other controllers.
On Fanuc controllers, at least the ones I have access to, backing up all the programs creates a single large file, not seperate program files. This simple script breaks the backup file into program files using the configuration of a program starting O1234, a capital letter O followed by 4 digits and ending at the beginning of the next program matching the starting condition.
I used this bash script successfully within Windows WSL under Ubuntu 24.04.1 LTS and previous versions, and tested to work with a RasPi so should work on other Linux systems as well.
There are a couple prerequisites to using this script as intended:
  -GNU Awk needs to be present, under Ubuntu "sudo apt install gawk" to install as its not present by default
  -finding the location of the systems tmpfs to keep the work in ram and increase preformance, using "df -h" will show where to find the systems tmpfs folders, in my case /run/user/1002
  -the script is linked into the /bin folder to activate it from any folder in the system, my hacky way was to link it from my script folder to the /bin folder ie "sudo ln -s /home/[user]/script/backup.sh /bin/backup" which also changes the name to backup from backup.sh, this allows the ability of using "backup <file>" to work from where ever the file may be located.

To change the location of the tmpfs location, edit the backup.sh script on the line starting "working=" to change to your location from the default working=/run/user/1002/ to the location of your usable tmpfs folder found with "df -h", on Ubuntu.
