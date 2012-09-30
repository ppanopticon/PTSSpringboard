/*PTSSpringBoardProtocol.h

Copyright (C) 2012 pontius software GmbH, created by Ralph Gasser

This program is free software: you can redistribute and/or modify
 it under the terms of the Createive Commons (CC BY-SA 3.0) license
*/


#import <Foundation/Foundation.h>

@class PTSSpringBoard;
@class PTSSpringBoardItem;

/** \protocol PTSSpringBoardDelegate
    \brief The protocol is implemented by a \ref PTSSpringBoard delegate to be informed of user-interactions occuring with the springboard. All the methods in this protocol are optional.
 
    @author Ralph Gasser
    @date 2012-09-14
    @version 1.0
    @copyright Copyright 2012, pontius software GmbH
 */
@protocol PTSSpringBoardDelegate <NSObject>
@optional

/** The \ref PTSSpringBoard informs the delegate, that it has entered editing mode. This triggered by calling the \ref PTSSpringBoards -(void)toggleEditingMode: method. By default, a long press on one of the items will call this method.
    @param springboard A reference to the calling \ref PTSSpringBoard.
 */
-(void)springboardDidEnterEditingMode:(PTSSpringBoard*)springboard;

/** The \ref PTSSpringBoard informs the delegate, that it has left editing mode. By default this triggered by calling the \ref PTSSpringBoards. It is up to the controller to make a \ref PTSSpringBoard leave editing mode.
    @param springboard A reference to the calling \ref PTSSpringBoard.
 */
-(void)springboardDidLeaveEditingMode:(PTSSpringBoard*)springboard;

/** The \ref PTSSpringBoard informs the delegate, that an item was selected (taped). This method is always fire, even if the springboard is in editing mode. You have to determine yourself, if you want to restrict certain actions to certain modes.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @param item A reference to the  \ref PTSSpringBoardItem that was tapped.
    @param index The positional index of the item, that was taped.
 */
-(void)springboard:(PTSSpringBoard*)springboard selectedItem:(PTSSpringBoardItem*)item atIndex:(NSInteger)index;

/** The \ref PTSSpringBoard informs the delegate that an item was deleted. This method is only called, while the springboard is in editing mode. You should use it to update your data source. If you don't the springboard will return to its original state, as soon as so leave editing mode.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @param item A reference to the  \ref PTSSpringBoardItem that was tapped.
    @param index The positional index of the item, that was taped.
 */
-(void)springboard:(PTSSpringBoard*)springboard deletedItem:(PTSSpringBoardItem*)item atIndex:(NSInteger)index;

/** The \ref PTSSpringBoard informs the delegate that an item was moved. This method is only called, while the springboard is in editing mode. You should use it to update your data source. If you don't the springboard will return to its original state, as soon as so leave editing mode.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @param item A reference to the  \ref PTSSpringBoardItem that was tapped.
    @param index The positional index of the item, that was taped.
 */
-(void)springboard:(PTSSpringBoard*)springboard movedItem:(PTSSpringBoardItem*)item atIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
@end

/** \protocol PTSSpringBoardDataSource
    \brief The protocol is implemented by a \ref PTSSpringBoard data source which provides the content for a \ref PTSSpringBoard. The methods of this protocol can be used to determine the springboards behaviour.
 
    @author Ralph Gasser
    @date 2012-09-14
    @version 1.0
    @copyright Copyright 2012, pontius software GmbH
 */
@protocol PTSSpringBoardDataSource <NSObject>

/** Asks the data source for the number of items, that are to be displayed in the springboard.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @return The number of items to be displayed in the springboard as a NSInteger.
*/
-(NSInteger)numberOfItemsInSpringboard:(PTSSpringBoard*)springboard;

/** Asks the data source for the item to insert at the specifed index.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @param index The positional index of the \ref PTSSpringBoardItem that requested.
    @return A \ref PTSSpringboarItem reference, to be displayed in the springboard.
 */
