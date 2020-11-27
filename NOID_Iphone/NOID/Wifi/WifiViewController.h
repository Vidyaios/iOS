//
//  WifiViewController.h
//  NOID
//
//  Created by iExemplar on 18/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
@interface WifiViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL wifi_setUp_ExpandedStatus,wifi_info_ExpandedStatus,defaultWifi_ExpandStatus,availableNetwork_ExpandStatus,cellExpandStatus,wifi_QR_ExpandedStatus;
    UIView *viewProceed,*viewCancel;
    CGRect frame_Org_Size_Controller_Wifi_List;
    float yOffSet_Content;
    NSInteger viewTagValue;
    AppDelegate *appDelegate;
    BOOL imageStatus;
    NSUserDefaults *defaults_Wifi;
    NSString *strEncoded_ControllerImage,*strResponseError,*str_Selected_Tap,*str_Previous_Tap,*strNetwork_Added_Status,*str_Added_ControllerID;
    NSDictionary *responseDict,*networkData_Dict;
}
@property (nonatomic, strong) NSString *strWifiAccessType;
@property (nonatomic, strong) IBOutlet UILabel *lblWifi_Header;
@property (nonatomic, strong) IBOutlet UILabel *lblWifi_Welcome;
@property (strong, nonatomic) IBOutlet UIView *viewWifi_Header;
@property (strong, nonatomic) IBOutlet UIView *viewWifi_Body;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewWifi;
@property (strong, nonatomic) NSString *str_MultipleNetwork_Mode;
//QRView
@property (strong, nonatomic) IBOutlet UIView *viewWifi_QR;
@property (strong, nonatomic) IBOutlet UIView *viewWifi_QR_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewWifi_QR_BodyContent;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceId_Wifi;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_QR_Wifi;

//ControllerSetUpView
@property (strong, nonatomic) IBOutlet UILabel *lblControllerIndex;
@property (strong, nonatomic) IBOutlet UIView *viewSetUp;
@property (strong, nonatomic) IBOutlet UIView *viewSetUp_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewSetUp_BodyContent;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_SetUp_Wifi;
@property (strong, nonatomic) IBOutlet UIView *viewSetUp_defaultWifi;
@property (strong, nonatomic) IBOutlet UIView *viewSetup_AvailableNetwork;
@property (strong, nonatomic) UIScrollView *scrollView_AvailableNetwork;
@property (strong, nonatomic) NSMutableArray *arrAvailableNetworks;
@property (strong, nonatomic) IBOutlet UIView *viewSetUp_ConnectToInternet;
@property (strong, nonatomic) IBOutlet UIView *view_Confirm_popUp;
@property (strong, nonatomic) IBOutlet UIView *view_success_popUp;
@property (strong, nonatomic) IBOutlet UIView *viewSetupDevice;
@property (strong, nonatomic) IBOutlet UIView *viewSkipDevice;
//ControllerinfoView
@property (strong, nonatomic) IBOutlet UILabel *lbl_deviceImgName_WifiController;
@property (strong, nonatomic) IBOutlet UILabel *lblViewIndex;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;
@property (strong, nonatomic) IBOutlet UIView *viewInfo_HeaderContent;
@property (strong, nonatomic) IBOutlet UIView *viewInfo_BodyContent;
@property (strong, nonatomic) IBOutlet UILabel *lblEdit_Info_Wifi;
@property (strong, nonatomic) IBOutlet UIView *viewInfo_ImageGallery;
@property (strong, nonatomic) IBOutlet UIView *viewInfo_ImageEdit;
@property (strong, nonatomic) IBOutlet UIView *viewInfo_ProceedView;
@property (strong, nonatomic) IBOutlet UIView *viewInfo_CancelView;
@property (strong, nonatomic) IBOutlet UITextField *txtfld_DeviceName_Wifi;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_Info;
@property (strong, nonatomic) IBOutlet UIView *view_deviceSetUp_Alert;
@property (strong, nonatomic) NSString *strPreviousView;
@property (strong, nonatomic) NSString *strControllerStatus;
//new
@property (strong, nonatomic) NSString *strController_TraceID;
@property (strong, nonatomic) IBOutlet UIView *deleteNetworkView_Wifi;
@property (strong, nonatomic) IBOutlet UIView *popUpDeleteView_Wifi;

@property (strong, nonatomic) IBOutlet UILabel *lbl_DefaultWifi;

-(IBAction)wifi_QR_ButtonAction:(id)sender;
-(IBAction)wifi_setUp_ButtonAction:(id)sender;
-(IBAction)wifi_TapMenu_Action:(id)sender;
-(IBAction)InfoSetup_Button_Action:(id)sender;
-(IBAction)networkHome_Setting_Wifi_Action:(id)sender;
-(IBAction)deleteNetwork_Wifi_Action:(id)sender;

@end
