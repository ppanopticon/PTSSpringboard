/* PTSSpringBoardItem.h

Copyright (C) 2012 pontius software GmbH, created by Ralph Gasser

This program is free software: you can redistribute and/or modify
it under the terms of the Createive Commons (CC BY-SA 3.0) license
*/



#import "PTSSpringBoardItem.h"

@implementation PTSSpringBoardItem

@synthesize delegate, labelText, iconImage, badgeValue, labelColor, badgeColor, badgeStrokeColor, badgeFont, labelFont, itemIdentifier, selected, deletable, movable;

#pragma mark 
#pragma mark Object-Lifecycle

-(id)init {
    if (self = [super initWithFrame:CGRectZero]) {
        /**Adds a gesture recognizer for a long press.*/
        UILongPressGestureRecognizer * pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        pressRecognizer.minimumPressDuration = 1.5;
        [self addGestureRecognizer:pressRecognizer];
        
        /**Adds a gesture recognizer for a tab.*/
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [tapRecognizer requireGestureRecognizerToFail:pressRecognizer];
        [self addGestureRecognizer:tapRecognizer];

        /**Sets the views background-color.*/
        [self setBackgroundColor:[UIColor clearColor]];
        
        /**Sets the default badge-color.*/
        badgeColor = [UIColor redColor];
        
        /**Sets the default badges stroke color.*/
        badgeStrokeColor = [UIColor whiteColor];
        
        /**Sets the default badge-font.*/
        badgeFont = [UIFont systemFontOfSize:16.0f];
        
        /**Sets the defualt label-color.*/
        labelColor = [UIColor blackColor];
        
        /**Sets the default label-font.*/
        labelFont = [UIFont boldSystemFontOfSize:14.0f];
        
        /**Modifies drawing-behaviour.*/
        self.opaque = NO;
        self.clearsContextBeforeDrawing = YES;
    }
    
    return self;
}

#pragma mark -
#pragma mark Custom Setter-Methods

-(void)setLabel:(NSString *)text {
    labelText = text;
    
    [self setNeedsDisplay];
}

-(void)setIcon:(UIImage *)anIcon {
    iconImage = anIcon;
    
    [self setNeedsDisplay];
}

-(void)setBadgeValue:(NSString *)value {
    badgeValue = value;
    
    [self setNeedsDisplay];
}

-(void)set:(NSString *)value {
    badgeValue = value;
    
    [self setNeedsDisplay];
}

-(void)setLabelColor:(UIColor*)color {
    labelColor = color;
    
    [self setNeedsDisplay];
}

-(void)setLabelFont:(UIFont *)font {
    labelFont = font;
    
    [self setNeedsDisplay];
}

-(void)setBadgeColor:(UIColor *)color {
    badgeColor = color;
    
    [self setNeedsDisplay];
}

-(void)setBadgeStrokeColor:(UIColor *)color {
    badgeStrokeColor = color;
    
    [self setNeedsDisplay];
}

-(void)setBadgeFont:(UIFont *)font {
    badgeFont = font;
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Custom methods

-(void)toggleWiggleAnimation:(BOOL)animate {
    if (animate) {
        CATransform3D transform;
        
        if (arc4random() % 2 == 1)
            transform = CATransform3DMakeRotation(-0.08, 0, 0, 1.0);
        else
            transform = CATransform3DMakeRotation(0.08, 0, 0, 1.0);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 0.2;
        animation.repeatCount = NSIntegerMax;
        animation.autoreverses = YES;
        animation.delegate = self;
        [[self layer] addAnimation:animation forKey:@"wiggleAnimation"];
    } else {
        [[self layer] removeAnimationForKey:@"wiggleAnimation"];
    }
}


#pragma mark -
#pragma mark User-Interaction handling

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer{
    [[self delegate] springboardItemTaped:self];
}

-(void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    [[self delegate] springboardItemLongPressed:self];
}

-(void)handleDeleteAction:(id)sender {
    [UIView animateWithDuration:0.75 animations:^(void){
        self.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self toggleWiggleAnimation:NO];
        [[self delegate] springboardItemDeleteButtonPressed:self];
    }]; 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([delegate springboardIsEditing] && [self isMovable]) {
        /**Stops the wiggeling animation for editing mode, while dragging and sets the alpha to 0.5. Then informs the delegate, that dragging has begun.*/
         [UIView animateWithDuration:0.25 animations:^(void){
             self.alpha = 0.5;
         } completion:^(BOOL finished) {
            [self toggleWiggleAnimation:NO];
             [[self delegate] springboardDidBeginDraging:self];
         }];
    }
 }

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([delegate springboardIsEditing] && [self isMovable]) {
        UITouch * touch = [touches anyObject];
        CGPoint location = [touch locationInView:self.superview];
        if ([touch view] == self) {
            self.center = CGPointMake(location.x, location.y);
            [[self delegate] springboardIsDraging:self];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([delegate springboardIsEditing] && [self isMovable]) {
        /**Resumes the wiggeling animation for editing mode and resets the alpha to 1. Then informs the delegate, that dragging has ended.*/
        [UIView animateWithDuration:0.25 animations:^(void){
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self toggleWiggleAnimation:YES];
            [[self delegate] springboardDidEndDraging:self];
        }];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([delegate springboardIsEditing] && [self isMovable]) {
        /**Resumes the wiggeling animation for editing mode and resets the alpha to 1. Then informs the delegate, that dragging has ended.*/
        [UIView animateWithDuration:0.25 animations:^(void){
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self toggleWiggleAnimation:YES];
            [[self delegate] springboardDidEndDraging:self];
        }];
    }
}

