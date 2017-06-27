# TruckYeah!
#### Junior Design Georgia Tech Food Truck Project.
TruckYeah! is an app that lets students easily discover food trucks on Gergia Tech's campus and browse their menus. The app's user experience is its appeal over browsing through Georgia Tech Dining Services schedule and the individual food truck menus. The interface is intuivive and quick, optimized for a mobile screen.

## Building and Deployment (Install Guide)
The iOS application did not make it to the Apple App Store, but can easily be built and installed with Xcode 8.3 (on macOS only) and a valid Apple ID. The steps are as follows:

1. Install Xcode 8
1. Download the TruckYeah Source Code by cloning this repository
1. Open "TruckYeah.xcworkspace" in Xcode
1. Go to Xcode's Preferences > Accounts and add your Apple ID
. In Xcode's sidebar select "TruckYeah" and go to General > Identity. Append a word at the end of the Bundle Identifier e.g. com.truckyeah.name so it's unique. Select your Apple ID in Signing > Team
1. Connect your iPad or iPhone using USB and select it in Xcode's Product menu > Destination
1. Press CMD+R or Product > Run to install TruckYeah
1. If you install using a free (non-developer) account, make sure to rebuild TruckYeah every 7 days, otherwise it will quit at launch when your certificate expires

### Troubleshooting
Most issues enountered with installation will be related to Apple's code signing system for installing to a device. If these issues are encountered, be sure to follow the official [code signing guide](https://developer.apple.com/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html).


## Dependency Management
Dependency management is entierly done through CocoaPods with required versions listed. Dependencyies are stable but can be alterred or modified as described in the [CocoaPods Docs](https://cocoapods.org). 

## Version 0.9.0 Release Notes
This is the beta release of our app. All features are new and listed below: 

- Register a truckyeah account under any email
- Use the app as a regsitered user or guest user
- Browse list of trucks that come to Georgia Tech's Campus
- Filter list of trucks only to trucks currently on GT's campus
- View details of trucks including
	- Menu Items and prices
	- User submitted Reviews
	- User submitted photos	
- Edit user profile items including username and profile picture

### Bug Fixes
As this was the first release, there are no previous bug fixes. Bugs that were fixed during this release's life cycle can be seen on pivotal tracker.

### Known Bugs and Chores
Bugs and chores, along with incomplete features are documented at the project's [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1859347). Contact <nteissler@gatech.edu> if you need access.

## Features for Next Release

- Ability for truck owners to add the location of their truck to a campus map
- Ability for users to view campus map with truck locations
- Ability for users to edit/delete any review they posted as anonymous or under their username
