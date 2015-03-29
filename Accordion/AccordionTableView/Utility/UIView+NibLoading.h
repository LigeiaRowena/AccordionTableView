//
//  UIView+NibLoading.h
//  Accordion
//
//  Created by Francesca Corsini on 04/03/15.
//  Copyright (c) 2015 Francesca Corsini. All rights reserved.
//

#import <UIKit/UIKit.h>

// Category of UIView to load a view from a NIB file

@interface UIView (NibLoading)

- (void) loadContentsFromNibNamed:(NSString*)nibName;
- (void) loadContentsFromNib;

@end

// Utility extension of UIView for init methods

@interface NibLoadedView : UIView

@end
