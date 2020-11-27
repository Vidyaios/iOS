//
//  AppDelegate.m
//  NOID
//
//  Created by iExemplar on 22/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Common.h"
#import "UIControl+SoundForControlEvents.h"
#import "MultipleNetworkViewController.h"
#import "ControllerSetUpViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"
#import "ServiceConnectorModel.h"
#import "CellularViewController.h"
#import "MBProgressHUD.h"
#import "DeviceSetUpViewController.h"

#define kButtonIndex 1000
@interface AppDelegate ()
{
    UIAlertView *alertViewPush[kButtonIndex];
    UIAlertView *alertViewPushPWD[kButtonIndex];
}
@end

@implementation AppDelegate
@synthesize viewController,strNoid_BackStatus,flagMap,strInitialView,multipleVC,controllerVC;
@synthesize swrevealVC,strController_Setup_Mode,strNetworkAddedStatus,dicit_NetworkDatas,strDevice_Added_Mode,strDevice_Added_Status;
@synthesize strController_IDApp,strAddedDevice_Type,strEdit_Controller_DeviceStatus,strNetworkDrawer_Status,strScheduleWay,strWeatherChanged,strDeleteScheduleCount,strAddNewSchedule,devicetoken_nsdatta,dict_NetworkControllerDatas,cellularVC,strNew_NotiReceived,strSettingAction,strNoidLogo,strOwnerNetwork_Status,strNetworkPermission,strScheduleAddedStatus,strInviteeID,strPaymentActive,strAlertDeviceCount,dict_OverlayCoord,imageNameOverLay,strMoveDeviceStatus,strProp_DeviceID,strProp_DeviceType,strLaunchOrientation,strTimeLineStatus,strTimeZoneChanged_Status,strHubId,strControllerSetUp_Header;

/* **********************************************************************************
 Date : 22/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title : Application States
 Description : when user launch the app control is transferred to main function after that
 main function create app thread. once therad was created app is flows is comes to
 application states.In this delegate method is used to configure home screen with navigation.
 Method Name : didFinishLaunchingWithOptions(AppDelegate delgate methods)
 ************************************************************************************* */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    strTimeLineStatus=@"";
    strLaunchOrientation=@"YES";
    strOwnerNetwork_Status=@"YES";
    strPushReadType=@"";
    strDevice_Added_Mode=@"";
    strSettingAction=@"";
    strNoidLogo=@"";
    strPaymentActive=@"";
    strInviteeID=@"0";
    strPushAlertCount=@"0";
    strPushAlertCountPWD=@"0";
    NSLog(@"wifi name==%@",[Common fetchSSIDInfo]);
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
//     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.window setFrame:[[UIScreen mainScreen] bounds]];
    

    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
     imageViewSplash = [[UIImageView alloc]initWithFrame:self.window.bounds];
    [self addSoundForUIControls];
    imageViewSplash.image = [UIImage imageNamed:@"LaunchImagePos1"];
    [self.window  addSubview:imageViewSplash];
    self.window.layer.speed = 2.0f;
//    [self testTemp];
    defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
    if (![[defaultsAppDelegate objectForKey:@"APPFIRSTTIME"] isEqualToString:@"YES"]){
        [defaultsAppDelegate setObject:@"YES" forKey:@"APPFIRSTTIME"];
        [defaultsAppDelegate setObject:@"" forKey:@"ACTIVENETWORKID"];
     //   [defaultsAppDelegate setObject:[NSString stringWithFormat:@"%@",getNoidAppUrlProd] forKey:@"NOIDURL"];
       [defaultsAppDelegate setObject:[NSString stringWithFormat:@"%@",getNoidAppUrl] forKey:@"NOIDURL"];
        [defaultsAppDelegate setObject:@"600" forKey:@"FOOTVIEW"];
        [defaultsAppDelegate synchronize];
    }
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"ios 8 push setup");
    }else{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"ios 7 push setup");
    }
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = userInfo;//[userInfo objectForKey:@"aps"];
    
    if(apsInfo!=nil){
        strPushReadType=@"AppLaunch";
        NSLog(@"super fast launch");
        NSLog(@"push type launch ==%@",strPushReadType);
        //[self handling_PushNotification_Details:apsInfo];
    }
  //  NSLog(@"device id==%@",[Common GetDeviceID]);
    

    [self performSelector:@selector(removeFirstSplash) withObject:imageViewSplash afterDelay:1];
    return YES;
}

- (void)addSoundForUIControls {
    NSString *soundAFilePath = [NSBundle.mainBundle pathForResource:@"tap-kissy" ofType:@"aif"];
    [[UIButton appearance] addSoundWithContentsOfFile:soundAFilePath forControlEvents:UIControlEventTouchUpInside];
    
    NSString *soundBFilePath = [NSBundle.mainBundle pathForResource:@"tap-fuzzy" ofType:@"aif"];
    [[UISegmentedControl appearance] addSoundWithContentsOfFile:soundBFilePath forControlEvents:UIControlEventValueChanged];
    
    NSString *soundCFilePath = [NSBundle.mainBundle pathForResource:@"slide-rock" ofType:@"aif"];
    [[UISwitch appearance] addSoundWithContentsOfFile:soundCFilePath forControlEvents:UIControlEventValueChanged];
    
    [[UITextField appearance] addSoundWithContentsOfFile:soundAFilePath forControlEvents:UIControlEventEditingChanged];
}

-(void)removeFirstSplash
{
    imageViewSplash.image = [UIImage imageNamed:@"LaunchImagePos2"];
    [self performSelector:@selector(removeSecondSplash) withObject:imageViewSplash afterDelay:1];
}
-(void)removeSecondSplash
{
   imageViewSplash.image = [UIImage imageNamed:@"LaunchImagePos3"];
   [self performSelector:@selector(removeThirdSplash) withObject:imageViewSplash afterDelay:1];
}

