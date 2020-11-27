//
//  Utils.h
//  FormularyCard
//
//
//  Copyright (c) 2012 BusinessOne Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^dbCallbackWithDictionary)(NSMutableDictionary *);
typedef void(^dbCallbackWithArray)(NSMutableArray *);
typedef void(^dbCallbackWithSingleString)(NSString *);
typedef void(^dbCallbackWithFloat)(float, float);

typedef void(^formCallbackDictionary)(NSMutableDictionary *);
typedef void(^formCallbackDictionaries)(NSMutableDictionary *, NSMutableDictionary *);
typedef void(^formCallbackString)(NSString *);
typedef void(^formCallbackIntAndDict)(int, NSMutableDictionary *);

typedef void(^formCallbackVoid)(void);

typedef void(^callbackWithDictionary)(NSMutableDictionary *);
typedef void(^leftBarbuttonAction)(void);


#pragma mark - Backgroung Setup
#define bgGroundApp	[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1]
#define bgView	[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1]
#define txt	[UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1]


#pragma mark - Text Color Setting (Nyon Blue)
#define lblRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#pragma mark - Datas
//service paramaters
#define kTokenType @"kTokenType"

#define kFirstName @"kFirstName"
#define kLastName @"kLastName"
#define kEmailID @"kEmailID"
#define kEmailType @"kEmailType"
#define kPassword @"kPassword"
#define kDeviceToken @"kDeviceToken"
#define kControllerID @"kControllerID"
#define kDeviceName @"kDeviceName"
#define kDeviceTraceID @"kDeviceTraceID"
#define kDeviceID @"kDeviceID"
#define kDeviceMode @"kDeviceMode"
#define kDeviceStatus @"kDeviceStatus"
#define kDeviceImage @"kDeviceImage"
#define kAccountID @"kAccountID"
#define kBillingPlanID @"kBillingPlanID"
#define kNetworkID @"kNetworkID"
#define kTemperatureType @"kTemperatureType"
#define kInAppStatus @"kInAppStatus"
#define kLanguage @"kLanguage"
#define kLat @"kLat"
#define kLong @"kLong"
#define KTimeZone @"KTimeZone"
#define kCardType @"kCardType"
#define kCardName @"kCardName"
#define kCardNumber @"kCardNumber"
#define kCardExpiryMonth @"kCardExpiryMonth"
#define kCardExpiryYear @"kCardExpiryYear"
#define kCardCSCCode @"kCardCSCCode"
#define kCardZipCode @"kCardZipCode"
#define kCreditCardID @"kCreditCardID"
#define KThumbnailImage @"KThumbnailImage"
#define kActiveSchedule @"kActiveSchedule"
#define kBatteryPercent @"kBatteryPercent"
#define kDeviceType @"kDeviceType"
#define kJan @"kJan"
#define kFeb @"kFeb"
#define kMar @"kMar"
#define kApr @"kApr"
#define kMay @"kMay"
#define kJun @"kJun"
#define kJly @"kJly"
#define kAug @"kAug"
#define kSep @"kSep"
#define kOct @"kOct"
#define kNov @"kNov"
#define kDec @"kDec"
#define kSun @"kSun"
#define kMon @"kMon"
#define kTue @"kTue"
#define kWed @"kWed"
#define kThr @"kThr"
#define kFri @"kFri"
#define kSat @"kSat"
#define kSun @"kSun"
#define kOddDay @"kOddDay"
#define kEvenDay @"kEvenDay"
#define kStartTime @"kStartTime"
#define kEndTime @"kEndTime"
#define kScheduleCategoryID @"kScheduleCategoryID"
#define kScheduleMode @"kScheduleMode"
#define kActiveSchedule @"kActiveSchedule"
#define kBatteryPercent @"kBatteryPercent"
#define kSchedule @"kSchedule"
#define kScheduleMonthID @"kScheduleMonthID"
#define kScheduleCategoryDesc @"kScheduleCategoryDesc"
#define kScheduleID @"kScheduleID"
#define kScheduleCategoryCode @"kScheduleCategoryCode"
#define kScheduleTime @"kScheduleTime"
#define kScheduleCategory @"kScheduleCategory"
#define kScheduleDay @"kScheduleDay"
#define kScheduleSettingID @"kScheduleSettingID"
#define kScheduleMonth @"kScheduleMonth"
#define kScheduleDayID @"kScheduleDayID"
#define kScheduleTimeID @"kScheduleTimeID"
#define kSchMainID @"kSchMainID"
#define kaccesstype @"kaccesstype"
#define kaccesstypeID @"kaccesstypeID"
#define knetworkid @"knetworkid"
#define kAlertCount @"kAlertCount"
#define kMessageCount @"kMessageCount"
#define kControllerType @"kControllerType"
#define kControllerConnectedStatus @"kControllerConnectedStatus"
#define kControllerPaymentCard @"kControllerPaymentCard"
#define kControllerPaymentCompleted @"kControllerPaymentCompleted"
#define kNetworkOwner @"kNetworkOwner"
#define kMessageID @"kMessageID"
#define kMessageStatus @"kMessageStatus"
#define kMessageTime @"kMessageTime"
#define kMessageSub @"kMessageSub"
#define kMessageDesc @"kMessageDesc"
#define kMessageAction @"kMessageAction"
#define kZoneStatus @"kZoneStatus"
#define kZoneID @"kZoneID"
#define kZoneLevel @"kZoneLevel"
#define kZoneConfigStatus @"kZoneConfigStatus"
#define kZoneName @"kZoneName"
#define kZoneThumbnailImage @"kZoneThumbnailImage"
#define kZoneBatteryPercentage @"kZoneBatteryPercentage"
#define kZoneStatusID @"kZoneStatusID"
#define kZoneStatusCode @"kZoneStatusCode"
#define kZoneModeID @"kZoneModeID"
#define kZoneModeCode @"kZoneModeCode"
#define kZoneSchedule @"kZoneSchedule"
#define kZoneDuration @"kZoneDuration"
#define kRunEvery @"kRunEvery"
#define kScheduleZones @"kScheduleZones"
#define kYearFormat @"kYearFormat"
#define kOrgTimeZone @"kOrgTimeZone"
//
#define kAlertAccess @"Access Denied."
#define kAlertResetSuccessTitle @"Check Your Email"
#define kAlertResetFailureTitle @"Incorrect Email Address"
#define kAlertResetSuccessMessage @"We've sent instructions on how to reset your password.  If you don't see it in a few minutes, check your email's spam and junk filters"
#define kAlertResetFailureMessage @"There doesn't appear to be a Noid account with that email.  Please check it and try again."
#define kAlertEmailWarningTitle @"Incorrect Username or Password"
#define kAlertEmailWarningMessages @"Please check your username and/or password and try again."
#define kAlertTitleWarning @"Warning"
#define kAlertTitleSuccess @"NOID"
#define kAlertSuccess @"Success"
#define kAlertMessage @"kAlertMessage"
#define kAlertTime @"kAlertTime"
#define kAlertViewButton @"kAlertViewButton"
#define kAlertCardImage @"kAlertCardImage"
#define kAlertCardBGImage @"kAlertCardBGImage"
#define kControllerName @"kControllerName"
#define kControllerStation @"kControllerStation"
#define kBillingDate @"kBillingDate"
#define kBillingRate @"kBillingRate"
#define kAccountName @"kAccountName"
#define kAccountLastName @"kAccountLastName"
#define kAccountID @"kAccountID"
#define kAccountPermission @"kAccountPermission"
#define kAccountPermissionID @"kAccountPermissionID"
#define kscheduleName @"kscheduleName"
#define kNetworkName @"kNetworkName"
#define kNetWrokImage @"kNetWrokImage"
#define kNetworkDirection @"kNetworkDirection"
#define ACCEPTABLE_CHARACTERSPWD @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890!@#$%^&*()-_=+,.<>?`~"
//#define ACCEPTABLE_CHARACTERS_NAME @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'"
#define ACCEPTABLE_CHARACTERSNAME @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define ACCEPTABLE_CHARACTERSNumbers @"0123456789"
#define ACCEPTABLE_CHARACTERSZIPCODEBILLING @"0123456789"
#define ACCEPTABLE_CHARACTERS_DEVICEID @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_DEVICENAME @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' "
#define UnitfieldMonthLimit 2
#define UnitfieldYearLimit 4
#define UnitfieldDigitsLimit 4
#define UnitfieldDigitsPWd 20
#define UnitfieldNameLimit 30
#define zipcodeBillingLimit 5
#define visaCardLimit 16
#define masterCardLimit 16
#define americanCardLimit 15
#define discoverCardLimit 16
#define UnitfieldIDLimit 100