# pragma mark - 
# pragma mark Drawing

-(void)drawRect:(CGRect)rect {
    /*Get the current graphics context....*/
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* and my frame!*/
    CGRect frame = self.bounds;
    
    /* Height and width of the badge text.*/
    CGSize badgeTextSize = [[self badgeValue] sizeWithFont:[self badgeFont]];

    /*Gets the height of the label text.*/
    CGSize labelTextSize = [[self labelText] sizeWithFont:[self labelFont]];

    /**Draws the Icon. The space the icon has, is dependant on the size of the badge and the label. The icon is allways centered in horizontal direction.*/
    [self.iconImage drawInRect:CGRectMake((CGRectGetWidth(frame) - (CGRectGetHeight(frame)-labelTextSize.height - 10.0f))/2, 10.0f, CGRectGetHeight(frame)-labelTextSize.height - 10.0f, CGRectGetHeight(frame)-labelTextSize.height - 10.0f)];
    
    /** Now draws the items label. The label is positioned at the most bottom right corner, and the labels rect size takes the full width of the item and the line height of the font. By using UITextAlignmentCenter, the label-text ist allways centered horizontally.*/
    [[self labelColor]  set];
    [self.labelText drawInRect:CGRectMake(0.0, CGRectGetHeight(frame) - labelTextSize.height, frame.size.width, labelTextSize.height) withFont:self.labelFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    
    /** Draws the badge if if necessary.*/
    if (self.badgeValue && ![[self badgeValue] isEqualToString:@"0"] && ![[self badgeValue] isEqualToString:@""]) {
        /*Height and width of the badge (dependant of the text)*/
        CGFloat badgeHeight = badgeTextSize.height + 2.0f;
        CGFloat badgeWidth = ((badgeTextSize.width + 10.0f) < badgeHeight) ? badgeHeight : (badgeTextSize.width + 10.0f);
                
        /* Shadow Declarations*/
        UIColor* innerShadow = [UIColor whiteColor];
        CGSize innerShadowOffset = CGSizeMake(1, 2);
        CGFloat innerShadowBlurRadius = 5;
        UIColor* outerShadow = [UIColor blackColor];
        CGSize outerShadowOffset = CGSizeMake(0, 2);
        CGFloat outerShadowBlurRadius = 3;
        
        /* Rounded Rectangle Drawing*/
        UIBezierPath * roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetWidth(frame) - badgeWidth - 10.0f, CGRectGetMinY(frame) + 10.0f, badgeWidth, badgeHeight) cornerRadius: 12.0f];
        /*Outer Shadow drawing.*/
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, outerShadowOffset, outerShadowBlurRadius, outerShadow.CGColor);

        [self.badgeColor setFill];
        [roundedRectanglePath fill];
        
        /* Rounded Rectangle Inner Shadow*/
        CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
        roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
        roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
        
        UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
        [roundedRectangleNegativePath appendPath: roundedRectanglePath];
        roundedRectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = innerShadowOffset.width + round(roundedRectangleBorderRect.size.width);
            CGFloat yOffset = innerShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        innerShadowBlurRadius,
                                        innerShadow.CGColor);
            
            [roundedRectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
            [roundedRectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [roundedRectangleNegativePath fill];
        }
        
        NSLineBreakMode
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        /*Drawing of the stroke...*/
        [[self badgeStrokeColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
        
        /* Rect of the text.*/
        CGRect textRect = CGRectMake(roundedRectangleBorderRect.origin.x + 1.0f, roundedRectangleBorderRect.origin.y + badgeTextSize.height/2 - 1.0f, roundedRectangleBorderRect.size.width, badgeTextSize.height);
        
        /* ...and the text.*/
        [[self badgeStrokeColor] setFill];
        [self.badgeValue drawInRect: textRect withFont:self.badgeFont lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
    }
    
    if ([self isDeletable]) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
        [button setImage:[UIImage imageNamed:@"delete-springboard"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleDeleteAction:) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:button];
    }
    
    if ([[self delegate] springboardIsEditing] && [self isMovable] && ![self isSelected]) {
        [self toggleWiggleAnimation:YES];
    } else {
        [self toggleWiggleAnimation:NO];
    }
}
@end