-(void)removeThirdSplash
{
    imageViewSplash.image = [UIImage imageNamed:@"LaunchImagePos4"];
    [self performSelector:@selector(removeFourthSplash) withObject:imageViewSplash afterDelay:1];
}
-(void)removeFourthSplash
{
    imageViewSplash.image = [UIImage imageNamed:@"LaunchImagePos5"];
    if([strPushReadType isEqualToString:@"AppLaunch"])
    {
        defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
        if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
        {
            [self sigountConfirmAlert];
            return;
        }
        else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
        {
            [self sigountConfirmAlertPassword];
            return;
        }
        //need to chk singin or not
        [self performSelector:@selector(removeSplashNavigateMP) withObject:imageViewSplash afterDelay:1];
    }else{
        [self performSelector:@selector(removeFifthSplash) withObject:imageViewSplash afterDelay:1];
    }
}

-(void)autoLogin
{
    [self start_PinWheel_AutoLogin];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
    NSLog(@"account id==%@",[defaultsAppDelegate objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaultsAppDelegate objectForKey:@"ACCOUNTID"],strNetworkId];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Get network details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAutoLogin) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for network details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorAutoLogin) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
    
}
-(void)responseErrorAutoLogin
{
    [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@, Please Login Again!",strResponseError]];
    
    if ([[Common deviceType] isEqualToString:@"iPhone5"]){
        viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
        viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    }else{
        viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    }
    self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
    self.window.rootViewController = self.navigtionController;
    [self.navigtionController.navigationBar setHidden:YES];
    [self.navigtionController setNavigationBarHidden:YES];
    [imageViewSplash removeFromSuperview];
    self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
    [self.window makeKeyAndVisible];
}
-(void)responseAutoLogin
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrNetwork_Data=[[NSMutableArray alloc] init];
            arrNetwork_Data=[[responseDict objectForKey:@"data"] objectForKey:@"networkDetails"];
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            NSLog(@"array count ==%lu",(unsigned long)arrNetwork_Data.count);
            if([arrNetwork_Data count]>0)
            {
                [self naviagte_NetworkHome_MultipleNetworkAutoLogin:[arrNetwork_Data objectAtIndex:0]];
            }else{
                [self stop_PinWheel_AutoLogin];
                [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed,Please Login Again!"]];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                    viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                }else{
                    viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                }
                self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
                self.window.rootViewController = self.navigtionController;
                [self.navigtionController.navigationBar setHidden:YES];
                [self.navigtionController setNavigationBarHidden:YES];
                [imageViewSplash removeFromSuperview];
                self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                [self.window makeKeyAndVisible];
            }
        }else{
            [self stop_PinWheel_AutoLogin];
            //[Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@,Please Login Again!",responseMessage]];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }else{
                viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }
            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
            self.window.rootViewController = self.navigtionController;
            [self.navigtionController.navigationBar setHidden:YES];
            [self.navigtionController setNavigationBarHidden:YES];
            [imageViewSplash removeFromSuperview];
            self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
            [self.window makeKeyAndVisible];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_AutoLogin];
        [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@,Please Login Again!",[exception description]]];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else{
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }
        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
    }
}
-(void)naviagte_NetworkHome_MultipleNetworkAutoLogin:(NSDictionary *)dictNetworkDetails
{
    NSLog(@"%@",dictNetworkDetails);
    self.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
    [self.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"alert"] forKey:kAlertCount];
    [self.dict_NetworkControllerDatas setObject:[[dictNetworkDetails valueForKey:@"id"] stringValue] forKey:kNetworkID];
    [self.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"message"] forKey:kMessageCount];
    [self.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"latitude"] forKey:kLat];
    [self.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"longitude"] forKey:kLong];
    [self.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"name"] forKey:kNetworkName];
    [self.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
    NSLog(@"network details==%@",self.dict_NetworkControllerDatas);
    [defaultsAppDelegate setObject:[dictNetworkDetails valueForKey:@"id"] forKey:@"NETWORKID"];
    [defaultsAppDelegate synchronize];
    NSDictionary *dictNetworkStatus=[dictNetworkDetails valueForKey:@"networkStatus"];
    NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
    if(arrController.count>0)
    {
        
        NSDictionary *dictController=[arrController objectAtIndex:0];
        NSLog(@"controller id ==%@",[dictController valueForKey:@"id"]);
        NSDictionary *dictControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
        NSLog(@"controllerConnectivityType is ==%@",dictControllerTrace);
        [self.dict_NetworkControllerDatas setObject:[dictControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
        [self.dict_NetworkControllerDatas setObject:[[dictController valueForKey:@"id"] stringValue] forKey:kControllerID];
        NSLog(@"controller type%@",[dictControllerTrace valueForKey:@"typeCode"]);
        NSLog(@"network details==%@",self.dict_NetworkControllerDatas);
        NSLog(@"controller Trace ID ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"]);
        [defaultsAppDelegate setObject:self.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
        [defaultsAppDelegate synchronize];
        if ([[dictControllerTrace valueForKey:@"typeCode"] isEqualToString:@"WIFI"]) {
            [self stop_PinWheel_AutoLogin];
            
            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                swrevealVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                swrevealVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            }else{
                swrevealVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            }
            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:swrevealVC];
        }else{
            if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue] && [[dictNetworkStatus valueForKey:@"hasPaymentRenewed"] boolValue])
            {
                [self stop_PinWheel_AutoLogin];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                    swrevealVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                    swrevealVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                }else{
                    swrevealVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                }
                self.navigtionController=[[UINavigationController alloc]initWithRootViewController:swrevealVC];
            }
            else if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue] && ![[dictNetworkStatus valueForKey:@"hasPaymentRenewed"] boolValue])
            {
                [self stop_PinWheel_AutoLogin];
                strInitialView=@"SignIn";
                if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                    multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                    multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                }else{
                    multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                }
                self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
            }
            else{
                NSLog(@"billing plan ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"]);
                strController_Setup_Mode = @"NetworkHomeDrawer";
                if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                    cellularVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CellularViewController"];
                }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                    cellularVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"CellularViewController"];
                }else{
                    cellularVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"CellularViewController"];
                }

                NSDictionary *dictPlan=[[NSUserDefaults standardUserDefaults] objectForKey:@"CONTROLLERPLANDATA"];
                NSLog(@"plan==%@",dictPlan);
                cellularVC.str_MultipleNetwork_Mode=@"edit";
                NSMutableDictionary *dictPaymentDict=[[NSMutableDictionary alloc] init];
                if([[dictNetworkStatus valueForKey:@"hasControllerConnected"] boolValue])
                {
                    cellularVC.strController_ConnectedSTS=@"YES";
                    [dictPaymentDict setObject:@"YES" forKey:kControllerConnectedStatus];
                }
                else{
                    cellularVC.strController_ConnectedSTS=@"NO";
                    [dictPaymentDict setObject:@"NO" forKey:kControllerConnectedStatus];
                }
                if([[dictNetworkStatus valueForKey:@"hasPaymentCard"] boolValue])
                {
                    cellularVC.strController_PaymentCardSTS=@"YES";
                    [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCard];
                }
                else{
                    cellularVC.strController_PaymentCardSTS=@"NO";
                    [dictPaymentDict setObject:@"NO" forKey:kControllerPaymentCard];
                }
                if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue])
                {
                    cellularVC.strController_PaymentCompletedSTS=@"YES";
                    [dictPaymentDict setObject:@"YES" forKey:kControllerPaymentCompleted];
                }
                else{
                    cellularVC.strController_PaymentCompletedSTS=@"NO";
                    [dictPaymentDict setObject:@"NO" forKey:kControllerPaymentCompleted];
                }
                cellularVC.dictController_BasicPlan=[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"];
                cellularVC.strController_TraceID=[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue];
                cellularVC.strTimeZoneIDFor_User=strTimeZoneIDFor_User;
                cellularVC.strCellularAccessType=@"0";
                [self stop_PinWheel_AutoLogin];
                self.navigtionController=[[UINavigationController alloc]initWithRootViewController:cellularVC];
                
            }
        }
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
    }
    else{
        [self stop_PinWheel_AutoLogin];
        [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@, Please Login Again!",strResponseError]];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else{
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }
        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
    }
}