#define kquoteTypeId @"kquoteTypeId"
#define kdeviceTypeId @"kdeviceTypeId"
#define kprorationDateTime @"kprorationDateTime"
#define kpropertyMapImage @"kpropertyMapImage"
#define kcenterLat @"kcenterLat"
#define kcenterLong @"kcenterLong"
#define ktopLeftLat @"ktopLeftLat"
#define ktopLeftLong @"ktopLeftLong"
#define ktopRightLat @"ktopRightLat"
#define ktopRightLong @"ktopRightLong"
#define kbottomLeftLat @"kbottomLeftLat"
#define kbottomLeftLong @"kbottomLeftLong"
#define kbottomRightLat @"kbottomRightLat"
#define kbottomRightLong @"kbottomRightLong"
#define kzoomLevel @"kzoomLevel"




//
//API
//#define getNoidAppUrl [NSString stringWithFormat:@"http://ec2-54-210-247-60.compute-1.amazonaws.com:8080"]
#define getNoidAppUrl [NSString stringWithFormat:@"https://services.noidtechservicesdev.com"]
//#define getNoidAppUrl [NSString stringWithFormat:@"http://52.11.3.82:8080"]
//#define getNoidAppUrl [NSString stringWithFormat:@"http://54.84.141.26:8080"]
#define getNoidAppUrlQA [NSString stringWithFormat:@"https://services.noidtechservicesqa.com"]
#define getNoidAppUrlProd [NSString stringWithFormat:@"https://services.noidtechservices.com"]

//METHOD NAME FOR API

#define Registration_Method_Name [NSString stringWithFormat:@"/accounts"]
#define SignIn_Method_Name [NSString stringWithFormat:@"/login"]
#define ControllerAvailabilit_Method_Name [NSString stringWithFormat:@"/controllerTrace?traceCode="]
#define Add_NewController_Device_Details [NSString stringWithFormat:@"/network/add"]
#define Get_All_Controller_Networks [NSString stringWithFormat:@"/network/get/"]
#define Get_User_Settings_Basic_Details [NSString stringWithFormat:@"/accounts?accountId="]
#define Add_Controller [NSString stringWithFormat:@"/controller/add"]
#define Update_Controller_Device_Details [NSString stringWithFormat:@"/network/update"]
#define Lights_Others_Availabilit_Method_Name [NSString stringWithFormat:@"/deviceTrace?traceCode="]
#define Update_UserSettings [NSString stringWithFormat:@"/accounts"]
#define TC_Method_Name [NSString stringWithFormat:@"/terms_conditions"]

