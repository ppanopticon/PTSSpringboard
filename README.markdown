PTSSpringBoard
==============

The PTSSpringBoard class provides the functionalities of a springboard as known from the iOS mainscreen. It supports moving and deleting items.

## Requirements
- QuartzCore.framework
- Only implemented to work with ARC

## Legal

Copyright: Copyright 2012 by pontius software GmbH (Switzerland)
Author: Ralph Gasser
License: GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007

## Description

The PTSSpringBoard class provides the functionalities of a springboard as known from the iOS mainscreen. It supports moving and deleting items. 

PTSSpringboard uses a delegation pattern to communicate with its data source and delegate, similar to that of the UITableView. By changing the implementation at the data source or delegate, you can completely control the behavior of the springboard and its items.

The class should be working on the iPhone (3.3 inch & 4inch) and iPad (although I only really tested the iPhones) and with all interface-orientations. 

The code is documented and provided free of charge under terms of the GPL v3.0 License. If you have any additions, or fixed an error - feel free to publish it.