-(void)removeSplashNavigateMP
{
    defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
    [defaultsAppDelegate setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
    [defaultsAppDelegate synchronize];
    
    strPushReadType=@"";
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"APPREMEMBERMESTATUS"] isEqualToString:@"YES"]){
        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else{
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }
        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
    }else{
        self.strInitialView=@"SignIn";
        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
            multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
            multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        }else{
            multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        }
        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
    }
}

-(void)removeFifthSplash
{
    defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
    [defaultsAppDelegate setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
    [defaultsAppDelegate synchronize];
    
    if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
    {
        [self sigountConfirmAlert];
        return;
    }
    else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
    {
        [self sigountConfirmAlertPassword];
        return;
    }
    [defaultsAppDelegate synchronize];
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"APPREMEMBERMESTATUS"] isEqualToString:@"YES"]){
        strLaunchOrientation=@"";
        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else{
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }
        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
        
    }else{
      /*  int countNetwork=[[defaultsAppDelegate objectForKey:@"NETWORKCOUNT"] intValue];
        NSLog(@"network count ==%d",countNetwork);
        if(countNetwork==0){
            self.strInitialView=@"RegisterUser";
            self.strController_Setup_Mode=@"AppLaunch";
            
            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                controllerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                controllerVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            }else{
                controllerVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            }

            controllerVC.str_Cellular_FirstStatus=@"ControllerFirstTime";
            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:controllerVC];
            self.window.rootViewController = self.navigtionController;
            [self.navigtionController.navigationBar setHidden:YES];
            [self.navigtionController setNavigationBarHidden:YES];
            [imageViewSplash removeFromSuperview];
            self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
            [self.window makeKeyAndVisible];
            
        }else if(countNetwork==1)
        {
            self.strInitialView=@"SignIn";
            self.strController_Setup_Mode=@"AppLaunch";
            [self autoLogin];
        }
        else{
            self.strInitialView=@"SignIn";
            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
            }else{
                multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
            }
            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
            self.window.rootViewController = self.navigtionController;
            [self.navigtionController.navigationBar setHidden:YES];
            [self.navigtionController setNavigationBarHidden:YES];
            [imageViewSplash removeFromSuperview];
            self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
            [self.window makeKeyAndVisible];
            
        } */
        
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(autoSignInService) withObject:self];
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }

    }
}

-(void)autoSignInService
{
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictSignInDetails=[[NSMutableDictionary alloc] init];
    defaultsAppDelegate = [NSUserDefaults standardUserDefaults];
    
    [dictSignInDetails setObject:[defaultsAppDelegate objectForKey:@"MAILID"] forKey:kEmailID];
    [dictSignInDetails setObject:[defaultsAppDelegate objectForKey:@"PASSWORD"] forKey:kPassword];
    if(devicetoken_nsdatta==nil){
        deviceToken=@"CDF1c7bf338c5e9bab2ad2fca45ada646d600061c28cf79c90a";
    }else{
        deviceToken=[NSString stringWithFormat:@"%@",devicetoken_nsdatta];
        deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    [dictSignInDetails setObject:deviceToken forKey:kDeviceToken];
    [dictSignInDetails setObject:@"1" forKey:kTokenType];
    parameters=[SCM signinList:dictSignInDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for auto SignIn NOID User==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAutoSignIn) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for auto SignIn NOID User==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorAutoLogin) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:SignIn_Method_Name];
}

