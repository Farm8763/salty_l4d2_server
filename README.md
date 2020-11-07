# Dedicated L4D2 Server 
## With custom maps, 5 player coop and 5v5 versus

### Setting up salt master
- TODO: 

### Spinning up a DigitalOcean droplet
- You need to set up ssh keys with digitalocean, as well as access keys. See [Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-configuring-salt-cloud-to-spin-up-digitalocean-resources)  for advice
- Add your missing values to `/etc/salt/cloud.providers.d/digitalocean.conf`

### Command to spin up a droplet (dev droplet)
`salt-cloud -P -m /etc/salt/cloud.maps.d/dev-environment.map -l debug`

### Command to destroy a droplet
`salt-cloud -d -m /etc/salt/cloud.maps.d/dev-environment.map -l debug`

### Deploying L4D2 server to minion
#### Note: If you spun up the DigitalOcean droplet with the code above, it's already a minion. Otherwise you're on your own. 
- You need to set the Steam Group ID (`sv_steamgroup`) in the `/salt/l4d2-server/server.cfg.jinja` file. To get the value for your group, in the 'Edit group profile' the 'ID' is the group number you need for the server
- Clients need to subscribe to the workshop maps [Steam Workshop Collection](https://steamcommunity.com/sharedfiles/filedetails/?id=2218692186) or they can't connect when using a custom map.
- Workshop files were too big for Github to be uploaded. They need to go into `/srv/l4d2-mods/workshop` on the salt master. See [Google Drive with big files](https://drive.google.com/drive/folders/1a0FjSMaqX_FOQyrt26YtgmdzSO_SrCBg?usp=sharing)
- Same with missing_content.vpk, it needs to go into `/srv/l4d2-mods/missing_content.vpk` on the salt master

### Deploy (from salt master)
`salt '*' state.highstate`

### Starting the server after deployed (currently ran on the minion after sshing in as the steam user)
`/home/steam/L4D2/srcds_run -console -game left4dead2`

### TODO 
- Run the server as a service
