//
//  AccordionTableView.h
//  Accordion
//
//  Created by Francesca Corsini on 14/03/15.
//  Copyright (c) 2015 Francesca Corsini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+NibLoading.h"

@class AccordionTableView;

#pragma mark - Defines

// available types of animations
typedef NS_ENUM(NSInteger, AccordionAnimation) {
	AccordionAnimationFade,
	AccordionAnimationRight,
	AccordionAnimationLeft,
	AccordionAnimationTop,
	AccordionAnimationBottom,
	AccordionAnimationNone,
	AccordionAnimationMiddle
};

#pragma mark - AccordionContentBean

// the content bean of the accordion tableview: AccordionContentBean
@interface AccordionContentBean : NSObject

@end

#pragma mark - AccordionHeaderView

@protocol AccordionHeaderViewDelegate;

// the header of the accordion tableview: AccordionHeaderView
@interface AccordionHeaderView : UITableViewHeaderFooterView

@end

#pragma mark - AccordionViewCell

@protocol AccordionViewCellDelegate;

// the cell of the accordion tableview: AccordionViewCell
@interface AccordionViewCell : UITableViewCell

@end

#pragma mark - AccordionTableView

// protocol delegate of AccordionTableView
@protocol AccordionViewDelegate <NSObject>

// returns the array of the headers
// objects can be NSString or id
- (NSArray *)accordionViewHeaders;

// returns the array of the content for each section
// objects can be NSString or id
- (NSArray *)accordionView:(AccordionTableView *)accordionView dataForHeaderInSection:(NSInteger)section;

@optional

// returns the header being tapped for each section
- (UIView *)accordionView:(AccordionTableView *)accordionView viewForHeaderInSection:(NSInteger)section;

// returns the cell of a section
- (AccordionViewCell *)accordionView:(AccordionTableView *)accordionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// tells the delegate that the specified row is now selected
- (void)accordionView:(AccordionTableView *)accordionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

// the view that contains the accordion tableview: AccordionTableView
@interface AccordionTableView : NibLoadedView <UITableViewDataSource, UITableViewDelegate>

// the tableview
@property (nonatomic, weak) IBOutlet UITableView *table;

// the delegate object
@property (nonatomic, weak) IBOutlet id<AccordionViewDelegate> delegate;

// the animation type
@property (nonatomic) AccordionAnimation animation;

// YES: a tap gesture on an open section performs a close animation
// NO: a tap gesture on an open section doesn't perform a close animation (default value)
@property (nonatomic) BOOL handleOpenSection;

// height of the header being tapped
@property (nonatomic) CGFloat headerHeight;

// load the accordion for the first time
- (void)load;

// reloads the rows and sections of the table view
- (void)reloadData;

// reloads the specified sections using a given animation effect
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;

// selects a section in the accordion
- (void)selectSection:(NSInteger)section animation:(AccordionAnimation)animation;

@end