-(void)responseAutoSignIn
{
    NSLog(@"%@",responseDict);
    @try {
        defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            if([dicitData count]>0){
                NSLog(@"DICT User Data ==%@",dicitData);
                NSLog(@"DIC User Data ==%lu",(unsigned long)dicitData.count);
                NSLog(@"account id ==%@",[dicitData valueForKey:@"accountId"]);
                NSLog(@"emailId id ==%@",[dicitData valueForKey:@"emailId"]);
                NSLog(@"firstName ==%@",[dicitData valueForKey:@"firstName"]);
                
                NSArray *networkList = [dicitData valueForKey:@"networkList"];
                NSLog(@"%@",networkList);
                NSUInteger count=[networkList count];
                NSLog(@"netwrok count ==%lu",(unsigned long)count);
                [self stop_PinWheel_AutoLogin];
                
                if(count==0)  //if its Zero Go TO Controller Setup Screen
                {
                    strInitialView=@"RegisterUser";
                    strController_Setup_Mode=@"AppLaunch";
                    //                    appDelegate.strNoidLogo=@"";
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                        controllerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
                    }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                        controllerVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
                    }else{
                        controllerVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
                    }
                    controllerVC.str_Cellular_FirstStatus=@"ControllerFirstTime";
                    self.navigtionController=[[UINavigationController alloc]initWithRootViewController:controllerVC];
                    self.window.rootViewController = self.navigtionController;
                    [self.navigtionController.navigationBar setHidden:YES];
                    [self.navigtionController setNavigationBarHidden:YES];
                    [imageViewSplash removeFromSuperview];
                    self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                    [self.window makeKeyAndVisible];
                }
                else if(count==1) //if its 1 means go to Network Home
                {
                    strInitialView=@"SignIn";
                    strController_Setup_Mode=@"AppLaunch";
                    strNetworkId = [[[networkList objectAtIndex:0] valueForKey:@"networkId"] stringValue];
                    NSLog(@"%@",strNetworkId);
                    NSString *strNetworkStatus = [[[networkList objectAtIndex:0] valueForKey:@"networkStatus"] stringValue];
                    NSLog(@"%@",strNetworkStatus);
                    NSLog(@"Permission =%@",[[[networkList objectAtIndex:0] valueForKey:@"accessTypeId"] stringValue]);

                    if ([strNetworkStatus isEqualToString:@"0"] || [strNetworkStatus isEqualToString:@"2"]) {
                        if([Common reachabilityChanged]==YES){
                            self.strNetworkPermission=[[[networkList objectAtIndex:0] valueForKey:@"accessTypeId"] stringValue];
                            if(![strNetworkStatus isEqualToString:@"0"])
                            {
                                self.strOwnerNetwork_Status=@"NO";
                            }else{
                                self.strOwnerNetwork_Status=@"YES";
                            }

                            [self performSelectorOnMainThread:@selector(start_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(autoLogin) withObject:self];
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                    }else{
                        strInitialView=@"SignIn";
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                            multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                            multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        }else{
                            multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        }
                        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
                        self.window.rootViewController = self.navigtionController;
                        [self.navigtionController.navigationBar setHidden:YES];
                        [self.navigtionController setNavigationBarHidden:YES];
                        [imageViewSplash removeFromSuperview];
                        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                        [self.window makeKeyAndVisible];
                    }
                }
                else //if its more than 1 means go to Multiple network
                {
                    strInitialView=@"SignIn";
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                        multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                    }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                        multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                    }else{
                        multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                    }
                    self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
                    self.window.rootViewController = self.navigtionController;
                    [self.navigtionController.navigationBar setHidden:YES];
                    [self.navigtionController setNavigationBarHidden:YES];
                    [imageViewSplash removeFromSuperview];
                    self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                    [self.window makeKeyAndVisible];
                }

            }else{
                [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@,Please Login Again!",responseMessage]];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                    viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                }else{
                    viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
                }
                self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
                self.window.rootViewController = self.navigtionController;
                [self.navigtionController.navigationBar setHidden:YES];
                [self.navigtionController setNavigationBarHidden:YES];
                [imageViewSplash removeFromSuperview];
                self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                [self.window makeKeyAndVisible];
            }
        }else{
            [self stop_PinWheel_AutoLogin];
            if([responseMessage isEqualToString:@"This Email-Id is not registered."])
            {
//                defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
//                [defaultsAppDelegate setObject:@"UNAMECHANGED" forKey:@"YES"];
//                [defaultsAppDelegate synchronize];
//                [self sigountConfirmAlert];
                UIAlertView *aVEmail = [[UIAlertView alloc] initWithTitle:@"NOID"
                                                                  message:@"Email Id is changed. You will be automatically signed out. Please login again with new credentials."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [aVEmail setTag:3];
                [aVEmail show];
                return;
            }
            else if([responseMessage isEqualToString:@"Invalid Credentials."])
            {
//                defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
//                [defaultsAppDelegate setObject:@"PWDCHANGED" forKey:@"YES"];
//                [defaultsAppDelegate synchronize];
//                [self sigountConfirmAlertPassword];
                UIAlertView *aVEmail = [[UIAlertView alloc] initWithTitle:@"NOID"
                                                                  message:@"Password is changed. You will be automatically signed out. Please login again with new credentials."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [aVEmail setTag:3];
                [aVEmail show];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@,Please Login Again!",responseMessage]];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }else{
                viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }
            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
            self.window.rootViewController = self.navigtionController;
            [self.navigtionController.navigationBar setHidden:YES];
            [self.navigtionController setNavigationBarHidden:YES];
            [imageViewSplash removeFromSuperview];
            self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
            [self.window makeKeyAndVisible];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_AutoLogin];
        [Common showAlert:kAlertTitleWarning withMessage:[NSString stringWithFormat:@"AutoLogin Failed %@,Please Login Again!",[exception description]]];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }else{
            viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }
        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = self.navigtionController;
        [self.navigtionController.navigationBar setHidden:YES];
        [self.navigtionController setNavigationBarHidden:YES];
        [imageViewSplash removeFromSuperview];
        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
        [self.window makeKeyAndVisible];
    }
}

