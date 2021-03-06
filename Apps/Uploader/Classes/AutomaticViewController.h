//
//  AutomaticViewController.h
//  iOS Data Collector
//
//  Created by Jeremy Poulin on 1/10/13.
//  Copyright 2013 iSENSE Development Team. All rights reserved.
//  Engaging Computing Lab, Advisor: Fred Martin
//

#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <iSENSE_API/headers/DataSaver.h>
#import <iSENSE_API/QueueUploaderView.h>
#import "Data_CollectorAppDelegate.h"
#import <../../Libs/iSENSE_API/iSENSE_API/ProjectBrowserViewController.h>
#import "Constants.h"
#import <iSENSE_API/DataFieldManager.h>
#import "Data_CollectorAppDelegate.h"
#import "StepOneSetup.h"
#import <iSENSE_API/ISKeys.h>

@interface AutomaticViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>  {
    IBOutlet UIButton *step1;
    IBOutlet UIButton *step2;
    IBOutlet UIButton *step3;
    UIBarButtonItem *menuButton;
    IBOutlet UILabel *step1Label;
    IBOutlet UILabel *step3Label;
}

- (void)displayMenu;
- (IBAction) setup:(UIButton *)sender;
- (IBAction) uploadData:(UIButton *)sender;
- (IBAction) onRecordLongClick:(UILongPressGestureRecognizer *)sender;

- (void) login:(NSString *)usernameInput withPassword:(NSString *)password;
- (void) recordData;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error;

@property (nonatomic, strong) API *api;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) BOOL backFromSetup;
@property (nonatomic) BOOL backFromQueue;
@property (nonatomic) int  elapsedTime;
@property (nonatomic) int  recordingRate;

@property (nonatomic, assign) float sampleInterval;
@property (nonatomic, copy) NSString *dataSetName;
@property (nonatomic) int testLength;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *recordDataTimer;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSMutableArray *dataToBeJSONed;
@property (nonatomic, strong) NSMutableArray *dataToBeOrdered;
@property (nonatomic, assign) int projNum;
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DataFieldManager *dfm;
@property (nonatomic, strong) Fields *f;

@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *country;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet UILongPressGestureRecognizer *longClickRecognizer;
@property (nonatomic, strong) DataSaver *dataSaver;

@end
