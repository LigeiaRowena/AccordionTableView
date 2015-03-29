//
//  UIView+NibLoading.m
//  Accordion
//
//  Created by Francesca Corsini on 04/03/15.
//  Copyright (c) 2015 Francesca Corsini. All rights reserved.
//

#import "UIView+NibLoading.h"
#import <objc/runtime.h>

#pragma mark UIView(NibLoading)

@implementation UIView(NibLoading)

+ (UINib*) _nibLoadingAssociatedNibWithName:(NSString*)nibName
{
	// Load the NIB file at runtime
    static char kUIViewNibLoading_associatedNibsKey;

    NSDictionary * associatedNibs = objc_getAssociatedObject(self, &kUIViewNibLoading_associatedNibsKey);
    UINib * nib = associatedNibs[nibName];
    if (nil == nib)
    {
        nib = [UINib nibWithNibName:nibName bundle:nil];
        if (nib)
        {
            NSMutableDictionary * newNibs = [NSMutableDictionary dictionaryWithDictionary:associatedNibs];
            newNibs[nibName] = nib;
            objc_setAssociatedObject(self, &kUIViewNibLoading_associatedNibsKey, [NSDictionary dictionaryWithDictionary:newNibs], OBJC_ASSOCIATION_RETAIN);
        }
    }

    return nib;
}

- (void) loadContentsFromNibNamed:(NSString*)nibName
{
    // Load the NIB file setting self as owner
    UINib * nib = [[self class] _nibLoadingAssociatedNibWithName:nibName];
    NSAssert(nib != nil, @"UIView+NibLoading : Can't load NIB named %@.",nibName);
    NSArray * views = [nib instantiateWithOwner:self options:nil];
    NSAssert(views != nil, @"UIView+NibLoading : Can't instantiate NIB named %@.",nibName);

    // Search for the first container view
    UIView * containerView = nil;
    for (id view in views)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            containerView = view;
            break;
        }
    }
    NSAssert(containerView != nil, @"UIView+NibLoading : There is no container UIView found at the root of NIB %@.",nibName);
	
	// autolayout setting
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if (CGRectEqualToRect(self.bounds, CGRectZero))
        // this view has no size so use the container view's size
        self.bounds = containerView.bounds;
    else
        // this view has a specific size so resize the container view to this size
        containerView.bounds = self.bounds;
    NSArray *constraints = containerView.constraints;
    
    // re-parent the subviews from the container view
    for (UIView * view in containerView.subviews)
	{
        [view removeFromSuperview];
        [self addSubview:view];
    }
    
    // re-add constraints
    for (NSLayoutConstraint *constraint in constraints)
    {
        id firstItem = constraint.firstItem;
        id secondItem = constraint.secondItem;
        if (firstItem == containerView)
            firstItem = self;
        if (secondItem == containerView)
            secondItem = self;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant]];
    }
}

- (void) loadContentsFromNib
{
    [self loadContentsFromNibNamed:NSStringFromClass([self class])];
}

@end

#pragma mark NibLoadedView

@implementation NibLoadedView : UIView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
	if (self) {
		[self loadContentsFromNib];
	}
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
		[self loadContentsFromNib];
	}
    return self;
}

@end
