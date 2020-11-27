//
//  AppDelegate.h
//  NOID
//
//  Created by iExemplar on 22/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

@class CellularViewController;
@class MultipleNetworkViewController;
@class ControllerSetUpViewController;
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    UIImageView *imageViewSplash;
     MPMoviePlayerController *moviePlayer;
    NSUserDefaults *defaultsAppDelegate;
    NSDictionary *responseDict;
    NSString *strResponseError,*strNetworkId,*strPushAlertCount,*strPushAlertCountPWD,*strPushReadType;
    AVAudioPlayer *audioPlayer;
    MBProgressHUD *hudToast;
    NSString *deviceToken,*strTimeZoneIDFor_User;
}

@property (strong, nonatomic) UIWindow *window;

/* **********************************************************************************
 Variable Name : strInitialView
 Description : The Purpose of this varialbe is check the page navigation is happen via Registeration OR Signin
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strInitialView;
/* **********************************************************************************
 Variable Name : strController_Setup_Mode
 Description : The Purpose of this varialbe is check the controller setup navigation is happen via Registeration,Signin,
 applaunch OR Multiple Netwrok OR Drawer(Network Home)
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strController_Setup_Mode;

/* **********************************************************************************
 Variable Name : strNetworkAddedStatus
 Description : The Purpose of this varialbe is check the controller setup navigation is happen via Multiplenetwork at the same time user is addding
 network
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strNetworkAddedStatus;


/* **********************************************************************************
 Variable Name : strDevice_Added_Mode
 Description : The Purpose of this varialbe is check the device added  navigation is happen via Multiplenetwork / Network home / Reqsining
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strDevice_Added_Mode;

/* **********************************************************************************
 Variable Name : strDevice_Added_Status
 Description : The Purpose of this varialbe is check the device added  is happen via Multiplenetwork / Network home / Reqsining
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strDevice_Added_Status;

/* **********************************************************************************
 Variable Name : strEdit_Controller_DeviceStatus;
 Description : The Purpose of this varialbe is edit the controller via MultiPleNetwork
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strEdit_Controller_DeviceStatus;

/* **********************************************************************************
 Variable Name : strController_IDApp;
 Description : The Purpose of this varialbe is added controller id
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strController_IDApp;

/* **********************************************************************************
 Variable Name : strAddedDevice_Type;
 Description : The Purpose of this varialbe is which device is added
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strAddedDevice_Type;

/* **********************************************************************************
 Variable Name : strAddedDevice_Type;
 Description : The Purpose of this varialbe is check the device added  navigation is happen via MultiplenetworkDrawer / Network home / Reqsining
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strNetworkDrawer_Status;

/* **********************************************************************************
 Variable Name : strChangeDrawerData;
 Description : The Purpose of this varialbe is select network from drawer
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strChangeDrawerData;

/* **********************************************************************************
 Variable Name : strDevieDeleted_Status;
 Description : The Purpose of this varialbe is delete device in details page sttaus
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strDevieDeleted_Status;

/* **********************************************************************************
 Variable Name : strDeviceUpdated_Status;
 Description : The Purpose of this varialbe is update device in details page sttaus
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strDeviceUpdated_Status;

/* **********************************************************************************
 Variable Name : strUpdated_Device_Name;
 Description : The Purpose of this varialbe is update device name
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strUpdated_Device_Name;

/* **********************************************************************************
 Variable Name : strUpdated_Device_Image;
 Description : The Purpose of this varialbe is update device image
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strUpdated_Device_Image;

/* **********************************************************************************
 Variable Name : strWeatherChanged;
 Description : The Purpose of this varialbe is update weather type in settings
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strWeatherChanged;

/* **********************************************************************************
 Variable Name : strScheduleWay;
 Description : The Purpose of this varialbe is add schedule via trace or exisitng
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strScheduleWay;


/* **********************************************************************************
 Variable Name : strDeleteScheduleCount;
 Description : The Purpose of this varialbe is deletesch count
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strDeleteScheduleCount;

/* **********************************************************************************
 Variable Name : strAddNewSchedule;
 Description : The Purpose of this varialbe is addnes sch
 ************************************************************************************* */
@property (strong, nonatomic) NSString *strAddNewSchedule;

/* *********************************************************************************
 Variable Name : strSettingAction;
 Description : The Purpose of this varialbe is user can delte cellular in settings
 section via M/P Network or anyother Screen
 ************************************************************************************ */
@property (strong, nonatomic) NSString *strSettingAction;

/* *********************************************************************************
 Variable Name : strSettingAction;
 Description : The Purpose of this varialbe is user can tapped NOID Logo via M/p Network or network home
 or any other sections
 ************************************************************************************ */
@property (strong, nonatomic) NSString *strNoidLogo;

/* *********************************************************************************
 Variable Name : strSettingAction;
 Description : The Purpose of this varialbe is user can tapped NOID Logo via M/p Network or network home
 or any other sections
 ************************************************************************************ */
@property (strong, nonatomic) NSString *strNew_NotiReceived;

/* *********************************************************************************
 Variable Name : strOwnerNetwork_Status;
 Description : The Purpose of this varialbe is user travel the app across their own network or others network
 ************************************************************************************ */
@property (strong, nonatomic) NSString *strOwnerNetwork_Status;

/* ********************************************************************************
Variable Name : strNetworkPermission;
Description : The Purpose of this varialbe is user add and edit their own nw or shared ne
*********************************************************************************** */
@property (strong, nonatomic) NSString *strNetworkPermission;

/* ********************************************************************************
Variable Name : strScheduleAddedStatus;
Description : The Purpose of this varialbe is user add new schedule or not
*********************************************************************************** */
@property (strong, nonatomic) NSString *strScheduleAddedStatus;

/* ********************************************************************************
Variable Name : strPaymentActive;
Description : The Purpose of this varialbe is user add payments details during the edit mode
*********************************************************************************** */
@property (strong, nonatomic) NSString *strPaymentActive;

@property (strong, nonatomic) NSString *strInviteeID;

@property(strong,nonatomic) NSString *strAlertDeviceCount;

@property (strong, nonatomic) NSMutableDictionary *dict_OverlayCoord;

@property (strong, nonatomic) UIImage *imageNameOverLay;

@property (strong, nonatomic) NSString *strMoveDeviceStatus;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MultipleNetworkViewController *multipleVC;
@property (strong, nonatomic) SWRevealViewController *swrevealVC;
@property (strong, nonatomic) ControllerSetUpViewController *controllerVC;
@property (strong, nonatomic) CellularViewController *cellularVC;

@property (strong, nonatomic) NSString *strNoid_BackStatus;
@property(strong,nonatomic) NSString *flagMap;

@property (strong, nonatomic) NSDictionary *dicit_NetworkDatas;
@property (strong, nonatomic) NSMutableDictionary *dict_NetworkControllerDatas;

@property (strong, nonatomic) UINavigationController *navigtionController;

@property (strong, nonatomic) NSData *devicetoken_nsdatta;

@property (strong, nonatomic) NSString *strProp_DeviceID;
@property (strong, nonatomic) NSString *strProp_DeviceType;
@property (strong, nonatomic) NSString *strLaunchOrientation;
@property (strong, nonatomic) NSString *strTimeLineStatus;
@property (strong, nonatomic) NSString *strTimeZoneChanged_Status;

@property (strong, nonatomic) NSString *strHubId;
@property (strong, nonatomic) NSString *strControllerSetUp_Header;

-(void)navigateDetailPage;
@end

