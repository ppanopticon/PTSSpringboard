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


#import "PTSSpringBoardItem.h"

@implementation PTSSpringBoardItem

@synthesize delegate, labelText, iconImage, badgeValue, labelColor, itemIdentifier, selected, deletable, movable;

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
    /*Get the current graphics context.*/
    CGContextRef context = UIGraphicsGetCurrentContext();

    /**Draws the Icon. */
    [self.iconImage drawInRect:CGRectMake(20.0f, 10.0f, 60.0f, 60.0f)];
    
    /** Draw the menu item title if necessary.*/
    [labelColor  set];
    
    [self.labelText drawInRect:CGRectMake(0.0, 70.0, 100.0f, 20.0) withFont:[UIFont systemFontOfSize:14.0f] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    /** Draws the badge if if necessary.*/
    if (self.badgeValue && ![[self badgeValue] isEqualToString:@"0"] && ![[self badgeValue] isEqualToString:@""]) {
        CGRect viewBounds = self.bounds;
        
        CGSize numberSize = [self.badgeValue sizeWithFont:[UIFont systemFontOfSize:14.0f]];
		
        CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
        
        CGRect badgeRect = CGPathGetBoundingBox(badgePath);
        
        badgeRect.origin.x = 0.0f;
        badgeRect.origin.y = 0.0f;
        badgeRect.size.width = ceil( badgeRect.size.width );
        badgeRect.size.height = ceil( badgeRect.size.height );
        
        
        CGFloat lineWidth = 2.0;
        
        CGContextSaveGState( context );
        CGContextSetLineWidth( context, lineWidth );
        CGContextSetStrokeColorWithColor(  context, [UIColor whiteColor].CGColor  );
        CGContextSetFillColorWithColor( context, [UIColor redColor].CGColor );
        
        // Line stroke straddles the path, so we need to account for the outer portion
        badgeRect.size.width += ceilf( lineWidth / 2 );
        badgeRect.size.height += ceilf( lineWidth / 2 );
        
        CGPoint ctm = CGPointMake(round((viewBounds.size.width - badgeRect.size.width - 10.0f)), round((badgeRect.size.height)/2));
        
        CGContextTranslateCTM( context, ctm.x, ctm.y);
        
        CGContextSaveGState( context );
        
		CGSize blurSize = CGSizeMake(0, 3);
		UIColor* blurColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
		
		CGContextSetShadowWithColor( context, blurSize, 4, blurColor.CGColor );
		
		CGContextBeginPath( context );
		CGContextAddPath( context, badgePath );
		CGContextClosePath( context );
		
		CGContextDrawPath( context, kCGPathFillStroke );
		CGContextRestoreGState(context);
        
        CGContextBeginPath( context );
        CGContextAddPath( context, badgePath );
        CGContextClosePath( context );
        CGContextDrawPath( context, kCGPathFillStroke );
        
        CGContextBeginPath( context );
		CGContextAddPath( context, badgePath );
		CGContextClosePath( context );
		CGContextClip(context);
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGFloat shinyColorGradient[8] = {1, 1, 1, 0.8, 1, 1, 1, 0};
		CGFloat shinyLocationGradient[2] = {0, 1};
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                     shinyColorGradient,
                                                                     shinyLocationGradient, 2);
		
		CGContextSaveGState(context);
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, 0, 0);
		
		CGFloat shineStartY = badgeRect.size.height*0.25;
		CGFloat shineStopY = shineStartY + badgeRect.size.height*0.4;
		
		CGContextAddLineToPoint(context, 0, shineStartY);
		CGContextAddCurveToPoint(context, 0, shineStopY,
                                 badgeRect.size.width, shineStopY,
                                 badgeRect.size.width, shineStartY);
		CGContextAddLineToPoint(context, badgeRect.size.width, 0);
		CGContextClosePath(context);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, gradient,
									CGPointMake(badgeRect.size.width / 2.0, 0),
									CGPointMake(badgeRect.size.width / 2.0, shineStopY),
									kCGGradientDrawsBeforeStartLocation);
		CGContextRestoreGState(context); 
		
		CGColorSpaceRelease(colorSpace); 
		CGGradientRelease(gradient); 
        
        CGContextRestoreGState( context );
        CGPathRelease(badgePath);
        
        CGContextSaveGState( context );
        CGContextSetFillColorWithColor( context, [UIColor whiteColor].CGColor );
		
        CGPoint textPt = CGPointMake(ctm.x + (badgeRect.size.width - numberSize.width)/2 , ctm.y + (badgeRect.size.height - numberSize.height)/2 );
        
        [self.badgeValue drawAtPoint:textPt withFont:[UIFont systemFontOfSize:14.0f]];
        
        CGContextRestoreGState( context );
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

- (CGPathRef)newBadgePathForTextSize:(CGSize)inSize {
	CGFloat arcRadius = ceil((inSize.height+2.0f)/2.0);
	
	CGFloat badgeWidthAdjustment = inSize.width - inSize.height/2.0;
	CGFloat badgeWidth = 2.0*arcRadius;
	
	if ( badgeWidthAdjustment > 0.0 ) {
		badgeWidth += badgeWidthAdjustment;
	}
	
	CGMutablePathRef badgePath = CGPathCreateMutable();
	
	CGPathMoveToPoint( badgePath, NULL, arcRadius, 0 );
	CGPathAddArc( badgePath, NULL, arcRadius, arcRadius, arcRadius, 3.0*M_PI_2, M_PI_2, YES);
	CGPathAddLineToPoint( badgePath, NULL, badgeWidth-arcRadius, 2.0*arcRadius);
	CGPathAddArc( badgePath, NULL, badgeWidth-arcRadius, arcRadius, arcRadius, M_PI_2, 3.0*M_PI_2, YES);
	CGPathAddLineToPoint( badgePath, NULL, arcRadius, 0 );
	
	return badgePath;
	
}
@end
