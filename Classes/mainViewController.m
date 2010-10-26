    //
//  mainViewController.m
//  backgroundMusic
//
//  Created by maliy on 7/15/10.
//  Copyright 2010 interMobile. All rights reserved.
//

#import "mainViewController.h"
#import "rightViewCell.h"


@implementation mainViewController

#pragma mark lifeCycle

- (id) init
{
	if (self = [super init])
	{
		editFields = [[NSMutableArray alloc] initWithCapacity:10];
		for (NSInteger i=0; i<10; i++)
		{
			[editFields addObject:[NSNull null]];
		}
		keyboardShown = NO;
	}
	return self;
}

- (void) dealloc
{
	[editFields release];
	
	[super dealloc];
}


#pragma mark -

- (UITextField *) createTextFieldWithTag:(NSInteger) _tag
{
	UITextField *rv = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 160.0, 30.0)];
    
	rv.borderStyle = UITextBorderStyleRoundedRect;
    rv.textColor = [UIColor blackColor];
	rv.font = [UIFont systemFontOfSize:17.0];
	rv.tag = _tag;
// 	rv.text = _text;
    rv.backgroundColor = [UIColor whiteColor];
	rv.autocorrectionType = UITextAutocorrectionTypeNo;
	
	rv.keyboardType = UIKeyboardTypeDefault;
	rv.returnKeyType = UIReturnKeyDone;
	rv.delegate = self;
	
	rv.clearButtonMode = UITextFieldViewModeWhileEditing;
	return rv;
}

- (void) moveToTextFiels:(NSInteger) idx
{
	[tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]
			  atScrollPosition:UITableViewScrollPositionMiddle
					  animated:YES];
}



#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *) textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *) textField
{
	lastTouchField = textField.tag;
	[self moveToTextFiels:lastTouchField];
}


#pragma mark tableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [editFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
//	NSString *cellID = @"TEST_CELL_ID";
	NSString *cellID = [NSString stringWithFormat:@"TEST_CELL_ID%d", indexPath.row];
	rightViewCell *rv = (rightViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if (!rv)
	{
		rv = [[[rightViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	}
	rv.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"edit #%02d", @""), indexPath.row];
	UITextField *rView = [editFields objectAtIndex:indexPath.row];
	if ([rView class]==[NSNull class])
	{
		rView = [self createTextFieldWithTag:indexPath.row];
		[editFields replaceObjectAtIndex:indexPath.row withObject:rView];
	}
	rv.view = rView;
	return rv;
}

- (void) deselect:(UITableView *) tableView
{
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSelector:@selector(deselect:) withObject:tableView afterDelay:0.5];
	
}

#pragma mark -

- (void) keyboardWillShown:(NSNotification*) aNotification
{
	if (keyboardShown)
		return;
	
	NSDictionary* info = [aNotification userInfo];
	NSLog(@"%@", info);
	
	// Get the size of the keyboard.
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	if (!aValue)
	{
		aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	}
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	CGRect rct = self.view.bounds;
	CGFloat kHeight = MIN(keyboardSize.width, keyboardSize.height);
	rct.size.height -= kHeight;
	tv.frame = rct;
	
	keyboardShown = YES;
}

- (void) keyboardDidShown:(NSNotification*) aNotification
{
	[self moveToTextFiels:lastTouchField];
}

- (void)keyboardWasHidden:(NSNotification*)aNotification
{
	//	NSDictionary* info = [aNotification userInfo];
	tv.frame = self.view.bounds;
	keyboardShown = NO;
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShown:)
												 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

- (void) unRegisterForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -

- (void) viewDidAppear:(BOOL) animated
{
	[self registerForKeyboardNotifications];
}

- (void) viewDidDisappear:(BOOL) animated
{
	[self unRegisterForKeyboardNotifications];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
	return YES;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	
	self.navigationItem.title = NSLocalizedString(@"table with editField", @"");
	
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	
	UIView *contentView = [[UIView alloc] initWithFrame:screenRect];
	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	contentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
	
	self.view = contentView;
	[contentView release];

	UITableView *_tv = [[UITableView alloc] initWithFrame:self.view.bounds
													style:UITableViewStylePlain];
	_tv.delegate = self;
	_tv.dataSource = self;
	_tv.autoresizesSubviews = YES;
	_tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tv = [_tv retain];
	[self.view addSubview:tv];
	[_tv release];
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[tv release];
}



@end
