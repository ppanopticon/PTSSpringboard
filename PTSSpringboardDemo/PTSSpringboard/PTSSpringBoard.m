/*PTSSpringBoard.h

Copyright (C) 2012 pontius software GmbH, created by Ralph Gasser

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
*/

#import "PTSSpringBoard.h"
@implementation PTSSpringBoard

@synthesize delegate, dataSource, itemSize, editing, updating;

#pragma mark -
#pragma mark Object-Lifecycle

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        
        /*Initializes the Items-Container...*/
        itemsContainer = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        /*...and sets it up.*/
        itemsContainer.delegate = self;
        [itemsContainer setScrollEnabled:YES];
        [itemsContainer setPagingEnabled:YES];
        itemsContainer.showsHorizontalScrollIndicator = NO;
        [self addSubview:itemsContainer];
        
        /*Initializes the the Page-Control*/
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        
        /*Sets the default item-size.*/
        self.itemSize = 100.0f;
        
        /*Initializes the items-array.*/
        itemsInOrder = [[NSMutableArray alloc] initWithCapacity:0];
        
        /*Sets the Auto-Resizing-Mask for the Springboard.*/
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

#pragma mark -
#pragma mark Custom methods

-(void)toggleEditingMode:(BOOL)isOn {
    editing = isOn;
    
    if (isOn) {
        if ([[self delegate] respondsToSelector:@selector(springboardDidEnterEditingMode:)]) {
            [[self delegate] springboardDidEnterEditingMode:self];
        }
    } else {
        if ([[self delegate] respondsToSelector:@selector(springboardDidLeaveEditingMode:)]) {
            [[self delegate] springboardDidLeaveEditingMode:self];
        }
    }
    
    /**When editing-mode is entered or left, the springboard is updated.*/
    [self updateSpringboard];
}


#pragma mark -
#pragma mark Layouting

-(void)layoutSubviews {
    /*Layouts the item container...*/
    itemsContainer.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
   
    /*...the page-control.*/
    pageControl.frame = CGRectMake(0.0f, self.frame.size.height-20.0f, self.frame.size.width, 20.0f);
    
    /*Now layouts the content-size of the item-container...*/
    NSInteger numberOfItems = [[self delegate] numberOfItemsInSpringboard:self];
    
    CGSize sizePerItem = CGSizeMake(self.itemSize, self.itemSize);
    
    NSInteger numberOfRows = floor(self.frame.size.width / sizePerItem.width);
    NSInteger numberOfColumns = floor(self.frame.size.height / sizePerItem.height);
    NSInteger numberOfItemsPerPage = numberOfRows * numberOfColumns;
    NSInteger numberOfPages = ceil((float)numberOfItems/numberOfItemsPerPage);

    
    if (pageControl.numberOfPages > numberOfPages) {
        pageControl.currentPage = pageControl.currentPage - 1;
    }
    
    pageControl.numberOfPages = numberOfPages;
    
    [itemsContainer setContentSize:CGSizeMake(numberOfPages*itemsContainer.frame.size.width, itemsContainer.frame.size.height)];
    
    CGFloat rowGap = ([[self superview] bounds].size.width - numberOfRows * sizePerItem.width)/numberOfRows;
    CGFloat columnGap = ([[self superview] bounds].size.height - numberOfColumns * sizePerItem.height)/numberOfColumns;
    
    /*...and the positions of the individual items.*/
    for (PTSSpringBoardItem * item in itemsInOrder) {
        NSInteger index = [itemsInOrder indexOfObject:item];
        
        if (index != NSNotFound) {
            NSInteger pageNumber = floor((float)(index/numberOfItemsPerPage));
        
            NSInteger collumnIdx = floor((float) (index % numberOfItemsPerPage) / numberOfRows);
            NSInteger rowIdx = (index % numberOfRows);
            
            /*If animation is in editing mode (except for the first layouting, when updating the springboard), repositioning of all items is animated. Otherwise it will be unanimated.*/
            if ([self isEditing] && ![self isUpdating]) {
                [UIView animateWithDuration:0.25f animations:^(void){
                    [item setFrame:CGRectMake((rowIdx * (self.itemSize + rowGap)) + (pageNumber*itemsContainer.frame.size.width), (collumnIdx * (self.itemSize + columnGap)), sizePerItem.width, sizePerItem.height)];
                }];
            } else {
                [item setFrame:CGRectMake((rowIdx * (self.itemSize + rowGap)) + (pageNumber*itemsContainer.frame.size.width), (collumnIdx * (self.itemSize + columnGap)), sizePerItem.width, sizePerItem.height)];
            }
        } else {
            NSLog(@"Error!");
        }
    }
    
    /*Sets updating to NO if it is set to YES.*/
    if ([self isUpdating]) {
        updating = NO;
    }

    [super layoutSubviews];
}

