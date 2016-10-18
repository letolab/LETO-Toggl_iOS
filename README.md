# LETO-Toggl_iOS

An OpenSource Location Based Time Tracking App  
![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat) [![License](https://img.shields.io/aur/license/yaourt.svg)](https://github.com/letolab/LETO-Toggl_iOS/blob/master/LICENSE)

[![image](https://linkmaker.itunes.apple.com/images/badges/en-us/badge_appstore-lrg.svg)](https://itunes.apple.com/us/app/leto-toggl-location-based/id1103212267?mt=8)

It uses [Toggl](https://toggl.com/) service for time tracking. 

## Project Set Up

This project requires Xcode 6+ and supports iOS 8+. To start working on the project, clone this repository on your machine using your Git client of choice (e.g. [SourceTree](http://www.sourcetreeapp.com/)) or by running the following command in a Terminal window:

	git clone https://github.com/letolab/LETO-Toggl_iOS.git

This project uses [CocoaPods](http://cocoapods.org) to manage external dependencies. Therefore **you need to always work on the LetoToggliOS.xcworkspace and NEVER on the LetoToggliOS.xcproject directly**! Doing so will prevent the project from correctly compiling.

Installed Pods are kept under version control therefore no setup should be necessary before being able to build and run the app (read about pros and cons of having Pods under version control [here](http://guides.cocoapods.org/using/using-cocoapods.html#should-i-ignore-the-pods-directory-in-source-control)). If you get any error from CocoaPods, try running the following commands in a Terminal window:

	# you can skip this step since all installed Pods are kept under version control
	cd LETO-Toggl_iOS
	gem update cocapods
	pod install
	

LETO Toggl uses [Fabric](https://fabric.io) for crash reports. Please set it up on `Build Phases`->`Run Script` or remove Fablic from the project. 

## Folder Structure

Groups in Xcode have a matching folder on the file system. _Avoid creating a group in Xcode that doesn't have a matching folder on the file system._

## Git Branching Strategy

The base for your work and current state of app will be on the 'develop' branch. This branch should always be kept in a deployable state. The 'master' branch will always be up-to-date with the latest deployed version of your code (App Store released). Features and fixes are worked on separate branches.

## License

 LETO Toggl is a location based time tracking App.
    Copyright (C) 2016  LETO

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

   [![img](https://d1orqdsmyxzawu.cloudfront.net/dist/leto/emails/2/leto-logo-black-email.png)](https://weareleto.com/)
