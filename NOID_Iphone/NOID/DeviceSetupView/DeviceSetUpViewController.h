//
//  DeviceSetUpViewController.h
//  NOID
//
//  Created by iExemplar on 10/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@protocol ProcessDataDelegateDeviceSetUpProfile <NSObject>
@required
-(void)processSuccessful_Back_To_NetworkHome_Via_DeviceSetUp:(BOOL)success;
@end

@interface DeviceSetUpViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL lightSetUp_QR_ExpandedStatus,lightSetUp_info_ExpandedStatus;
    NSString *strDeviceInfo_ExpandStatus,*strDevice_TraceID;
    id <ProcessDataDelegateDeviceSetUpProfile> delegate;
    AppDelegate *appDelegate;
    BOOL imageStatus,categoryStatus;
    NSString *strDevice_Edit_Status,*strResponseError,*strEncoded_ControllerImag,*strScanCode;
    NSDictionary *responseDict;
    NSUserDefaults *defaultsDevice;
    NSString *strSave_Skip_Schedule,*str_Saved_DeviceID,*str_Device_Added,*strprorationTime;
}
@property (retain) id delegate;
@property (strong, nonatomic) NSString *strDeviceID;
@property (strong, nonatomic) NSString *strDeviceType;
@property (strong, nonatomic) NSString *strBackStatus_LightSetUp;
@property (strong, nonatomic) NSString *strPreviousView;
@property (strong, nonatomic) IBOutlet UIView *viewLightSetUp_Header;
@property (strong, nonatomic) IBOutlet UIView *viewLightSetUp_Body;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_LightSetUp;
@property (strong, nonatomic) IBOutlet UIButton *btnHeader_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UIButton *backarrow_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ScanTabNo_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UILabel *lbl_DeviceInfoTabNo_LightOtherSetUp;

//QRView
@property (strong, nonatomic) IBOutlet UIView *viewLightSetUp_QR;
@property (strong, nonatomic) IBOutlet UIView *viewLightSetUp_QR_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewLightSetUp_QR_BodyContent;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceId_LightSetUp;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_QR_LightSetUp;
@property (strong, nonatomic) IBOutlet UILabel *lblScan_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceId_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UIView *view_Proceed_LightOtherSetUp;

//DeviceinfoView
@property (strong, nonatomic) IBOutlet UILabel *lbl_deviceImgName;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_Container;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_BodyContent;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceEdit_Info_Wifi;
//@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_SelectCategory;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_ImageGallery;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_ImageEdit;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_SetUpSchedule;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_SkipSchedule;
//@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_ProceedCancel_View;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceInfo_SetupSkip_View;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceName_LightSetUp;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Info;
@property (strong, nonatomic) IBOutlet UIView *view_otherCategory;
@property (strong, nonatomic) IBOutlet UIButton *cameraSnap_LightOtherSetUp;
@property (strong, nonatomic) IBOutlet UIButton *album_LightOtherSetUp;
//@property (strong, nonatomic) IBOutlet UIView *view_SetUpSchedule;
@property (strong, nonatomic) IBOutlet UIView *view_DeviceInfo_Alert;
@property (strong, nonatomic) IBOutlet UIButton *btn_DeviceInfo_chargeMyCard;
@property (strong, nonatomic) NSString *strControllerStatus;

@property (strong, nonatomic) NSString *strController_Added_ID;
@property (strong, nonatomic) NSDictionary *network_Data_Dict;

//QR Scanner
@property (nonatomic, strong) AVCaptureSession *captureSession_lightSetUp;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer_lightSetUp;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer_lightSetUp;
@property (nonatomic) BOOL isReading_lightSetUp;

@property (strong, nonatomic) IBOutlet UIView *viewLightSetUp_QRScanCode;
@property (strong, nonatomic) IBOutlet UIView *bodyView_QRScan_LightSetUp;

@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_device;
@property (strong, nonatomic) IBOutlet UIView *viewAlert_PlanUpgrade_Confirm_device;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PlanUpgrade_Charge_device;
@property (strong, nonatomic) IBOutlet UIButton *btn_Charge_device;

-(IBAction)lightSetUp_TapMenu_Action:(id)sender;
-(IBAction)lightSetUp_QR_ButtonAction:(id)sender;
-(IBAction)lightSetUp_DeviceInfo_ButtonAction:(id)sender;
-(IBAction)networkHome_Setting_LightOtherSetUp_Action:(id)sender;
-(IBAction)planUpgrade_Confirmation_Device_Action:(id)sender;
@end