#pragma mark -
#pragma mark Custom methods

/** This is an internal method and not intended for external use. It is used to determine a collision between two \ref PTSSpringBoardItems while one item is dragged. The method will return YES if two items collide and both items are movable. If otherwise, the method will return NO. Upon returning yes, the second item that takes part in the collision is returned by reference.
        @param item PTSSpringBoardItem The item that is moved.
        @param collisionItem A pointer to another PTSSpringBoardItem. It is assigned, when a collision is detected.
        @return BOOL YES if a collision was detected. Otherwise NO.
 */ 
-(BOOL)item:(PTSSpringBoardItem*)item collidesWithOtherItem:(PTSSpringBoardItem **)collisionItem {
    for (PTSSpringBoardItem * spItem in itemsInOrder) {
        if (spItem != item && [item isMovable] && [spItem isMovable]) {
            CGPoint p1 = item.center;
            CGPoint p2 = spItem.center;
        
            if (sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)) <= 25.0f) {
                *collisionItem = spItem;
                return YES; 
            }
        }
    }
    
    return NO;
}

-(void)updateSpringboard {
    /*Sets updating to YES. This is done for display reasons.*/
    updating = YES;
    
    /*Does the updates.*/
    for (NSInteger i = 0;i<[[self dataSource]  numberOfItemsInSpringboard:self];i++) {
        [self updateItemAtIndex:i];
    }
}

-(void)updateItemWithIdentifier:(NSString*)identifier {
    PTSSpringBoardItem * item;
    
    for (item in itemsInOrder) {
        if ([[item itemIdentifier] isEqualToString:identifier]) {
            /*An item was found -> you have to break, as you can't change an array while enumerating it.*/
            break;
        }
    }
    
    if (item) {
        [self updateItemAtIndex:[itemsInOrder indexOfObject:item]];
    }
}

