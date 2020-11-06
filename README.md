# salty_l4d2_server

Dependencies
- CentOS 7 DigitalOcean droplet that is a minion to a salt master. Plus setting up ssh keys and what have you...
- You need to set the Steam Group ID in the /salt/l4d2-server/server.cfg.jinja file
- Clients need to subscribe to the workshop maps https://steamcommunity.com/sharedfiles/filedetails/?id=2218692186 
- Workshop files were too big for Github to be uploaded. They need to go into /srv/l4d2-mods/workshop on the salt master https://drive.google.com/drive/folders/1e4cfri626wTkqWHSPLDW2wEXQa9LnCae?usp=sharing 
- Same with missing_content.vpk, it needs to go into /srv/l4d2-mods/missing_content.vpk on the salt master

Deploying to minion
- salt '<minion>' state.highstate

Starting the server after deployed (currently ran on the minion after sshing in)
- /home/steam/L4D2/srcds_run -console -game left4dead2
