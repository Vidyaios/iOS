//
//  WelcomeViewController.h
//  NOID
//
//  Created by iExemplar on 20/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface ControllerSetUpViewController : UIViewController<UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    AppDelegate *appDelegate;
    NSString *strResponseError,*strScanCode;
    NSDictionary *responseDict;
    NSUserDefaults *defaultsController;
}
@property (strong, nonatomic) NSString *strBackStatus;
@property (strong, nonatomic) NSString *str_Cellular_FirstStatus;
@property (strong, nonatomic) NSString *str_EditCellularStatus;
@property (strong, nonatomic) NSString *str_MultipleNetwork_Mode; //No Used

@property (strong, nonatomic) IBOutlet UILabel *lbl_header1_ControllerSetup;
@property (strong, nonatomic) IBOutlet UILabel *lbl_header2_ControllerSetup;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_deviceId_SetUp;
@property (strong, nonatomic) IBOutlet UIView *view_QRScanCode;
@property (strong, nonatomic) IBOutlet UIView *Bodyview_QRScanCode;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(IBAction)wifi_multipleNetwork_Action:(id)sender;
-(IBAction)settings_Welcome_Action:(id)sender;
-(IBAction)networkhome_Welcome_Action:(id)sender;
-(IBAction)scanQRcode_Action:(id)sender;
@end
