/* PTSSpringBoardItem.h

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
#import <QuartzCore/QuartzCore.h>
#import "PTSSpringBoardProtocols.h"

/** \class PTSSpringBoardItem
    \brief The PTSSpringBoardItem class implements attributes and behaviours of an item, that appears in a \ref PTSSpringBoard.  It implements properties and methods to manage appearance and event handling. 
        <p>The items appearance consists of a label, an icon and a badge. The labels color is adjustable. The label and the badge take any possible string value, granted that it won't exceed the items frame of 100 x 100 pixles. The icon will be resized automatically.</p>
         <p>To identify an item to its the springboards delegate (see \ref PTSSpringBoardDelegate), one can assign an identifier to an item. The item identifier can be used to implement actions for each item. In an environment which allows movement and/or deletion of an item (thus the positional index is not constant), this identifier remains to identify each singe item.</p> 
 
    @author Ralph Gasser
    @date 2012-09-14
    @version 1.2
    @copyright Copyright 2012, pontius software GmbH
 */

@interface PTSSpringBoardItem : UIView {
    /**The delegate (usually a \ref PTSSpringBoard) that is informed, when user-interaction occurs with an item. Must implement the \ref PTSSpringBoardItemDelegate.*/
    @private id <PTSSpringBoardItemDelegate> __weak delegate;
    
    /**The text if the springboard-item's label.*/
    @private NSString * labelText;
    
    /**UIColor of the springboard's label.*/
    @private UIColor * labelColor;
    
    /**The text if the springboard-item's badge.*/
    @private NSString * badgeValue;
    
    /**The icon that is displayed for this springboard-icon. it shouldn't be any bigger than 100x100 pixels.*/
    @private UIImage * iconImage;
    
    /**An identifier-string. It can be used by the \ref PTSSpringBoard delegate, to trigger appropriate actions for the pressed springboard.*/
    @private NSString * itemIdentifier;
    
    /**The item is marked for selection. This information is used by the \ref PTSSpringBoardClass for display and layout reason.*/
    @private BOOL selected;
    
    /**The item is marked as deletable. This infromation is set by the \ref PTSSpringBoardClass for display, layout and handling reason.*/
    @private BOOL deletable;
    
    /**The item is marked as movable. This infromation is set by the \ref PTSSpringBoardClass for display, layout and handling reason.*/
    @private BOOL movable;
}

@property (nonatomic, weak) id <PTSSpringBoardItemDelegate> delegate;

@property (nonatomic) NSString * itemIdentifier;

@property (nonatomic, readonly) UIImage * iconImage;

@property (nonatomic, readonly) NSString * labelText;

@property (nonatomic, readonly) NSString * badgeValue;

@property (nonatomic, readonly) UIColor * labelColor;

@property (nonatomic, getter = isSelected) BOOL selected;

@property (nonatomic, getter = isDeletable) BOOL deletable;

@property (nonatomic, getter = isMovable) BOOL movable;

/**Custom setter-method for the label text. Triggers a redrawing event for the item.
    @param text NSString containing the new label text.
*/
-(void)setLabel:(NSString *)text;

/**Custom setter-method for the badgeValue. Triggers a redrawing event for the item.
    @param value NSString containing the new badge value.
 */
-(void)setBadgeValue:(NSString *)value;

/**Custom setter-method for the iconImage. Triggers a redrawing event for the item.
    @param image UIImage containing the new icon-image.
 */
-(void)setIcon:(UIImage *)image;

/**Custom setter-method for the label color. Triggers a redrawing event for the item.
    @param color UIColor containing the new label color. */
-(void)setLabelColor:(UIColor*)color;

@end