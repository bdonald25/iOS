//
//  QueueUploaderView.m
//  iSENSE_API
//
//  Created by Jeremy Poulin on 6/26/13.
//  Copyright (c) 2013 Jeremy Poulin. All rights reserved.
//

#import "QueueUploaderView.h"

@implementation QueueUploaderView

@synthesize mTableView, currentIndex, dataSaver, managedObjectContext, selectedMarks, dataSource, iapi, edit, lastClickedCellIndex;

// Initialize the view where the
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self = [super initWithNibName:@"queue_layout-landscape~ipad" bundle:nibBundleOrNil];
        } else {
            self = [super initWithNibName:@"queue_layout~ipad" bundle:nibBundleOrNil];
        }
    } else {
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self = [super initWithNibName:@"queue_layout-landscape~iphone" bundle:nibBundleOrNil];
        } else {
            self = [super initWithNibName:@"queue_layout~iphone" bundle:nibBundleOrNil];
        }
    }
    
    if (self) {
        iapi = [iSENSE getInstance];
    }
    return self;
    
}

// Upload button control
-(IBAction)upload:(id)sender {
    
    NSLog(@"%@", dataSaver.dataQueue.description);
    
    // Words n stuff
    if ([iapi isLoggedIn]) {
        
        // Do zee upload thang
        bool uploadSuccessful = [dataSaver upload];
        if (!uploadSuccessful) NSLog(@"Upload Not Successful");
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

// displays the correct xib based on orientation and device type - called automatically upon view controller entry
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [[NSBundle mainBundle] loadNibNamed:@"queue_layout-landscape~ipad"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"queue_layout~ipad"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [[NSBundle mainBundle] loadNibNamed:@"queue_layout-landscape~iphone"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"queue_layout~iphone"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        }
    }
}

// Do any additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Managed Object Context for Data_CollectorAppDelegate
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // Get dataSaver from the App Delegate
    if (dataSaver == nil) {
        dataSaver = [(AppDelegate *)[[UIApplication sharedApplication] delegate] dataSaver];
        if (dataSaver == nil) NSLog(@"We've got a problem here");
    }
    
    selectedMarks = [[NSMutableArray alloc] init];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPressOnTableCell:)];
    lpgr.minimumPressDuration = 0.5;
    lpgr.delegate = self;
    [self.mTableView addGestureRecognizer:lpgr];
    
    mTableView.allowsSelectionDuringEditing = YES;
    
    currentIndex = 0;
    
}

- (void) handleLongPressOnTableCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gestureRecognizer locationInView:self.mTableView];
        
        NSIndexPath *indexPath = [self.mTableView indexPathForRowAtPoint:p];
        if (indexPath != nil) {
            
            lastClickedCellIndex = [indexPath copy];
            QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:indexPath];
            if (cell.isHighlighted) {
                
                UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                             initWithTitle:nil
                                             delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Delete"
                                             otherButtonTitles:@"Rename", nil];
                popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                [popupQuery showInView:self.view];
                
            }
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void) enterEditMode {
    if ([mTableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [mTableView setEditing:NO animated:YES];
        [edit setTitle:@"Edit"];
        edit.style = UIBarButtonItemStyleBordered;
    }
    else {
        [edit setTitle:@"Done"];
        edit.style = UIBarButtonItemStyleDone;
        
        // Turn on edit mode
        
        [mTableView setEditing:YES animated:YES];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIAlertView *message;
    QueueCell *cell;
    
	switch (buttonIndex) {
        case QUEUE_DELETE: {
            
            cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
            NSNumber *key = [cell getKey];
            cell = nil;
            [dataSaver removeDataSet:key];
            [self.mTableView reloadData];
            
            break;
        }
            
        case QUEUE_RENAME: {
            message = [[UIAlertView alloc] initWithTitle:@"Enter new session name:"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Okay", nil];
            
            message.tag = QUEUE_RENAME;
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
            [message textFieldAtIndex:0].tag = TAG_QUEUE_RENAME;
            [message textFieldAtIndex:0].delegate = self;
            [message show];
            
            break;
        }
            
        default:
			break;
	}
	
}

- (void) login:(NSString *)usernameInput withPassword:(NSString *)passwordInput {
    
    UIAlertView *message;
    dispatch_queue_t queue = dispatch_queue_create("automatic_login_from_login_function", NULL);
    dispatch_async(queue, ^{
        BOOL success = [iapi login:usernameInput with:passwordInput];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self.view makeWaffle:@"Login Successful!"
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_CHECKMARK];
            } else {
                [self.view makeWaffle:@"Login Failed!"
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_RED_X];
            }
            if (message != nil)
                [message dismissWithClickedButtonIndex:nil animated:YES];
        });
    });
    
}


- (void) alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == QUEUE_LOGIN) {
        
        if (buttonIndex != OPTION_CANCELED) {
            NSString *usernameInput = [[actionSheet textFieldAtIndex:0] text];
            NSString *passwordInput = [[actionSheet textFieldAtIndex:1] text];
            [self login:usernameInput withPassword:passwordInput];
        }
    } else if (actionSheet.tag == QUEUE_RENAME) {
        
        if (buttonIndex != OPTION_CANCELED) {
            
            NSString *newSessionName = [[actionSheet textFieldAtIndex:0] text];
            QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
            [cell setSessionName:newSessionName];
            [mTableView reloadData];
        }
    }
}


// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Allows the device to rotate as necessary.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

// iOS6 enable rotation
- (BOOL)shouldAutorotate {
    return YES;
}

// iOS6 enable rotation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// There is a single column in this table
- (NSInteger *)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// There are as many rows as there are DataSets
- (NSInteger *)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataSaver == nil) NSLog(@"Why am I nil?");
    return dataSaver.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
    
    // init the CRTableViewCell
    QueueCell *cell = (QueueCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[QueueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CRTableViewCellIdentifier];
    }
    
    NSArray *keys = [dataSaver.dataQueue allKeys];
    DataSet *tmp = [dataSaver.dataQueue objectForKey:keys[indexPath.row]];
    [cell setupCellWithDataSet:tmp andKey:keys[indexPath.row]];
    
    // Check if the cell is currently selected (marked)
    NSString *text = cell.dataSet.name;
    cell.isSelected = [selectedMarks containsObject:[cell getKey]] ? YES : NO;
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QueueCell *cell = (QueueCell *) [mTableView cellForRowAtIndexPath:indexPath];
    
    
    if ([selectedMarks containsObject:[cell getKey]])// Is selected?
        [selectedMarks removeObject:[cell getKey]];
    else
        [selectedMarks addObject:[cell getKey]];
    
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