-(void)testTemp
{
    
    //COuntry
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"%@",countryCode);
    
    //Lanuage
    //    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    //    NSLog(@"My deviceOS language is: %@", locale);
    //    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    NSLog(@"My deviceOS language is: %@", language);
    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *lang = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:langID];
    NSLog(@"My deviceOS language is: %@", lang);
    
    //Device Wifi Status
    //  NSLog(@"Device Wifi ==%@",[Common fetchSSIDInfo]);
    
    //Wifi Conntection is Present or not
    // NSLog(@"Chk wifi is connected or not ==%@",[Common wifiConnectionStatus]);
    
//    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
//    NSString *tzName = [currentTimeZone name];
//    NSLog(@"timezone==%@",tzName);

    NSTimeZone *currentTimeZone = [NSTimeZone timeZoneWithName:@"America/"];//[NSTimeZone localTimeZone];
    NSString *strTimeZone =[NSString stringWithFormat:@"%@",[currentTimeZone name]];
    NSLog(@"timezone==%@",strTimeZone);
    NSLocale *localeZone = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    strTimeZone = [currentTimeZone localizedName:NSTimeZoneNameStyleStandard locale:localeZone];
    NSLog(@"timezone==%@",strTimeZone);
    
//    defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
//    [defaultsAppDelegate setObject:lang forKey:@"LANGUAGE"];
//    [defaultsAppDelegate setObject:tzName forKey:@"TIMEZONE"];
//    [defaultsAppDelegate synchronize];
    
    NSString *str= @"[{1001, 1};{1002, 2}]";
    NSCharacterSet* characterSet = [[NSCharacterSet
                                        characterSetWithCharactersInString:@"0123456789{;}"] invertedSet];
    NSString* newString = [[str componentsSeparatedByCharactersInSet:characterSet]
                            componentsJoinedByString:@""];
    NSLog(@"%@",newString);
    NSArray *items = [newString componentsSeparatedByString:@";"];
    NSLog(@"%@",items);
    for(int i=0;i<[items count];i++)
    {
        NSLog(@" %d th value is =%@",i,[items objectAtIndex:i]);
    }

///
    
//    NSString* str = @"[1012,1023,1042]";
//    NSCharacterSet* characterSet = [[NSCharacterSet
//                                     characterSetWithCharactersInString:@"0123456789,"] invertedSet];
//    NSString* newString = [[str componentsSeparatedByCharactersInSet:characterSet]
//                           componentsJoinedByString:@""];
//    NSLog(@"%@",newString);
//    NSArray *items = [newString componentsSeparatedByString:@","];
//    NSLog(@"%@",items);
//    for(int i=0;i<[items count];i++)
//    {
//        NSLog(@" %d th value is =%@",i,[items objectAtIndex:i]);
//    }
    
    ////
    
    NSString *strOrgTimeZone;
    
    if([strTimeZone isEqualToString:@"Atlantic Time Zone"])
    {
        strOrgTimeZone=@"";
    }else if([strTimeZone isEqualToString:@"Eastern Time Zone"])
    {
        strOrgTimeZone=@"America/New_Yorks";   //crt
    }
    else if([strTimeZone isEqualToString:@"Central Time Zone"])
    {
        strOrgTimeZone=@"America/Chicago";
    }
    else if([strTimeZone isEqualToString:@"Mountain Time Zone"])
    {
        strOrgTimeZone=@"";
    }
    else if([strTimeZone isEqualToString:@"Mountain Time Zone - Arizona"])
    {
        strOrgTimeZone=@"";
    }
    else if([strTimeZone isEqualToString:@"Pacific Time Zone"])
    {
        strOrgTimeZone=@"America/Los_Angeles";
    }
    else if([strTimeZone isEqualToString:@"Alaska Time Zone"])
    {
        strOrgTimeZone=@"";
    }
    else if([strTimeZone isEqualToString:@"Hawaii–Aleutian Time Zone"])
    {
        strOrgTimeZone=@"America/Araguaina";
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)navigateDetailPage
{
   
    DeviceSetUpViewController *LVC = [[DeviceSetUpViewController alloc] initWithNibName:@"DeviceSetUpViewController" bundle:nil];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]){
        LVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LightsViewController"];
    }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
        LVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"LightsViewController"];
    }else{
        LVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"LightsViewController"];
    }
    LVC.strDeviceID=self.strProp_DeviceID;
    LVC.strDeviceType=self.strProp_DeviceType;
    [Common viewSlide_FromRight_ToLeft:self.navigtionController.view];
    [self.navigtionController pushViewController:LVC animated:NO];
}

#pragma mark - Orientation
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title : Orientation
 Description : The purpose of this method is to set the orientation for the view.
 Method Name : supportedInterfaceOrientationsForWindow(Orientation Delegate methods)
 ************************************************************************************* */
//-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
////     NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;
//    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
//    
//    if(self.window.rootViewController){
//        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
//        if ([strLaunchOrientation isEqualToString:@"YES"]) {
//            orientations = UIInterfaceOrientationMaskPortrait;
//        }else{
//            orientations = [presentedViewController supportedInterfaceOrientations];
//        }
//    }
//    return orientations;
//}

