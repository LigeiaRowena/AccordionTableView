This is a simple tableview with accordion features. The accordion is made by simply creating a multi-sections tableview: each section has a tappable header that opens/closes the section showing/hiding the rows.
Main features:

- Minimum OS: iOS 6.0
- Devices: iPad/iPhone
- ARC
- Interface orientations: landscape/portrait
- AutoLayout
- Possibility to use XIB for header/cell (registerNibForHeaderView: and registerNibForCell: metods)
- Possibility to subclass header/cell classes
- Language used: Objective-C (you have to wait for swift, I prefer swiffer :P)

There is a demo projects that explains how to use AccordionTableView.

#INSTALLATION

First you have to import in header file of your view controller:

`#import "AccordionTableView.h"`

Then your view controller has to be conform to the AccordionViewDelegate protocol:

`@interface ViewController : UIViewController <AccordionViewDelegate>`

#USING

You can create an instance of AccordionTableView programmatically:

`@property (nonatomic, strong) AccordionTableView *accordionView;`

and the init by:

```
self.accordionView = [[AccordionTableView alloc] initWithFrame:myFrame];
self.accordionView.delegate = self;
[self.view addSubview:self.accordionView];
```

or you can simply create an IBOutlet of it, and of course in Interface Builder you have to set it as a subview of the main view of your view controller (see the example):

`@property (nonatomic, weak) IBOutlet AccordionTableView *accordionView;`

Remember also to set the delegate of the AccordionTableView object, programmatically or by using Interface Builder:

`self.accordionView.delegate = self;`

In the viewDidLoad method of your view controller you have to register the header NIB or the custom class of the cell/header of the AccordionTableView object:

```
// register header NIB for the accordion
UINib *headerNib = [UINib nibWithNibName:@"AccordionHeaderView" bundle:nil];
[self.accordionView registerNibForHeaderView:headerNib];
	
// register cell NIB
UINib *cellNib = [UINib nibWithNibName:@"AccordionViewCell" bundle:nil];
[self.accordionView registerNibForCell:cellNib];
```

In the viewDidAppear: method of your view controller you can set some optional properties of the AccordionTableView object:

```
// set the kind of animation
self.accordionView.animation = AccordionAnimationFade;
	
// a tap gesture on an open section doesn't perform a close animation
self.accordionView.handleOpenSection = NO;
	
// at first select a particular section
[self.accordionView selectSection:1];
	
// height of the header/section
self.accordionView.headerHeight = 60;
```

And then you HAVE to call the load method:

```
// load the accordion
[self.accordionView load];
```

#PROTOCOL METHODS

You have to implement the required methods of the protocol:

1.
Returns the array of the headers: you can pass an array of titles (NSString) or an array of objects (id)

`- (NSArray *)accordionViewHeaders;`

2.
Returns the array of the content for each section:you can pass an array of titles (NSString) or an array of objects (id).
The arrays's length has to be the same of the headers array's length, if not there will be a NSAssert.

`- (NSArray *)accordionView:(AccordionTableView *)accordionView dataForHeaderInSection:(NSInteger)section;`

Then you can implement the optional methods of the protocol:

1.
Returns the header being tapped for each section: you implement this method if in the accordionViewHeaders method you pass an array of objects (and not an array of strings).
Please remember that if you want to make a custom class for the header, you have to subclass the AccordionHeaderView class.

`- (AccordionHeaderView *)accordionView:(AccordionTableView *)accordionView viewForHeaderInSection:(NSInteger)section;`

2.
Returns the cell of a section: you implement this method if in the accordionView:dataForHeaderInSection method you pass an array of objects (and not an array of strings).
The parameter isOpenCell tells if the cell is opened or not: of course you have to set the content cell only if isOpenCell=TRUE.
Please remember that if you want to make a custom class for the cell, you have to subclass the AccordionViewCell class.

`- (AccordionViewCell *)accordionView:(AccordionTableView *)accordionView cellForRowAtIndexPath:(NSIndexPath *)indexPath isOpenCell:(BOOL)isOpenCell;`

3.
Tells the delegate that the specified row is now selected

`- (void)accordionView:(AccordionTableView *)accordionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;`
