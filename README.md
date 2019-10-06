# nm-scripts

The `nm-scripts` was intented to solve the problem of the **endless** amount of time takes to delete `node_moudles` directory.  

The idea is to create a `VHD` (Virtual Hard Drive) file for each `node_modules` directory that we want to maintain and then simply mount it in the relevant path.  
When we want to clear `node_modules` we can simply format the mounted `VHD` volume which takes few seconds.  

The repository contains 4 scripts and it is recommended to clone the repository and put the directory in the `PATH`.

### nm-config
This command must be run on first use to configure the default `VHD`s size and the `VHD`s directory

`nm-config -DefaultDiskSize 1GB -DisksFolder <Path>`

### nm-create
This command creates a `VHD` file and mount it to `node_modules` under the current directory

`nm-create` -Folder <Path>

* `Folder` is optional and defaults to current directory

### nm-clear
This command format the current mounted `node_modules`

`nm-clear` -Folder <Path>

* `Folder` is optional and defaults to current directory

### nm-delete
This command dismount `node_modules` and delete the `VHD` file.

`nm-delete` -Folder <Path>

* `Folder` is optional and defaults to current directory


## Notes
* Scripts need to be run elevated as adminstrator
* It works only in Windows
