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

#import <UIKit/UIKit.h>
#import "PTSSpringBoardItem.h"
#import "PTSSpringBoardProtocols.h"

/** \class PTSSpringBoard
    \brief The PTSSpringBoard is used to display a list of user-interactable items in a view that resembles the iOS Homescreen. The items are dynamically arranged on the view and, if necessary, on multiple pages.
 
    \details  <p>This class implements the behaviour of the PTSSpringBoard (a resizing behaviour, item-order, drawing and event handling) and uses delegation, to report user-interaction and to load content. The springboard needs a data-source which implements the \ref PTSSpringBoardDataSource protocol. The data source provides the content and information on the basic behaviour of the springboard.
        <p>User-Interaction triggered events are reported to the delegate of the springboard, using the \ref PTSSpringBoardDelegate protocol. The protocol can be used to implement actions, that are triggered when \ref PTSSpringBoardItems are selected, moved or deleted by the user.</p>
 
    @author Ralph Gasser
    @date 2012-09-17
    @version 1.5
    @copyright Copyright 2012, pontius software GmbH
 */

@interface PTSSpringBoard : UIView <UIScrollViewDelegate, PTSSpringBoardItemDelegate, UIAccelerometerDelegate> {
    /**This is weak reference to the PTSSpringBoards delegate - usually a ViewController. It is informed when the user performs any actions on one of the Springboard's items. It must implement the \ref PTSSpringBoardDelegate protocol.*/
    @private id <PTSSpringBoardDelegate> __weak delegate;
    
    /**This is weak reference to the springboards data-source. It is used to setup the Springboard and provide it with content. The data source has to implement the \ref PTSSpringBoardDataSource protocol.*/
    @private id <PTSSpringBoardDataSource> __weak dataSource;
    
    /**A boolean indicating, wheather the PTSSpringBoard is in editing mode or not.*/
    @private BOOL editing; 
    
    /**The \ref UIPageControl used to navigate between pages. This is an internal variable and no getters or setters are defined.*/
    @private UIPageControl * __strong pageControl;
    
    /**The \ref UIScrollView which contains the \ref PTSMenuItem Objects. This is an internal variable and no getters or setters are defined.*/
    @private UIScrollView * __strong itemsContainer;
    
    /**The size of one springboard-item. You shouldn't choose the item-size too big - it could lead to undefined behaviour for dragging the items on small screens. 100.0f to 120.0f should be ok.*/
    @private CGFloat itemSize;
    
    /**NSArray containing the \ref PTSSpringBoardItems in order they are displayed. This is an internal variable and no getters or setters are defined.*/
    @private NSMutableArray * itemsInOrder;
    
    /**This is an internal variable and should not be changed. It is used for caching when moving items around.*/
    @private NSInteger oldIndex;
    
    /**This is an internal variable and should not be changed. It is used for caching when moving items around.*/
    @private NSInteger newIndex;
    
    /**This is an internal variable and should not be changed. It is marked as YES when the springboard is updating.*/
    @private BOOL updating;
    
}

@property (nonatomic, weak) id delegate;

@property (nonatomic, weak) id dataSource;

@property (nonatomic) CGFloat itemSize;

@property (nonatomic, getter = isEditing, readonly) BOOL editing;

@property (nonatomic, getter = isUpdating, readonly) BOOL updating;

/**Updates all \ref PTSSpringBoardItem by invoking the data sources -(PTSSpringBoardItem*)springboard:itemForIndex: method. This will completely reload all items and cause the springboard to be re-layouted.
 */
-(void)updateSpringboard;

/**Updates a \ref PTSSpringBoardItem at a given index, by invoking the data sources -(PTSSpringBoardItem*)springboard:itemForIndex: method. This will completely reload the item and cause the springboard to be re-layouted. You can use this method, if you're only updating one ore a few items at a time.
    @param index NSInteger containing the index of the item, that needs to be reloaded.
*/
-(void)updateItemAtIndex:(NSInteger)index;

/**Updates a \ref PTSSpringBoardItem given by an identifier, by invoking the data sources -(PTSSpringBoardItem*)springboard:itemForIndex: method. This will completely reload the item and cause the springboard to be re-layouted. You can use this method, if you're only updating one ore a few items at a time.
    @param index NSString identifier The item-identifier of the \ref PTSSpringBoardItem.
 */
-(void)updateItemWithIdentifier:(NSString*)identifier;

/**Toggles the editing-mode. Calling this method will inform the delegate, of the change and cause the springboard to be reloaded. This method replaces the setter-method for the editing variable.
    @param isOn Determines, wheather editing-mode is on (YES) or off (NO).
*/
-(void)toggleEditingMode:(BOOL)isOn;

@end