-(void)updateItemAtIndex:(NSInteger)index {
    PTSSpringBoardItem * item = [[self dataSource] springboard:self itemForIndex:index];
    
    if ([itemsInOrder count] >= (index + 1) && item) {
        PTSSpringBoardItem * oldItem = [itemsInOrder objectAtIndex:index];
        
        [oldItem removeFromSuperview];
        [itemsInOrder removeObject:oldItem];
    }
    
    if (item) {
        item.delegate = self;
        [itemsInOrder insertObject:item atIndex:index];
        [itemsContainer addSubview:item];
        
        if ([self isEditing]) {
            if([[self dataSource] respondsToSelector:@selector(springboard:shouldAllowDeletingItem:)] &&
               [[self dataSource] springboard:self shouldAllowDeletingItem:item]) {
                [item setDeletable:YES];
            }
        
            if([[self dataSource] respondsToSelector:@selector(springboard:shouldAllowMovingItem:)] &&
               [[self dataSource] springboard:self shouldAllowMovingItem:item]) {
                [item setMovable:YES];
            }
        }
    }
   
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark PTSMenuItemDelegate Protocol implementations, Handle User-Interactions

-(void)springboardItemTaped:(PTSSpringBoardItem*)item; {
    /*A tap was detected on one of the springboards items. This will cause the springboard to inform its delegate */
    if ([[self delegate] respondsToSelector:@selector(springboard: selectedItem: atIndex:)]) {
        [[self delegate] springboard:self selectedItem:item atIndex:[itemsInOrder indexOfObject:item]];
    }
}

-(void)springboardItemLongPressed:(PTSSpringBoardItem*)item; {
    /*A long-press was detected on one of the springboards items. This will cause the springboard to enter editing mode, if 
        a) It it isn't allready.
        b) The datasource's springBoardShouldEnterEditingMode: returns YES
     */
    if (![self isEditing]) {
        if ([[self dataSource] respondsToSelector:@selector(springBoardShouldEnterEditingMode:)] &&
            [[self dataSource] springBoardShouldEnterEditingMode:self] == YES) {
            
            /*Activates the editing mode.*/
            [self toggleEditingMode:YES];
        }
    }
}

-(void)springboardItemDeleteButtonPressed:(PTSSpringBoardItem *)item {
    if ([[self delegate] respondsToSelector:@selector(springboard: deletedItem: atIndex:)]) {
        NSInteger index = [itemsInOrder indexOfObject:item];
        if (index != NSNotFound) {
            /*Removes the object internally...*/
            [itemsInOrder removeObjectAtIndex:index];
        
            /*...and informs the delegate.*/
            [[self delegate] springboard:self deletedItem:item atIndex:index];
        
            [self setNeedsLayout];
        }
    }
}

-(void)springboardDidBeginDraging:(PTSSpringBoardItem *)item {
    /*A springboard item reports a touchEvent, which will initiate dragging. The springboard will mark this item as selected.*/

    item.selected = YES;
    [itemsContainer setScrollEnabled:NO];
    
    [self setNeedsLayout];
}

-(void)springboardIsDraging:(PTSSpringBoardItem *)item {
    /*A springboard item reports that a touchEvent is moving, which will cause the corresponding item to move. This method takes care of two things:
     
        a) It checks for collisions with other items in the view. If one is detected, and the delegate responds to -(void)springboard:movedItemAtIndex:toIndex:, it will cause the two items to be exchanged internally.
        b) It checks, wheather the item is move across the borders to another page.
     
        The internal exchange of items upon collision is only temporary for display reasons. The data source will be informed of the exchange with the -(void)springboard: movedItem: atIndex: toIndex: method. It has to take care of the reordering, otherwise the items position will be reset, when dragging ends.
     */
    PTSSpringBoardItem * collisionItem;

    /*Checks for collision.*/
    if ([self item:item collidesWithOtherItem:&collisionItem] && [[self delegate] respondsToSelector:@selector(springboard:movedItem:atIndex:toIndex:)]) {
        
        oldIndex = [itemsInOrder indexOfObject:item];
        newIndex = [itemsInOrder indexOfObject:collisionItem];
        
        if (oldIndex != NSNotFound && newIndex != NSNotFound) {
            [itemsInOrder exchangeObjectAtIndex:newIndex withObjectAtIndex:oldIndex];
            [[self delegate] springboard:self movedItem:item atIndex:oldIndex toIndex:newIndex];
        
            [self setNeedsLayout];
        }
    }
    
    /*Checks for moving an item across a border.*/
    CGRect contentFrame = CGRectMake(0.0f, 0.0f, itemsContainer.contentSize.width, itemsContainer.contentSize.height);
    if (!CGRectContainsRect(itemsContainer.frame, item.frame) && CGRectContainsRect(contentFrame, item.frame)) {
            
        CGRect visibleFrame = CGRectMake(itemsContainer.contentOffset.x, itemsContainer.contentOffset.y, itemsContainer.contentSize.width, itemsContainer.contentSize.height);
            
        CGRect nextPageRect;
            
        if (item.frame.origin.x > visibleFrame.origin.x) {
            nextPageRect = CGRectMake(((pageControl.currentPage + 1) * itemsContainer.bounds.size.width), itemsContainer.bounds.origin.y, itemsContainer.bounds.size.width, itemsContainer.bounds.size.height);
        } else {
            nextPageRect = CGRectMake(((pageControl.currentPage - 1) * itemsContainer.bounds.size.width), itemsContainer.bounds.origin.y, itemsContainer.bounds.size.width, itemsContainer.bounds.size.height);
        }
            
        [itemsContainer scrollRectToVisible:nextPageRect animated:YES];
    }
    
}

-(void)springboardDidEndDraging:(PTSSpringBoardItem *)item {
    /*A springboard item reports that a touchEvent ended or was canceled, which willend dragging. The springboard will mark this item as unselected and update the springboard.
     */
    item.selected = NO;
    itemsContainer.scrollEnabled = YES;
    [self setNeedsLayout];
}

-(BOOL)springboardIsEditing {
    /*Returs the editing-status as part of the PTSSpringBoardItemDelegate protocol.*/
    return [self isEditing];
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = itemsContainer.frame.size.width;
    int page = floor((itemsContainer.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

@end