-(PTSSpringBoardItem*)springboard:(PTSSpringBoard*)springboard itemForIndex:(NSInteger)index;

@optional
/** Asks the data source whether the springboard is allowed to enter editing mode. If this method is not implemented by the data source, editing mode is NOT allowed.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @return A boolean, indicating wheater the springboard is allowed (YES) to enter editing mode or not (NO).
 */
-(BOOL)springBoardShouldEnterEditingMode:(PTSSpringBoard*)springboard;

/** Asks the data source whether a given item is allowed to move. This method is only called, if -(void)springboardShouldEnterEditingMode: returns YES. If this method is not implemented by the data source, no item is movable.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @param item A reference to the \ref PTSSpringBoardItem that is about to be moved.
    @return A boolean indicating wheater the item is allowed to move (YES) or not (NO).
 */
-(BOOL)springboard:(PTSSpringBoard*)springboard shouldAllowMovingItem:(PTSSpringBoardItem*)item;

/** Asks the data source whether a given item is allowed to be deleted. This method is only called, if -(void)springboardShouldEnterEditingMode: returns YES. If this method is not implemented by the data source, no item is deletable.
    @param springboard A reference to the calling \ref PTSSpringBoard.
    @param item A reference to the \ref PTSSpringBoardItem that is about to be deleted.
    @return A boolean indicating wheater the item is allowed to be deleted (YES) or not (NO).
 */
-(BOOL)springboard:(PTSSpringBoard*)springboard shouldAllowDeletingItem:(PTSSpringBoardItem*)item;
@end

/** \protocol PTSSpringBoardItemDelegate
    \brief The protocol is implemented by the \ref PTSSpringBoard to be informed of user-interactions by a single \ref PTSSpringBoardItem. This is the onyl purpose of this protocol. You should not edit it, unless you want to alter the \ref PTSSpringBoard classes behaviour.
 
    @author Ralph Gasser
    @date 2012-09-14
    @version 1.0
    @copyright Copyright 2012, pontius software GmbH
 */
@protocol PTSSpringBoardItemDelegate <NSObject>
/** A \ref PTSSpringBoardItem informs the delegate, that it was taped.
    @param item A reference to the affected \ref PTSSpringBoardItem.
*/
-(void)springboardItemTaped:(PTSSpringBoardItem *)item;
/** A \ref PTSSpringBoardItem informs the delegate, that it was long pressed.
 @param item A reference to the affected \ref PTSSpringBoardItem.
 */
-(void)springboardItemLongPressed:(PTSSpringBoardItem *)item;

/** A \ref PTSSpringBoardItem informs the delegate, that the delete button was pressed. This method is only called, when the item has been marked deletable by the data source.
    @param item A reference to the affected \ref PTSSpringBoardItem.
 */
-(void)springboardItemDeleteButtonPressed:(PTSSpringBoardItem*)item;

/** A \ref PTSSpringBoardItem informs the delegate, that it did begin dragging (a touching event was detected). This method is only called, when the item has been marked movable by the data source.
    @param item A reference to the affected \ref PTSSpringBoardItem.
 */
-(void)springboardDidBeginDraging:(PTSSpringBoardItem *)item;

/** A \ref PTSSpringBoardItem informs the delegate, that it is being dragged. This method is only called, when the item has been marked movable by the data source.
    @param item A reference to the affected \ref PTSSpringBoardItem.
 */
-(void)springboardIsDraging:(PTSSpringBoardItem *)item;

/** A \ref PTSSpringBoardItem informs the delegate, that dragging ended. This method is only called, when the item has been marked movable by the data source.
    @param item A reference to the affected \ref PTSSpringBoardItem.
 */
-(void)springboardDidEndDraging:(PTSSpringBoardItem *)item;

/** A \ref PTSSpringBoardItem can use this method to determine, whether the delegate is in editing-mode or not.
    @return BOOL indicating, whether the delegate is currently in editing mode (YES) or not (NO).
 */
-(BOOL)springboardIsEditing;
@end