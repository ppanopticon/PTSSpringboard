//
//  ViewController.h
//  PTSSpringBoardDemo
//
//  Created by Ralph Gasser on 16.09.12.
//  Copyright (c) 2012 pontius software GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSSpringBoard.h"

@interface ViewController : UIViewController <PTSSpringBoardDataSource, PTSSpringBoardDelegate> {
    
    PTSSpringBoard * __strong mySpringboard;
    
    NSMutableArray * items;
}
@property (nonatomic, strong) PTSSpringBoard * mySpringboard;
@property (nonatomic) NSMutableArray * items;

@end
