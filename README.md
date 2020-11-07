# Dedicated L4D2 Server with custom maps and 5 player coop/5v5 versus
Setting up salt master
- TODO: 

Spinning up a DigitalOcean droplet
- Need to set up ssh keys with digitalocean, as well as access keys. See https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-configuring-salt-cloud-to-spin-up-digitalocean-resources  for advice
- Add missing values to /etc/salt/cloud.providers.d/digitalocean.conf

Command to spin up a droplet (dev droplet)
- salt-cloud -P -m /etc/salt/cloud.maps.d/dev-environment.map -l debug 

Command to destroy a droplet
- salt-cloud -d -m /etc/salt/cloud.maps.d/dev-environment.map -l debug

Deploying L4D2 server to minion
- Note: If you spun up the DigitalOcean droplet with the code above, it's already a minion. Otherwise you're on your own. 
- You need to set the Steam Group ID in the /salt/l4d2-server/server.cfg.jinja file. To get it for your group, in the 'Edit group profile' the 'ID' is the group number you need for the server
- Clients need to subscribe to the workshop maps https://steamcommunity.com/sharedfiles/filedetails/?id=2218692186 or they can't connect when using a custom map.
- Workshop files were too big for Github to be uploaded. They need to go into /srv/l4d2-mods/workshop on the salt master https://drive.google.com/drive/folders/1e4cfri626wTkqWHSPLDW2wEXQa9LnCae?usp=sharing 
- Same with missing_content.vpk, it needs to go into /srv/l4d2-mods/missing_content.vpk on the salt master
- Deploy (from salt master) with: salt '*' state.highstate

Starting the server after deployed (currently ran on the minion after sshing in)
- /home/steam/L4D2/srcds_run -console -game left4dead2

TODO 
- Run the server as a service
- Clean up Readme formatting
