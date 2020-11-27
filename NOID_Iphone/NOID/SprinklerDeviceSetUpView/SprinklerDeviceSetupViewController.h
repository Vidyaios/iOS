//
//  SprinklerDeviceSetupViewController.h
//  NOID
//
//  Created by Karthik on 8/18/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Common.h"
@protocol ProcessDataDelegateSprinklerDeviceSetUpProfile <NSObject>
@required
-(void)processSuccessful_Back_To_NetworkHome_Via_SprinklerDeviceSetUp:(BOOL)success;
@end
@interface SprinklerDeviceSetupViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL sprinkler_QR_ExpandedStatus,zoneExpandStatus,imageStatus;
    id <ProcessDataDelegateSprinklerDeviceSetUpProfile> delegate;
    AppDelegate *appDelegate;
    NSMutableArray *arrZoneDetails;
    NSString *strZoneUIStatus,*strEncoded_ControllerImage;
    int tag_Pos;
    NSDictionary *responseDict;
    NSString *strResponseError,*strSprinklerDevice_TraceID,*strZoneCode,*strZone_Added_Status,*strSprinkler_DeviceID;
    NSUserDefaults *defaults_AddSprinkler;
    NSString *strAutoOpen_Status,*strServiceUpdate_Status,*strScanCode_SprinklerSetUp,*strprorationTime;
    NSString *strDeviceAdd_UpdateStatus,*strZone_AddedStatus,*strVacationStatus;
    float Amount_Zone;
    NSString *strActionType,*strZoneProceedStatus;
}
@property (retain) id delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewSprinkler;

//QRView
@property (strong, nonatomic) IBOutlet UIView *viewSprinkler_QR;
@property (strong, nonatomic) IBOutlet UIView *viewSprinkler_QR_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewSprinkler_QR_BodyContent;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceId_SetUp;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_QR;

//FOOTER VIEW
@property (strong, nonatomic) IBOutlet UIView *footerView_Zone_Sprinkler;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIView *bodyView;
@property (strong, nonatomic) NSString *strDeviceType;

//Common
@property (strong, nonatomic) IBOutlet UIView *commonView;
@property (strong, nonatomic) IBOutlet UIView *commonProceedView;
@property (strong, nonatomic) IBOutlet UIView *commonCancelView;
@property (strong, nonatomic) IBOutlet UIView *commonImageView;
@property (strong, nonatomic) IBOutlet UIView *commonEditImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewZone;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceName_SetUp;

//QR Scanner
@property (nonatomic, strong) AVCaptureSession *captureSession_SprinklerSetUp;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer_SprinklerSetUp;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer_SprinklerSetUp;
@property (nonatomic) BOOL isReading_SprinklerSetUp;

@property (strong, nonatomic) IBOutlet UIView *viewSprinklerSetUp_QRScanCode;
@property (strong, nonatomic) IBOutlet UIView *bodyView_QRScan_SprinklerSetUp;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_Zone;
@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_Confirm_Zone;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanUpgrade_Charge_Zone;
@property (strong, nonatomic) IBOutlet UIButton *btn_Charge_Zone;


-(IBAction)sprinkler_QR_ButtonAction:(id)sender;
-(IBAction)sprinkler_TapMenu_Action:(id)sender;
-(IBAction)settings_HomeNoid_SprinklerSetUp_Action:(id)sender;
-(IBAction)sprinkler_Zone_Action:(id)sender;
-(IBAction)planUpgrade_Confirm_Zone_Action:(id)sender;

@end