#pragma mark - PushNotification Delegates
//<8b2273c3 b19dd60b 397cf1d1 0afce667 b1565558 27a609d4 1fbbf143 697b22bf>
/* **********************************************************************************
 Date : 11/02/2015
 Author : iExemplar Software India Pvt Ltd.
 Title : Push Notification
 Description : The purpose of this method is receive push notifcation device token.
 the purpose of device token is send this device token to server, any thing interesting happen
 on DB APNS send notification to coressponding device token
 Method Name : didRegisterForRemoteNotificationsWithDeviceToken (Push Notification Delegate Method)
 ************************************************************************************* */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My Device token is: %@", deviceToken);
    
    devicetoken_nsdatta=deviceToken;
    // NSLog(@"nsdata device token==%@",devicetoken_nsdatta);
    //self.device_token = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    NSLog(@"device token==%@",[NSString stringWithFormat:@"%@",devicetoken_nsdatta]);
    // device_token= [NSString stringWithFormat:@"%@",deviceToken];
    //NSLog(@"token %@",device_token);
    
}
/* **********************************************************************************
 Date : 11/02/2015
 Author : iExemplar Software India Pvt Ltd.
 Title : Push Notification
 Description : Anything error on during register our device token to APNS
 Method Name : didFailToRegisterForRemoteNotificationsWithError (Push Notification Delegate Method)
 ************************************************************************************* */

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) completed
{
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title : Push Notification
 Description : Receive Push Notification while app in background
 Method Name : didReceiveRemoteNotification (Push Notification Delegate Method)
 ************************************************************************************* */

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"Remote Notification Recieved");
    NSLog(@"userinfo==%@",userInfo);
    
    NSDictionary *apsInfo = userInfo;//[userInfo objectForKey:@"aps"];
    if (application.applicationState == UIApplicationStateActive)
        
    {
        NSLog(@"application state active");
        strPushReadType=@"Active";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"apple_sms" ofType:@"mp3"];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [audioPlayer play];
        if(apsInfo!=nil){
            [self handling_PushNotification_Details:apsInfo];
        }
    }else
    {
        NSLog(@"push type launch ==%@",strPushReadType);
        if([strPushReadType isEqualToString:@"AppLaunch"])
        {
            strPushReadType=@"AppLaunch";
            NSLog(@"dictPush==%@",userInfo);
            NSLog(@"alert==%@",[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]);
            NSLog(@"badge count==%@",[[userInfo objectForKey:@"aps"] valueForKey:@"badge"]);
            NSLog(@"pushType==%@",[userInfo objectForKey:@"pushType"]);
            if([[userInfo objectForKey:@"pushType"] isEqualToString:@"userNameReset"])
            {
                defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
                [defaultsAppDelegate setObject:@"YES" forKey:@"UNAMECHANGED"];
                [defaultsAppDelegate synchronize];
            }
            else if([[userInfo objectForKey:@"pushType"] isEqualToString:@"passwordReset"])
            {
                defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
                [defaultsAppDelegate setObject:@"YES" forKey:@"PWDCHANGED"];
                [defaultsAppDelegate synchronize];
            }
            return;
        }
        else{
            strPushReadType=@"InActive";
        }
        NSLog(@"application background fetch comilation handler");
        NSLog(@"dici==%@",userInfo);
        if(apsInfo!=nil){
            [self handling_PushNotification_Details:apsInfo];
        }
    }
}

