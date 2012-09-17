PTSSpringBoard
==============

The PTSSpringBoard class provides the functionalities of a springboard as known from the iOS mainscreen. It supports moving and deleting items.

## Author
Ralph Gasser (pontius software GmbH)

## Requirements
* QuartzCore.framework
* Only implemented to work with ARC

## Legal
Copyright 2012 by pontius software GmbH (Switzerland), All rights reserved

The code and its documentation are provided free of charge under the terms of the GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007. If you want to use it for commercial applications, please contact the author.

## Description
The PTSSpringBoard class provides the functionalities of a springboard as known from the iOS mainscreen. It supports moving and deleting items. 

PTSSpringboard uses a delegation pattern to communicate with its data source and delegate, similar to that of the UITableView. By changing the implementation at the data source or delegate, you can completely control the behavior of the springboard and its items.

The class should be working on the iPhone (3.3 inch & 4inch) and iPad (although I only really tested the iPhones) and with all interface-orientations.  

## To-Do's
* Implementation for non-ARC environments.
* More possibilites for styling individual springboard-items (e.g. Badge-Color, Size, Font)
* Different sizes for springboard-items.
* Tweaking of the code - e.g. only re-layouting visible portions of the springboard.
* Testing and implementation for very lager numbers of items.

