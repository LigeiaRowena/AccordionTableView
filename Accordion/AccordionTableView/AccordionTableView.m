//
//  AccordionTableView.m
//  Accordion
//
//  Created by Francesca Corsini on 14/03/15.
//  Copyright (c) 2015 Francesca Corsini. All rights reserved.
//

#import "AccordionTableView.h"

#pragma mark - AccordionContentBean

@interface AccordionContentBean()

// YES: the content is open
// NO: the content isn't open
@property (nonatomic) BOOL open;

// the data of the content
@property (nonatomic, strong) id content;

// init
- (id)initWithContent:(id)content;

@end

@implementation AccordionContentBean

#pragma mark Init

- (id)initWithContent:(id)content
{
	self = [super init];
	if (self) {
		self.content = content;
		self.open = NO;
	}
	return self;
}

@end

#pragma mark - AccordionHeaderView

typedef void (^AccordionHeaderBlock)(int);

@interface AccordionHeaderView()

// utility block for notification of the section being tapped
@property (copy) AccordionHeaderBlock accordionHeaderBlock;

// the area tapped
@property (nonatomic, weak) IBOutlet UIButton *button;

// the index section of the accordion
@property (nonatomic) NSInteger section;

@end

@implementation AccordionHeaderView

#pragma mark Init


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self) {
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

#pragma mark Identifier

+ (NSString *)reuseIdentifier
{
	return NSStringFromClass([self class]);
}

#pragma mark UI

- (void)setContent:(id)obj block:(AccordionHeaderBlock)block
{
	self.accordionHeaderBlock = [block copy];
	[self.button setTitle:(NSString*)obj forState:UIControlStateNormal];
}

- (IBAction)selectSection:(id)sender
{
	if (self.accordionHeaderBlock != nil)
		self.accordionHeaderBlock(self.section);
}

@end

#pragma mark - AccordionViewCell

typedef void (^AccordionViewCellBlock)(NSString*, int, id);

@interface AccordionViewCell()

// utility block for notification of some actions
@property (copy) AccordionViewCellBlock accordionViewCellBlock;

// the main label of the cell
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation AccordionViewCell

#pragma mark Init

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
}

#pragma mark Identifier

+ (NSString *)reuseIdentifier
{
	return NSStringFromClass([self class]);
}

#pragma mark UI

- (void)setContent:(id)obj block:(AccordionViewCellBlock)block
{
	self.accordionViewCellBlock = [block copy];
	[self.label setText:(NSString*)obj];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

- (IBAction)someAction:(id)sender
{
	if (self.accordionViewCellBlock != nil)
		self.accordionViewCellBlock(@"action_name", 1, @[@"1"]);
}

@end


#pragma mark - AccordionTableView

@interface AccordionTableView()

// the data of contents of the tableview
@property (nonatomic, strong) NSMutableArray *data;

// the data of headers of the tableview
@property (nonatomic, strong) NSArray *headers;

@end

@implementation AccordionTableView

#pragma mark Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	// register header NIB
	UINib *headerNib = [UINib nibWithNibName:@"AccordionHeaderView" bundle:nil];
	[self.table registerNib:headerNib forHeaderFooterViewReuseIdentifier:[AccordionHeaderView reuseIdentifier]];
	
	// register cell NIB
	UINib *cellNib = [UINib nibWithNibName:@"AccordionViewCell" bundle:nil];
	[self.table registerNib:cellNib forCellReuseIdentifier:[AccordionViewCell reuseIdentifier]];
	
	// init properties
	self.animation = AccordionAnimationNone;
	self.handleOpenSection = NO;
	self.headerHeight = 60;
}

- (void)load
{
	// init headers
	if (self.delegate && [self.delegate respondsToSelector:@selector(accordionViewHeaders)])
		self.headers = [self.delegate accordionViewHeaders];
	
	// init data
	self.data = @[].mutableCopy;
	[self.headers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(accordionView:dataForHeaderInSection:)])
		{
			NSArray *content = [self.delegate accordionView:self dataForHeaderInSection:idx];
			if (content == nil)
				NSAssert(content != nil, @"Warning: You didn't passed any array for section %i", idx);

			AccordionContentBean *bean = [[AccordionContentBean alloc] initWithContent:content];
			[self.data addObject:bean];
		}
	}];
	
	[self.table reloadData];
}

#pragma mark UITableViewDataSource/UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.headers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// the content bean of the data
	AccordionContentBean *bean = self.data[section];
	if (bean.open)
		return [bean.content count];
	else
		return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// overrided
	if (self.delegate && [self.delegate respondsToSelector:@selector(accordionView:viewForHeaderInSection:)])
		return [self.delegate accordionView:self viewForHeaderInSection:section];
	
	AccordionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[AccordionHeaderView reuseIdentifier]];
	headerView.section = section;
	id content = self.headers[section];
	if ([content isKindOfClass:[NSString class]])
		[headerView setContent:content block:^(int section) {
			[self didSelectSection:section];
		}];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return self.headerHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// overrided
	if (self.delegate && [self.delegate respondsToSelector:@selector(accordionView:cellForRowAtIndexPath:)])
		return [self.delegate accordionView:self cellForRowAtIndexPath:indexPath];
	
	AccordionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AccordionViewCell reuseIdentifier]];
	AccordionContentBean *bean = self.data[indexPath.section];
	if (bean.open)
	{
		id content = bean.content[indexPath.row];
		if ([content isKindOfClass:[NSString class]])
			[cell setContent:content block:^(NSString * actionName, int index, id object) {
				NSLog(@"Perform some action %@ with index %i and object %@", actionName, index, object);
			}];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(accordionView:didSelectRowAtIndexPath:)])
		[self.delegate accordionView:self didSelectRowAtIndexPath:indexPath];
}

- (void)didSelectSection:(NSInteger)section
{
	AccordionContentBean *beanSelected = self.data[section];
	
	if (!beanSelected.open || self.handleOpenSection)
	{
		// change data
		if (self.handleOpenSection && beanSelected.open)
			beanSelected.open = NO;
		else
			[self.data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				AccordionContentBean *bean = (AccordionContentBean*)obj;
				bean.open = (section == idx);
			}];
		
		
		// perform the open/close animation
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.data count])];
		switch (self.animation)
		{
			case AccordionAnimationFade:
				[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
				break;
			case AccordionAnimationRight:
				[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
				break;
			case AccordionAnimationLeft:
				[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
				break;
			case AccordionAnimationTop:
				[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
				break;
			case AccordionAnimationBottom:
				[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
				break;
			case AccordionAnimationMiddle:
				[self.table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationMiddle];
				break;
			case AccordionAnimationNone:
				[self.table reloadData];
				break;
			default:
				break;
		}
	}
}

#pragma mark Public

- (void)reloadData
{
	[self.table reloadData];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
	[self.table reloadSections:sections withRowAnimation:animation];
}

- (void)selectSection:(NSInteger)section animation:(AccordionAnimation)animation
{
	self.animation = animation;
	[self didSelectSection:section];	
}

@end