-(void)handling_PushNotification_Details:(NSDictionary *)dictPush
{
    @try {
        // defaults=[NSUserDefaults standardUserDefaults];
        NSLog(@"dictPush==%@",dictPush);
        NSLog(@"alert==%@",[[dictPush objectForKey:@"aps"] valueForKey:@"alert"]);
        NSLog(@"pushType==%@",[dictPush objectForKey:@"pushType"]);
        NSLog(@"netowrk invite id's==%@",[dictPush objectForKey:@"inviteeNetworkIds"]);
        if([[dictPush objectForKey:@"pushType"] isEqualToString:@"inviteeAlertAdd"]||[[dictPush objectForKey:@"pushType"] isEqualToString:@"inviteeAlertUpdate"]||[[dictPush objectForKey:@"pushType"] isEqualToString:@"inviteeAlertRemove"]){
            
            NSDictionary *dictAlert=[[dictPush objectForKey:@"aps"] valueForKey:@"alert"];
            NSLog(@"msg body == %@",[dictAlert valueForKey:@"body"]);
            if([strPushReadType isEqualToString:@"Active"] && [[dictPush objectForKey:@"pushType"] isEqualToString:@"inviteeAlertAdd"])   // Invite New USer
            {
                [self showToastNotification:[dictAlert valueForKey:@"body"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMessageReceivedNotification" object:@"YES"];
                strNew_NotiReceived = @"YES";
            }
            else if([strPushReadType isEqualToString:@"Active"] && [[dictPush objectForKey:@"pushType"] isEqualToString:@"inviteeAlertUpdate"])   // Update alredy invited user
            {
                
                [self showToastNotification:[dictAlert valueForKey:@"body"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMessageReceivedNotification" object:@"YES"];
                strNew_NotiReceived = @"YES";
                
                if([self.strOwnerNetwork_Status isEqualToString:@"NO"])
                {
                    //
                    NSError *jsonError;
                    NSData *objectData = [[dictPush objectForKey:@"inviteeNetworkIds"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    NSLog(@"dict =%@",json);
                    NSMutableArray *arrIDS=[[NSMutableArray alloc] init];
                    arrIDS=[json valueForKey:@"nl"];
                    NSLog(@"ArrnOw =%@",arrIDS);
                    NSLog(@"ArrnOw count ==%lu",(unsigned long)[arrIDS count]);
                    NSLog(@"network id =%@",[[arrIDS objectAtIndex:0] objectForKey:@"n"]);
                    NSLog(@"invitee id =%@",self.strInviteeID);
                    NSLog(@"network id ==%@",[self.dict_NetworkControllerDatas valueForKey:kNetworkID]);
                    NSLog(@"permission =%@",[[arrIDS objectAtIndex:0] objectForKey:@"a"]);
                    for(int index=0;index<[arrIDS count];index++)
                    {
                        if(([[[[arrIDS objectAtIndex:index] objectForKey:@"n"] stringValue] isEqualToString:[self.dict_NetworkControllerDatas valueForKey:kNetworkID]])&&(![[[[arrIDS objectAtIndex:index] objectForKey:@"a"] stringValue] isEqualToString:self.strNetworkPermission]))
                        {
                            //self.strNetworkPermission=[[[arrIDS objectAtIndex:0] objectForKey:@"a"] stringValue];
                            defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
                            [defaultsAppDelegate setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                            [defaultsAppDelegate synchronize];
                            self.strInitialView=@"SignIn";
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                                multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                                multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                            }else{
                                multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                            }
                            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
                            self.window.rootViewController = self.navigtionController;
                            [self.navigtionController.navigationBar setHidden:YES];
                            [self.navigtionController setNavigationBarHidden:YES];
                            [imageViewSplash removeFromSuperview];
                            self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                            [self.window makeKeyAndVisible];
                            index=(int)[arrIDS count]+index;
                        }
                    }
                    //
                }
                
            }
            else if([strPushReadType isEqualToString:@"Active"] && [[dictPush objectForKey:@"pushType"] isEqualToString:@"inviteeAlertRemove"])    //Remove user
            {
                //appDelegate.strInviteeID
                NSLog(@"network remove ");
                NSLog(@"inviteed id going to deltede =%@",[dictPush objectForKey:@"invitee"]);
                [self showToastNotification:[dictAlert valueForKey:@"body"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMessageReceivedNotification" object:@"YES"];
                strNew_NotiReceived = @"YES";
                
                //invitee = "{\"id\":1810}";
                if([self.strOwnerNetwork_Status isEqualToString:@"NO"])
                {
                    NSError *jsonError;
                    NSData *objectData = [[dictPush objectForKey:@"invitee"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    NSLog(@"dict =%@",json);
                    if([[[json objectForKey:@"id"] stringValue] isEqualToString:self.strInviteeID])
                    {
                        NSLog(@"network remove same");
                        defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
                        [defaultsAppDelegate setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                        [defaultsAppDelegate synchronize];
                        self.strInitialView=@"SignIn";
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                            multipleVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                            multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        }else{
                            multipleVC = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                        }
                        self.navigtionController=[[UINavigationController alloc]initWithRootViewController:multipleVC];
                        self.window.rootViewController = self.navigtionController;
                        [self.navigtionController.navigationBar setHidden:YES];
                        [self.navigtionController setNavigationBarHidden:YES];
                        [imageViewSplash removeFromSuperview];
                        self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
                        [self.window makeKeyAndVisible];
                    }
                }
            }
            else if([strPushReadType isEqualToString:@"InActive"])
            {
                NSLog(@"set Local Notification here");
                [self removeSplashNavigateMP];
            }
        }
        else if([[dictPush objectForKey:@"pushType"] isEqualToString:@"userNameReset"])    //Mail Changes
        {
            defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
            [defaultsAppDelegate setObject:@"YES" forKey:@"UNAMECHANGED"];
            [defaultsAppDelegate synchronize];
            if([strPushReadType isEqualToString:@"Active"])
            {
                NSLog(@"push type ==%@",[dictPush objectForKey:@"pushType"]);
                [self sigountConfirmAlert];
            }
            else if([strPushReadType isEqualToString:@"InActive"])
            {
                NSLog(@"set Local Notification here");
                //[self removeSplashNavigateMP];
                [self sigountConfirmAlert];
            }
        }
        else if([[dictPush objectForKey:@"pushType"] isEqualToString:@"passwordReset"])    //Pwd Changes
        {
            defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
            [defaultsAppDelegate setObject:@"YES" forKey:@"PWDCHANGED"];
            [defaultsAppDelegate synchronize];
            
            if([strPushReadType isEqualToString:@"Active"])
            {
                NSLog(@"push type ==%@",[dictPush objectForKey:@"pushType"]);
                [self sigountConfirmAlertPassword];
            }
            else if([strPushReadType isEqualToString:@"InActive"])
            {
                NSLog(@"set Local Notification here");
                //[self removeSplashNavigateMP];
                [self sigountConfirmAlertPassword];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"notification error==%@",exception);
    }
}

-(void)sigountConfirmAlert
{
    int totalAlertCount =[strPushAlertCount intValue];
    if(totalAlertCount==0)
    {
        alertViewPush[totalAlertCount] = [[UIAlertView alloc] initWithTitle:@"NOID"
                                                                    message:@"Email Id is changed. You will be automatically signed out. Please login again with new credentials."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
        [alertViewPush[totalAlertCount] setTag:1];
        [alertViewPush[totalAlertCount] show];
        totalAlertCount=totalAlertCount+1;
        strPushAlertCount=[NSString stringWithFormat:@"%d",totalAlertCount];
    }
    
}
-(void)sigountConfirmAlertPassword
{
    int totalAlertCount =[strPushAlertCountPWD intValue];
    if(totalAlertCount==0)
    {
        alertViewPushPWD[totalAlertCount] = [[UIAlertView alloc] initWithTitle:@"NOID"
                                                                       message:@"Password is changed. You will be automatically signed out. Please login again with new credentials."
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
        [alertViewPushPWD[totalAlertCount] setTag:2];
        [alertViewPushPWD[totalAlertCount] show];
        totalAlertCount=totalAlertCount+1;
        strPushAlertCountPWD=[NSString stringWithFormat:@"%d",totalAlertCount];
    }
}
-(void)responseErrorDelegate{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if(alertView.tag==1)
    {
        if (buttonIndex == 0) {
            // do something here...
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(signOutServiceDelegate) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
                if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
                {
                    [defaultsAppDelegate setObject:@"" forKey:@"UNAMECHANGED"];
                    [defaultsAppDelegate synchronize];
                    strPushAlertCount=@"0";
                }
                else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
                {
                    [defaultsAppDelegate setObject:@"" forKey:@"PWDCHANGED"];
                    [defaultsAppDelegate synchronize];
                    strPushAlertCountPWD=@"0";
                    
                }
            }
        }
    }else if(alertView.tag==2)
    {
        if (buttonIndex == 0) {
            // do something here...
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(signOutServiceDelegate) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
                if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
                {
                    [defaultsAppDelegate setObject:@"" forKey:@"UNAMECHANGED"];
                    [defaultsAppDelegate synchronize];
                    strPushAlertCount=@"0";
                }
                else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
                {
                    [defaultsAppDelegate setObject:@"" forKey:@"PWDCHANGED"];
                    [defaultsAppDelegate synchronize];
                    strPushAlertCountPWD=@"0";
                }
            }
        }
    }
    else if(alertView.tag==3)
    {
        if (buttonIndex == 0) {
            // do something here...
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(signOutServiceDelegate) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

#pragma mark - Toast for forground Notifications
-(void)showToastNotification:(NSString *)strMessage
{
    hudToast = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hudToast.mode = MBProgressHUDModeText;
    hudToast.labelText = strMessage;
    hudToast.margin = 10.f;
    hudToast.yOffset = 250.f;
    hudToast.removeFromSuperViewOnHide = YES;
    hudToast.dimBackground = NO;
    hudToast.userInteractionEnabled=NO;
    [hudToast hide:YES afterDelay:5];
    strPushReadType=@"";
}


-(void)signOutServiceDelegate
{
    defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsAppDelegate objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/logout",[defaultsAppDelegate objectForKey:@"ACCOUNTID"]];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    deviceToken=@"";
    if(self.devicetoken_nsdatta==nil){
        deviceToken=@"ASD1c7bf338c5e9bab2ad2fca45ada646d600061c28cf79c90a";
    }else{
        deviceToken=[NSString stringWithFormat:@"%@",self.devicetoken_nsdatta];
        deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    NSMutableDictionary *dictDetails=[[NSMutableDictionary alloc] init];
    [dictDetails setObject:deviceToken forKey:kDeviceToken];
    [dictDetails setObject:@"1" forKey:kTokenType];
    
    parameters=[SCM signOut:dictDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for signout==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSignOutDelegate) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sign out==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_AutoLogin) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDelegate) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseSignOutDelegate
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_AutoLogin];
            defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
            [defaultsAppDelegate setObject:@"" forKey:@"APPREMEMBERMESTATUS"];
            [defaultsAppDelegate setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
            [defaultsAppDelegate setObject:@"" forKey:@"ACTIVENETWORKID"];

            if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
            {
                [defaultsAppDelegate setObject:@"" forKey:@"UNAMECHANGED"];
                strPushAlertCount=@"0";
            }
            else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
            {
                [defaultsAppDelegate setObject:@"" forKey:@"PWDCHANGED"];
                strPushAlertCountPWD=@"0";
            }
            [defaultsAppDelegate synchronize];
            self.strNoidLogo=@"";
            self.strOwnerNetwork_Status=@"";
            [self.dict_NetworkControllerDatas removeAllObjects];
            self.strInviteeID=@"";
            self.strNetworkPermission=@"";
            self.dict_NetworkControllerDatas=nil;
            [Common resetNetworkFlags];

            if ([[Common deviceType] isEqualToString:@"iPhone5"]){
                viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }else if([[Common deviceType] isEqualToString:@"iPhone6"]){
                viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }else{
                viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone6plus" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            }
            self.navigtionController=[[UINavigationController alloc]initWithRootViewController:viewController];
            self.window.rootViewController = self.navigtionController;
            [self.navigtionController.navigationBar setHidden:YES];
            [self.navigtionController setNavigationBarHidden:YES];
            [imageViewSplash removeFromSuperview];
            self.window.backgroundColor=lblRGBA(65, 64, 66, 1);
            [self.window makeKeyAndVisible];
        }else{
            [self stop_PinWheel_AutoLogin];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
            if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
            {
                [defaultsAppDelegate setObject:@"" forKey:@"UNAMECHANGED"];
                [defaultsAppDelegate synchronize];
                strPushAlertCount=@"0";
            }
            else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
            {
                [defaultsAppDelegate setObject:@"" forKey:@"PWDCHANGED"];
                [defaultsAppDelegate synchronize];
                strPushAlertCountPWD=@"0";
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_AutoLogin];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        defaultsAppDelegate=[NSUserDefaults standardUserDefaults];
        if([[defaultsAppDelegate objectForKey:@"UNAMECHANGED"] isEqualToString:@"YES"])
        {
            [defaultsAppDelegate setObject:@"" forKey:@"UNAMECHANGED"];
            [defaultsAppDelegate synchronize];
            strPushAlertCount=@"0";
        }
        else if([[defaultsAppDelegate objectForKey:@"PWDCHANGED"] isEqualToString:@"YES"])
        {
            [defaultsAppDelegate setObject:@"" forKey:@"PWDCHANGED"];
            [defaultsAppDelegate synchronize];
            strPushAlertCountPWD=@"0";
        }
    }
}

#pragma mark - Pin Wheel Deleagte
-(void)start_PinWheel_AutoLogin{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.labelText = @"Please Wait";
    [self.window bringSubviewToFront:hud];
}
-(void)stop_PinWheel_AutoLogin{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
    strLaunchOrientation=@"";
}

@end
