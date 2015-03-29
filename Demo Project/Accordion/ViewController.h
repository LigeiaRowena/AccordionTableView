//
//  ViewController.h
//  Accordion
//
//  Created by Francesca Corsini on 03/03/15.
//  Copyright (c) 2015 Francesca Corsini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccordionTableView.h"

@interface ViewController : UIViewController <AccordionViewDelegate>

@property (nonatomic, weak) IBOutlet AccordionTableView *accordionView;

@end

