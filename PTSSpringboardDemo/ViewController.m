//
//  ViewController.m
//  PTSSpringBoardDemo
//
//  Created by Ralph Gasser on 16.09.12.
//  Copyright (c) 2012 pontius software GmbH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mySpringboard, items;
- (void)viewDidLoad {
    mySpringboard = [[PTSSpringBoard alloc] initWithFrame:self.view.bounds];
    
    self.mySpringboard.delegate = self;
    self.mySpringboard.dataSource = self;
    
    [self.view addSubview:mySpringboard];
    
    items = [[NSMutableArray alloc] initWithObjects:
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"My Profile", @"label",
              [UIImage imageNamed:@"profile_icon"], @"icon",
              @"profile", @"identifier",
              nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Profiles", @"label",
              [UIImage imageNamed:@"profiles_icon"], @"icon",
              @"profiles", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Search", @"label",
              [UIImage imageNamed:@"search_icon"], @"icon",
              @"search", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Settings", @"label",
              [UIImage imageNamed:@"settings_icon"], @"icon",
              @"settings", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Post-It", @"label",
              [UIImage imageNamed:@"postits_icon"], @"icon",
              @"postits", @"identifier",
              nil]
             ,[NSDictionary dictionaryWithObjectsAndKeys:
               @"My Profile", @"label",
               [UIImage imageNamed:@"profile_icon"], @"icon",
               @"profile", @"identifier",
               nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Profiles", @"label",
              [UIImage imageNamed:@"profiles_icon"], @"icon",
              @"profiles", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Search", @"label",
              [UIImage imageNamed:@"search_icon"], @"icon",
              @"search", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Settings", @"label",
              [UIImage imageNamed:@"settings_icon"], @"icon",
              @"settings", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Post-It", @"label",
              [UIImage imageNamed:@"postits_icon"], @"icon",
              @"postits", @"identifier",
              nil], [NSDictionary dictionaryWithObjectsAndKeys:
                     @"My Profile", @"label",
                     [UIImage imageNamed:@"profile_icon"], @"icon",
                     @"profile", @"identifier",
                     nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Profiles", @"label",
              [UIImage imageNamed:@"profiles_icon"], @"icon",
              @"profiles", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Search", @"label",
              [UIImage imageNamed:@"search_icon"], @"icon",
              @"search", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Settings", @"label",
              [UIImage imageNamed:@"settings_icon"], @"icon",
              @"settings", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Post-It", @"label",
              [UIImage imageNamed:@"postits_icon"], @"icon",
              @"postits", @"identifier",
              nil],[NSDictionary dictionaryWithObjectsAndKeys:
                    @"My Profile", @"label",
                    [UIImage imageNamed:@"profile_icon"], @"icon",
                    @"profile", @"identifier",
                    nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Profiles", @"label",
              [UIImage imageNamed:@"profiles_icon"], @"icon",
              @"profiles", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Search", @"label",
              [UIImage imageNamed:@"search_icon"], @"icon",
              @"search", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Settings", @"label",
              [UIImage imageNamed:@"settings_icon"], @"icon",
              @"settings", @"identifier",
              nil]
             ,
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Post-It", @"label",
              [UIImage imageNamed:@"postits_icon"], @"icon",
              @"postits", @"identifier",
              nil]
             ,
             nil];
    
    [mySpringboard updateSpringboard];
    
    [super viewDidLoad];
}

#pragma mark -
#pragma mark PTSSpringBoardDataSource protocol

-(NSInteger)numberOfItemsInSpringboard:(PTSSpringBoard *)springboard {
    return [[self items] count];
}

-(PTSSpringBoardItem*)springboard:(PTSSpringBoard *)springboard itemForIndex:(NSInteger)index {
    PTSSpringBoardItem * item = [[PTSSpringBoardItem alloc] init];
    
    [item setLabel:[[[self items] objectAtIndex:index] objectForKey:@"label"]];
    [item setIcon:[[[self items] objectAtIndex:index] objectForKey:@"icon"]];
    [item setItemIdentifier:[[[self items] objectAtIndex:index] objectForKey:@"identifier"]];
    [item setBadgeValue:[NSString stringWithFormat:@"%d", (index + 1)]];
     
     return item;
}

-(BOOL)springBoardShouldEnterEditingMode:(PTSSpringBoard *)springboard {
    return YES;
}

-(BOOL)springboard:(PTSSpringBoard *)springboard shouldAllowDeletingItem:(PTSSpringBoardItem *)item {
    if ([[item itemIdentifier] isEqualToString:@"profiles"] || [[item itemIdentifier] isEqualToString:@"search"]) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)springboard:(PTSSpringBoard *)springboard shouldAllowMovingItem:(PTSSpringBoardItem *)item {
    if ([[item itemIdentifier] isEqualToString:@"postits"] || [[item itemIdentifier] isEqualToString:@"settings"] || [[item itemIdentifier] isEqualToString:@"profiles"]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark PTSSpringBoardelegate protocol

-(void)springboardDidEnterEditingMode:(PTSSpringBoard *)springboard {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Entered editing mode..." message:@"You just entered the springboards editing mode. Shake your phone to leave editing mode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

-(void)springboard:(PTSSpringBoard *)springboard selectedItem:(PTSSpringBoardItem *)item atIndex:(NSInteger)index {
    if (![springboard isEditing]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Entered editing mode..." message:[NSString stringWithFormat:@"You taped the item at position %d. It uses the item-identifier '%@'.", (index + 1), [item itemIdentifier]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        [alert show];
    }
}

-(void)springboard:(PTSSpringBoard *)springboard deletedItem:(PTSSpringBoardItem *)item atIndex:(NSInteger)index {
    [[self items] removeObjectAtIndex:index];
}

-(void)springboard:(PTSSpringBoard *)springboard movedItem:(PTSSpringBoardItem *)item atIndex:(NSInteger)index toIndex:(NSInteger)newIndex {
     [[self items] exchangeObjectAtIndex:index withObjectAtIndex:newIndex];
}

#pragma mark -
#pragma mark Handles Accelerometer-Shake

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake && [[self mySpringboard] isEditing]) {
        [[self mySpringboard] toggleEditingMode:NO];
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
@end
