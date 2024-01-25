# ipatool-mass

Mass downloading IPA files from App Store using [ipatool](https://github.com/majd/ipatool).


## Usage

Form a files with list of bundles you want to download. See `example.txt`. Each line consists of bundle id and search term.
A bundle id is a sort of namespace of an app. To search for it, you can use `ipatool search`. As current version (`2.1.*`) of 
`ipatool` does not allow reading information about app by bundle, we need to use search term for finding recent 
app version for detecting if we need to download an update of an app.

Applications are downloaded to the current directory and then moved to subdirectories with names made of search terms. 
To mass download apps using list of apps do this:

`cat example.txt | ipatool-mass.sh`

Of course, you need to place `ipatool-mass.sh` to one of your `$PATH` directories.


## Notice about downloaded IPA files

All downloaded IPA files are signed by Apple and your Apple ID. You can install them to others people phones/pads, but on the first
run you will need to enter your Apple ID credentials. And do not forget to log out then in App Store!


## Installation of IPA files on iOS device

You can send file to your phone/pad using AirDrop or any other way and then just open it. System then will ask you if you would like to install application.
