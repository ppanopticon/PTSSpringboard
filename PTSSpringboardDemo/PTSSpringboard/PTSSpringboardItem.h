/* PTSSpringBoardItem.h

Copyright (C) 2012 pontius software GmbH, created by Ralph Gasser

 This program is free software: you can redistribute and/or modify
 it under the terms of the Createive Commons (CC BY-SA 3.0) license
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
    @version 1.6
    @copyright Copyright 2012, pontius software GmbH
 */

@interface PTSSpringBoardItem : UIView {
    /**The delegate (usually a \ref PTSSpringBoard) that is informed, when user-interaction occurs with an item. Must implement the \ref PTSSpringBoardItemDelegate.*/
    @private id <PTSSpringBoardItemDelegate> __weak delegate;
    
    /**The text if the springboard-item's label. Texts that are too long can result in the label being to large for the item's view. In this case the label will be clipped. The exact number is depending on the size of the item and the font.*/
    @private NSString * labelText;
    
    /**The font of the springboard-items label text. Choosing values for label-size, that are too big, will result in the label being larger than the item's view. In this case the label will be clipped.*/
    @private UIFont * labelFont;
    
    /**UIColor of the springboard's label text.*/
    @private UIColor * labelColor;
    
    /**The text if the springboard-item's badge. Texts that are too long can result in the badge being to large for the item's view. In this case the badge will be clipped. The exact number is depending on the size of the item and the font. E.g. with an item size of 100px and a badge font-size of 14.0f, the badge can hold 6-7 characters without being clipped.*/
    @private NSString * badgeValue;
    
    /**The font of the springboard-items badge text. Choosing values for font-size, that are too big, will result in the badge being larger than the item's view. In this case, the badge will be clipped.*/
    @private UIFont * badgeFont;
    
    /**The color of the badge.*/
    @private UIColor * badgeColor;
    
    /**The color of the baged's stroke and the text.*/
    @private UIColor * badgeStrokeColor;
    
    /**The icon that is displayed for this springboard-icon. You have to choose the size of your icon-image according to the size
     of the springboard item, you defined in your \ref PTSSpringboardClass.*/
    @private UIImage * iconImage;
    
    /**An identifier-string. It can be used by the \ref PTSSpringBoard delegate, to trigger appropriate actions for the pressed springboard.*/
    @private NSString * itemIdentifier;
    
    /**The item is marked for selection. The information is used by the \ref PTSSpringBoard class for display and layout reason.*/
    @private BOOL selected;
    
    /**The item is marked as deletable. This is a cached value and determined by the \ref PTSSpringboardDataSource. The property is set by the \ref PTSSpringBoard class for display, layout and handling reason.*/
    @private BOOL deletable;
    
    /**The item is marked as movable. This is a cached value and determined by the \ref PTSSpringboardDataSource. The property is set by the \ref PTSSpringBoard class for display, layout and handling reason.*/
    @private BOOL movable;
}

@property (nonatomic, weak) id <PTSSpringBoardItemDelegate> delegate;

@property (nonatomic) NSString * itemIdentifier;

@property (nonatomic, readonly) UIImage * iconImage;

@property (nonatomic, readonly) NSString * labelText;

@property (nonatomic, readonly) NSString * badgeValue;

@property (nonatomic, readonly) UIColor * labelColor;

@property (nonatomic, readonly) UIFont * labelFont;

@property (nonatomic, readonly) UIColor * badgeColor;

@property (nonatomic, readonly) UIColor * badgeStrokeColor;

@property (nonatomic, readonly) UIFont * badgeFont;

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