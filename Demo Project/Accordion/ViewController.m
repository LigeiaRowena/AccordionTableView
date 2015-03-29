
//
//  ViewController.m
//  Accordion
//
//  Created by Francesca Corsini on 03/03/15.
//  Copyright (c) 2015 Francesca Corsini. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - Init

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// register header NIB for the accordion
	UINib *headerNib = [UINib nibWithNibName:@"AccordionHeaderView" bundle:nil];
	[self.accordionView registerNibForHeaderView:headerNib];
	
	// register cell NIB
	UINib *cellNib = [UINib nibWithNibName:@"AccordionViewCell" bundle:nil];
	[self.accordionView registerNibForCell:cellNib];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// set the kind of animation
	self.accordionView.animation = AccordionAnimationFade;
	
	// a tap gesture on an open section doesn't perform a close animation
	self.accordionView.handleOpenSection = NO;
	
	// at first select a particular section
	[self.accordionView selectSection:1];
	
	// height of the header/section
	self.accordionView.headerHeight = 60;
	
	// load the accordion
	[self.accordionView load];
}

#pragma mark - AccordionViewDelegate

- (NSArray *)accordionViewHeaders
{
	return @[@"First Section", @"Second Section", @"Third Section"];
}

- (NSArray *)accordionView:(AccordionTableView *)accordionView dataForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @[@"first"];
			break;
		case 1:
			return @[@"second"];
			break;
		case 2:
			return @[@"1", @"2", @"3"];
			break;
		default:
			break;
	}
	return nil;
}

- (void)accordionView:(AccordionTableView *)accordionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
