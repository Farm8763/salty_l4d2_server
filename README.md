# Dedicated L4D2 Server + Elasticstack Monitoring
## With custom maps, 5 player coop and 5v5 versus
Building on some groundwork by [@Mustack](https://github.com/Mustack) , this project automated the creation of a L4D2 Dedicated server. With the 2020 pandemic we started playing more L4D2 and found documentation for setting up a dedicated server severely lacking/outdated. This project will setup a server with some select custom maps, 5 player coop and 5v5 versus. Modify `/srv/salt/top.sls` if you don't want every mod deployed.

### Setting up salt master
#### Note: You need a Salt Master to run this project. Recommended CentOS 7.
- Follow the procedures on the Saltstack page [Saltstack Package Repo](https://repo.saltstack.com/#rhel) make sure to select the correct tab for CentOS 7. This was only tested/ran on CentOS 7. 
- You definitely need `salt-master` and `salt-cloud`, you might need `salt-api` and `salt-ssh`
- Checkout the project files into their specific folders

### Spinning up a DigitalOcean droplet
- You need to set up ssh keys with digitalocean, as well as access keys. See [Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-configuring-salt-cloud-to-spin-up-digitalocean-resources)  for advice
- Add your missing values to `/etc/salt/cloud.providers.d/digitalocean.conf`

### Command to spin up a droplet (dev droplet)
`salt-cloud -P -m /etc/salt/cloud.maps.d/dev-environment.map -l debug`

### Deploying L4D2 server to minion
#### Note: If you spun up the DigitalOcean droplet with the code above, it's already a minion. Otherwise you're on your own. 
- You need the Steam Group ID when deploying the server (below). To get the value for your group, in the 'Edit group profile' the 'ID' is the group number you need for the server
- Clients need to subscribe to the workshop maps [Steam Workshop Collection](https://steamcommunity.com/sharedfiles/filedetails/?id=2218692186) or they can't connect when using a custom map.
- Workshop files were too big for Github to be uploaded. They need to go into `/srv/salt/l4d2-mods/workshop` on the salt master. See [Google Drive with big files](https://drive.google.com/drive/folders/1a0FjSMaqX_FOQyrt26YtgmdzSO_SrCBg?usp=sharing)
- Same with missing_content.vpk, it needs to go into `/srv/salt/l4d2-mods/missing_content.vpk` on the salt master

### Deploy
#### Note: Ran on the salt master
##### Minimum to deploy
`salt '*' state.highstate pillar='{"steamgroup": "<steamgroup #>"}'`

Eg: `salt '*' state.highstate pillar='{"steamgroup": "12345678"}'`

##### Optionally, you can pass in server_mode and max_players for L4D2 as well. For Elastic monitoring, it's recommended to provide a default password
`salt '*' state.highstate pillar='{"steamgroup": "<steamgroup #>", "max_player_count": "<number of players>", "server_mode":"<coop|versus>", "bootstrap_pass": "<password>"}'`

Eg: `salt '*' state.highstate pillar='{"steamgroup": "12345678", "max_player_count": "7", "server_mode":"coop", "bootstrap_pass": "Solarwinds123"}'`

### Starting the L4D2 server after deployed 
#### Note: Currently ran on the minion after sshing in as the steam user
`/home/steam/L4D2/srcds_run -console -game left4dead2 -gamestatsloggingtofile -condebug -developer -dev`

### Kibana
#### Note: Kibana currently deploys with a self-signed cert
Kibana is deployed at `https://<monitoring_server_ip>:5601/` , you can log in with the user 'elastic' and the password you provided above.

Filebeat will be deployed to the L4D2 server, and the ingest pipeline will be set up automatically in Kibana/Elasticsearch to parse the incoming logs.

### Sample visualizations
#### Note: Names have been changed
##### Kill/Death Stats
![kills](https://user-images.githubusercontent.com/1817337/134778074-09cd6955-8253-4bc2-8cca-1e185c4570b9.JPG)

##### More Kill/Death Stats
![more_kill](https://user-images.githubusercontent.com/1817337/134778089-91949489-e08e-4c72-8d74-fb63345fa0e1.JPG)

##### Tracking who killed who
![revenge](https://user-images.githubusercontent.com/1817337/134778092-e6686679-ad3b-4367-afd8-3e180ab5f0d4.JPG)

##### Weapon Damage Word Cloud
![word_damage](https://user-images.githubusercontent.com/1817337/134778094-ae058e67-b00c-40f7-87de-6cce316959c9.JPG)

##### Zombie Weapon Stats
![zomb_weapons](https://user-images.githubusercontent.com/1817337/134778099-98f9a56c-9bdd-42ca-a765-cdd3f48d84f7.JPG)

##### The weapons that killed you
![killed_by](https://user-images.githubusercontent.com/1817337/134778101-3a1c9b4f-3ddc-4cc7-a990-c31fd424a7d6.JPG)

##### Your top weapons
![7weapons](https://user-images.githubusercontent.com/1817337/134778103-59c18a72-16dd-4e66-bf48-a6b42dd45f17.JPG)


### External Dependancies
#### Note: Fetched automatically or included
- [Sourcemod v1.10.0-r6499](https://www.sourcemod.net/)
- [Metamod v1.10.7-r971](https://www.sourcemm.net/)
- [L4dtoolz L4D2 Mod v1.0.0.9h](https://forums.alliedmods.net/showthread.php?t=93600)
- [Superversus L4D2 Mod](https://forums.alliedmods.net/showthread.php?p=830069?p=830069)

### Resources
- [How to setup a dedicated server on Debian/Ubuntu](https://steamcommunity.com/sharedfiles/filedetails/?id=895492473)
- [L4D2 Cvars](https://developer.valvesoftware.com/wiki/List_of_L4D2_Cvars)
- [Digital Ocean User Setup](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-centos-quickstart)
- [Digital Ocean Salt Cloud Tutorial](https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-configuring-salt-cloud-to-spin-up-digitalocean-resources)
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD#Linux)
- [Original server config](https://www.dropbox.com/s/5i7kovj8fd2g6zv/Detailed%20Server%20Config.txt?dl=0)
- [Custom L4D2 Campaigns](https://steamcommunity.com/sharedfiles/filedetails/?id=625654184)



### TODO 
- Run the server as a service
- Salt doesn't seem to support SSH key file passwords
