//
//  NetworkHomeViewController.m
//  NOID
//
//  Created by iExemplar on 25/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "NetworkHomeViewController.h"
#import "SettingsViewController.h"
#import "Common.h"
#import "LightsViewController.h"
#import "MultipleNetworkViewController.h"
#import "AddNetworkViewController.h"
#import "AddSprinklerScheldule.h"
#import "Utils.h"
#import "DeviceSetUpViewController.h"
#import "SprinklerDeviceSetupViewController.h"
#import "TimeLineViewController.h"
#import "SWRevealViewController.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "Base64.h"
#import "ServiceConnectorModel.h"
#import "Utils.h"
#import "AddSprinklerScheldule.h"
#import "MyAnnotation.h"
#import "CustomAnnotationView.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kBgQueueDevice dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kButtonIndex 1000
#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20
double footView;
CLLocationCoordinate2D topLeft,topRight,bottomLeft,newCoordianteOverlay,bottomRight;

@interface NetworkHomeViewController ()
{
    //Alerts & AlertsLightsCard
    UIView *menuView[kButtonIndex];
    UIView *menuTapView[kButtonIndex];
    UIView *view_AlertMsg_ContentView[kButtonIndex];

    UIView *view_ScheduleCell_Sprinkler[kButtonIndex];
    UIView *view_Schedule_ContentView[kButtonIndex];
    UIView *view_Schedule_Sub[kButtonIndex];
    NSMutableArray *arrAlerts;
    UILabel *lblMsgAlert[kButtonIndex];
    UILabel *lblCardAlert[kButtonIndex];
    UILabel *lblDateAlert[kButtonIndex];
    UILabel *lblSchedule_Sprinkler[kButtonIndex];
    UILabel *lblSchedule_Time_Sprinkler[kButtonIndex];
    UITextField *txt_Schedule_Sprinkler[kButtonIndex];
    UIImageView *imgViewSchedule_Sprinkler[kButtonIndex];
    UIImageView *imgViewSchedule_Sprinkler_Clock[kButtonIndex];
//    UIButton *viewButtonAlert[kButtonIndex];
    UILabel *lbl_viewAlert[kButtonIndex];

    UIButton *calendarButtonAlert[kButtonIndex];
    UIButton *imageButtonDevices[kButtonIndex];
    UIButton *btn_Save_Schedule[kButtonIndex];
    UIButton *btn_Edit_Schedule[kButtonIndex];
    UIButton *btn_Close_Schedule[kButtonIndex];
    UISwitch *deviceSwitch_Alerts[kButtonIndex];
    UIButton *round[kButtonIndex];

    //Lights and Others
    UIView *menuDeviceView[kButtonIndex];
    AsyncImageView *postimageView[kButtonIndex];
    AsyncImageView *aPostimageView[kButtonIndex];
   
    NSString *strSmallWeatherImage[kButtonIndex];
}

@end

@implementation NetworkHomeViewController
@synthesize view_alert,btn_swipeDownAlert,BodyView_NetworkHome,BodyView_Weather,BodyView_Container;
@synthesize scrollView_weather,view_Weather1,view_Weather2,view_Weather3,view_Weather4,view_Weather5,view_Weather6,view_Weather7,view_Weather8,view_changeWeather,BodyView_PropertyMap;
@synthesize lbl_temp1,lbl_temp2,lbl_temp3,lbl_temp4,lbl_temp5,lbl_temp6,lbl_temp7,lbl_temp8,ViewLightDevice,tbleView_Lights,arrDeivce_Images,arrDeivce_Name,btn_swipeDownDeviceAlerts,headerView_NetworkHome,str_Pop_Type,popUpScheduleView,view_infoAlert;
@synthesize btn_back_networkHome,btn_networkHome_logo,btn_settings,viewLightNetworkHome,viewOthersNetworkHome,lightsAddDeviceViewButton,view_VacationMode,viewSprinklerNetworkHome,tbleView_Sprinklers,sprinklerAddDeviceViewButton,arr_ScheduleName,arr_ScheduleTime,tbleView_ScheduleSprinklers,sprinklerScheduleView,view_Schedule,view_Devices,btn_AddSchedule,btn_Vacation,btn_Info,lbl_vacationMode,str_CheckAction,scroll_SprinklerScheduleVw,view_AddSchedule,ViewSprinklerDevice,header_View_Lights,tableView_Alerts,arrAlerts_MSG,imgScheduleSprinkler,lbl_addSchedule,view_alertMsgExpand,sidebarButton,alertFooter,scrollView_Alert,btnSliderHeader_Bar,btnSliderHeader_Image,scroll_View_LightsCard,viewLightsCard_FooterView;
@synthesize viewSprinklerAlert,viewSprinklerAlert_Device_FooterView,viewSprinklerAlert_DeviceView,viewSprinklerAlert_Schedule_FooterView,viewSprinklerAlert_ScheduleView,scrollView_SprinklerCard,viewSprinkler_Alert,viewSprinkler_SwipeDownView,viewSprinklersCard_DataView,viewSprinklersCard_FooterView,viewSprinklersCard_Schedule_FooterView,tab_DeviceView,tab_ScheduleView,tabDetailView_Sprinkler,tabView_Sprinkler,scroll_View_Sprinklers_Device,scroll_View_Sprinklers_Schedule,scroll_View_SprinklersCard,btn_sprinkler_swipeDown,tapGestureRecognizer,lbl_networkName,imgView_Header_Property;
@synthesize btn_currentWeather,lbl_maxTemp_Weather,lbl_maxtemp1,lbl_maxtemp2,lbl_maxtemp3,lbl_maxtemp4,lbl_maxtemp5,lbl_maxtemp6,lbl_maxtemp7,lbl_maxtemp8,img_weather1,img_weather2,img_weather3,img_weather4,img_weather5,img_weather6,img_weather7,img_weather8,lbl_dayWeather1,lbl_dayWeather2,lbl_dayWeather3,lbl_dayWeather4,lbl_dayWeather5,lbl_dayWeather6,lbl_dayWeather7,lbl_dayWeather8,lbl_Date_weather,lbl_latlong_weather,lbl_maxTempBig_weather,lbl_minTempBig_weather,lbl_NetworkName_weather,lbl_Summery_weather,img_WeatherCondition,lbl_minTemp_Weather,lbl_timeAgo,logTimer,lbl_Weather_WindCount,btn_Alert_Count,btn_Message_Count,lblDeviceType,imgDeviceType,view_manualOffAlert,btn_Weather_WindImg;
@synthesize mapViewProperty,deleteProfilebtn,cameraProfilebtn,gallaryProfilebtn,lbl_Humidity,lbl_Ozone,lbl_Pressure,lbl_weather_subSunsetTime,btn_Weather_SunRiseImg,viewAlert_AddDevice,btnPropertyMap,btn_PropertyMap_Location,view_Sprinkler_manualOffAlert,view_manualOnAlert;

#pragma mark - View LifeCycle
/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flagSetupNetwork_Home];
    [self uiConfiguration];
    [self drawerSetUP];
    self.revealViewController.delegate = self;
    SWRevealViewController *revealController = [self revealViewController];
    [self revealController:revealController willMoveToPosition:FrontViewPositionRightMost];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strWeatherChanged=@"";
//    [self testingArrayMap];
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if([strLoadedStatus isEqualToString:@"YES"]){
        strLoadedStatus=@"NO";
        return;
    }
    if (position ==FrontViewPositionRight) {
        NSLog(@"disbale");
        self.tapGestureRecognizer.enabled = YES;
        self.BodyView_Container.userInteractionEnabled = NO;
        self.titleBarView1_swipe.userInteractionEnabled = NO;
        self.headerView_NetworkHome.userInteractionEnabled = NO;
    }
    else if (position == FrontViewPositionLeftSide){
        NSLog(@"enabled");
        [self chnageNetworksDrawers];
        self.tapGestureRecognizer.enabled = NO;
        self.BodyView_Container.userInteractionEnabled = YES;
        self.titleBarView1_swipe.userInteractionEnabled = YES;
        self.headerView_NetworkHome.userInteractionEnabled = YES;
    }else{
        NSLog(@"worst case");
        NSLog(@"enablde");
        [self chnageNetworksDrawers];
        self.tapGestureRecognizer.enabled = NO;
        self.BodyView_Container.userInteractionEnabled = YES;
        self.titleBarView1_swipe.userInteractionEnabled = YES;
        self.headerView_NetworkHome.userInteractionEnabled = YES;
    }
}

-(void)resetWeatherDatas
{
    [btn_currentWeather setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.lbl_maxTemp_Weather.text=@"";
    self.lbl_minTemp_Weather.text=@"";
}

-(void)chnageNetworksDrawers
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strChangeDrawerData isEqualToString:@"YES"]){
        [self.logTimer invalidate];
        [self start_PinWheel_Lights];
        if (wheaterTag==2) {
            [self PropertMap_to_Home];
        }else if (wheaterTag==1){
            [self backtoWeatherHome];
        }
        NSLog(@"netowrk changed");
        [self resetWeatherDatas];
        NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
        lbl_networkName.text=[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkName];
        NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
        messageCount = [[appDelegate.dict_NetworkControllerDatas valueForKey:kMessageCount] intValue];
        NSLog(@"%d",messageCount);
        [btn_Message_Count setTitle:[[appDelegate.dict_NetworkControllerDatas valueForKey:kMessageCount] stringValue] forState:UIControlStateNormal];
        
        //
        defaults=[NSUserDefaults standardUserDefaults];
        if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID] isEqualToString:[defaults objectForKey:@"ACTIVENETWORKID"]])
        {
            footView=[[defaults objectForKey:@"FOOTVIEW"] doubleValue];
        }else{
            footView=500;
            [defaults setObject:@"500" forKey:@"FOOTVIEW"];
            [defaults setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID] forKey:@"ACTIVENETWORKID"];
            [defaults synchronize];
        }
        //
        if([appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] == [NSNull null]){
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView_Header_Property.image = [UIImage imageNamed:@"noNetworkImage1"];
                });
            });
        }
        else if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] isEqualToString:@""]){
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView_Header_Property.image = [UIImage imageNamed:@"noNetworkImage1"];
                });
            });
        }else{
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView_Header_Property.image = [UIImage imageWithData:[Base64 decode:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage]]];
                });
            });
        }
        appDelegate.strChangeDrawerData=@"";
        if ([deviceActions isEqualToString:@"lights"]||[deviceActions isEqualToString:@"others"]) {
            viewLightsCard_FooterView.hidden=YES;
        }
        else if ([deviceActions isEqualToString:@"sprinklers"])
        {
            self.viewSprinklerAlert_Schedule_FooterView.hidden=YES;
            self.viewSprinklerAlert_Device_FooterView.hidden=YES;
            for (int index=0; index<[arr_Schedule_Sprinklers count]; index++) {
                [view_ScheduleCell_Sprinkler[index] removeFromSuperview];
            }
        }
        //viewLightsCard_FooterView.hidden=YES;
        for (int index=0;index<[arrDevices count];index++){
            [menuDeviceView[index] removeFromSuperview];
        }
        [self stop_PinWheel_Lights];
        strWeatherType=@"";
        if([Common reachabilityChanged]==YES){
            currentWeather_tag=0;
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getWeatherDetails) withObject:self];
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
}

-(void)uiConfiguration{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DICT Network Data ==%@",appDelegate.dict_NetworkControllerDatas);
    lbl_networkName.text=[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkName];
    [btn_Alert_Count setTitle:[[appDelegate.dict_NetworkControllerDatas valueForKey:kAlertCount] stringValue] forState:UIControlStateNormal];
    [btn_Message_Count setTitle:[[appDelegate.dict_NetworkControllerDatas valueForKey:kMessageCount] stringValue] forState:UIControlStateNormal];
    messageCount = [[appDelegate.dict_NetworkControllerDatas valueForKey:kMessageCount] intValue];
    NSLog(@"msg count==%d",messageCount);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    if([appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] == [NSNull null])
    {
        dispatch_async(kBgQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView_Header_Property.image = [UIImage imageNamed:@"noNetworkImage1"];
            });
        });
    }
    else if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] isEqualToString:@""]){
        dispatch_async(kBgQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView_Header_Property.image = [UIImage imageNamed:@"noNetworkImage1"];
            });
        });
    }else{
        dispatch_async(kBgQueue,   ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                imgView_Header_Property.image = [UIImage imageWithData:[Base64 decode:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage]]];
                CGSize imgScalling = [Common imageScalling:imgView_Header_Property.image withScalingDetails:180 and:92];
                imgView_Header_Property.image = [Common imageWithImage:imgView_Header_Property.image scaledToSize:imgScalling];
            });
        });
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    strTimer_Status=@"timer_Stopped";
    [self.logTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNOIDNetowrksHome:) name:@"PushMessageReceivedNotification" object:nil];
}
- (void) incomingNOIDNetowrksHome:(NSNotification *)notification{
    if([[notification object] isEqualToString:@"YES"])
    {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.strNetworkDrawer_Status=@"ReSet";
    }
}

/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: View Will Appear
 Description : Set the view after loading
 Method Name : viewWillAppear(View Delegate Methods)
 ************************************************************************************* */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"landscape");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
        
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }

    if ([strTimer_Status isEqualToString:@"timer_Stopped"])
    {
//        [self timerTick];
        [self startLogTimer];
        strTimer_Status=@"";
    }
    appDelegate.strNoidLogo=@"NetworkHome";
    if([appDelegate.strNoid_BackStatus isEqualToString:@"noid"]){
        appDelegate.strNoid_BackStatus=@"";
        [self resetNetwork_Views];
        [Common resetNetworkFlags];
    }
    if([strLoaderViewStatus isEqualToString:@"YES"])
    {
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getWeatherDetails) withObject:self];
//            [Common resetNetworkFlags];
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
        strLoaderViewStatus=@"";
    }
    else if([appDelegate.strDevice_Added_Status isEqualToString:@"CATEGORY"])
    {
        if(wheaterTag==2)
        {
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getPropertyMapService) withObject:self];
            [Common resetNetworkFlags];
        }else{
            if ([deviceActions isEqualToString:@"lights"]||[deviceActions isEqualToString:@"others"]) {
                viewLightsCard_FooterView.hidden=YES;
            }
            else if ([deviceActions isEqualToString:@"sprinklers"])
            {
                self.viewSprinklerAlert_Device_FooterView.hidden=YES;
            }
          //  viewLightsCard_FooterView.hidden=YES;
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            for (int index=0;index<[arrDevices count];index++){
                [menuDeviceView[index] removeFromSuperview];
            }
            [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [Common resetNetworkFlags];
            if ([deviceActions isEqualToString:@"lights"]) {
                [self showOthersPopup];
            }
            else if ([deviceActions isEqualToString:@"others"])
            {
                [self showLightsPopup];
            }
            else if ([deviceActions isEqualToString:@"sprinklers"])
            {
                [self showSprinklerPopup];
            }
        }
       
    }
    else if([appDelegate.strDevice_Added_Status isEqualToString:@"REMOVEPOPUPLOAD"])
    {
        if(wheaterTag==2)
        {
            [self resetNetwork_Views];
        }
       // viewLightsCard_FooterView.hidden=YES;
        if ([deviceActions isEqualToString:@"lights"]||[deviceActions isEqualToString:@"others"]) {
            viewLightsCard_FooterView.hidden=YES;
        }
        else if ([deviceActions isEqualToString:@"sprinklers"])
        {
            // viewSprinklersCard_FooterView.hidden=YES;
            self.viewSprinklerAlert_Device_FooterView.hidden=YES;
        }

        [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
        for (int index=0;index<[arrDevices count];index++){
            [menuDeviceView[index] removeFromSuperview];
        }
        for (int index=0;index<[arr_Schedule_Sprinklers count];index++){
            [view_ScheduleCell_Sprinkler[index] removeFromSuperview];
        }

        
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [Common resetNetworkFlags];
    }
    else if([appDelegate.strDevice_Added_Status isEqualToString:@"OLDPOPUPLOAD"]||[appDelegate.strDevieDeleted_Status isEqualToString:@"YES"]||[appDelegate.strDeviceUpdated_Status isEqualToString:@"YES"]||[appDelegate.strScheduleAddedStatus isEqualToString:@"YES"]){
       
        if(wheaterTag==2)
        {
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getPropertyMapService) withObject:self];
            [Common resetNetworkFlags];
        }
        else{
             [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
           // viewLightsCard_FooterView.hidden=YES;
            if ([deviceActions isEqualToString:@"lights"]||[deviceActions isEqualToString:@"others"]) {
                viewLightsCard_FooterView.hidden=YES;
            }
            else if ([deviceActions isEqualToString:@"sprinklers"])
            {
                // viewSprinklersCard_FooterView.hidden=YES;
                self.viewSprinklerAlert_Device_FooterView.hidden=YES;
                self.viewSprinklersCard_Schedule_FooterView.hidden=YES;
                for (int index=0;index<[arr_Schedule_Sprinklers count];index++){
                    [view_ScheduleCell_Sprinkler[index] removeFromSuperview];
                }
                strStatusSchedule=@"";
            }
            for (int index=0;index<[arrDevices count];index++){
                [menuDeviceView[index] removeFromSuperview];
            }
          //  [self performSelectorInBackground:@selector(getAllNOID_Devices) withObject:self];
            
            if ([deviceActions isEqualToString:@"lights"]||[deviceActions isEqualToString:@"others"]) {
                [self performSelectorInBackground:@selector(getAllNOID_Devices) withObject:self];
                
            }
            else if ([deviceActions isEqualToString:@"sprinklers"])
            {
                [self performSelectorInBackground:@selector(getAllSpinklerDevices) withObject:self];
            }
            [Common resetNetworkFlags];
        }
        
    }
    else if([appDelegate.strDevice_Added_Status isEqualToString:@"SPRINKLER"])
    {
        if(wheaterTag==2)
        {
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getPropertyMapService) withObject:self];
            [Common resetNetworkFlags];
        }else{
            
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            for (int index=0;index<[arr_Schedule_Sprinklers count];index++){
                [view_ScheduleCell_Sprinkler[index] removeFromSuperview];
            }
            [self stop_PinWheel_Lights];
            
            if([Common reachabilityChanged]==YES){
                self.viewSprinklerAlert_Schedule_FooterView.hidden=YES;
                newVacModeStatus=@"";
                vacationModeStatus=@"NO";
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getZoneScheduleList) withObject:self];
            }else{
                [self reset_SprinklerSchedule_Status];
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            [Common resetNetworkFlags];
        }
    }
    if([appDelegate.strWeatherChanged isEqualToString:@"YES"])
    {
        [self.logTimer invalidate];
        appDelegate.strWeatherChanged=@"";
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getWeatherDetails) withObject:self];
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PinWheel Delegate Methods
-(void)start_PinWheel_Lights{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}
-(void)stop_PinWheel_Lights{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

#pragma mark - IBActions
/* **********************************************************************************
 Date : 30/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description :
 Method Name : add_Schedule_Action
 ************************************************************************************* */
-(IBAction)add_Schedule_Action:(id)sender{
    
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Owner==%@",appDelegate.strOwnerNetwork_Status);
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if ([arrDevices count]==0) {
        [Common showAlert:@"Warning" withMessage:@"At least 1 zone should be configured"];
        return;
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strDevice_Added_Mode=@"NetworkHome";
    AddSprinklerScheldule *addSprinklr = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
    [addSprinklr setDelegate:self];
    [Common viewSlide_FromRight_ToLeft:self.navigationController.view];
    [self.navigationController pushViewController:addSprinklr animated:NO];
}

-(IBAction)vacationMode:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Owner==%@",appDelegate.strOwnerNetwork_Status);
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([arr_Schedule_Sprinklers count]==0)
    {
        [Common showAlert:@"Warning" withMessage:@"No schedules available. Cannot turn ON vacation mode."];
        return;
    }
    if ([vacationModeStatus isEqualToString:@"YES"]) {
        strzoneModeStatus = @"1";
        vacationModeStatus=@"NO";
    }else if ([vacationModeStatus isEqualToString:@"NO"]){
        strzoneModeStatus = @"2";
        vacationModeStatus=@"YES";
    }
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(update_Sprinkler_ZoneModeStatus) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

-(IBAction)info_BtnAction:(id)sender{
    
    header_View_Lights.alpha=0.6;
    sprinklerScheduleView.alpha=0.6;
    [popUpScheduleView setHidden:YES];
    [view_infoAlert setHidden:NO];
}

-(IBAction)closeInfoAlert:(id)sender{
    [self change_Light_Schedule_Alpha];
    [popUpScheduleView setHidden:YES];
    [view_infoAlert setHidden:YES];
}
-(IBAction)closeAlert:(id)sender{
    [self change_Light_Schedule_Alpha];
    [popUpScheduleView setHidden:YES];
}
-(void)change_Light_Schedule_Alpha
{
    header_View_Lights.alpha=1.0;
    sprinklerScheduleView.alpha=1.0;
}

/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Display Alert view on click of the alert button
 Method Name : alert_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)alert_Action:(id)sender
{
    [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
    [self alertViewSetup];
    strAlertType=@"AlertsMSG";
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3];
    scrollView_Alert.frame  = CGRectMake(scrollView_Alert.frame.origin.x, 20,scrollView_Alert.frame.size.width,scrollView_Alert.frame.size.height);
    [self HideViewOnTouch];
    [self.BodyView_NetworkHome setUserInteractionEnabled:NO];
    [self performSelectorInBackground:@selector(getAllNOID_Messages) withObject:self];
    //[self performSelectorInBackground:@selector(loadAlertsDatas) withObject:self];
    [UIView commitAnimations];
    [btn_back_networkHome setUserInteractionEnabled:NO];
    [btn_networkHome_logo setUserInteractionEnabled:NO];
    [btn_settings setUserInteractionEnabled:NO];
    [btnSliderHeader_Bar setUserInteractionEnabled:NO];
    [btnSliderHeader_Image setUserInteractionEnabled:NO];
    cellExpandStatusAlert=YES;
}

/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event hides the alert view from the superview.
 Method Name : hideView_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)hideView_Action:(id)sender
{
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            [self hideAlertView];
            break;
        case 1:
            [self hideAlertView_LightsOthers];
            break;
        case 2:
            [self hideAlertView_Sprinklers];
            break;
    }
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event navigates to the weather screen.
 Method Name : weather_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)weather_Action:(id)sender
{
    //old time 0.5
    wheaterTag=1;
    strAlertType=@"";
    [UIView transitionWithView:self.BodyView_Container
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [BodyView_NetworkHome setHidden:YES];
                        [BodyView_PropertyMap setHidden:YES];
                        [self.BodyView_Container addSubview:BodyView_Weather];
                        [BodyView_Weather setHidden:NO];
                        [self weatherTap_Configuration];
                    }
                    completion:NULL];
}

//-(void)backToUserLocation:(UIButton*)sender
//{
//    btn_PropertyMap_Location.hidden = YES;
//    
//    CLLocationCoordinate2D newCoordiante;
//    newCoordiante.latitude=[[dictProperty_NetworkDetails objectForKey:@"latitude"] doubleValue];
//    newCoordiante.longitude=[[dictProperty_NetworkDetails objectForKey:@"longitude"] doubleValue];
//    [self.mapViewProperty setRegion:MKCoordinateRegionMakeWithDistance(newCoordiante, footView,footView)];
//    
//    if ([strCallout isEqualToString:@"select"]) {
//        [viewCallout removeFromSuperview];
//    }
//
////    MyAnnotation *annotation=self.parentAnnotationView.annotation;
////    [mapViewProperty setCenterCoordinate:annotation.coordinate animated:YES];
//}


-(void)backToUserLocation:(UIButton*)sender
{
    btn_PropertyMap_Location.hidden = YES;
    if ([strCallout isEqualToString:@"select"]) {
        //[viewCallout removeFromSuperview];
        MyAnnotation *annotation=self.parentAnnotationView.annotation;
        [mapViewProperty setCenterCoordinate:annotation.coordinate animated:YES];
    }else{
        CLLocationCoordinate2D newCoordiante;
        newCoordiante.latitude=[[dictProperty_NetworkDetails objectForKey:@"latitude"] doubleValue];
        newCoordiante.longitude=[[dictProperty_NetworkDetails objectForKey:@"longitude"] doubleValue];
        [self.mapViewProperty setRegion:MKCoordinateRegionMakeWithDistance(newCoordiante, footView,footView)];
        NSLog(@"new zoom level ==%f",footView);
    }
    
    
}
/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event navigates to the Property map screen.
 Method Name : PropertyMap_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)PropertyMap_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([Common reachabilityChanged]==YES){
        propertyLoaderStatus=@"";
        [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(getPropertyMapService) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}



/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event navigates to the settings screen.
 Method Name : settings_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)settings_Action:(id)sender
{
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.strSettingAction = @"networkHome";
        SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [SVC setDelegate:self];
        [Common viewFadeInSettings:self.navigationController.view];
        [self.navigationController pushViewController:SVC animated:NO];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Condition check to navigate back to network home screen
 Method Name : Back_TO_Home_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)Back_TO_Home_Action:(id)sender
{
    if(wheaterTag==0){
        return;
    }else if (wheaterTag==2) {
        [self PropertMap_to_Home];
    }else if (wheaterTag==1){
        [self backtoWeatherHome];
    }
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event display the device alerts
 Method Name : device_View_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)device_View_Action:(id)sender
{
    
    UIButton *btnTag=(UIButton *)sender;
    
    switch (btnTag.tag) {
        case 0:
        {
            [self showSprinklerPopup];
        }
            break;
        case 1:
        {
            [self showLightsPopup];
        }
            break;
        case 2:
        {
            [self showOthersPopup];
        }
            break;
    }
}


-(void)showSprinklerPopup
{
    [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
    [self config_Sprinklers_Widgets];
    deviceActions=@"sprinklers";
    strAlertType=@"AlertsSprinklers";
    vacationModeStatus=@"NO";
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3];
    self.scrollView_SprinklerCard.frame=CGRectMake(self.scrollView_SprinklerCard.frame.origin.x, 20, self.scrollView_SprinklerCard.frame.size.width, self.scrollView_SprinklerCard.frame.size.height);
    [self HideViewOnTouch];
    [self.BodyView_NetworkHome setUserInteractionEnabled:NO];
    [UIView commitAnimations];
    [self performSelectorInBackground:@selector(getAllSpinklerDevices) withObject:self];
    [btn_back_networkHome setUserInteractionEnabled:YES];
    [btn_networkHome_logo setUserInteractionEnabled:NO];
    [btn_settings setUserInteractionEnabled:NO];
    [btnSliderHeader_Bar setUserInteractionEnabled:NO];
    [btnSliderHeader_Image setUserInteractionEnabled:NO];
}

-(void)showWarningPermissionNetwork:(id)sender
{
    [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
}

-(void)swipeDown_Spinkler_PopUp
{
    swipeDownLightsAlert.enabled=YES;
    swipeDownLightsAlert = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown_ToHide_SpinklerAlert:)];
    [swipeDownLightsAlert setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.viewSprinklerAlert addGestureRecognizer:swipeDownLightsAlert];
}

- (void)swipeDown_ToHide_lightsOthersAlert:(UISwipeGestureRecognizer *)swipe {
    [self hideAlertView_LightsOthers];
}

- (void)swipeDown_ToHide_SpinklerAlert:(UISwipeGestureRecognizer *)swipe {
    [self hideAlertView_Sprinklers];
}

- (void)swipeDown_ToHide_Alert:(UISwipeGestureRecognizer *)swipe {
    [self hideAlertView];
}

-(void)ImageClick:(UIButton*)sender
{
    indexValue = sender.tag;
    [self navigate_To_LightDetailView];
}

-(IBAction)addDevice_lights_Other_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"]||[appDelegate.strNetworkPermission isEqualToString:@"3"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    appDelegate.strDevice_Added_Mode=@"NetworkHome";
    DeviceSetUpViewController *devicesetup = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
    devicesetup.strDeviceType = deviceActions;
    [devicesetup setDelegate:self];
    [self.navigationController pushViewController:devicesetup animated:YES];
}

-(IBAction)addDevice_Sprinkler_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Owner==%@",appDelegate.strOwnerNetwork_Status);
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"]||[appDelegate.strNetworkPermission isEqualToString:@"3"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    appDelegate.strDevice_Added_Mode=@"NetworkHome";
    SprinklerDeviceSetupViewController *SDSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SprinklerDeviceSetupViewController"];
    SDSVC.strDeviceType = deviceActions;
    [SDSVC setDelegate:self];
    [self.navigationController pushViewController:SDSVC animated:YES];

}

-(IBAction)manualOff_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Yes
        {
            self.view_manualOffAlert.hidden=YES;
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
//                if([deviceActions isEqualToString:@"sprinklers"]){
//                    [self performSelectorInBackground:@selector(update_SprinklerDeviceStatus) withObject:self];
//                }else{
                    [self performSelectorInBackground:@selector(update_DeviceStatus) withObject:self];
              //  }
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                self.view.userInteractionEnabled=YES;
            }
        }
            break;
        case 1: //Cancel
        {
            self.view_manualOffAlert.hidden=YES;
           // [self popUp_Alpha_NwHome_Disabled];
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            [self resetDeviceCardSwitchOldPos];
        }
            break;
    }
}
-(IBAction)sprinkler_ManualOn_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Yes
        {
            self.view_manualOnAlert.hidden=YES;
           // [self popUp_Alpha_NwHome_Disabled];
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(update_SprinklerDeviceStatus) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                self.view.userInteractionEnabled=YES;
            }
        }
            break;
        case 1: //Cancel
        {
            self.view_manualOnAlert.hidden=YES;
          //  [self popUp_Alpha_NwHome_Disabled];
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            [self resetDeviceCardSwitchOldPos];
        }
            break;
    }
}

-(IBAction)sprinkler_ManualOff_Action:(id)sender
{
    
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            self.view_Sprinkler_manualOffAlert.hidden=YES;
            //[self popUp_Alpha_NwHome_Disabled];
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(update_SprinklerDeviceStatus) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                self.view.userInteractionEnabled=YES;
            }
        }
            break;
        case 1: //Yes
        {
            self.view_Sprinkler_manualOffAlert.hidden=YES;
           // [self popUp_Alpha_NwHome_Disabled];
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(update_SprinklerDeviceStatus) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                self.view.userInteractionEnabled=YES;
            }
        }
            break;
        case 2: //Cancel
        {
            self.view_Sprinkler_manualOffAlert.hidden=YES;
          // [self popUp_Alpha_NwHome_Disabled];
            BodyView_NetworkHome.alpha = 1.0;
            headerView_NetworkHome.alpha=1.0;
            self.titleBarView1_swipe.alpha=1.0;
            [self resetDeviceCardSwitchOldPos];
        }
            break;
    }
}

-(IBAction)sprinklerTapAction:(id)sender
{
    
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            str_Selected_Tap=@"Schedule";
            NSLog(@"%@",str_Selected_Tap);
            NSLog(@"%@",str_Previous_Tap);
            if([str_Selected_Tap isEqualToString:@"Schedule"] && ![str_Previous_Tap isEqualToString:@"Schedule"]){
                str_Previous_Tap=@"Schedule";
                NSLog(@"schedule selected");
                [self start_PinWheel_Lights];
                str_Previous_Tap=str_Selected_Tap;
                [self.viewSprinklerAlert_Device_FooterView setHidden:YES];
                [self.viewSprinklerAlert_DeviceView setHidden:YES];
                [self.viewSprinklerAlert_ScheduleView setHidden:NO];
                [self stop_PinWheel_Lights];

                if(![strStatusSchedule isEqualToString:@"YES"]){
                    [self.viewSprinklerAlert_ScheduleView setHidden:YES];
                    if([Common reachabilityChanged]==YES){
                        [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                        [self performSelectorInBackground:@selector(getZoneScheduleList) withObject:self];
                    }else{
                        [self reset_SprinklerSchedule_Status];
                        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                    }
                }else{
                    [self start_PinWheel_Lights];
                    [self.viewSprinklerAlert_ScheduleView setHidden:NO];
                    [self changeScheduleHeight:yaxis_Schedule];
                    [self.viewSprinklerAlert_Schedule_FooterView setHidden:NO];
                    [self stop_PinWheel_Lights];
                }
                self.tab_ScheduleView.backgroundColor=lblRGBA(135, 197, 65, 1);
                self.tab_DeviceView.backgroundColor=lblRGBA(128, 130, 133, 1);
            }
        }
            break;
        case 1:
        {
            str_Selected_Tap=@"Device";
            if([str_Selected_Tap isEqualToString:@"Device"] && ![str_Previous_Tap isEqualToString:@"Device"]){
                NSLog(@"device selected");
                str_Previous_Tap=@"Device";
                str_Previous_Tap=str_Selected_Tap;
                [self start_PinWheel_Lights];
                [self.viewSprinklerAlert_Schedule_FooterView setHidden:YES];
                [self.viewSprinklerAlert_ScheduleView setHidden:YES];
                [self.viewSprinklerAlert_Device_FooterView setHidden:YES];
                [self stop_PinWheel_Lights];

                self.tab_ScheduleView.backgroundColor=lblRGBA(128, 130, 133, 1);
                self.tab_DeviceView.backgroundColor=lblRGBA(135, 197, 65, 1);

                if(![strStatusDevice isEqualToString:@"YES"]){
                    [self.viewSprinklerAlert_DeviceView setHidden:YES];
                    [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(loadAlertsDatas_Sprinklers) withObject:self];
                }else{
                    [self start_PinWheel_Lights];
                    
                    if(![newVacModeStatus isEqualToString:vacationModeStatus])
                    {
                        NSLog(@"status changed");
                        for (int index=0;index<[arrDevices count];index++){
                            [menuDeviceView[index] removeFromSuperview];
                        }
                        [self stop_PinWheel_Lights];
                        
                        if([Common reachabilityChanged]==YES){
                            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                            [self performSelectorInBackground:@selector(getAllSpinklerDevices) withObject:self];
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                        return;
                    }
                    [self.viewSprinklerAlert_DeviceView setHidden:NO];
                    [self changeDeviceViewHeight:yaxis_Device];
                    [self.viewSprinklerAlert_Device_FooterView setHidden:NO];
                    [self stop_PinWheel_Lights];
                }
            }
        }
            break;
    }
    
}


-(IBAction)refreshWeatherMap_Action:(id)sender
{
    if([Common reachabilityChanged]==YES){
        strWeatherType=@"refresh"; // not need
        [self.logTimer invalidate];
        [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(getWeatherDetails) withObject:self];
//        [self performSelectorInBackground:@selector(refreshWeatherDetails) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // [self dismissModalViewControllerAnimated:YES];//ios 6 or less
    if(([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) | ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight))
    {
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [self.navigationController pushViewController:TLVC animated:NO];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];//ios 7
    NSLog(@"did cancel");
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Edit or delete the property map image
 Method Name : change_delete_Deviceimg_Action_Network_Home(User Defined Methods)
 ************************************************************************************* */
-(IBAction)change_delete_Deviceimg_Action_Network_Home:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"]||[appDelegate.strNetworkPermission isEqualToString:@"3"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                [myAlertView show];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;[self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 2:
            NSLog(@"delete");
            if([Common reachabilityChanged]==YES){
                strEncoded_ControllerImage=@"";
                [self performSelector:@selector(start_PinWheel_Lights) withObject:self afterDelay:0.1];
                [self performSelectorInBackground:@selector(propertyImageUpdate) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            break;
    }
}

-(IBAction)addDevice_propertyMap_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Owner==%@",appDelegate.strOwnerNetwork_Status);
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"]||[appDelegate.strNetworkPermission isEqualToString:@"3"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }

    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Add device
        {
            viewAlert_AddDevice.hidden=NO;
            [self popUp_Alpha_NwHome_Enabled];
            self.titleBarView1_swipe.alpha=0.6;
        }
            break;
        case 1: //close btn
        {
            [self hide_AddDevicePopUp_PropertyMap];
        }
            break;
        case 2: //Sprinkler
        {
            appDelegate.strDevice_Added_Mode=@"NetworkHome";
            [self hide_AddDevicePopUp_PropertyMap];
            SprinklerDeviceSetupViewController *SDSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SprinklerDeviceSetupViewController"];
            SDSVC.strDeviceType =@"sprinklers";
            [SDSVC setDelegate:self];
            [self.navigationController pushViewController:SDSVC animated:YES];
        }
            break;
        case 3: //lights
        {
            appDelegate.strDevice_Added_Mode=@"NetworkHome";
            DeviceSetUpViewController *devicesetup = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
            devicesetup.strDeviceType = @"lights";
            [self hide_AddDevicePopUp_PropertyMap];
            [devicesetup setDelegate:self];
            [self.navigationController pushViewController:devicesetup animated:YES];
        }
            break;
        case 4: //Other
        {
            appDelegate.strDevice_Added_Mode=@"NetworkHome";
            DeviceSetUpViewController *devicesetup = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
            devicesetup.strDeviceType = @"others";
            [self hide_AddDevicePopUp_PropertyMap];
            [devicesetup setDelegate:self];
            [self.navigationController pushViewController:devicesetup animated:YES];
        }
            break;
    }
}

#pragma mark - Image Picker Delegtes
/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Image Saved To Album
 Description : after capture Image/Video its saved to album
 Method Name : hasBeenSavedInPhotoAlbumWithError (Media Picker Delegate Method)
 ************************************************************************************* */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *newImage;
        if (![strEncoded_ControllerImage isEqualToString:@""]) {
            NSArray *pointsArray = [self.mapViewProperty overlays];
            [mapViewProperty removeOverlays:pointsArray];
        }
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *img =  [info objectForKey:UIImagePickerControllerEditedImage];
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
            newImage=img;
            NSData *imageData1 = UIImageJPEGRepresentation(newImage, 1);
            NSLog(@"Size of image = %lu KB",(imageData1.length/1024));
            CGSize size=CGSizeMake(newImage.size.width/8,newImage.size.height/8);
            newImage=[self resizeImagePropertyImgDetails:newImage newSize:size];
            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
            NSLog(@"Size of image = %lu KB",(imageData.length/1024));
        }else{
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            newImage=image;
            NSData *imageData1 = UIImageJPEGRepresentation(newImage, 1);
            NSLog(@"Size of image = %lu KB",(imageData1.length/1024));
            CGSize size=CGSizeMake(newImage.size.width/8,newImage.size.height/8);
            newImage=[self resizeImagePropertyImgDetails:newImage newSize:size];
            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
            NSLog(@"Size of image = %lu KB",(imageData.length/1024));
        }
        NSData* data = UIImageJPEGRepresentation(newImage, 0.3f);
        strEncoded_ControllerImage = [Base64 encode:data];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        if([Common reachabilityChanged]==YES){
            appDelegate.imageNameOverLay=newImage;
            //
            appDelegate.dict_OverlayCoord = [[NSMutableDictionary alloc] init];
            [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",topLeft.latitude] forKey:@"UpperLeftLat"];
            [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",topLeft.longitude] forKey:@"UpperLeftLong"];
            [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",topRight.latitude] forKey:@"UpperRightLat"];
            [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",topRight.longitude] forKey:@"UpperRightLong"];
            [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",bottomLeft.latitude] forKey:@"BottomLeftLat"];
            [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",bottomLeft.longitude] forKey:@"BottomLeftLong"];
            NSLog(@"%@",appDelegate.dict_OverlayCoord);
            
            //
            [self setOverLayImage];
            [deleteProfilebtn setHidden:NO];
            [gallaryProfilebtn setHidden:NO];
            [cameraProfilebtn setHidden:NO];
            [self iconsPositionOrg_PropertyMap];
            [self performSelector:@selector(start_PinWheel_Lights) withObject:self afterDelay:0.1];
            [self performSelectorInBackground:@selector(propertyImageUpdate) withObject:self];
            
        }else{
            strEncoded_ControllerImage=@"";
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
}

- (UIImage *)resizeImagePropertyImgDetails:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Image Saved To Album
 Description : after capture Image/Video its saved to album
 Method Name : hasBeenSavedInPhotoAlbumWithError (Media Picker Delegate Method)
 ************************************************************************************* */
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
//    if (error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo Saving Failed"
//                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Saved" message:@"Saved To Photo Album"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}
-(void)setOverLayImage
{
    MapOverlay * mapOverlay = [[MapOverlay alloc] init];
    [mapOverlay coordinate:newCoordianteOverlay];
    [self.mapViewProperty addOverlay:mapOverlay];
//    self.mapViewProperty.zoomEnabled=NO;
}

#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.tbleView_ScheduleSprinklers];
    CGPoint contentOffset = self.tbleView_ScheduleSprinklers.contentOffset;
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    [self.tbleView_ScheduleSprinklers setContentOffset:contentOffset animated:YES];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [self.tbleView_ScheduleSprinklers indexPathForCell:cell];
        [self.tbleView_ScheduleSprinklers scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    }
    return YES;
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the return button on the keyboard is clicked
 Method Name : textFieldShouldReturn(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark - User Defined Methods
-(void)drawerSetUP{
    [self.sidebarButton addTarget:self.revealViewController action:@selector(revealToggle:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.btnSliderHeader_Bar addTarget:self.revealViewController action:@selector(revealToggle:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.btn_back_networkHome addTarget:self.revealViewController action:@selector(revealToggle:)
                        forControlEvents:UIControlEventTouchUpInside];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : initial flag setup for the network home screen
 Method Name : flagSetupNetwork_Home(User Defined Methods)
 ************************************************************************************* */
-(void)flagSetupNetwork_Home
{
    sprinkler_On_Count=0;
    currentWeather_tag=0;
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    defaults=[NSUserDefaults standardUserDefaults];
   // footView=[[defaults objectForKey:@"FOOTVIEW"] doubleValue];
    //NSLog(@"%f",footView);
    
    if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID] isEqualToString:[defaults objectForKey:@"ACTIVENETWORKID"]])
    {
        footView=[[defaults objectForKey:@"FOOTVIEW"] doubleValue];
    }else{
        footView=500;
        [defaults setObject:@"500" forKey:@"FOOTVIEW"];
        [defaults setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID] forKey:@"ACTIVENETWORKID"];
        [defaults synchronize];
    }
    
    strLoaderViewStatus=@"YES";
    [BodyView_Weather setHidden:YES];
    [BodyView_PropertyMap setHidden:YES];
    wheaterTag=0;
    yOffset = 0.0;
    
    [popUpScheduleView setHidden:YES];
    [view_infoAlert setHidden:YES];
    vacationModeStatus=@"YES";
    
//    str_Selected_Tap=@"Schedule";
//    str_Previous_Tap=@"Schedule";
    str_Selected_Tap=@"Device";
    str_Previous_Tap=@"Device";

    strWeatherType=@"";

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strNetworkDrawer_Status=@"YES";
    strLoadedStatus=@"YES";
    view_manualOffAlert.hidden=YES;
    appDelegate.strNetworkAddedStatus=@"";
    appDelegate.strPaymentActive=@"";
    appDelegate.strEdit_Controller_DeviceStatus=@"";
    strUpdatedLat=@"0";
    strUpdatedLong=@"0";
    strEncoded_ControllerImage=@"";
    viewAlert_AddDevice.hidden=YES;
    strzoneModeStatus=@"";
    vacationModeStatus=@"NO";
    newVacModeStatus=@"NO";
    view_Sprinkler_manualOffAlert.hidden=YES;
    view_manualOnAlert.hidden=YES;
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : pop back to the multiple network screen
 Method Name : popToMultipleNetwork(User Defined Methods)
 ************************************************************************************* */
-(void)popToMultipleNetwork
{
    for (UIViewController *controller in [self.navigationController viewControllers])
    {
        if ([controller isKindOfClass:[MultipleNetworkViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Remove the tap gesture action
 Method Name : tapGusterSetup(User Defined Methods)
 ************************************************************************************* */
-(void)tapGusterSetup{
    [self.BodyView_Container removeGestureRecognizer:tapViewContainer];
    [self.headerView_NetworkHome removeGestureRecognizer:tapViewHeader];
    [self.titleBarView1_swipe removeGestureRecognizer:tapViewTitle];
    //need to remove tap guster for scrollview and scrolllview
    if([strAlertType isEqualToString:@"AlertsMSG"]){
        [self.scrollView_Alert removeGestureRecognizer:tapScrollView];
        [self.view_alert removeGestureRecognizer:tapViewAlert];
    }
    else if([strAlertType isEqualToString:@"AlertsLights"]||[strAlertType isEqualToString:@"AlertsOthers"]){
        [self.scroll_View_LightsCard removeGestureRecognizer:tapScrollView];
        [self.ViewLightDevice removeGestureRecognizer:tapViewAlert];
    }
    else if([strAlertType isEqualToString:@"AlertsSprinklers"]){
        [self.scrollView_SprinklerCard removeGestureRecognizer:tapScrollView];
        [self.viewSprinklerAlert removeGestureRecognizer:tapViewAlert];
    }
}
/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Calls the tap gesture for hiding the alert view when user clicks outside the view
 Method Name : HideViewOnTouch(User Defined Method)
 ************************************************************************************* */
-(void)HideViewOnTouch
{
    tapViewContainer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActions:)];
    [self.BodyView_Container addGestureRecognizer:tapViewContainer];
    tapViewHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionsHeader:)];
    [self.headerView_NetworkHome addGestureRecognizer:tapViewHeader];
    tapViewTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionsTitleBar:)];
    [self.titleBarView1_swipe addGestureRecognizer:tapViewTitle];
    
    if([strAlertType isEqualToString:@"AlertsMSG"]){
        tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionsScrollView:)];
        [self.scrollView_Alert addGestureRecognizer:tapScrollView];
        tapViewAlert = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionAlertView:)];
        [self.view_alert addGestureRecognizer:tapViewAlert];
    }
    else if([strAlertType isEqualToString:@"AlertsLights"]||[strAlertType isEqualToString:@"AlertsOthers"]){
        tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionsScrollView:)];
        [self.scroll_View_LightsCard addGestureRecognizer:tapScrollView];
        tapViewAlert = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionAlertView:)];
        [self.ViewLightDevice addGestureRecognizer:tapViewAlert];
    }
    else if([strAlertType isEqualToString:@"AlertsSprinklers"]){
        tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionsScrollView:)];
        [self.scrollView_SprinklerCard addGestureRecognizer:tapScrollView];
        tapViewAlert = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapActionAlertView:)];
        [self.viewSprinklerAlert addGestureRecognizer:tapViewAlert];
    }
}


/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Hides the alert view when user clicks anywhere outside the alert view.
 Method Name : ViewTapActionsEcontacts(User Defined Method)
 ************************************************************************************* */
-(void)ViewTapActions:(UITapGestureRecognizer *)recognizer
{
    [self hidePopUPS];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Hides the alert view when user clicks anywhere outside the alert view.
 Method Name : ViewTapActionsHeader(User Defined Methods)
 ************************************************************************************* */
-(void)ViewTapActionsHeader:(UITapGestureRecognizer *)recognizer
{
    [self hidePopUPS];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Hides the alert view when user clicks anywhere outside the alert view.
 Method Name : ViewTapActionsTitleBar(User Defined Methods)
 ************************************************************************************* */
-(void)ViewTapActionsTitleBar:(UITapGestureRecognizer *)recognizer
{
    [self hidePopUPS];
}

-(void)ViewTapActionsScrollView:(UITapGestureRecognizer *)recognizer
{
    [self hidePopUPS];
}

-(void)ViewTapActionAlertView:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"view touch");
}



-(void)hidePopUPS{
    if([strAlertType isEqualToString:@"AlertsMSG"]){
        [self hideAlertView];
    }else if([strAlertType isEqualToString:@"AlertsLights"]||[strAlertType isEqualToString:@"AlertsOthers"]){
        [self hideAlertView_LightsOthers];
    }else if([strAlertType isEqualToString:@"AlertsSprinklers"]){
        [self hideAlertView_Sprinklers];
    }
}

/* *********************************************************************************
 Date : 23/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description :sliding to multiplenetwork
 Method Name :Drawer_NetworkHomeAction(User Defined Methods)
 ************************************************************************************ */
-(void)Drawer_NetworkHomeAction{
    [UIView animateWithDuration:0.5 animations:^{
        MultipleNetworkViewController *MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        [Common viewSlide_FromLeft_ToRight:self.navigationController.view];
        [self.navigationController pushViewController:MNVC animated:NO];
    }];
}


#pragma mark - Weather SetUp
/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Weather Tap gesture action
 Method Name : weatherTap_Configuration(User Defined Methods)
 ************************************************************************************* */
-(void)weatherTap_Configuration{
    TapView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap1Actions:)];
    [self.view_Weather1 addGestureRecognizer:TapView1];
    TapView2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap2Actions:)];
    [self.view_Weather2 addGestureRecognizer:TapView2];
    TapView3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap3Actions:)];
    [self.view_Weather3 addGestureRecognizer:TapView3];
    TapView4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap4Actions:)];
    [self.view_Weather4 addGestureRecognizer:TapView4];
    TapView5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap5Actions:)];
    [self.view_Weather5 addGestureRecognizer:TapView5];
    TapView6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap6Actions:)];
    [self.view_Weather6 addGestureRecognizer:TapView6];
    TapView7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap7Actions:)];
    [self.view_Weather7 addGestureRecognizer:TapView7];
    TapView8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTap8Actions:)];
    [self.view_Weather8 addGestureRecognizer:TapView8];
    TapChangeWeather = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewWeatherAction:)];
    [self.view_changeWeather addGestureRecognizer:TapChangeWeather];
}

-(void)currentWeatherView
{
    view_Weather1.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 0;
    [self parseWeatherImage:currentWeather_tag];
}

-(void)ViewTap1Actions:(UITapGestureRecognizer *)recognizer
{
    [self currentWeatherView];
    
//    view_Weather1.backgroundColor=lblRGBA(136, 197, 65, 1);
//    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
//    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
//    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
//    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
//    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
//    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
//    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
//    lbl_temp1.textColor = lblRGBA(194, 222, 156, 1);
//    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
//    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
//    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
//    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
//    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
//    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
//    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
//    currentWeather_tag = 0;
//    [self parseWeatherImage:currentWeather_tag];

}

-(void)ViewTap2Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 1;
    [self parseWeatherImage:currentWeather_tag];
}

-(void)ViewTap3Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 2;
    [self parseWeatherImage:currentWeather_tag];
}
-(void)ViewTap4Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 3;
    [self parseWeatherImage:currentWeather_tag];
}
-(void)ViewTap5Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 4;
    [self parseWeatherImage:currentWeather_tag];
}
-(void)ViewTap6Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 5;
    [self parseWeatherImage:currentWeather_tag];
}
-(void)ViewTap7Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(136, 197, 65, 1);
    view_Weather8.backgroundColor=lblRGBA(40, 165, 222, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(194, 222, 156, 1);
    lbl_temp8.textColor = lblRGBA(158, 203, 237, 1);
    
    currentWeather_tag = 6;
    [self parseWeatherImage:currentWeather_tag];
}
-(void)ViewTap8Actions:(UITapGestureRecognizer *)recognizer
{
    view_Weather1.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather2.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather3.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather4.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather5.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather6.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather7.backgroundColor=lblRGBA(40, 165, 222, 1);
    view_Weather8.backgroundColor=lblRGBA(136, 197, 65, 1);
    lbl_temp1.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp2.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp3.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp4.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp5.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp6.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp7.textColor = lblRGBA(158, 203, 237, 1);
    lbl_temp8.textColor = lblRGBA(194, 222, 156, 1);
    
    currentWeather_tag = 7;
    [self parseWeatherImage:currentWeather_tag];
}

-(void)ViewWeatherAction:(UITapGestureRecognizer *)recognizer{
    [self backtoWeatherHome];
}

/* **********************************************************************************
 Date : 30/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: ScrollView Configuration
 Description : The scrollView content size is set for all screens
 Method Name : ScrollView_Configuration_Weather(User Defined Method)
 ************************************************************************************* */
-(void)ScrollView_Configuration_Weather
{
    scrollView_weather .showsHorizontalScrollIndicator=NO;
    scrollView_weather.showsVerticalScrollIndicator=NO;
    scrollView_weather.scrollEnabled=YES;
    scrollView_weather.userInteractionEnabled=YES;
    scrollView_weather.delegate=self;
    scrollView_weather.contentSize=CGSizeMake(self.scrollView_weather.contentSize.width, 500);
}


/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Nvigates to network home screen from the weather screen
 Method Name : backtoWeatherHome(User Defined Methods)
 ************************************************************************************* */
-(void)backtoWeatherHome{
    
    //org 0.5
    [UIView transitionWithView:self.BodyView_Container
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [BodyView_NetworkHome setHidden:NO];
                        [self.BodyView_Container addSubview:BodyView_NetworkHome];
                        [BodyView_Weather setHidden:YES];
                        [BodyView_PropertyMap setHidden:YES];
                        wheaterTag=0;
                    }
                    completion:NULL];
//    [self.logTimer invalidate];
}

#pragma mark - Alert/Message Popup SetUp
-(void)loadAlertsDatas{
    float x_OffsetAlerts=0,h_OffsetAlerts,yOffsetAlerts;
    
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        h_OffsetAlerts=42,yOffsetAlerts=22.0;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        h_OffsetAlerts=44,yOffsetAlerts=30.0;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        h_OffsetAlerts=44,yOffsetAlerts=26.0;
    }
    @try {
        for(int alertIndex=0;alertIndex<[arrAlerts count];alertIndex++){
            NSLog(@"array value is ==%@",arrAlerts);
            NSLog(@"array value is indi ==%@",[arrAlerts objectAtIndex:alertIndex]);
            menuView[alertIndex]=[[UIView alloc] init];
            menuView[alertIndex].frame=CGRectMake(x_OffsetAlerts, yOffsetAlerts,self.view_alert.frame.size.width,h_OffsetAlerts);
            menuView[alertIndex].backgroundColor=[UIColor clearColor];
            menuView[alertIndex].tag=alertIndex;
            [self.view_alert addSubview:menuView[alertIndex]];
            
            menuTapView[alertIndex]=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                menuTapView[alertIndex].frame=CGRectMake(0,0 ,menuView[alertIndex].frame.size.width,42);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                menuTapView[alertIndex].frame=CGRectMake(0,0 ,menuView[alertIndex].frame.size.width,44);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                menuTapView[alertIndex].frame=CGRectMake(0,0 ,menuView[alertIndex].frame.size.width,44);
            }
            menuTapView[alertIndex].backgroundColor=[UIColor clearColor];
            menuTapView[alertIndex].tag=alertIndex;
            [menuView[alertIndex] addSubview:menuTapView[alertIndex]];
            
            UITapGestureRecognizer *tapGestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandAlert_View_onClick:)];
            [menuTapView[alertIndex] addGestureRecognizer:tapGestureView];
            [menuTapView[alertIndex] setExclusiveTouch:YES];
            
            
            lblMsgAlert[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblMsgAlert[alertIndex].frame=CGRectMake(10, 0, 158, 42);
                [lblMsgAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblMsgAlert[alertIndex].frame=CGRectMake(8, 0, 238, 42);
                [lblMsgAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblMsgAlert[alertIndex].frame=CGRectMake(8, 0, 213, 44);
                [lblMsgAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }
            [lblMsgAlert[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            lblMsgAlert[alertIndex].numberOfLines=2;
            lblMsgAlert[alertIndex].text =[NSString stringWithFormat:@"%@",[[arrAlerts objectAtIndex:alertIndex] valueForKey:kMessageSub]];
            if([[[arrAlerts objectAtIndex:alertIndex] valueForKey:kMessageStatus] isEqualToString:@"read"])
            {
                menuView[alertIndex].alpha=0.6;
            }
            [menuView[alertIndex] addSubview:lblMsgAlert[alertIndex]];
            
            
            NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrAlerts objectAtIndex:alertIndex] valueForKey:kMessageTime]] doubleValue];
            NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_User]];
            NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];
            [dateFormatter setDateFormat:[Common GetCurrentDateFormat]];
            NSString *timeDate = [dateFormatter stringFromDate:epochNSDate];
            NSLog(@"Your local date is: %@", timestamp);
            
            lblDateAlert[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblDateAlert[alertIndex].frame=CGRectMake(183, 0, 67, 42);
                [lblDateAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblDateAlert[alertIndex].frame=CGRectMake(258, 0, 76, 42);
                [lblDateAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblDateAlert[alertIndex].frame=CGRectMake(223, 0, 75, 42);
                [lblDateAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }
            [lblDateAlert[alertIndex] setTextColor:lblRGBA(255, 255, 255, 1)];
            lblDateAlert[alertIndex].text =timeDate;
            [menuView[alertIndex] addSubview:lblDateAlert[alertIndex]];
            
            lbl_viewAlert[alertIndex]=[[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lbl_viewAlert[alertIndex].font=[UIFont fontWithName:@"NexaBold" size:9];
                lbl_viewAlert[alertIndex].frame = CGRectMake(262,0,40.0, 42.0);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lbl_viewAlert[alertIndex].font=[UIFont fontWithName:@"NexaBold" size:9];
                lbl_viewAlert[alertIndex].frame = CGRectMake(346,0,40.0, 42.0);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lbl_viewAlert[alertIndex].font=[UIFont fontWithName:@"NexaBold" size:10];
                lbl_viewAlert[alertIndex].frame = CGRectMake(304,0,40.0, 42.0);
            }
            lbl_viewAlert[alertIndex].textColor = lblRGBA(136, 197, 65, 1);
            lbl_viewAlert[alertIndex].text = @"VIEW";
            lbl_viewAlert[alertIndex].textAlignment = NSTextAlignmentCenter;
            [menuView[alertIndex] addSubview:lbl_viewAlert[alertIndex]];
            
            UIImageView *imgViewDivier=[[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgViewDivier.frame=CGRectMake(0, 41,menuView[alertIndex].frame.size.width, 1);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgViewDivier.frame=CGRectMake(0, 43,menuView[alertIndex].frame.size.width, 1);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgViewDivier.frame=CGRectMake(0, 43,menuView[alertIndex].frame.size.width, 1);
            }
            imgViewDivier.image=[UIImage imageNamed:@"dottedLine_image"];
            [menuView[alertIndex] addSubview:imgViewDivier];
            
            yOffsetAlerts=menuView[alertIndex].frame.size.height+menuView[alertIndex].frame.origin.y;
        }
        
        NSLog(@"y==%f",yOffsetAlerts);
        
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            if (yOffsetAlerts>274)
            {
                self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width, yOffsetAlerts+10);
                swipeDownAlert.enabled=NO;
            }
            else{
                self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width,274);
                [self swipeDown_Alert_PopUp];
            }
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            if (yOffsetAlerts>339)
            {
                self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width, yOffsetAlerts+10);
                swipeDownAlert.enabled=NO;
            }
            else{
                self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width,339);
                [self swipeDown_Alert_PopUp];
            }
            
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            if (yOffsetAlerts>309)
            {
                self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width, yOffsetAlerts+10);
                swipeDownAlert.enabled=NO;
            }
            else{
                self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width,340);
                [self swipeDown_Alert_PopUp];
            }
        }
        
        //Alert Scroll Setup
        self.scrollView_Alert.contentSize = CGSizeMake(scrollView_Alert.contentSize.width, self.view_alert.frame.origin.y+self.view_alert.frame.size.height);
        self.view_alert.layer.cornerRadius = 16.0;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    [self stop_PinWheel_Lights];
}

-(void)myAction:(UIButton *)sender
{
    
}

-(void)parseMessageExpandWidget
{
    @try {
        if (cellExpandStatusAlert==YES) {
            self.view.userInteractionEnabled=NO;
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 212);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 283);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 264);
                }
                menuView[viewCurrent.tag].backgroundColor=lblRGBA(77, 77, 79, 1);
                yOffSet_Content_Alert=menuView[viewCurrent.tag].frame.origin.y+menuView[viewCurrent.tag].frame.size.height;
                NSLog(@"y==%f",yOffSet_Content_Alert);
                for (int index=0;index<[arrAlerts count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }
                        yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                    }
                }
                viewTagValueAlert=viewCurrent.tag;
                [self scroll_AlertMsg_SetUp:yOffSet_Content_Alert];
            } completion:^(BOOL finished) {
                [self alertMsg_AddWidget:tag_Pos_Alerts];
                lbl_viewAlert[viewTagValueAlert].text = @"CLOSE";
                cellExpandStatusAlert=NO;
                self.view.userInteractionEnabled=YES;
            }];
        }
        else{
            self.view.userInteractionEnabled=NO;
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menuView[viewTagValueAlert].frame=CGRectMake(0, menuView[viewTagValueAlert].frame.origin.y, menuView[viewTagValueAlert].frame.size.width, 42);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menuView[viewTagValueAlert].frame=CGRectMake(0, menuView[viewTagValueAlert].frame.origin.y, menuView[viewTagValueAlert].frame.size.width, 44);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    menuView[viewTagValueAlert].frame=CGRectMake(0, menuView[viewTagValueAlert].frame.origin.y, menuView[viewTagValueAlert].frame.size.width, 44);
                }
                menuView[viewTagValueAlert].backgroundColor=[UIColor clearColor];
                yOffSet_Content_Alert=menuView[viewTagValueAlert].frame.origin.y+menuView[viewTagValueAlert].frame.size.height;
                lbl_viewAlert[viewTagValueAlert].text = @"VIEW";
                [view_AlertMsg_ContentView[viewTagValueAlert] setHidden:YES];
                [view_AlertMsg_ContentView[viewTagValueAlert] removeFromSuperview];
                for (int index=0;index<[arrAlerts count];index++){
                    if (index>viewTagValueAlert) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }
                        yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                    }
                }
                
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 212);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 283);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 264);
                }
                menuView[viewCurrent.tag].backgroundColor=lblRGBA(77, 77, 79, 1);
                yOffSet_Content_Alert=menuView[viewCurrent.tag].frame.origin.y+menuView[viewCurrent.tag].frame.size.height;
                for (int index=0;index<[arrAlerts count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }
                        yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                    }
                }
                viewTagValueAlert=viewCurrent.tag;
                [self scroll_AlertMsg_SetUp:yOffSet_Content_Alert];
            } completion:^(BOOL finished) {
                [self alertMsg_AddWidget:tag_Pos_Alerts];
                lbl_viewAlert[viewTagValueAlert].text = @"CLOSE";
                self.view.userInteractionEnabled=YES;
                cellExpandStatusAlert=NO;
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
    
}

- (void)expandAlert_View_onClick:(UITapGestureRecognizer*)sender {
    viewCurrent = sender.view;
    tag_Pos_Alerts=(int)viewCurrent.tag;
    NSLog(@"tag==%ld",(long)viewCurrent.tag);
    @try {
        if (cellExpandStatusAlert==YES) {
            if([[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageStatus] isEqualToString:@"unread"])
            {
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(updateStatusRead) withObject:self];
                return;
            }
            self.view.userInteractionEnabled=NO;
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 212);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 283);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 264);
                }
                menuView[viewCurrent.tag].backgroundColor=lblRGBA(77, 77, 79, 1);
                yOffSet_Content_Alert=menuView[viewCurrent.tag].frame.origin.y+menuView[viewCurrent.tag].frame.size.height;
                NSLog(@"y==%f",yOffSet_Content_Alert);
                for (int index=0;index<[arrAlerts count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                        }
                        yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                    }
                }
                viewTagValueAlert=viewCurrent.tag;
                [self scroll_AlertMsg_SetUp:yOffSet_Content_Alert];
            } completion:^(BOOL finished) {
                [self alertMsg_AddWidget:tag_Pos_Alerts];
                lbl_viewAlert[viewTagValueAlert].text = @"CLOSE";
                cellExpandStatusAlert=NO;
                self.view.userInteractionEnabled=YES;
            }];
        }else{
            if (viewTagValueAlert==viewCurrent.tag) {
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 42);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 44);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                        menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 44);
                    }
                    menuView[viewCurrent.tag].backgroundColor=[UIColor clearColor];
                    yOffSet_Content_Alert=menuView[viewCurrent.tag].frame.origin.y+menuView[viewCurrent.tag].frame.size.height;
                    for (int index=0;index<[arrAlerts count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                            }
                            yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                        }
                    }
                    [self scroll_AlertMsg_SetUp:yOffSet_Content_Alert];
                    lbl_viewAlert[viewTagValueAlert].text = @"VIEW";
                    [view_AlertMsg_ContentView[viewCurrent.tag] setHidden:YES];
                    [view_AlertMsg_ContentView[viewCurrent.tag] removeFromSuperview];
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatusAlert=YES;
                }];
            }else{
                if([[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageStatus] isEqualToString:@"unread"])
                {
                    [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                    [self performSelectorInBackground:@selector(updateStatusRead) withObject:self];
                    return;
                }
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuView[viewTagValueAlert].frame=CGRectMake(0, menuView[viewTagValueAlert].frame.origin.y, menuView[viewTagValueAlert].frame.size.width, 42);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuView[viewTagValueAlert].frame=CGRectMake(0, menuView[viewTagValueAlert].frame.origin.y, menuView[viewTagValueAlert].frame.size.width, 44);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                        menuView[viewTagValueAlert].frame=CGRectMake(0, menuView[viewTagValueAlert].frame.origin.y, menuView[viewTagValueAlert].frame.size.width, 44);
                    }
                    menuView[viewTagValueAlert].backgroundColor=[UIColor clearColor];
                    yOffSet_Content_Alert=menuView[viewTagValueAlert].frame.origin.y+menuView[viewTagValueAlert].frame.size.height;
                    lbl_viewAlert[viewTagValueAlert].text = @"VIEW";
                    [view_AlertMsg_ContentView[viewTagValueAlert] setHidden:YES];
                    [view_AlertMsg_ContentView[viewTagValueAlert] removeFromSuperview];
                    for (int index=0;index<[arrAlerts count];index++){
                        if (index>viewTagValueAlert) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                            }
                            yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                        }
                    }
                    
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 212);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 283);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                        menuView[viewCurrent.tag].frame = CGRectMake(0, menuView[viewCurrent.tag].frame.origin.y, menuView[viewCurrent.tag].frame.size.width, 264);
                    }
                    menuView[viewCurrent.tag].backgroundColor=lblRGBA(77, 77, 79, 1);
                    yOffSet_Content_Alert=menuView[viewCurrent.tag].frame.origin.y+menuView[viewCurrent.tag].frame.size.height;
                    for (int index=0;index<[arrAlerts count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 42);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                                menuView[index].frame = CGRectMake(0,yOffSet_Content_Alert, menuView[index].frame.size.width, 44);
                            }
                            yOffSet_Content_Alert=menuView[index].frame.origin.y+menuView[index].frame.size.height;
                        }
                    }
                    viewTagValueAlert=viewCurrent.tag;
                    [self scroll_AlertMsg_SetUp:yOffSet_Content_Alert];
                } completion:^(BOOL finished) {
                    [self alertMsg_AddWidget:tag_Pos_Alerts];
                    lbl_viewAlert[viewTagValueAlert].text = @"CLOSE";
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatusAlert=NO;
                }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}
-(void)scroll_AlertMsg_SetUp:(float)yAxis
{
    //    view_alert.frame=CGRectMake(view_alert.frame.origin.x, view_alert.frame.origin.y, view_alert.frame.size.width, yAxis);
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        if (yAxis>274)
        {
            self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width, yAxis+10);
            swipeDownAlert.enabled=NO;
        }
        else{
            self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width,274);
            [self swipeDown_Alert_PopUp];
        }
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        if (yAxis>339)
        {
            self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width, yAxis+10);
            swipeDownAlert.enabled=NO;
        }
        else{
            self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width,339);
            [self swipeDown_Alert_PopUp];
        }
        
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        if (yAxis>309)
        {
            self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width, yAxis+10);
            swipeDownAlert.enabled=NO;
        }
        else{
            self.view_alert.frame=CGRectMake(self.view_alert.frame.origin.x, self.view_alert.frame.origin.y, self.view_alert.frame.size.width,340);
            [self swipeDown_Alert_PopUp];
        }
        
    }
    
    scrollView_Alert.contentSize = CGSizeMake(scrollView_Alert.contentSize.width, view_alert.frame.origin.y+view_alert.frame.size.height);
}

-(void)alertMsg_AddWidget:(int)tag
{
    @try {
        view_AlertMsg_ContentView[tag]=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_AlertMsg_ContentView[tag].frame = CGRectMake(0, 42, view_alert.frame.size.width, 170);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_AlertMsg_ContentView[tag].frame = CGRectMake(0, 44, view_alert.frame.size.width, 239);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_AlertMsg_ContentView[tag].frame = CGRectMake(0, 44, view_alert.frame.size.width, 220);
        }
        view_AlertMsg_ContentView[tag].backgroundColor=lblRGBA(77, 77, 79, 1);
        [menuView[tag] addSubview:view_AlertMsg_ContentView[tag]];
        
        UIView *view_divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_AlertMsg_ContentView[tag].frame.size.width, 1)];
        view_divider.backgroundColor = lblRGBA(99, 99, 102, 1);
        [view_AlertMsg_ContentView[tag] addSubview:view_divider];
        
        UILabel *lbl_Subject = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Subject.frame = CGRectMake(0, 20, view_AlertMsg_ContentView[tag].frame.size.width, 63);
            lbl_Subject.font = [UIFont fontWithName:@"NexaBold" size:13];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Subject.frame = CGRectMake(0, 36, view_AlertMsg_ContentView[tag].frame.size.width, 63);
            lbl_Subject.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lbl_Subject.frame = CGRectMake(0, 33, view_AlertMsg_ContentView[tag].frame.size.width, 63);
            lbl_Subject.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lbl_Subject.textColor = [UIColor whiteColor];
        lbl_Subject.textAlignment = NSTextAlignmentCenter;
        lbl_Subject.numberOfLines=3;
        lbl_Subject.text = [[arrAlerts objectAtIndex:tag] valueForKey:kMessageDesc];
        [view_AlertMsg_ContentView[tag] addSubview:lbl_Subject];
        
        if ([strAlertType isEqualToString:@"Alerts"]) {
            UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnClose setImage:[UIImage imageNamed:@"bigClose_imagei6plus"] forState:UIControlStateNormal];
            [btnClose setTag:tag];
            //        [btnClose addTarget:self action:@selector(close_Controller_Action:) forControlEvents:UIControlEventTouchUpInside];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnClose.frame = CGRectMake(119, 54, 27, 26);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnClose.frame = CGRectMake(154, 84, 38, 38);
            }else{
                btnClose.frame = CGRectMake(138, 76, 35, 35);
            }
            [view_AlertMsg_ContentView[tag] addSubview:btnClose];
            
            UIButton *btnTick = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnTick setImage:[UIImage imageNamed:@"ok_iconi6plus"] forState:UIControlStateNormal];
            [btnTick setTag:tag];
            //        [btnTick addTarget:self action:@selector(close_Controller_Action:) forControlEvents:UIControlEventTouchUpInside];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnTick.frame = CGRectMake(157, 54, 27, 26);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnTick.frame = CGRectMake(200, 84, 38, 38);
            }else{
                btnTick.frame = CGRectMake(181, 76, 35, 35);
            }
            [view_AlertMsg_ContentView[tag] addSubview:btnTick];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception draw Contentview ==%@",exception.description);
    }
}

-(void)alertViewSetup
{
    alertFooter.hidden=YES;
    scrollView_Alert .showsHorizontalScrollIndicator=NO;
    scrollView_Alert.showsVerticalScrollIndicator=NO;
    scrollView_Alert.scrollEnabled=YES;
    scrollView_Alert.userInteractionEnabled=YES;
    scrollView_Alert.delegate=self;
}

-(void)swipeDown_Alert_PopUp
{
    swipeDownAlert.enabled=YES;
    swipeDownAlert = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown_ToHide_Alert:)];
    [swipeDownAlert setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view_alert addGestureRecognizer:swipeDownAlert];
}

/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click even hides the alert view
 Method Name : hideAlertView(View Delegate Methods)
 ************************************************************************************* */
-(void)hideAlertView
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self resetAlertsFrames];
    } completion:^(BOOL finished) {
        [self.BodyView_NetworkHome setUserInteractionEnabled:YES];
    }];
}

-(void)resetAlertsFrames{
    scrollView_Alert.frame  = CGRectMake(scrollView_Alert.frame.origin.x, 1500,scrollView_Alert.frame.size.width,scrollView_Alert.frame.size.height);
    scrollView_Alert.contentOffset = CGPointMake(0, 0);
    for (int index=0;index<[arrAlerts count];index++){
        [menuView[index] removeFromSuperview];
    }
    [btn_back_networkHome setUserInteractionEnabled:YES];
    [btn_networkHome_logo setUserInteractionEnabled:YES];
    [btn_settings setUserInteractionEnabled:YES];
    [btnSliderHeader_Bar setUserInteractionEnabled:YES];
    [btnSliderHeader_Image setUserInteractionEnabled:YES];
    [self tapGusterSetup];
    strAlertType=@"";
}


#pragma mark - Lights/Other PopUp SetUP
-(void)alertViewSetupLights{
    viewLightsCard_FooterView.hidden=YES;
    scroll_View_LightsCard .showsHorizontalScrollIndicator=NO;
    scroll_View_LightsCard.showsVerticalScrollIndicator=NO;
    scroll_View_LightsCard.scrollEnabled=YES;
    scroll_View_LightsCard.userInteractionEnabled=YES;
    scroll_View_LightsCard.delegate=self;
}

-(void)resetAlertsFramesLightsCards{
    scroll_View_LightsCard.frame  = CGRectMake(scroll_View_LightsCard.frame.origin.x, 1500,scroll_View_LightsCard.frame.size.width,scroll_View_LightsCard.frame.size.height);
    for (int index=0;index<[arrDevices count];index++){
        [menuDeviceView[index] removeFromSuperview];
    }
    scroll_View_LightsCard.contentOffset = CGPointMake(0, 0);
    [btn_back_networkHome setUserInteractionEnabled:YES];
    [btn_networkHome_logo setUserInteractionEnabled:YES];
    [btn_settings setUserInteractionEnabled:YES];
    [btnSliderHeader_Bar setUserInteractionEnabled:YES];
    [btnSliderHeader_Image setUserInteractionEnabled:YES];
    [self tapGusterSetup];
    strAlertType=@"";
}

-(void)showLightsPopup
{
    [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
    deviceActions=@"lights";
    strAlertType=@"AlertsLights";
    lblDeviceType.text = @"LIGHTS";
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3];
    scroll_View_LightsCard.frame  = CGRectMake(scroll_View_LightsCard.frame.origin.x, 20,scroll_View_LightsCard.frame.size.width,scroll_View_LightsCard.frame.size.height);
    [self HideViewOnTouch];
    [self.BodyView_NetworkHome setUserInteractionEnabled:NO];
    [UIView commitAnimations];
    viewLightsCard_FooterView.backgroundColor = lblRGBA(255, 206, 52, 1);
    [self alertViewSetupLights];
    
    imgDeviceType.frame = CGRectMake(15, 32, 25, 25);
    imgDeviceType.image = [UIImage imageNamed:@"lights_imagei6plus"];
    
    [self performSelectorInBackground:@selector(getAllNOID_Devices) withObject:self];
    [btn_back_networkHome setUserInteractionEnabled:NO];
    [btn_networkHome_logo setUserInteractionEnabled:NO];
    [btn_settings setUserInteractionEnabled:NO];
    [btnSliderHeader_Bar setUserInteractionEnabled:NO];
    [btnSliderHeader_Image setUserInteractionEnabled:NO];
}
-(void)showOthersPopup
{
    [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
    deviceActions=@"others";
    strAlertType=@"AlertsOthers";
    lblDeviceType.text = @"OTHER";
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3];
    scroll_View_LightsCard.frame  = CGRectMake(scroll_View_LightsCard.frame.origin.x, 20,scroll_View_LightsCard.frame.size.width,scroll_View_LightsCard.frame.size.height);
    [self HideViewOnTouch];
    [self.BodyView_NetworkHome setUserInteractionEnabled:NO];
    [UIView commitAnimations];
    viewLightsCard_FooterView.backgroundColor = lblRGBA(49, 165, 222, 1);
    [self alertViewSetupLights];
    imgDeviceType.frame = CGRectMake(15, 32, 25, 25);
    imgDeviceType.image = [UIImage imageNamed:@"others_imagei6plus"];
    [self performSelectorInBackground:@selector(getAllNOID_Devices) withObject:self];
    [btn_back_networkHome setUserInteractionEnabled:NO];
    [btn_networkHome_logo setUserInteractionEnabled:NO];
    [btn_settings setUserInteractionEnabled:NO];
    [btnSliderHeader_Bar setUserInteractionEnabled:NO];
    [btnSliderHeader_Image setUserInteractionEnabled:NO];
}

-(void)rendering_LightsOthers_Card
{
    float x_OffsetAlerts=0,h_OffsetAlerts,yOffset_Lights;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        h_OffsetAlerts=57,yOffset_Lights = 65.0;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        h_OffsetAlerts=74,yOffset_Lights = 73.0;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        h_OffsetAlerts=66,yOffset_Lights = 65.0;
    }
    
#define REC_POSTUSER_IMG_TAG 999
    @try {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        for(int alertIndex=0;alertIndex<[arrDevices count];alertIndex++){
            NSLog(@"array value is indi ==%@",[arrDevices objectAtIndex:alertIndex]);
            menuDeviceView[alertIndex]=[[UIView alloc] init];
            menuDeviceView[alertIndex].frame=CGRectMake(x_OffsetAlerts, yOffset_Lights, ViewLightDevice.frame.size.width,h_OffsetAlerts);
            menuDeviceView[alertIndex].backgroundColor=lblRGBA(99, 100, 102, 1);
            menuDeviceView[alertIndex].tag=alertIndex;
            [menuDeviceView[alertIndex] setExclusiveTouch:YES];
            [self.ViewLightDevice addSubview:menuDeviceView[alertIndex]];
            
            UITapGestureRecognizer *tapGesture_Cards = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceCards_OnClick:)];
            [menuDeviceView[alertIndex] addGestureRecognizer:tapGesture_Cards];
            
            
            //imageCard
            [AsyncImageLoader sharedLoader].cache = nil;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                postimageView[alertIndex] = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 57.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                postimageView[alertIndex] = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 121.0f, 74.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                postimageView[alertIndex] = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 110.0f, 66.0f)];
            }
            postimageView[alertIndex].tag =REC_POSTUSER_IMG_TAG;
            [menuDeviceView[alertIndex] addSubview:postimageView[alertIndex]];
            
            //get image view
            aPostimageView[alertIndex] = (AsyncImageView *)[menuDeviceView[alertIndex] viewWithTag:REC_POSTUSER_IMG_TAG];
            //cancel loading previous image for cell
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:aPostimageView[alertIndex]];
            if([[arrDevices objectAtIndex:alertIndex] objectForKey:@"thumbnailImage"] == [NSNull null]){
                if([deviceActions isEqualToString:@"lights"])
                {
                    aPostimageView[alertIndex].image = [UIImage imageNamed:@"dcardLight"];
                }else{
                    aPostimageView[alertIndex].image = [UIImage imageNamed:@"dcardOther"];
                }
                
            }else if([[[arrDevices objectAtIndex:alertIndex] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
                if([deviceActions isEqualToString:@"lights"])
                {
                    aPostimageView[alertIndex].image = [UIImage imageNamed:@"dcardLight"];
                }else{
                    aPostimageView[alertIndex].image = [UIImage imageNamed:@"dcardOther"];
                }
            }else{
                aPostimageView[alertIndex].image = [UIImage imageWithData:[Base64 decode:[[arrDevices objectAtIndex:alertIndex] objectForKey:@"thumbnailImage"]]];
            }
            
            
            imageButtonDevices[alertIndex]=[UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imageButtonDevices[alertIndex].frame=CGRectMake(0.0f, 0.0f, 94.0f, 57.0f);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imageButtonDevices[alertIndex].frame=CGRectMake(0.0f, 0.0f, 121.0f, 74.0f);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imageButtonDevices[alertIndex].frame=CGRectMake(0.0f, 0.0f, 110.0f, 66.0f);
            }
            [imageButtonDevices[alertIndex] setBackgroundColor:[UIColor clearColor]];
            imageButtonDevices[alertIndex].tag=alertIndex;
            [imageButtonDevices[alertIndex] addTarget:self action:@selector(deviceCardsTapped:) forControlEvents:UIControlEventTouchUpInside];
            [menuDeviceView[alertIndex] addSubview:imageButtonDevices[alertIndex]];
            
            
            lblCardAlert[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblCardAlert[alertIndex].frame=CGRectMake(102, 0, 114, 34);
                [lblCardAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblCardAlert[alertIndex].frame=CGRectMake(124, 0, 167, 48);
                [lblCardAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:14]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblCardAlert[alertIndex].frame=CGRectMake(118, 0, 153, 39);
                [lblCardAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }
            lblCardAlert[alertIndex].numberOfLines=2;
            [lblCardAlert[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            lblCardAlert[alertIndex].text =[NSString stringWithFormat:@"%@",[[arrDevices objectAtIndex:alertIndex] objectForKey:@"name"]];
            [menuDeviceView[alertIndex] addSubview:lblCardAlert[alertIndex]];
            
            
            if([[[arrDevices objectAtIndex:alertIndex] objectForKey:@"hasSchedule"] boolValue]){
                calendarButtonAlert[alertIndex]=[UIButton buttonWithType:UIButtonTypeCustom];
                [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"addschedulesprinki6plus"] forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                    [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
                    calendarButtonAlert[alertIndex].frame = CGRectMake(102,30,19, 19);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                    [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"calendari6plus"] forState:UIControlStateNormal];
                    calendarButtonAlert[alertIndex].frame = CGRectMake(124,20,38, 67);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                    [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"calendari6"] forState:UIControlStateNormal];
                    calendarButtonAlert[alertIndex].frame = CGRectMake(118,16,33, 62);
                }//addschedulesprinki6plus
                [menuDeviceView[alertIndex] addSubview:calendarButtonAlert[alertIndex]];
            }
            
            int batterpercentage=[[[arrDevices objectAtIndex:alertIndex] objectForKey:@"batteryPercentage"] intValue];
            batterpercentage=batterpercentage/25;
            
            UIImageView *imgView_Device_Battery=[[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgView_Device_Battery.frame = CGRectMake(137, 32, 29, 19);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgView_Device_Battery.frame = CGRectMake(179, 44, 36, 25);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgView_Device_Battery.frame = CGRectMake(163, 38, 33, 23);
            }
            if (batterpercentage == 1) {
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery1Image"];
            }else if (batterpercentage == 2){
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery2Image"];
            }else if (batterpercentage == 3){
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery3Image"];
            }else if (batterpercentage == 4){
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery4Image"];
            }
            //            else if (batterpercentage == 5){
            //                imgView_Device_Battery.image=[UIImage imageNamed:@"battery5Image"];
            //            }
            else{
                imgView_Device_Battery.image=[UIImage imageNamed:@"lowBatteryImage"];
            }
            [menuDeviceView[alertIndex] addSubview:imgView_Device_Battery];
            
            
            NSLog(@"device Mode means active or vaction ==%@",[[[arrDevices objectAtIndex:alertIndex] objectForKey:@"deviceMode"] objectForKey:@"deviceModeCode"]);
            
            NSLog(@"device Status means Manual On Or Off ==%@",[[[arrDevices objectAtIndex:alertIndex] objectForKey:@"deviceStatus"] objectForKey:@"code"]);
            
            deviceSwitch_Alerts[alertIndex] = [[UISwitch alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                deviceSwitch_Alerts[alertIndex].frame = CGRectMake(240, 12, 51, 31);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                deviceSwitch_Alerts[alertIndex].frame = CGRectMake(325, 21, 51, 31);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                deviceSwitch_Alerts[alertIndex].frame = CGRectMake(293, 17, 51, 31);
            }
            deviceSwitch_Alerts[alertIndex].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            deviceSwitch_Alerts[alertIndex].backgroundColor=[UIColor whiteColor];
            deviceSwitch_Alerts[alertIndex].layer.masksToBounds=YES;
            deviceSwitch_Alerts[alertIndex].layer.cornerRadius=16.0;
            deviceSwitch_Alerts[alertIndex].tag=alertIndex;
            [deviceSwitch_Alerts[alertIndex] addTarget:self action:@selector(switchToggledLightsOthersCard:) forControlEvents:UIControlEventValueChanged];
            [deviceSwitch_Alerts[alertIndex] setOn:NO animated:NO];
            [deviceSwitch_Alerts[alertIndex] setSelected:NO];
            [menuDeviceView[alertIndex] addSubview:deviceSwitch_Alerts[alertIndex]];
            [deviceSwitch_Alerts[alertIndex] setOnTintColor:lblRGBA(255, 255, 255, 1)];
            [deviceSwitch_Alerts[alertIndex] setTintColor:lblRGBA(255, 255, 255, 1)];
            [deviceSwitch_Alerts[alertIndex] setThumbTintColor:lblRGBA(99, 99, 102, 1)];
            
            if([[[[arrDevices objectAtIndex:alertIndex] objectForKey:@"deviceMode"] objectForKey:@"deviceModeCode"] isEqualToString:@"ACTIVE"])
            {
                //Active Means Vaction Mode Off.In This Scnerios We need to set switch interaction true. at the same time
                // need to check device status manual on or off. on means change device layout bg color.
                deviceSwitch_Alerts[alertIndex].userInteractionEnabled=YES;
                if([[[[arrDevices objectAtIndex:alertIndex] objectForKey:@"deviceStatus"] objectForKey:@"code"] isEqualToString:@"MANUALLY_ON"])
                {
                    if([deviceActions isEqualToString:@"lights"])
                    {
                        menuDeviceView[alertIndex].backgroundColor=lblRGBA(255, 206, 52, 1);
                        [deviceSwitch_Alerts[alertIndex] setOn:YES animated:NO];
                        [deviceSwitch_Alerts[alertIndex] setSelected:YES];
                        [deviceSwitch_Alerts[alertIndex] setThumbTintColor:lblRGBA(255, 206, 52, 1)];
                    }else{
                        menuDeviceView[alertIndex].backgroundColor=lblRGBA(49, 165, 222, 1);
                        [deviceSwitch_Alerts[alertIndex] setOn:YES animated:NO];
                        [deviceSwitch_Alerts[alertIndex] setSelected:YES];
                        [deviceSwitch_Alerts[alertIndex] setThumbTintColor:lblRGBA(49, 165, 222, 1)];
                    }
                }
                if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
                {
                    NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
                    if([appDelegate.strNetworkPermission isEqualToString:@"2"])
                    {
                        UIButton *btnManu = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btnManu addTarget:self
                                    action:@selector(showWarningPermissionNetwork:)
                          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                        [btnManu setTitle:@"" forState:UIControlStateNormal];
                        btnManu.userInteractionEnabled=YES;
                        //btnManu.frame = CGRectMake(596, 32, 44, 40);
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            btnManu.frame = CGRectMake(240, 12, 51, 31);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            btnManu.frame = CGRectMake(325, 21, 51, 31);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            btnManu.frame = CGRectMake(293, 17, 51, 31);
                        }
                        [menuDeviceView[alertIndex] addSubview:btnManu];
                    }
                }
            }else{
                //Not Active Means Vaction Mode is On. In This Scnerio We need to set switch interaction false and need to set overlay image to indicate to vaction mode status
                deviceSwitch_Alerts[alertIndex].userInteractionEnabled=NO;
                UIImageView *imgVaction=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageButtonDevices[alertIndex].frame.size.width, imageButtonDevices[alertIndex].frame.size.height)];
                imgVaction.image=[UIImage imageNamed:@"devicevaction"];
                [menuDeviceView[alertIndex] addSubview:imgVaction];
            }
            
            UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDetectedRightLightsCard:)];
            swipeRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
            [menuDeviceView[alertIndex] addGestureRecognizer:swipeRecognizerRight];
            
            yOffset_Lights=menuDeviceView[alertIndex].frame.size.height+menuDeviceView[alertIndex].frame.origin.y+5;
        }
        //Footer
        CGRect newAlertFrame=self.viewLightsCard_FooterView.frame;
        newAlertFrame.origin.y=yOffset_Lights;
        self.viewLightsCard_FooterView.frame=newAlertFrame;
        
        //Light Card View
        yOffset_Lights=newAlertFrame.size.height+newAlertFrame.origin.y;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            if (yOffset_Lights>438)
            {
                self.ViewLightDevice.frame=CGRectMake(self.ViewLightDevice.frame.origin.x, self.ViewLightDevice.frame.origin.y, self.ViewLightDevice.frame.size.width, yOffset_Lights+10);
                swipeDownLightsAlert.enabled=NO;
            }
            else{
                self.ViewLightDevice.frame=CGRectMake(self.ViewLightDevice.frame.origin.x, self.ViewLightDevice.frame.origin.y, self.ViewLightDevice.frame.size.width,438);
                [self swipeDown_Lights_PopUp];
            }
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            if (yOffset_Lights>584)
            {
                self.ViewLightDevice.frame=CGRectMake(self.ViewLightDevice.frame.origin.x, self.ViewLightDevice.frame.origin.y, self.ViewLightDevice.frame.size.width, yOffset_Lights+10);
                swipeDownLightsAlert.enabled=NO;
            }
            else{
                self.ViewLightDevice.frame=CGRectMake(self.ViewLightDevice.frame.origin.x, self.ViewLightDevice.frame.origin.y, self.ViewLightDevice.frame.size.width,584);
                [self swipeDown_Lights_PopUp];
            }
            
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            if (yOffset_Lights>523)
            {
                self.ViewLightDevice.frame=CGRectMake(self.ViewLightDevice.frame.origin.x, self.ViewLightDevice.frame.origin.y, self.ViewLightDevice.frame.size.width, yOffset_Lights+10);
                swipeDownLightsAlert.enabled=NO;
            }
            else{
                self.ViewLightDevice.frame=CGRectMake(self.ViewLightDevice.frame.origin.x, self.ViewLightDevice.frame.origin.y, self.ViewLightDevice.frame.size.width,523);
                [self swipeDown_Lights_PopUp];
            }
            
        }
        
        //Lights Scroll Setup
        self.scroll_View_LightsCard.contentSize=CGSizeMake(scroll_View_LightsCard.frame.size.width, self.ViewLightDevice.frame.origin.y+self.ViewLightDevice.frame.size.height);
        
        //Corner For Lights Card
        self.viewLightsCard_FooterView.hidden=NO;
        UIBezierPath *maskPathPlan_Lights = [UIBezierPath bezierPathWithRoundedRect:ViewLightDevice.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(16.0, 16.0)];
        CAShapeLayer *maskLayerPlan_Lights = [[CAShapeLayer alloc] init];
        maskLayerPlan_Lights.frame = self.view.bounds;
        maskLayerPlan_Lights.path  = maskPathPlan_Lights.CGPath;
        ViewLightDevice.layer.mask = maskLayerPlan_Lights;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
}

-(void)swipeDown_Lights_PopUp
{
    swipeDownLightsAlert.enabled=YES;
    swipeDownLightsAlert = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown_ToHide_lightsOthersAlert:)];
    [swipeDownLightsAlert setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.ViewLightDevice addGestureRecognizer:swipeDownLightsAlert];
}
-(void)deviceCardsTapped:(UIButton *)sender;
{
    cardTag=(int)sender.tag;
    [self navigate_To_LightDetailView];
}

- (void)deviceCards_OnClick:(UITapGestureRecognizer*)sender {
    UIView *view = sender.view;
    cardTag=(int)view.tag;
    NSLog(@"tag==%ld",(long)view.tag);
    [self navigate_To_LightDetailView];
}


- (void)swipeDetectedRightLightsCard:(UIGestureRecognizer *)sender {
    NSLog(@"Right Swipe");
    UIView *view = sender.view;
    cardTag=(int)view.tag;
    NSLog(@"tag==%ld",(long)view.tag);
    [self navigate_To_LightDetailView];
}

- (void)switchToggledLightsOthersCard:(UISwitch *)twistedSwitch
{
    if ([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        //Write code for SwitchON Action
        self.view.userInteractionEnabled=NO;
        [twistedSwitch setSelected:YES];
        NSLog(@"on");
        deviceTag=(int)twistedSwitch.tag;
        strManualType=@"1";
        if([deviceActions isEqualToString:@"lights"]){
            menuDeviceView[deviceTag].backgroundColor=lblRGBA(255, 206, 52, 1);
            [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(255, 206, 52, 1)];
        }else if([deviceActions isEqualToString:@"others"]){
            menuDeviceView[deviceTag].backgroundColor=lblRGBA(40, 165, 222, 1);
            [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(49, 165, 222, 1)];
        }
        else if([deviceActions isEqualToString:@"sprinklers"]){
            menuDeviceView[deviceTag].backgroundColor=lblRGBA(135, 197, 65, 1);
            [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(135, 197, 65, 1)];
        }
        if([Common reachabilityChanged]==YES){
            //            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            //            if([deviceActions isEqualToString:@"sprinklers"]){
            //                [self performSelectorInBackground:@selector(update_SprinklerDeviceStatus) withObject:self];
            //            }else{
            //                [self performSelectorInBackground:@selector(update_DeviceStatus) withObject:self];
            //            }
            
            if([deviceActions isEqualToString:@"sprinklers"]){
                if(sprinkler_On_Count>=1)
                {
                    self.view.userInteractionEnabled=YES;
                    self.view_manualOnAlert.hidden=NO;
                    BodyView_NetworkHome.alpha = 0.6;
                    headerView_NetworkHome.alpha=0.6;
                    self.titleBarView1_swipe.alpha=0.6;
                    return;
                    
                }
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(update_SprinklerDeviceStatus) withObject:self];
            }else{
                [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(update_DeviceStatus) withObject:self];
            }
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            self.view.userInteractionEnabled=YES;
        }
    }
    else if ((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        // self.view_manualOffAlert.hidden=NO;
        //  [self popUp_Alpha_NwHome_Enabled];
        
        if([deviceActions isEqualToString:@"sprinklers"]){
            self.view_Sprinkler_manualOffAlert.hidden=NO;
        }else{
            self.view_manualOffAlert.hidden=NO;
        }
        
        BodyView_NetworkHome.alpha = 0.6;
        headerView_NetworkHome.alpha=0.6;
        self.titleBarView1_swipe.alpha=0.6;
        //Write code for SwitchOFF Action
        [twistedSwitch setSelected:NO];
        NSLog(@"off");
        deviceTag=(int)twistedSwitch.tag;
        strManualType=@"2";
        menuDeviceView[deviceTag].backgroundColor=lblRGBA(99, 100, 102, 1);
        [deviceSwitch_Alerts[deviceTag] setTintColor:lblRGBA(255, 255, 255, 1)];
        [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(99, 99, 102, 1)];
    }
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : hides the device pop up
 Method Name : hideAlertView_LightsOthers(User Defined Methods)
 ************************************************************************************* */
-(void)hideAlertView_LightsOthers
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self resetAlertsFramesLightsCards];
    } completion:^(BOOL finished) {
        [self.BodyView_NetworkHome setUserInteractionEnabled:YES];
    }];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Navigates to lights screen
 Method Name : navigate_To_LightDetailView(User Defined Methods)
 ************************************************************************************* */
-(void)navigate_To_LightDetailView{
    LightsViewController *LVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LightsViewController"];
    [LVC setDelegate:self];
    LVC.strDeviceType=deviceActions;
    if ([deviceActions isEqualToString:@"sprinklers"]) {
        LVC.strDeviceID=[[arrDevices objectAtIndex:cardTag] objectForKey:kDeviceID];
        LVC.strDeviceMode=[[arrDevices objectAtIndex:cardTag] objectForKey:kZoneModeCode];
        LVC.strZoneID=[[arrDevices objectAtIndex:cardTag] objectForKey:kZoneID];
        LVC.strZoneStatusID=[[arrDevices objectAtIndex:cardTag] objectForKey:kZoneStatusID];
        LVC.strZoneLevel=[[arrDevices objectAtIndex:cardTag] objectForKey:kZoneLevel];
        LVC.strZoneStatus=[[arrDevices objectAtIndex:cardTag] objectForKey:kZoneStatus];
        if([[[arrDevices objectAtIndex:cardTag] objectForKey:kZoneSchedule] isEqualToString:@"1"])
        {
            LVC.str_HasSchedule=@"YES";
        }else{
            LVC.str_HasSchedule=@"NO";
        }
    }else{
        NSLog(@"selected device id == %@",[[arrDevices objectAtIndex:cardTag] objectForKey:@"id"]);
        NSLog(@"selected device id == %c",[[[arrDevices objectAtIndex:cardTag] objectForKey:@"hasSchedule"] boolValue]);
        
        LVC.strDeviceID=[[[arrDevices objectAtIndex:cardTag] objectForKey:@"id"] stringValue];
        LVC.strDeviceMode=[[[arrDevices objectAtIndex:cardTag] objectForKey:@"deviceMode"] objectForKey:@"deviceModeCode"];
        if([[[arrDevices objectAtIndex:cardTag] objectForKey:@"hasSchedule"] boolValue])
        {
            LVC.str_HasSchedule=@"YES";
        }else{
            LVC.str_HasSchedule=@"NO";
        }
    }
    [Common viewSlide_FromRight_ToLeft:self.navigationController.view];
    [self.navigationController pushViewController:LVC animated:NO];
    
}

#pragma mark - Property Map
/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Nvigates to network home screen from the property map screen
 Method Name : PropertMap_to_Home(User Defined Methods)
 ************************************************************************************* */
-(void)PropertMap_to_Home{
    [UIView transitionWithView:self.BodyView_Container
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.mapViewProperty removeAnnotations:self.mapViewProperty.annotations];
                        NSLog(@"%@",self.mapViewProperty.annotations);
                        [mapViewProperty removeFromSuperview];
                        [BodyView_NetworkHome setHidden:NO];
                        [self.BodyView_Container addSubview:BodyView_NetworkHome];
                        [BodyView_Weather setHidden:YES];
                        [BodyView_PropertyMap setHidden:YES];
                        wheaterTag=0;
                    }
                    completion:NULL];
}

-(void)bringToSuper
{
    [self.BodyView_PropertyMap bringSubviewToFront:gallaryProfilebtn];
    [self.BodyView_PropertyMap bringSubviewToFront:deleteProfilebtn];
    [self.BodyView_PropertyMap bringSubviewToFront:cameraProfilebtn];
}

-(void)getPropertyMaps
{
    if([propertyLoaderStatus isEqualToString:@"YES"])
    {
        [self updateDeviceCoordinates];
    }
    else if([propertyLoaderStatus isEqualToString:@""])
    {
        wheaterTag=2;
        strAlertType=@"";
        mapViewProperty = [[MKMapView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            mapViewProperty.frame = CGRectMake(0, 43, 320, 360);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            mapViewProperty.frame = CGRectMake(0, 53, 414, 484);
        }else{
            mapViewProperty.frame = CGRectMake(0, 43, 375, 437);
        }
        [BodyView_PropertyMap addSubview:mapViewProperty];
        [mapViewProperty setRotateEnabled:NO];
        
        btn_PropertyMap_Location = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_PropertyMap_Location.frame = CGRectMake(280, 320, 25, 25);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_PropertyMap_Location.frame = CGRectMake(330, 404, 35, 35);
        }else{
            btn_PropertyMap_Location.frame = CGRectMake(320, 390, 30, 30);
        }
        [btn_PropertyMap_Location setBackgroundImage:[UIImage imageNamed:@"locationGrayImage"] forState:UIControlStateNormal];
        [btn_PropertyMap_Location addTarget:self action:@selector(backToUserLocation:) forControlEvents:UIControlEventTouchUpInside];
        [mapViewProperty addSubview:btn_PropertyMap_Location];
        btn_PropertyMap_Location.hidden=YES;
    }
    [mapViewProperty setRotateEnabled:NO];
    
    self.mapViewProperty.delegate=self;
    
    NSLog(@"arr==%@",arrPropertyDevices);
    NSLog(@"arr count==%lu",(unsigned long)[arrPropertyDevices count]);
    
    UIPanGestureRecognizer* panRecPropertyMap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragPropertyMap:)];
    [panRecPropertyMap setDelegate:self];
    [self.mapViewProperty addGestureRecognizer:panRecPropertyMap];
    
    MyAnnotation *ann;
    for(int index=0;index<[arrPropertyDevices count];index++)
    {
        if([[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceType"] objectForKey:@"code"] isEqualToString:@"SPRINKLER"])
        {
            NSArray *arrZone=[[arrPropertyDevices objectAtIndex:index] objectForKey:@"zone"];
            NSLog(@"zone count = %lu",(unsigned long)arrZone.count);
            for(int zindex=0;zindex<[arrZone count];zindex++)
            {
                if([[[[arrZone objectAtIndex:zindex] objectForKey:@"status"] stringValue] isEqualToString:@"1"])
                {
                    if([[[arrZone objectAtIndex:zindex] objectForKey:@"mapLatitude"] floatValue]==0&&[[[arrZone objectAtIndex:zindex] objectForKey:@"mapLongitude"] floatValue]==0)
                    {
                        ann=[[MyAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([[[arrZone objectAtIndex:zindex] objectForKey:@"latitude"] doubleValue], [[[arrZone objectAtIndex:zindex] objectForKey:@"longitude"] doubleValue])];
                        ann.annLat=[[[arrZone objectAtIndex:zindex] objectForKey:@"latitude"] stringValue];
                        ann.annLong=[[[arrZone objectAtIndex:zindex] objectForKey:@"longitude"] stringValue];
                    }else{
                        ann=[[MyAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([[[arrZone objectAtIndex:zindex] objectForKey:@"mapLatitude"] doubleValue], [[[arrZone objectAtIndex:zindex] objectForKey:@"mapLongitude"] doubleValue])];
                        ann.annLat=[[[arrZone objectAtIndex:zindex] objectForKey:@"mapLatitude"] stringValue];
                        ann.annLong=[[[arrZone objectAtIndex:zindex] objectForKey:@"mapLongitude"] stringValue];
                    }
                    ann.anncardName=[[arrZone objectAtIndex:zindex] objectForKey:@"name"];
                    ann.annCardType=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceType"] objectForKey:@"code"];
                    ann.annCardID=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceId"] stringValue];
                    ann.annCardZoneID=[[[arrZone objectAtIndex:zindex] objectForKey:@"id"] stringValue];
                    int count=(int)[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"unReadAlerts"] count]; //only for main tag
                    ann.annUnreadCount=[NSString stringWithFormat:@"%d",count];
                    ann.annZoneLevel=[[[arrZone objectAtIndex:zindex] objectForKey:@"zoneLevel"] stringValue];
                    ann.annZoneStatus=[[[arrZone objectAtIndex:zindex] objectForKey:@"status"] stringValue];
                    ann.annZoneStatusID=[[[[arrZone objectAtIndex:zindex] objectForKey:@"zoneStatus"] objectForKey:@"id"] stringValue];
                    ann.annDeviceMode=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceMode"] objectForKey:@"deviceModeCode"];
                    [self.mapViewProperty addAnnotation:ann];
                }
                
            }
            
            
        }else{
            if([[[arrPropertyDevices objectAtIndex:index] objectForKey:@"mapLatitude"] floatValue]==0&&[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"mapLongitude"] floatValue]==0)
            {
                ann=[[MyAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([[[arrPropertyDevices objectAtIndex:index] objectForKey:@"latitude"] doubleValue], [[[arrPropertyDevices objectAtIndex:index] objectForKey:@"longitude"] doubleValue])];
                ann.annLat=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"latitude"] stringValue];
                ann.annLong=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"longitude"] stringValue];
            }else{
                ann=[[MyAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([[[arrPropertyDevices objectAtIndex:index] objectForKey:@"mapLatitude"] doubleValue], [[[arrPropertyDevices objectAtIndex:index] objectForKey:@"mapLongitude"] doubleValue])];
                ann.annLat=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"mapLatitude"] stringValue];
                ann.annLong=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"mapLongitude"] stringValue];
            }
            ann.anncardName=[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceName"];
            ann.annCardType=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceType"] objectForKey:@"code"];
            ann.annCardID=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceId"] stringValue];
            int count=(int)[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"unReadAlerts"] count];
            ann.annUnreadCount=[NSString stringWithFormat:@"%d",count];
            ann.annCardZoneID=@"0";
            ann.annZoneStatusID=@"0";
            ann.annZoneLevel=@"0";
            ann.annZoneStatus=@"";
            ann.annDeviceMode=[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceMode"] objectForKey:@"deviceModeCode"];
            [self.mapViewProperty addAnnotation:ann];
        }
    }
    
    [self.mapViewProperty setZoomEnabled:YES];
    [self.mapViewProperty setScrollEnabled:YES];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocationCoordinate2D newCoordiante;
    newCoordiante.latitude=[[dictProperty_NetworkDetails objectForKey:@"latitude"] doubleValue];
    newCoordiante.longitude=[[dictProperty_NetworkDetails objectForKey:@"longitude"] doubleValue];
    [self.mapViewProperty setRegion:MKCoordinateRegionMakeWithDistance(newCoordiante, footView,footView)];
    NSLog(@"zoom level %f",mapViewProperty.region.span.latitudeDelta);
    
    if(![[dictProperty_NetworkDetails objectForKey:@"propertyMapImage"] isEqualToString:@""]){
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.imageNameOverLay=[UIImage imageWithData:[Base64 decode:[dictProperty_NetworkDetails objectForKey:@"propertyMapImage"]]];
        strEncoded_ControllerImage = [dictProperty_NetworkDetails objectForKey:@"propertyMapImage"];
        NSLog(@"%@",strEncoded_ControllerImage);
        //
        appDelegate.dict_OverlayCoord = [[NSMutableDictionary alloc] init];
        //"
        [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",[[dictProperty_NetworkDetails objectForKey:@"topLeftLatitude"] floatValue]] forKey:@"UpperLeftLat"];
        [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",[[dictProperty_NetworkDetails objectForKey:@"topLeftLongitude"] floatValue]] forKey:@"UpperLeftLong"];
        [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",[[dictProperty_NetworkDetails objectForKey:@"topRightLatitude"] floatValue]] forKey:@"UpperRightLat"];
        [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",[[dictProperty_NetworkDetails objectForKey:@"topRightLongitude"] floatValue]] forKey:@"UpperRightLong"];
        [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",[[dictProperty_NetworkDetails objectForKey:@"bottomLeftLatitude"] floatValue]] forKey:@"BottomLeftLat"];
        [appDelegate.dict_OverlayCoord setObject:[NSString stringWithFormat:@"%f",[[dictProperty_NetworkDetails objectForKey:@"bottomLeftLongitude"] floatValue]] forKey:@"BottomLeftLong"];
        NSLog(@"%@",appDelegate.dict_OverlayCoord);
        
        //
        [self setOverLayImage];
        [self.deleteProfilebtn setHidden:NO];
        [self iconsPositionOrg_PropertyMap];
    }else{
        [self.deleteProfilebtn setHidden:YES];
        [self iconsPositionNew_PropertyMap];
    }
    if([propertyLoaderStatus isEqualToString:@""])
    {
        propertyLoaderStatus=@"YES";
        [UIView transitionWithView:self.BodyView_Container
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [BodyView_NetworkHome setHidden:YES];
                            [BodyView_Weather setHidden:YES];
                            [self.BodyView_Container addSubview:BodyView_Weather];
                            [BodyView_PropertyMap setHidden:NO];
                            //[deleteProfilebtn setHidden:YES];
                            [self bringToSuper];
                        }
                        completion:NULL];
    }
    [self stop_PinWheel_Lights];
}
-(void)iconsPositionOrg_PropertyMap
{
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        cameraProfilebtn.frame = CGRectMake(214, cameraProfilebtn.frame.origin.y, cameraProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
        gallaryProfilebtn.frame = CGRectMake(250, gallaryProfilebtn.frame.origin.y, gallaryProfilebtn.frame.size.width, gallaryProfilebtn.frame.size.height);
        deleteProfilebtn.frame=CGRectMake(286, deleteProfilebtn.frame.origin.y, deleteProfilebtn.frame.size.width, self.cameraProfilebtn.frame.size.height);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        cameraProfilebtn.frame = CGRectMake(278, cameraProfilebtn.frame.origin.y, cameraProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
        gallaryProfilebtn.frame = CGRectMake(324, gallaryProfilebtn.frame.origin.y, gallaryProfilebtn.frame.size.width, gallaryProfilebtn.frame.size.height);
        deleteProfilebtn.frame=CGRectMake(370, deleteProfilebtn.frame.origin.y, deleteProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
    }else{
        cameraProfilebtn.frame = CGRectMake(251, cameraProfilebtn.frame.origin.y, cameraProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
        gallaryProfilebtn.frame = CGRectMake(293, gallaryProfilebtn.frame.origin.y, gallaryProfilebtn.frame.size.width, gallaryProfilebtn.frame.size.height);
        deleteProfilebtn.frame=CGRectMake(335, deleteProfilebtn.frame.origin.y, deleteProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
    }
}
-(void)iconsPositionNew_PropertyMap
{
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        cameraProfilebtn.frame = CGRectMake(250, cameraProfilebtn.frame.origin.y, cameraProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
        gallaryProfilebtn.frame = CGRectMake(286, gallaryProfilebtn.frame.origin.y, gallaryProfilebtn.frame.size.width, gallaryProfilebtn.frame.size.height);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        cameraProfilebtn.frame = CGRectMake(324, cameraProfilebtn.frame.origin.y, cameraProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
        gallaryProfilebtn.frame = CGRectMake(370, gallaryProfilebtn.frame.origin.y, gallaryProfilebtn.frame.size.width, gallaryProfilebtn.frame.size.height);
    }else{
        cameraProfilebtn.frame = CGRectMake(293, cameraProfilebtn.frame.origin.y, cameraProfilebtn.frame.size.width, cameraProfilebtn.frame.size.height);
        gallaryProfilebtn.frame = CGRectMake(335, gallaryProfilebtn.frame.origin.y, gallaryProfilebtn.frame.size.width, gallaryProfilebtn.frame.size.height);
    }
}

/* **********************************************************************************
 Date : 08/01/2016
 Author : iExemplar Software India Pvt Ltd.
 Title: Map View touch options
 Description : when map tapped call this function
 Method Name : gestureRecognizer (delegate Method for tapGuster)
 ************************************************************************************* */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


/* **********************************************************************************
 Date : 08/01/2016
 Author : iExemplar Software India Pvt Ltd.
 Title: Map View touch options
 Description : when user drag the map aprat from current location call this function.
 purpose of this function is
 Method Name : gestureRecognizer (delegate Method for tapGuster)
 ************************************************************************************* */
- (void)didDragPropertyMap:(UIGestureRecognizer*)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"drag ended");
        [btn_PropertyMap_Location setHidden:NO];
    }
}

#pragma mark - Sprinkler PopUp Setup

-(void)config_Sprinklers_Widgets{
    [view_AddSchedule setAlpha:1.0];
//    [self.viewSprinklerAlert_Schedule_FooterView setHidden:YES];
//    [self.viewSprinklerAlert_Device_FooterView setHidden:YES];
//    [self.viewSprinklerAlert_ScheduleView setHidden:NO];
//    [self.viewSprinklerAlert_DeviceView setHidden:YES];
    self.tab_ScheduleView.backgroundColor=lblRGBA(128, 130, 133, 1);
    self.tab_DeviceView.backgroundColor=lblRGBA(135, 197, 65, 1);

    [self.viewSprinklerAlert_Schedule_FooterView setHidden:YES];
    [self.viewSprinklerAlert_Device_FooterView setHidden:YES];
    [self.viewSprinklerAlert_ScheduleView setHidden:YES];
    [self.viewSprinklerAlert_DeviceView setHidden:NO];
    self.scrollView_SprinklerCard.showsHorizontalScrollIndicator=NO;
    self.scrollView_SprinklerCard.showsVerticalScrollIndicator=NO;
    self.scrollView_SprinklerCard.scrollEnabled=YES;
    self.scrollView_SprinklerCard.userInteractionEnabled=YES;
    self.scrollView_SprinklerCard.delegate=self;
}


-(void)resetAlertsFramesSprinklersCards{
    scrollView_SprinklerCard.frame  = CGRectMake(scrollView_SprinklerCard.frame.origin.x, 1500,scrollView_SprinklerCard.frame.size.width,scrollView_SprinklerCard.frame.size.height);
    scrollView_SprinklerCard.contentOffset = CGPointMake(0, 0);
    strStatusDevice=@"";
    strStatusSchedule=@"";
    sprinkler_On_Count=0;
    for (int index=0;index<[arrDevices count];index++){
        [menuDeviceView[index] removeFromSuperview];
    }
    for (int index=0;index<[arr_Schedule_Sprinklers count];index++){
        [view_ScheduleCell_Sprinkler[index] removeFromSuperview];
    }
    [btn_back_networkHome setUserInteractionEnabled:YES];
    [btn_networkHome_logo setUserInteractionEnabled:YES];
    [btn_settings setUserInteractionEnabled:YES];
    [btnSliderHeader_Bar setUserInteractionEnabled:YES];
    [btnSliderHeader_Image setUserInteractionEnabled:YES];
    str_Selected_Tap=@"Device";
    str_Previous_Tap=@"Device";
    self.tab_ScheduleView.backgroundColor=lblRGBA(128, 130, 133, 1);
    self.tab_DeviceView.backgroundColor=lblRGBA(135, 197, 65, 1);
    [self tapGusterSetup];
    strAlertType=@"";
}

-(void)changeVacation_Mode_OldState_Sprinkler{
    if ([vacationModeStatus isEqualToString:@"NO"]) {
        for(int index=0;index<[arr_Schedule_Sprinklers count];index++){
            view_ScheduleCell_Sprinkler[index].userInteractionEnabled=YES;
            lblSchedule_Sprinkler[index].textColor=lblRGBA(255, 255, 255, 1);
            [lblSchedule_Time_Sprinkler[index] setHidden:NO];
            [imgViewSchedule_Sprinkler_Clock[index] setHidden:NO];
            view_ScheduleCell_Sprinkler[index].backgroundColor=lblRGBA(136, 197, 65, 1);
            view_Schedule_Sub[index].backgroundColor=lblRGBA(159, 206, 101, 1);
            [imgViewSchedule_Sprinkler[index] setAlpha:1.0];
        }
        view_AddSchedule.backgroundColor=lblRGBA(136, 197, 65, 1);
        view_VacationMode.backgroundColor=lblRGBA(128,130,133, 1);
        view_AddSchedule.alpha = 1.0;
        lbl_vacationMode.text = @"TURN ON VACATION MODE";
        [view_AddSchedule setUserInteractionEnabled:YES];
    }else{
        for(int index=0;index<[arr_Schedule_Sprinklers count];index++){
            view_ScheduleCell_Sprinkler[index].userInteractionEnabled=NO;
            view_ScheduleCell_Sprinkler[index].backgroundColor=lblRGBA(88,89,91,1);
            view_Schedule_Sub[index].backgroundColor=lblRGBA(88, 89,91,1);
            lblSchedule_Sprinkler[index].textColor=lblRGBA(128, 130, 133, 1);
            [imgViewSchedule_Sprinkler[index] setAlpha:0.4];
            [lblSchedule_Time_Sprinkler[index] setHidden:YES];
            [imgViewSchedule_Sprinkler_Clock[index] setHidden:YES];
        }
        view_VacationMode.backgroundColor=lblRGBA(217,38,50, 1);//red for vacation
        view_AddSchedule.backgroundColor=lblRGBA(128,130,133, 1);
        view_AddSchedule.alpha = 0.4;
        lbl_vacationMode.text = @"TURN OFF VACATION MODE";
        [view_AddSchedule setUserInteractionEnabled:NO];
    }
}

-(void)reset_SprinklerSchedule_Status
{
    if ([vacationModeStatus isEqualToString:@"YES"]) {
        view_VacationMode.backgroundColor=lblRGBA(217,38,50, 1);//red for vacation
        view_AddSchedule.backgroundColor=lblRGBA(128,130,133, 1);
        view_AddSchedule.alpha = 0.4;
        lbl_vacationMode.text = @"TURN OFF VACATION MODE";
        [view_AddSchedule setUserInteractionEnabled:NO];
    }else{
        view_AddSchedule.backgroundColor=lblRGBA(136, 197, 65, 1);
        view_VacationMode.backgroundColor=lblRGBA(128,130,133, 1);
        view_AddSchedule.alpha = 1.0;
        lbl_vacationMode.text = @"TURN ON VACATION MODE";
        [view_AddSchedule setUserInteractionEnabled:YES];
    }
}


-(void)drawBodyContent_Sprinklers_Schedule{
    @try {
        float x_OffsetAlerts=0,h_OffsetAlerts,yOffset_Alerts =0.0;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            h_OffsetAlerts=44;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            h_OffsetAlerts=56;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            h_OffsetAlerts=50;
        }
        for (int index=0;index<[arr_Schedule_Sprinklers count];index++){
            view_ScheduleCell_Sprinkler[index]=[[UIView alloc] initWithFrame:CGRectMake(x_OffsetAlerts, yOffset_Alerts, self.viewSprinklerAlert_ScheduleView.frame.size.width, h_OffsetAlerts)];
            [view_ScheduleCell_Sprinkler[index] setBackgroundColor:lblRGBA(136, 197, 65, 1)];
            [view_ScheduleCell_Sprinkler[index] setTag:index];
            [viewSprinklerAlert_ScheduleView addSubview:view_ScheduleCell_Sprinkler[index]];
            
            UITapGestureRecognizer *tapGestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sprinkler_ScheduleTap:)];
            [view_ScheduleCell_Sprinkler[index] addGestureRecognizer:tapGestureView];
            [view_ScheduleCell_Sprinkler[index] setExclusiveTouch:YES];
            
            imgViewSchedule_Sprinkler[index] = [[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgViewSchedule_Sprinkler[index].frame = CGRectMake(6, 14, 16, 16);
//                imgViewSchedule_Sprinkler[index].image=[UIImage imageNamed:@"scheduleCalenderImage"];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgViewSchedule_Sprinkler[index].frame = CGRectMake(10, 15, 25, 25);
//                imgViewSchedule_Sprinkler[index].image=[UIImage imageNamed:@"scheduleCalenderImagei6plus"];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgViewSchedule_Sprinkler[index].frame = CGRectMake(10, 15, 20, 20);
//                imgViewSchedule_Sprinkler[index].image=[UIImage imageNamed:@"scheduleCalenderImagei6"];
            }
            imgViewSchedule_Sprinkler[index].image=[UIImage imageNamed:@"addschedulesprinki6plus"];
            imgViewSchedule_Sprinkler[index].tag=index;
            [view_ScheduleCell_Sprinkler[index] addSubview:imgViewSchedule_Sprinkler[index]];
            
            lblSchedule_Sprinkler[index] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblSchedule_Sprinkler[index].frame = CGRectMake(35, 0, 133, 43);
                lblSchedule_Sprinkler[index].font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblSchedule_Sprinkler[index].frame = CGRectMake(43, 0, 178, 55);
                lblSchedule_Sprinkler[index].font = [UIFont fontWithName:@"NexaBold" size:13.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblSchedule_Sprinkler[index].frame = CGRectMake(38, 0, 157, 50);
                lblSchedule_Sprinkler[index].font = [UIFont fontWithName:@"NexaBold" size:12.0];
            }
            lblSchedule_Sprinkler[index].text = [[arr_Schedule_Sprinklers objectAtIndex:index] valueForKey:@"scheduleName"];
            lblSchedule_Sprinkler[index].textColor = lblRGBA(255, 255, 255, 1);
            lblSchedule_Sprinkler[index].tag=index;
            [view_ScheduleCell_Sprinkler[index] addSubview:lblSchedule_Sprinkler[index]];
            
            
            view_Schedule_Sub[index]=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_Schedule_Sub[index].frame = CGRectMake(170, 0, 108, 43);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_Schedule_Sub[index].frame = CGRectMake(224, 0, 138, 55);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_Schedule_Sub[index].frame = CGRectMake(202, 0, 124, 50);
            }
            view_Schedule_Sub[index].backgroundColor=lblRGBA(159, 206, 101, 1);
            [view_ScheduleCell_Sprinkler[index] addSubview:view_Schedule_Sub[index]];
            
            //ClockImagei6plus
            imgViewSchedule_Sprinkler_Clock[index] = [[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgViewSchedule_Sprinkler_Clock[index].frame = CGRectMake(6, 14, 16, 16);
//                imgViewSchedule_Sprinkler_Clock[index].image = [UIImage imageNamed:@"clocksprinkleri5"];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgViewSchedule_Sprinkler_Clock[index].frame = CGRectMake(10, 18, 20, 20);
//                imgViewSchedule_Sprinkler_Clock[index].image = [UIImage imageNamed:@"clocksprinkleri6plus"];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgViewSchedule_Sprinkler_Clock[index].frame = CGRectMake(5, 16, 18, 18);
//                imgViewSchedule_Sprinkler_Clock[index].image = [UIImage imageNamed:@"clocksprinkleri6"];
            }
            imgViewSchedule_Sprinkler_Clock[index].image = [UIImage imageNamed:@"ClockImagei6plus"];
            [view_Schedule_Sub[index] addSubview:imgViewSchedule_Sprinkler_Clock[index]];
            
            
            lblSchedule_Time_Sprinkler[index] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblSchedule_Time_Sprinkler[index].frame = CGRectMake(30, 0, 71, 43);
                lblSchedule_Time_Sprinkler[index].font = [UIFont fontWithName:@"NexaBold" size:10.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblSchedule_Time_Sprinkler[index].frame = CGRectMake(38, 0, 89, 55);
                lblSchedule_Time_Sprinkler[index].font = [UIFont fontWithName:@"NexaBold" size:12.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblSchedule_Time_Sprinkler[index].frame = CGRectMake(30, 0, 86, 50);
                lblSchedule_Time_Sprinkler[index].font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }
            lblSchedule_Time_Sprinkler[index].text = [[arr_Schedule_Sprinklers objectAtIndex:index] valueForKey:@"startTime"];
            lblSchedule_Time_Sprinkler[index].numberOfLines=2;
            lblSchedule_Time_Sprinkler[index].textAlignment=NSTextAlignmentRight;
            lblSchedule_Time_Sprinkler[index].textColor = lblRGBA(65, 64, 66, 1);
            [view_Schedule_Sub[index] addSubview:lblSchedule_Time_Sprinkler[index]];
            
            if ([vacationModeStatus isEqualToString:@"YES"]) {
                view_ScheduleCell_Sprinkler[index].userInteractionEnabled=NO;
                view_ScheduleCell_Sprinkler[index].backgroundColor=lblRGBA(88,89,91,1);
                view_Schedule_Sub[index].backgroundColor=lblRGBA(88, 89,91,1);
                lblSchedule_Sprinkler[index].textColor=lblRGBA(128, 130, 133, 1);
                [imgViewSchedule_Sprinkler[index] setAlpha:0.4];
                [lblSchedule_Time_Sprinkler[index] setHidden:YES];
                [imgViewSchedule_Sprinkler_Clock[index] setHidden:YES];
            }
            
            yOffset_Alerts=view_ScheduleCell_Sprinkler[index].frame.origin.y+view_ScheduleCell_Sprinkler[index].frame.size.height+7;
        }
        yaxis_Schedule=yOffset_Alerts;
        NSLog(@"yaxis sch==%f",yaxis_Schedule);
        [self changeScheduleHeight:yaxis_Schedule];
        
        [self reset_SprinklerSchedule_Status];
        self.viewSprinklerAlert_Schedule_FooterView.hidden=NO;
        
        self.viewSprinklerAlert.layer.cornerRadius = 16.0;
        strStatusSchedule = @"YES";
    }
    @catch (NSException *exception) {
        NSLog(@"schedule cell exception==%@",exception.description);
    }
    [self.viewSprinklerAlert_ScheduleView setHidden:NO];
    [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
}

-(void)changeScheduleHeight:(float)yaxisS
{
    //Schedule Container
    CGRect newAlertFrame=self.viewSprinklerAlert_ScheduleView.frame;
    newAlertFrame.size.height=yaxisS;
    self.viewSprinklerAlert_ScheduleView.frame=newAlertFrame;
    
    // Schedule Footer Card View
    CGRect newAlertFrame_Footer=self.viewSprinklerAlert_Schedule_FooterView.frame;
    newAlertFrame_Footer.origin.y=newAlertFrame.size.height+newAlertFrame.origin.y+20;
    self.viewSprinklerAlert_Schedule_FooterView.frame=newAlertFrame_Footer;
    
    //Schedule Card View
    yaxisS=newAlertFrame_Footer.size.height+newAlertFrame_Footer.origin.y;
    
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        if (yaxisS>438)
        {
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width, yaxisS+10);
            swipeDownLightsAlert.enabled=NO;
        }
        else{
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width,438);
            [self swipeDown_Spinkler_PopUp];
        }
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        if (yaxisS>584)
        {
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width, yaxisS+10);
            swipeDownLightsAlert.enabled=NO;
        }
        else{
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width,584);
            [self swipeDown_Spinkler_PopUp];
        }
        
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        if (yaxisS>523)
        {
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width, yaxisS+10);
            swipeDownLightsAlert.enabled=NO;
        }
        else{
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width,523);
            [self swipeDown_Spinkler_PopUp];
        }
    }
    
    //Sprinkler Schedule Scroll Setup
    self.scrollView_SprinklerCard.contentSize=CGSizeMake(scrollView_SprinklerCard.frame.size.width, self.viewSprinklerAlert.frame.origin.y+self.viewSprinklerAlert.frame.size.height);
}


-(void)loadAlertsDatas_Sprinklers{
    float x_OffsetAlerts=0,h_OffsetAlerts,yOffset_Sprinklers = 0.0;
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        h_OffsetAlerts=57;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        h_OffsetAlerts=74;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        h_OffsetAlerts=66;
    }
    
#define REC_POSTUSER_IMG_TAG 999
    @try {
        NSLog(@"%lu",(unsigned long)[arrDevices count]);
        NSLog(@"%@",arrDevices);
        for(int alertIndex=0;alertIndex<[arrDevices count];alertIndex++){
            
            NSLog(@"array value is ==%@",arrDevices);
            NSLog(@"array value is indi ==%@",[arrDevices objectAtIndex:alertIndex]);
            menuDeviceView[alertIndex]=[[UIView alloc] init];
            menuDeviceView[alertIndex].frame=CGRectMake(x_OffsetAlerts, yOffset_Sprinklers, viewSprinklerAlert_DeviceView.frame.size.width,h_OffsetAlerts);
            menuDeviceView[alertIndex].backgroundColor=lblRGBA(99, 100, 102, 1);
            menuDeviceView[alertIndex].tag=alertIndex;
            [menuDeviceView[alertIndex] setExclusiveTouch:YES];
            [self.viewSprinklerAlert_DeviceView addSubview:menuDeviceView[alertIndex]];
            
            UITapGestureRecognizer *tapGesture_Cards = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deviceCards_OnClick:)];
            [menuDeviceView[alertIndex] addGestureRecognizer:tapGesture_Cards];
            
            
            //imageCard
            [AsyncImageLoader sharedLoader].cache = nil;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                postimageView[alertIndex] = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 57.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                postimageView[alertIndex] = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 121.0f, 74.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                postimageView[alertIndex] = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 110.0f, 66.0f)];
            }
            postimageView[alertIndex].tag =REC_POSTUSER_IMG_TAG;
            [menuDeviceView[alertIndex] addSubview:postimageView[alertIndex]];
            
            //get image view
            aPostimageView[alertIndex] = (AsyncImageView *)[menuDeviceView[alertIndex] viewWithTag:REC_POSTUSER_IMG_TAG];
            //cancel loading previous image for cell
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:aPostimageView[alertIndex]];
            if([[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneThumbnailImage] == [NSNull null]){
                aPostimageView[alertIndex].image = [UIImage imageNamed:@"dcardSprinkler"];
            }else if([[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneThumbnailImage] isEqualToString:@""]){
                aPostimageView[alertIndex].image = [UIImage imageNamed:@"dcardSprinkler"];
            }else{
                aPostimageView[alertIndex].image = [UIImage imageWithData:[Base64 decode:[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneThumbnailImage]]];
            }
            
            imageButtonDevices[alertIndex]=[UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imageButtonDevices[alertIndex].frame=CGRectMake(0.0f, 0.0f, 94.0f, 57.0f);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imageButtonDevices[alertIndex].frame=CGRectMake(0.0f, 0.0f, 121.0f, 74.0f);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imageButtonDevices[alertIndex].frame=CGRectMake(0.0f, 0.0f, 110.0f, 66.0f);
            }
            [imageButtonDevices[alertIndex] setBackgroundColor:[UIColor clearColor]];
            imageButtonDevices[alertIndex].tag=alertIndex;
            [imageButtonDevices[alertIndex] addTarget:self action:@selector(deviceCardsTapped:) forControlEvents:UIControlEventTouchUpInside];
            [menuDeviceView[alertIndex] addSubview:imageButtonDevices[alertIndex]];
            
            
            lblCardAlert[alertIndex] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblCardAlert[alertIndex].frame=CGRectMake(102, 0, 114, 34);
                [lblCardAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblCardAlert[alertIndex].frame=CGRectMake(129, 0, 167, 48);
                [lblCardAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:14]];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblCardAlert[alertIndex].frame=CGRectMake(115, 0, 153, 39);
                [lblCardAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:13]];
            }
            lblCardAlert[alertIndex].numberOfLines=2;
            [lblCardAlert[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
            lblCardAlert[alertIndex].text =[NSString stringWithFormat:@"%@",[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneName]];
            [menuDeviceView[alertIndex] addSubview:lblCardAlert[alertIndex]];
            
            
            NSLog(@"sch status ==%@",[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneSchedule]);
            if(![[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneSchedule] isEqualToString:@"0"]){
                calendarButtonAlert[alertIndex]=[UIButton buttonWithType:UIButtonTypeCustom];
                [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"addschedulesprinki6plus"] forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                    [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
                    calendarButtonAlert[alertIndex].frame = CGRectMake(102,30,19, 19);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                    [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"calendari6plus"] forState:UIControlStateNormal];
                    calendarButtonAlert[alertIndex].frame = CGRectMake(124,20,38, 67);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//                    [calendarButtonAlert[alertIndex] setImage:[UIImage imageNamed:@"calendari6"] forState:UIControlStateNormal];
                    calendarButtonAlert[alertIndex].frame = CGRectMake(118,16,33, 62);
                }
                [menuDeviceView[alertIndex] addSubview:calendarButtonAlert[alertIndex]];
            }
            
            int batterpercentage=[[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneBatteryPercentage] intValue];
            batterpercentage=batterpercentage/25;
            
            UIImageView *imgView_Device_Battery=[[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgView_Device_Battery.frame = CGRectMake(137, 32, 29, 19);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgView_Device_Battery.frame = CGRectMake(179, 44, 36, 25);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgView_Device_Battery.frame = CGRectMake(163, 38, 33, 23);
            }
            if (batterpercentage == 1) {
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery1Image"];
            }else if (batterpercentage == 2){
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery2Image"];
            }else if (batterpercentage == 3){
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery3Image"];
            }else if (batterpercentage == 4){
                imgView_Device_Battery.image=[UIImage imageNamed:@"battery4Image"];
            }
            else{
                imgView_Device_Battery.image=[UIImage imageNamed:@"lowBatteryImage"];
            }
            // imgView_Device_Battery.hidden=YES;
            [menuDeviceView[alertIndex] addSubview:imgView_Device_Battery];
            
            
            NSLog(@"device Mode means active or vaction ==%@",[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneModeCode]);
            
            NSLog(@"device Status means Manual On Or Off ==%@",[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneStatusCode]);
            
            deviceSwitch_Alerts[alertIndex] = [[UISwitch alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                deviceSwitch_Alerts[alertIndex].frame = CGRectMake(220, 12, 51, 31);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                deviceSwitch_Alerts[alertIndex].frame = CGRectMake(300, 21, 51, 31);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                deviceSwitch_Alerts[alertIndex].frame = CGRectMake(260, 17, 51, 31);
            }
            deviceSwitch_Alerts[alertIndex].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            deviceSwitch_Alerts[alertIndex].backgroundColor=[UIColor whiteColor];
            deviceSwitch_Alerts[alertIndex].layer.masksToBounds=YES;
            deviceSwitch_Alerts[alertIndex].layer.cornerRadius=16.0;
            deviceSwitch_Alerts[alertIndex].tag=alertIndex;
            [deviceSwitch_Alerts[alertIndex] addTarget:self action:@selector(switchToggledLightsOthersCard:) forControlEvents:UIControlEventValueChanged];
            [deviceSwitch_Alerts[alertIndex] setOn:NO animated:NO];
            [deviceSwitch_Alerts[alertIndex] setSelected:NO];
            [menuDeviceView[alertIndex] addSubview:deviceSwitch_Alerts[alertIndex]];
            [deviceSwitch_Alerts[alertIndex] setOnTintColor:lblRGBA(255, 255, 255, 1)];
            [deviceSwitch_Alerts[alertIndex] setTintColor:lblRGBA(255, 255, 255, 1)];
            [deviceSwitch_Alerts[alertIndex] setThumbTintColor:lblRGBA(99, 99, 102, 1)];
            if([[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneModeCode] isEqualToString:@"ACTIVE"])
            {
                //Active Means Vaction Mode Off.In This Scnerios We need to set switch interaction true. at the same time
                // need to check device status manual on or off. on means change device layout bg color.
                deviceSwitch_Alerts[alertIndex].userInteractionEnabled=YES;
                if([[[arrDevices objectAtIndex:alertIndex] objectForKey:kZoneStatusCode] isEqualToString:@"MANUALLY_ON"])
                {
                    menuDeviceView[alertIndex].backgroundColor=lblRGBA(135, 197, 65, 1);
                    [deviceSwitch_Alerts[alertIndex] setOn:YES animated:NO];
                    [deviceSwitch_Alerts[alertIndex] setSelected:YES];
                    [deviceSwitch_Alerts[alertIndex] setThumbTintColor:lblRGBA(135, 197, 65, 1)];
                }
                if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
                {
                    NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
                    if([appDelegate.strNetworkPermission isEqualToString:@"2"])
                    {
                        UIButton *btnManu = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btnManu addTarget:self
                                    action:@selector(showWarningPermissionNetwork:)
                          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                        [btnManu setTitle:@"" forState:UIControlStateNormal];
                        btnManu.userInteractionEnabled=YES;
                        //btnManu.frame = CGRectMake(596, 32, 44, 40);
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            btnManu.frame = CGRectMake(220, 12, 51, 31);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            btnManu.frame = CGRectMake(300, 21, 51, 31);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                            btnManu.frame = CGRectMake(260, 17, 51, 31);
                        }
                        [menuDeviceView[alertIndex] addSubview:btnManu];
                    }
                }
            }else{
                //Not Active Means Vaction Mode is On. In This Scnerio We need to set switch interaction false and need to set overlay image to indicate to vaction mode status
                deviceSwitch_Alerts[alertIndex].userInteractionEnabled=NO;
                UIImageView *imgVaction=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageButtonDevices[alertIndex].frame.size.width, imageButtonDevices[alertIndex].frame.size.height)];
                imgVaction.image=[UIImage imageNamed:@"devicevaction"];
                [menuDeviceView[alertIndex] addSubview:imgVaction];
            }
            
            UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDetectedRightLightsCard:)];
            swipeRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
            [menuDeviceView[alertIndex] addGestureRecognizer:swipeRecognizerRight];
            
            yOffset_Sprinklers=menuDeviceView[alertIndex].frame.size.height+menuDeviceView[alertIndex].frame.origin.y+5;
        }
        
        yaxis_Device=yOffset_Sprinklers;
        NSLog(@"org yaxis for sprinkler list ==%f",yaxis_Device);
        [self changeDeviceViewHeight:yaxis_Device];
        self.viewSprinklerAlert_Device_FooterView.hidden=NO;
        self.viewSprinklerAlert.layer.cornerRadius = 16.0;
        strStatusDevice=@"YES";
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    [self.viewSprinklerAlert_DeviceView setHidden:NO];
    [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
}

-(void)changeDeviceViewHeight:(float)yaxis_DeviceDummy
{
    //Device Container
    CGRect newAlertFrame=self.viewSprinklerAlert_DeviceView.frame;
    newAlertFrame.size.height=yaxis_DeviceDummy;
    self.viewSprinklerAlert_DeviceView.frame=newAlertFrame;
    
    //Device Footer Card View
    CGRect newAlertFrame_Footer=self.viewSprinklerAlert_Device_FooterView.frame;
    newAlertFrame_Footer.origin.y=newAlertFrame.size.height+newAlertFrame.origin.y+20;
    self.viewSprinklerAlert_Device_FooterView.frame=newAlertFrame_Footer;
    
    //Device Card View
    yaxis_DeviceDummy=newAlertFrame_Footer.size.height+newAlertFrame_Footer.origin.y;
    
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        if (yaxis_DeviceDummy>438)
        {
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width, yaxis_DeviceDummy+10);
            swipeDownLightsAlert.enabled=NO;
        }
        else{
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width,438);
            [self swipeDown_Spinkler_PopUp];
        }
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        if (yaxis_DeviceDummy>584)
        {
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width, yaxis_DeviceDummy+10);
            swipeDownLightsAlert.enabled=NO;
        }
        else{
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width,584);
            [self swipeDown_Spinkler_PopUp];
        }
        
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        if (yaxis_DeviceDummy>523)
        {
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width, yaxis_DeviceDummy+10);
            swipeDownLightsAlert.enabled=NO;
        }
        else{
            self.viewSprinklerAlert.frame=CGRectMake(self.viewSprinklerAlert.frame.origin.x, self.viewSprinklerAlert.frame.origin.y, self.viewSprinklerAlert.frame.size.width,523);
            [self swipeDown_Spinkler_PopUp];
        }
    }
    //Sprinkler Schedule Scroll Setup
    self.scrollView_SprinklerCard.contentSize=CGSizeMake(scrollView_SprinklerCard.frame.size.width, self.viewSprinklerAlert.frame.origin.y+self.viewSprinklerAlert.frame.size.height);
}

-(void)sprinkler_ScheduleTap:(UITapGestureRecognizer*)sender
{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Owner==%@",appDelegate.strOwnerNetwork_Status);
    //    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    //    {
    //        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
    //        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
    //        {
    //            [Common showAlert:kAlertTitleWarning withMessage:@"You have no permisson to do this"];
    //            return;
    //        }
    //    }
    UIView *view = sender.view;
    int schTag=(int)view.tag;
    NSLog(@"tag==%ld",(long)view.tag);
    NSLog(@"arr_Schedule_Sprinklers%@",[arr_Schedule_Sprinklers objectAtIndex:schTag]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strDevice_Added_Mode=@"NetworkHome";
    
    AddSprinklerScheldule *ASSVC = [[AddSprinklerScheldule alloc] initWithNibName:@"AddSprinklerScheldule" bundle:nil];
    ASSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
    [ASSVC setDelegate:self];
    ASSVC.dictScheduleList=[arr_Schedule_Sprinklers objectAtIndex:schTag];
    ASSVC.strScheduleAction=@"EDIT";
    [Common viewSlide_FromRight_ToLeft:self.navigationController.view];
    [self.navigationController pushViewController:ASSVC animated:NO];
}

-(void)hideAlertView_Sprinklers{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self resetAlertsFramesSprinklersCards];
    } completion:^(BOOL finished) {
        [self.BodyView_NetworkHome setUserInteractionEnabled:YES];
        
    }];
}

-(void)hide_AddDevicePopUp_PropertyMap
{
    viewAlert_AddDevice.hidden=YES;
    [BodyView_Container setAlpha:1.0];
    [headerView_NetworkHome setAlpha:1.0];
    [self.titleBarView1_swipe setAlpha:1.0];
}

-(void)popUp_Alpha_NwHome_Enabled
{
    [self.BodyView_Container setAlpha:0.6];
    [self.header_View_Lights setAlpha:0.6];
    [self.titleBarView1_swipe setAlpha:0.6];
}

-(void)popUp_Alpha_NwHome_Disabled
{
    [self.BodyView_Container setAlpha:1.0];
    [self.header_View_Lights setAlpha:1.0];
    [self.titleBarView1_swipe setAlpha:1.0];
}

#pragma mark - Timer Methods
- (void)startLogTimer {
    NSLog(@"Timer Start");
    NSString *durationStr =@"1";
    NSLog(@"set defualt duraion 60 sec %@",durationStr);
    NSInteger duration = [durationStr integerValue] * 60; //in sec
    NSLog(@"duration==%ld",(long)duration);
    self.logTimer=nil;
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

-(void)fetchCurrentTime
{
    NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrWeatherDetails objectAtIndex:0] objectForKey:@"weatherModifyTimeStamp"]] doubleValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    Time = [dateFormatter stringFromDate:epochNSDate];
    NSLog(@"Your local time is: %@", Time);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *timeFormatter;
    timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString  *timerTime = [timeFormatter stringFromDate:now];
    NSLog(@"%@",timerTime);
    NSDate *start = [timeFormatter dateFromString:Time];
    end = [timeFormatter dateFromString:timerTime];
    interval = [end timeIntervalSinceDate:start];
    NSLog(@"interval==%f",interval);
    timerMinutes = (fabs(interval)/60);
    NSLog(@"%d mins",timerMinutes);

    int hour = timerMinutes / 60;
    int min = timerMinutes % 60;
    if(hour == 0){
        if(min <= 1){
            lbl_timeAgo.text = [NSString stringWithFormat:@"%d Minute Ago", min];
        }else {
            lbl_timeAgo.text = [NSString stringWithFormat:@"%d Minutes Ago", min];
        }
    }
    else{
        lbl_timeAgo.text = [NSString stringWithFormat:@"%dh %02dm Ago", hour, min];
    }
}

- (void)timerTick {
    NSLog(@"%d minutes",timerMinutes);
    timerMinutes = timerMinutes+1;
    NSLog(@"%d",timerMinutes);
    int hour = timerMinutes / 60;
    int min = timerMinutes % 60;
    
    if(hour == 0){
        if(min <= 1){
            lbl_timeAgo.text = [NSString stringWithFormat:@"%d Minute Ago", min];
        }else {
            lbl_timeAgo.text = [NSString stringWithFormat:@"%d Minutes Ago", min];
        }
    }
    else{
        lbl_timeAgo.text = [NSString stringWithFormat:@"%dh %02dm Ago", hour, min];
    }
    NSLog(@"%@",lbl_timeAgo.text);
}

#pragma mark - Protocol implmentation
/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal implementation
 Method Name : processSuccessful_Back_To_NetworkHome(User Defined Methods)
 ************************************************************************************* */
-(void)processSuccessful_Back_To_NetworkHome:(BOOL)success
{
     if(success){
         [self resetNetwork_Views];
         [Common resetNetworkFlags];
     }
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal implementation
 Method Name : processSuccessful_Back_To_NetworkHome_Via_Lights(User Defined Methods)
 ************************************************************************************* */
-(void)processSuccessful_Back_To_NetworkHome_Via_Lights:(BOOL)success
{
    if(success){
        [self resetNetwork_Views];
        [Common resetNetworkFlags];
    }
}

/* **********************************************************************************
 Date : 06/08/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal implementation
 Method Name : processSuccessful_Back_To_NetworkHome_Via_Sprinkler(User Defined Methods)
 ************************************************************************************* */
-(void)processSuccessful_Back_To_NetworkHome_Via_Sprinkler:(BOOL)success
{
    if(success){
        [self resetNetwork_Views];
        [Common resetNetworkFlags];
    }
}

/* **********************************************************************************
 Date : 12/08/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal implementation
 Method Name : processSuccessful_Back_To_NetworkHome_Via_DeviceSetUp(User Defined Methods)
 ************************************************************************************* */
-(void)processSuccessful_Back_To_NetworkHome_Via_DeviceSetUp:(BOOL)success
{
    if(success){
        [self resetNetwork_Views];
        [Common resetNetworkFlags];
    }
}

/* **********************************************************************************
 Date : 12/08/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal implementation
 Method Name : processSuccessful_Back_To_NetworkHome_Via_DeviceSetUp(User Defined Methods)
 ************************************************************************************* */
-(void)processSuccessful_Back_To_NetworkHome_Via_SprinklerDeviceSetUp:(BOOL)success
{
    if(success){
        [self resetNetwork_Views];
        [Common resetNetworkFlags];
    }
}

-(void)processSuccessful_Back_To_TimeLine:(BOOL)success
{
    if(success){
        [self resetNetwork_Views];
        [Common resetNetworkFlags];
    }
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : View Setup
 Method Name : resetNetwork_Views(User Defined Methods)
 ************************************************************************************* */
-(void)resetNetwork_Views{
    if([strAlertType isEqualToString:@"AlertsMSG"]){
        [self hideAlertView];
    }else if([strAlertType isEqualToString:@"AlertsLights"]||[strAlertType isEqualToString:@"AlertsOthers"]){
        [self hideAlertView_LightsOthers];
    }else if([strAlertType isEqualToString:@"AlertsSprinklers"]){
        [self hideAlertView_Sprinklers];
    }
    if(wheaterTag==2)
    {
        [self PropertMap_to_Home];
    }
    [BodyView_NetworkHome setHidden:NO];
    [BodyView_Weather setHidden:YES];
    [BodyView_PropertyMap setHidden:YES];
    wheaterTag=0;
    strAlertType=@"";
}
#pragma mark - Orientation
/* **********************************************************************************
 Date : 25/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Set the Orientation of the view
 Method Name : shouldAutorotate(Pre Defined Method)
 ************************************************************************************* */
- (BOOL) shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
    //return here which orientation you are going to support
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        NSLog(@"Landscape left");
//        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
//        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
//        [Common viewFadeIn:self.navigationController.view];
//        [self.navigationController pushViewController:TLVC animated:NO];
//        
//    }
//    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        NSLog(@"Landscape right");
//        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
//        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
//        [Common viewFadeIn:self.navigationController.view];
//        [self.navigationController pushViewController:TLVC animated:NO];
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
//    }
}
#pragma mark - Scroll Fluid
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"scroll begn");
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scollview content offset==%f",scrollView_Alert.contentOffset.y);
    NSLog(@"scroll did"); //resetAlertsFramesLightsCards
    if([strAlertType isEqualToString:@"AlertsMSG"]){
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
        }
        if (scrollView.contentOffset.y <=-50)
        {
            [self hideAlertView];
        }
        
    }
    else if([strAlertType isEqualToString:@"AlertsLights"]||[strAlertType isEqualToString:@"AlertsOthers"]){
        
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
        }
        if (scrollView.contentOffset.y <=-50)
        {
            [self hideAlertView_LightsOthers];
        }
        
    }
    else if([strAlertType isEqualToString:@"AlertsSprinklers"]){
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
        }
        if (scrollView.contentOffset.y <=-50)
        {
            [self hideAlertView_Sprinklers];
        }
    }
}

#pragma mark - SwitchToggle
-(void)changeCardSwitchStatus
{
    //place_name
    NSString *strDeviceName;
    if([deviceActions isEqualToString:@"lights"]){
        strDeviceName=@"ac_switch";
        
    }else{
        strDeviceName=@"valve_controller";
    }
    NSString *jsonReq= [NSString stringWithFormat:@"{\"deviceName\":\"%@\",\"smsType\":\"%@\"}",strDeviceName,strTYPES];
    NSLog(@"JSON Req==%@",jsonReq);
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *postURL = [NSURL URLWithString:@"http://noidsmsrest.elasticbeanstalk.com/noid/v0.2/devices/sms"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: postURL
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue:@"testapikey" forHTTPHeaderField:@"apikey"];
    [request setValue:@"testapisecretkey" forHTTPHeaderField:@"apisecretkey"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"content-type"];
    [request setHTTPBody: [jsonReq dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   NSLog(@"error");
                                   // [self performSelectorOnMainThread:@selector(stopPinfavorite) withObject:self waitUntilDone:YES];
                                   [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
                               } else {
                                   // Handle the success
                                   NSLog(@"Succ");
                                   
                                   NSString *resp = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                                   NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSLog(@"response for particularplacedetails.......................%@", resp);
                                   NSString *resCode=[parsedObject valueForKey:@"code"];
                                   respMSG=[parsedObject valueForKey:@"message"];
                                   NSLog(@"dict is ==%@",parsedObject);
                                   NSLog(@"uwres code is==%@",resCode);
                                   NSLog(@"uwres msg is==%@",respMSG);
                                   if([resCode isEqualToString:@"200"]){
                                       [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
                                       // [self performSelectorOnMainThread:@selector(responseMessage) withObject:self waitUntilDone:YES];
                                       
                                   }else{
                                       
                                       [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
                                       //  [self performSelectorOnMainThread:@selector(responseMessage) withObject:self waitUntilDone:YES];
                                   }
                                   
                               }
                           }
     ];
}

/*-(void)getController_DeviceDetails
{
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSLog(@"%@",[[appDelegate.dicit_NetworkDatas objectForKey:@"account"]objectForKey:@"id"]);
    
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dicit_NetworkDatas objectForKey:@"id"],appDelegate.strControllerID];
    
//NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"ACCOUNTID"]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for User Basic Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseError_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)response_DeviceDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT controller Data ==%@",dicitData);
            NSLog(@"DIC controller Data  count==%lu",(unsigned long)dicitData.count);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)responseError_DeviceDetails
{
    [Common showAlert:kAlertTitleWarning withMessage:strResponseError];
} 

 */

#pragma mark - Webservice Part
-(void)getAllNOID_Devices
{
    NSString *strType=@"";
    if([deviceActions isEqualToString:@"lights"])
    {
        strType=@"1";
    }
    else{
        strType=@"3";
    }
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
   NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices?deviceTypeId=%@",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],strType];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Devices==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(loadAlertsDatas_LightsOthers) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Devices ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseErrorListDevices
{
    [Common showAlert:kAlertTitleWarning withMessage:strResponseError];
}
-(void)loadAlertsDatas_LightsOthers{
    
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arrDevices = [[NSMutableArray alloc] init];
            arrDevices=[responseDict valueForKey:@"data"];
            NSLog(@"device data count==%lu",(unsigned long)arrDevices.count);
            [self rendering_LightsOthers_Card];
            
        }else{
            [self stop_PinWheel_Lights];
            if (![responseMessage isEqualToString:@"Device list information is unavailable"]) {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            if([deviceActions isEqualToString:@"lights"]){
                self.viewLightsCard_FooterView.backgroundColor=lblRGBA(255, 206, 52, 1);
            }else if([deviceActions isEqualToString:@"others"]){
                self.viewLightsCard_FooterView.backgroundColor=lblRGBA(49, 165, 222, 1);
            }
            self.viewLightsCard_FooterView.hidden=NO;
            self.viewLightsCard_FooterView.frame = CGRectMake(self.viewLightsCard_FooterView.frame.origin.x,75,self.viewLightsCard_FooterView.frame.size.width, self.viewLightsCard_FooterView.frame.size.height);
            self.ViewLightDevice.layer.cornerRadius=16.0;
            [self swipeDown_Lights_PopUp];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        return;
    }
}

-(void)getWeatherDetails
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);

    NSString *sLat=[appDelegate.dict_NetworkControllerDatas valueForKey:kLat];
    sLat=[NSString stringWithFormat:@"%.2f",[sLat floatValue]];
    NSString *sLong=[appDelegate.dict_NetworkControllerDatas valueForKey:kLong];
    sLong=[NSString stringWithFormat:@"%.2f",[sLong floatValue]];
//    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/forecast?latitude=%@&longitude=%@",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],sLat,sLong];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/weather",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];

    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for User Basic Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_WeatherDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for User Basic Details==%@",resErrorString);
        btn_currentWeather.userInteractionEnabled=NO;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(checkAnyDevicesAddedFirstTime) withObject:self waitUntilDone:YES];
    };
    if ([strWeatherType isEqualToString:@"refresh"]) {
        [SCM serviceConnectorPUT:nil andMethodName:strMethodNameWith_Value];
 }else{
        [SCM serviceConnectorGET:strMethodNameWith_Value];
    }

}

-(void)checkAnyDevicesAddedFirstTime
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strDevice_Added_Status isEqualToString:@"NEWPOPUPLOAD"]){
        if([appDelegate.strAddedDevice_Type isEqualToString:@"lights"]){
            [self showLightsPopup];
        }else if([appDelegate.strAddedDevice_Type isEqualToString:@"others"]){
            [self showOthersPopup];
        }else if([appDelegate.strAddedDevice_Type isEqualToString:@"sprinklers"]){
            [self showSprinklerPopup];
        }
        [Common resetNetworkFlags];
    }
}
-(void)response_WeatherDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arrWeatherDetails = [[NSMutableArray alloc] init];
            strTimeZoneIDFor_Weather=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            arrWeatherDetails = [[responseDict objectForKey:@"data"] objectForKey:@"weatherList"];
            NSLog(@"DICT weather Data ==%@",arrWeatherDetails);
            NSLog(@"DIC weather Data  count==%lu",(unsigned long)arrWeatherDetails.count);
            if([arrWeatherDetails count]>0)
            {
                arrWeatherDetails=[[[arrWeatherDetails reverseObjectEnumerator] allObjects] mutableCopy];
                NSLog(@"reverse array==%@",arrWeatherDetails);
//                [self fetchCurrentTime];
                [self parseWeatherDetails:arrWeatherDetails];
//                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//                if([appDelegate.strOwnerNetwork_Status isEqualToString:@"YES"]){
                    btn_currentWeather.userInteractionEnabled=YES;
//                }
            }else{
                btn_currentWeather.userInteractionEnabled=NO;
                [self stop_PinWheel_Lights];
                [self checkAnyDevicesAddedFirstTime];
            }
        }else{
            btn_currentWeather.userInteractionEnabled=NO;
            [self stop_PinWheel_Lights];
            [self checkAnyDevicesAddedFirstTime];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        btn_currentWeather.userInteractionEnabled=NO;
        [self stop_PinWheel_Lights];
        [self checkAnyDevicesAddedFirstTime];
    }
}

-(void)parseWeatherDetails:(NSMutableArray *)arrweatherDetails
{
    @try {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *timestamp=@"",*day=@"";
        
        for (int index=0; index<[arrweatherDetails count]; index++) {
            int maxTemp = roundf([[[arrweatherDetails objectAtIndex:index] objectForKey:@"maxTemperature"] floatValue]);
            int minTemp = roundf([[[arrweatherDetails objectAtIndex:index] objectForKey:@"minTemperature"] floatValue]);
            
            NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrweatherDetails objectAtIndex:index] objectForKey:@"sunriseTime"]] doubleValue];
            NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_Weather]];
            [dateFormatter setDateFormat:@"EEE dd MMM YYYY"];
            
            timestamp = [dateFormatter stringFromDate:epochNSDate];
            [dateFormatter setDateFormat:@"EEE"];
            day = [dateFormatter stringFromDate:epochNSDate];
            NSLog(@"Your local date is: %@", timestamp);
            [self parseWeatherImage:currentWeather_tag];

            if (index==0) {
                lbl_maxTemp_Weather.text = [NSString stringWithFormat:@"%dº%@",maxTemp,[[arrweatherDetails objectAtIndex:index] objectForKey:@"temperatureType"]];
                lbl_minTemp_Weather.text = [NSString stringWithFormat:@"%dº%@",minTemp,[[arrweatherDetails objectAtIndex:index] objectForKey:@"temperatureType"]];
                lbl_latlong_weather.text=[NSString stringWithFormat:@"%.2f - %.2f",[[[arrweatherDetails objectAtIndex:index] objectForKey:@"latitude"] floatValue],[[[arrweatherDetails objectAtIndex:index] objectForKey:@"longitude"] floatValue]];
                
                if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"clear-day"]) {
                    strWeatherName = @"bigClearDayImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"clear-night"]) {
                    strWeatherName = @"bigClearNightImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"rain"]) {
                    strWeatherName = @"bigWeatherImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"snow"]) {
                    strWeatherName = @"bigSnowImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"sleet"]) {
                    strWeatherName = @"bigSleetImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"wind"]) {
                    strWeatherName = @"bigWindImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"fog"]) {
                    strWeatherName = @"bigFogImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"cloudy"]) {
                    strWeatherName = @"bigCloudyImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"partly-cloudy-day"]) {
                    strWeatherName = @"bigPartyCloudyImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"partly-cloudy-night"]) {
                    strWeatherName = @"bigPartyCloudyNightImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"hail"]) {
                    strWeatherName = @"bigHailImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"thnderstorm"]) {
                    strWeatherName = @"bigThunderstormImage";
                }else if ([[[arrWeatherDetails objectAtIndex:0] valueForKey:@"icon"] isEqualToString:@"tornado"]) {
                    strWeatherName = @"bigTornadoImage";
                }

                [btn_currentWeather setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",strWeatherName]] forState:UIControlStateNormal];
                NSString *str = [NSString stringWithFormat:@"%@",[[arrweatherDetails objectAtIndex:index] objectForKey:@"weatherCreateTimeStamp"]];
                NSString *str1 = [NSString stringWithFormat:@"%@",[[arrweatherDetails objectAtIndex:index] objectForKey:@"weatherModifyTimeStamp"]];
                NSLog(@"create time==%@",str);
                NSLog(@"modify time==%@",str1);
                lbl_maxtemp1.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp1.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather1.text = day;
            }else if (index==1){
                lbl_maxtemp2.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp2.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather2.text = day;
            }else if (index==2){
                lbl_maxtemp3.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp3.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather3.text = day;
            }else if (index==3){
                lbl_maxtemp4.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp4.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather4.text = day;
            }else if (index==4){
                lbl_maxtemp5.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp5.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather5.text = day;
            }else if (index==5){
                lbl_maxtemp6.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp6.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather6.text = day;
            }else if (index==6){
                lbl_maxtemp7.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp7.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather7.text = day;
            }else if (index==7){
                lbl_maxtemp8.text = [NSString stringWithFormat:@"%dº",maxTemp];
                lbl_temp8.text = [NSString stringWithFormat:@"%dº",minTemp];
                lbl_dayWeather8.text = day;
            }
        }
//        lbl_timeAgo.text = @"0 Minute Ago";
        if (currentWeather_tag==0) {
            [self currentWeatherView];
        }
        [self fetchCurrentTime];
        [self parseSmallWeatherImage];
        [self checkAnyDevicesAddedFirstTime];
        [self startLogTimer];
        [self stop_PinWheel_Lights];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [self checkAnyDevicesAddedFirstTime];
    }
}

-(void)parseWeatherImage:(int)tag
{
    @try {
//        NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"forecastDate"]] doubleValue];
        NSTimeInterval date =[[NSString stringWithFormat:@"%@",[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"sunriseTime"]] doubleValue];
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:date/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:strTimeZoneIDFor_Weather]];
        [dateFormatter setDateFormat:@"EEE dd MMM YYYY"];
        NSString *timestamp = [dateFormatter stringFromDate:epochNSDate];
        NSLog(@"Your local date is: %@", timestamp);
        
        if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"clear-day"]) {
            strWeatherName = @"bigClearDayImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"clear-night"]) {
            strWeatherName = @"bigClearNightImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"rain"]) {
            strWeatherName = @"bigWeatherImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"snow"]) {
            strWeatherName = @"bigSnowImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"sleet"]) {
            strWeatherName = @"bigSleetImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"wind"]) {
            strWeatherName = @"bigWindImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"fog"]) {
            strWeatherName = @"bigFogImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"cloudy"]) {
            strWeatherName = @"bigCloudyImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"partly-cloudy-day"]) {
            strWeatherName = @"bigPartyCloudyImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"partly-cloudy-night"]) {
            strWeatherName = @"bigPartyCloudyNightImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"hail"]) {
            strWeatherName = @"bigHailImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"thnderstorm"]) {
            strWeatherName = @"bigThunderstormImage";
        }else if ([[[arrWeatherDetails objectAtIndex:tag] valueForKey:@"icon"] isEqualToString:@"tornado"]) {
            strWeatherName = @"bigTornadoImage";
        }
        float humidity=[[[arrWeatherDetails objectAtIndex:tag]objectForKey:@"humidity"]floatValue];
        int roundHumidity = roundf(humidity*100);
        lbl_Humidity.text=[NSString stringWithFormat:@"%d",roundHumidity];
        NSLog(@"%@",lbl_Humidity.text);
        
        lbl_Summery_weather.text=[NSString stringWithFormat:@"%@",[[arrWeatherDetails objectAtIndex:tag]objectForKey:@"summary"]];
        img_WeatherCondition.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",strWeatherName]];
        lbl_Date_weather.text = timestamp;
        
        int maxTemp = roundf([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"maxTemperature"] floatValue]);
        int minTemp = roundf([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"minTemperature"] floatValue]);
        
        lbl_maxTempBig_weather.text = [NSString stringWithFormat:@"%dº%@",maxTemp,[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"temperatureType"]];;
        lbl_minTempBig_weather.text = [NSString stringWithFormat:@"%dº%@",minTemp,[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"temperatureType"]];
        
        float ozone =[[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"ozone"] floatValue];
        int ozoneVal=roundf(ozone);
        self.lbl_Ozone.text=[NSString stringWithFormat:@"%d",ozoneVal];
        
        float pressure =[[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"pressure"] floatValue];
        int pressureVal=roundf(pressure);
        self.lbl_Pressure.text=[NSString stringWithFormat:@"%d",pressureVal];

        
        float windSpeed =[[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windSpeed"] floatValue];
        int windVal=roundf(windSpeed);
        self.lbl_Weather_WindCount.text=[NSString stringWithFormat:@"%d",windVal];

        NSLog(@"WindDirection === %@",[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"]);
        
        if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"North"]) //North
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windN"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"North-northeast"]) //North-northeast
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windNNE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"Northeast"]) //Northeast
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windNE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"East-northeast"]) //East-southeast
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windENE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"East"]) //East
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"East-southeast"]) //East-southeast
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windESE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"Southeast"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windSE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"South-southeast"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windSSE"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"South"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windS"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"South-southwest"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windSSW"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"Southwest"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windSW"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"West-southwest"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windWSW"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"West"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windW"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"West-northwest"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windWNW"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"Northwest"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windNW"] forState:UIControlStateNormal];
        }
        else if([[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"windDirection"] isEqualToString:@"North-northwest"])
        {
            [btn_Weather_WindImg setBackgroundImage:[UIImage imageNamed:@"windNNW"] forState:UIControlStateNormal];
        }
        //Sunset or Sunrise cal
        NSTimeInterval sunRiseTime = [[NSString stringWithFormat:@"%@",[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"sunriseTime"]] doubleValue];
        NSTimeInterval sunSetTime = [[NSString stringWithFormat:@"%@",[[arrWeatherDetails objectAtIndex:tag] objectForKey:@"sunsetTime"]] doubleValue];
        
        
        NSDate *epochRiseTime = [[NSDate alloc] initWithTimeIntervalSince1970:sunRiseTime/1000];
        NSDate *epochSetTime = [[NSDate alloc] initWithTimeIntervalSince1970:sunSetTime/1000];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"HH:mm"];
        //[dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
        
        NSString *RiseTime = [dateFormatter1 stringFromDate:epochRiseTime];
        NSString *SetTime = [dateFormatter1 stringFromDate:epochSetTime];
        
        NSLog(@"rise time == %@",RiseTime);
        NSLog(@"set time == %@",SetTime);
        
        if(tag==0)
        {
            NSDate *currentTime = [NSDate date];
            
            NSString *hourCountString =[dateFormatter1 stringFromDate:currentTime];
            NSLog(@"current time == %@",hourCountString);
            
            NSComparisonResult result = [hourCountString compare:RiseTime];
            NSLog(@"reult==%ld",(long)result);
            
            if(result == NSOrderedDescending)
            {
                lbl_weather_subSunsetTime.text=SetTime;
                [btn_Weather_SunRiseImg setImage:[UIImage imageNamed:@"SunsetImage"] forState:UIControlStateNormal];
            }
            else if(result == NSOrderedAscending)
            {
                lbl_weather_subSunsetTime.text=RiseTime;
                [btn_Weather_SunRiseImg setImage:[UIImage imageNamed:@"sunrise_imagei6plus"] forState:UIControlStateNormal];
            }
            else
            {
                lbl_weather_subSunsetTime.text=RiseTime;
                [btn_Weather_SunRiseImg setImage:[UIImage imageNamed:@"sunrise_imagei6plus"] forState:UIControlStateNormal];
            }
        }
        else{
            lbl_weather_subSunsetTime.text=RiseTime;
            [btn_Weather_SunRiseImg setImage:[UIImage imageNamed:@"sunrise_imagei6plus"] forState:UIControlStateNormal];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)parseSmallWeatherImage
{
    lbl_NetworkName_weather.text = lbl_networkName.text;
    for (int i=0; i<[arrWeatherDetails count]; i++) {
        if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"clear-day"]) {
            strSmallWeatherImage[i] = @"smallClearDayImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"clear-night"]) {
            strSmallWeatherImage[i] = @"smallClearNightImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"rain"]) {
            strSmallWeatherImage[i] = @"smallRainImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"snow"]) {
            strSmallWeatherImage[i] = @"smallSnowImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"sleet"]) {
            strSmallWeatherImage[i] = @"smallSleetImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"wind"]) {
            strSmallWeatherImage[i] = @"smallWindImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"fog"]) {
            strSmallWeatherImage[i] = @"smallFogImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"cloudy"]) {
            strSmallWeatherImage[i] = @"smallCloudyImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"partly-cloudy-day"]) {
            strSmallWeatherImage[i] = @"smallPartyCloudydayImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"partly-cloudy-night"]) {
            strSmallWeatherImage[i] = @"smallPartyCloudyNightImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"hail"]) {
            strSmallWeatherImage[i] = @"smallHailImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"thnderstorm"]) {
            strSmallWeatherImage[i] = @"smallThunderstormImage";
        }else if ([[[arrWeatherDetails objectAtIndex:i] valueForKey:@"icon"] isEqualToString:@"tornado"]) {
            strSmallWeatherImage[i] = @"smallTornadoImage";
        }
    }
    img_weather1.image = [UIImage imageNamed:strSmallWeatherImage[0]];
    img_weather2.image = [UIImage imageNamed:strSmallWeatherImage[1]];
    img_weather3.image = [UIImage imageNamed:strSmallWeatherImage[2]];
    img_weather4.image = [UIImage imageNamed:strSmallWeatherImage[3]];
    img_weather5.image = [UIImage imageNamed:strSmallWeatherImage[4]];
    img_weather6.image = [UIImage imageNamed:strSmallWeatherImage[5]];
    img_weather7.image = [UIImage imageNamed:strSmallWeatherImage[6]];
    img_weather8.image = [UIImage imageNamed:strSmallWeatherImage[7]];
}

- (BOOL)isExclusiveTouch
{
    return YES;
}

-(void)update_DeviceStatus
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/profileStatus",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    NSDictionary *parameters;
    NSMutableDictionary *dictDeviceStatus=[[NSMutableDictionary alloc] init];
    [dictDeviceStatus setObject:[[[arrDevices objectAtIndex:deviceTag] objectForKey:@"id"] stringValue] forKey:kDeviceID];
    [dictDeviceStatus setObject:strManualType forKey:kDeviceStatus];
    
    parameters=[SCM device_Status_Update:dictDeviceStatus];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Device Manual On Off status==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDeviceManualStatusLIGHTSOTHERS) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Device Manual On Off status==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(resetDeviceCardSwitchOldPos) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
        self.view.userInteractionEnabled=YES;
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)resetDeviceCardSwitchOldPos
{
    if([strManualType isEqualToString:@"1"])
    {
        [deviceSwitch_Alerts[deviceTag] setOn:NO animated:NO];
        [deviceSwitch_Alerts[deviceTag] setSelected:NO];
        [deviceSwitch_Alerts[deviceTag] setTintColor:lblRGBA(255, 255, 255, 1)];
        [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(99, 99, 102, 1)];
        menuDeviceView[deviceTag].backgroundColor=lblRGBA(99, 100, 102, 1);
    }else{
        [deviceSwitch_Alerts[deviceTag] setOn:YES animated:NO];
        [deviceSwitch_Alerts[deviceTag] setSelected:YES];
        if([deviceActions isEqualToString:@"lights"]){
            menuDeviceView[deviceTag].backgroundColor=lblRGBA(255, 206, 52, 1);
            [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(255, 206, 52, 1)];
        }else if([deviceActions isEqualToString:@"others"]){
            menuDeviceView[deviceTag].backgroundColor=lblRGBA(40, 165, 222, 1);
            [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(49, 165, 222, 1)];
        }
        else if([deviceActions isEqualToString:@"sprinklers"]){
            menuDeviceView[deviceTag].backgroundColor=lblRGBA(135, 197, 65, 1);
            [deviceSwitch_Alerts[deviceTag] setThumbTintColor:lblRGBA(135, 197, 65, 1)];
        }
    }
}
-(void)responseDeviceManualStatusLIGHTSOTHERS
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            
            [self stop_PinWheel_Lights];
        }
        else{
            [self resetDeviceCardSwitchOldPos];
            [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self resetDeviceCardSwitchOldPos];
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    self.view.userInteractionEnabled=YES;
}


-(void)responseDeviceManualStatus
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            if([strManualType isEqualToString:@"1"])
            {
//                if(sprinkler_On_Count>=1)
//                {
//                    [deviceSwitch_Alerts[current_Active_On_Tag] setOn:NO animated:NO];
//                    [deviceSwitch_Alerts[current_Active_On_Tag] setSelected:NO];
//                    [deviceSwitch_Alerts[current_Active_On_Tag] setTintColor:lblRGBA(255, 255, 255, 1)];
//                    [deviceSwitch_Alerts[current_Active_On_Tag] setThumbTintColor:lblRGBA(99, 99, 102, 1)];
//                    menuDeviceView[current_Active_On_Tag].backgroundColor=lblRGBA(99, 100, 102, 1);
//                    current_Active_On_Tag=deviceTag;
//                }else{
//                    current_Active_On_Tag=deviceTag;
//                }
                for(int index=0;index<[arrDevices count];index++)
                {
                    if(deviceTag!=index)
                    {
                        [deviceSwitch_Alerts[index] setOn:NO animated:NO];
                        [deviceSwitch_Alerts[index] setSelected:NO];
                        [deviceSwitch_Alerts[index] setTintColor:lblRGBA(255, 255, 255, 1)];
                        [deviceSwitch_Alerts[index] setThumbTintColor:lblRGBA(99, 99, 102, 1)];
                        menuDeviceView[index].backgroundColor=lblRGBA(99, 100, 102, 1);
                    }
                }
                current_Active_On_Tag=deviceTag;
                if(sprinkler_On_Count==0)
                {
                    sprinkler_On_Count=1;
                }
                
            }else{
                sprinkler_On_Count=sprinkler_On_Count-1;
                
            }
            
            [self stop_PinWheel_Lights];
        }
        else{
            [self resetDeviceCardSwitchOldPos];
            [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self resetDeviceCardSwitchOldPos];
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    self.view.userInteractionEnabled=YES;
}
-(void)getAllNOID_Messages
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    
    NSString *sLat=[appDelegate.dict_NetworkControllerDatas valueForKey:kLat];
    sLat=[NSString stringWithFormat:@"%.2f",[sLat floatValue]];
    NSString *sLong=[appDelegate.dict_NetworkControllerDatas valueForKey:kLong];
    sLong=[NSString stringWithFormat:@"%.2f",[sLong floatValue]];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/messages",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for messages list==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseMessages) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for  messages list ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseMessages
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrRead=[[NSMutableArray alloc] init];
            arrAlerts=[[NSMutableArray alloc] init];
            NSMutableArray *arrUnRead=[[NSMutableArray alloc] init];
            arrUnRead=[[responseDict valueForKey:@"data"] valueForKey:@"unRead"];
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            messageCount = (int)[arrUnRead count];
            NSLog(@"count==%d",messageCount);
            [btn_Message_Count setTitle: [NSString stringWithFormat:@"%d",messageCount] forState:UIControlStateNormal];

            if([arrUnRead count]>0)
            {
                for(int index=0;index<[arrUnRead count];index++)
                {
                    NSMutableDictionary *dictUnRead=[[NSMutableDictionary alloc] init];
                    [dictUnRead setObject:[[[arrUnRead objectAtIndex:index] objectForKey:@"id"] stringValue] forKey:kMessageID];
                    [dictUnRead setObject:[[arrUnRead objectAtIndex:index] objectForKey:@"description"] forKey:kMessageDesc];
                    [dictUnRead setObject:[[arrUnRead objectAtIndex:index] objectForKey:@"subject"] forKey:kMessageSub];
                    [dictUnRead setObject:[[arrUnRead objectAtIndex:index] objectForKey:@"modifyTimestamp"] forKey:kMessageTime];
                    [dictUnRead setObject:@"unread" forKey:kMessageStatus];
                    [arrAlerts addObject:dictUnRead];
                }
            }
            
            arrRead=[[responseDict valueForKey:@"data"] valueForKey:@"read"];
            if([arrRead count]>0)
            {
                for(int index=0;index<[arrRead count];index++)
                {
                    NSMutableDictionary *dictRead=[[NSMutableDictionary alloc] init];
                    [dictRead setObject:[[[arrRead objectAtIndex:index] objectForKey:@"id"] stringValue] forKey:kMessageID];
                    [dictRead setObject:[[arrRead objectAtIndex:index] objectForKey:@"description"] forKey:kMessageDesc];
                    [dictRead setObject:[[arrRead objectAtIndex:index] objectForKey:@"subject"] forKey:kMessageSub];
                    [dictRead setObject:[[[arrRead objectAtIndex:index] objectForKey:@"modifyTimestamp"] stringValue] forKey:kMessageTime];
                    [dictRead setObject:@"read" forKey:kMessageStatus];
                    [arrAlerts addObject:dictRead];
                }
            }
            
            [self loadAlertsDatas];
            // [self stop_PinWheel_Lights];
        }
        else{
            [self stop_PinWheel_Lights];
            if(![responseMessage isEqualToString:@"No Messages to view"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                
            }
            
            self.view_alert.layer.cornerRadius=16.0;
            [self swipeDown_Alert_PopUp];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)updateStatusRead
{
    NSDictionary *parameters;
    defaults=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/messages",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    NSMutableDictionary *dictReadMsg_Update=[[NSMutableDictionary alloc] init];
    [dictReadMsg_Update setObject:[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageID] forKey:kMessageID];
    [dictReadMsg_Update setObject:@"viewed" forKey:kMessageAction];
    
    parameters=[SCM update_Read_Message_Status:dictReadMsg_Update];
    NSLog(@"%@",parameters);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Read msg status==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseReadMessagesUpdate) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Read msg status==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseReadMessagesUpdate
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSLog(@"%@",[arrAlerts objectAtIndex:tag_Pos_Alerts]);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"read" forKey:kMessageStatus];
            [dict setObject:[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageID] forKey:kMessageID];
            [dict setObject:[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageDesc] forKey:kMessageDesc];
            [dict setObject:[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageSub] forKey:kMessageSub];
            [dict setObject:[[arrAlerts objectAtIndex:tag_Pos_Alerts] valueForKey:kMessageTime] forKey:kMessageTime];
            [arrAlerts replaceObjectAtIndex:tag_Pos_Alerts withObject:dict];
            NSLog(@"%@",[arrAlerts objectAtIndex:tag_Pos_Alerts]);
            [self parseMessageExpandWidget];
            menuView[tag_Pos_Alerts].alpha=0.6;
            messageCount = messageCount-1;
            [btn_Message_Count setTitle:[NSString stringWithFormat:@"%d",messageCount] forState:UIControlStateNormal];
            [self stop_PinWheel_Lights];
        }
        else{
            [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getAllSpinklerDevices
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/zones",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for sprinkler zone list==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSpinkler_ZoneList) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sprinkler zone list ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseSpinkler_ZoneList
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        arrDevices = [[NSMutableArray alloc] init];
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrZoneDetails=[[NSMutableArray alloc] init];
            arrZoneDetails = [[responseDict valueForKey:@"data"]valueForKey:@"zoneDetails"];
            NSString *vacMode = [[[responseDict valueForKey:@"data"]valueForKey:@"deviceMode"] valueForKey:@"deviceModeCode"];
            NSString *vacModeID = [[[[responseDict valueForKey:@"data"]valueForKey:@"deviceMode"] valueForKey:@"id"] stringValue];
            NSLog(@"vacmode status ==%@",vacMode);
            NSLog(@"vacmode mode id ==%@",vacModeID);
            
            NSLog(@"device list==%@",arrZoneDetails);
            NSLog(@"device data count==%lu",(unsigned long)arrZoneDetails.count);
            
            if ([vacMode isEqualToString:@"VACATION"]) {
                vacationModeStatus=@"YES";
                newVacModeStatus=@"YES";
            }else{
                vacationModeStatus=@"NO";
                newVacModeStatus=@"NO";
            }
            
            NSMutableArray *arrList = [[NSMutableArray alloc] init];
            NSMutableDictionary *dict_ZoneList;
            if([arrZoneDetails count]>0)
            {
                 sprinkler_On_Count=0;
                for (int alertindex=0; alertindex<[arrZoneDetails count]; alertindex++) {
                    arrList = [[arrZoneDetails objectAtIndex:alertindex] valueForKey:@"zoneList"];
//                    if([arrList count]>0)
//                    {
//                        if ([[[[arrZoneDetails objectAtIndex:0] valueForKey:@"zoneMode"] valueForKey:@"deviceModeCode"] isEqualToString:@"VACATION"]) {
//                            vacationModeStatus=YES;
//                            newVacModeStatus=YES;
//                        }else{
//                            vacationModeStatus=NO;
//                            newVacModeStatus=NO;
//                        }
//                        
//                    }
                    for (int index=0; index<[arrList count]; index++) {
                        NSLog(@"arrval==%@",[arrList objectAtIndex:index]);
                        if(![[[[arrList objectAtIndex:index] valueForKey:@"status"] stringValue] isEqualToString:@"2"])
                        {
                            NSLog(@"%@",[[arrList objectAtIndex:index] valueForKey:@"name"]);
                            dict_ZoneList = [[NSMutableDictionary alloc] init];
                            [dict_ZoneList setObject:[[[arrZoneDetails objectAtIndex:alertindex] valueForKey:@"deviceId"] stringValue] forKey:kDeviceID];
                            [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"id"] stringValue] forKey:kZoneID];
                            [dict_ZoneList setObject:[[arrList objectAtIndex:index] valueForKey:@"name"] forKey:kZoneName];
                            [dict_ZoneList setObject:[[arrList objectAtIndex:index] valueForKey:@"thumbnailImage"]  forKey:kZoneThumbnailImage];
                            [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"batteryPercentage"] stringValue] forKey:kZoneBatteryPercentage];
                            [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"zoneLevel"] stringValue] forKey:kZoneLevel];
                            [dict_ZoneList setObject:[[[[arrList objectAtIndex:index] valueForKey:@"zoneStatus"] valueForKey:@"id"] stringValue] forKey:kZoneStatusID];
                            [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"zoneStatus"] valueForKey:@"code"]  forKey:kZoneStatusCode];
                           // [dict_ZoneList setObject:[[[[arrZoneDetails objectAtIndex:alertindex] valueForKey:@"zoneMode"] valueForKey:@"id"] stringValue] forKey:kZoneModeID];
                            //vacModeID
                            [dict_ZoneList setObject:vacModeID forKey:kZoneModeID];
                            //[dict_ZoneList setObject:[[[arrZoneDetails objectAtIndex:alertindex] valueForKey:@"zoneMode"] valueForKey:@"deviceModeCode"] forKey:kZoneModeCode];
                            [dict_ZoneList setObject:vacMode forKey:kZoneModeCode];
                            [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"status"] stringValue] forKey:kZoneStatus];
                            [dict_ZoneList setObject:[[[arrList objectAtIndex:index] valueForKey:@"hasSchedule"] stringValue] forKey:kZoneSchedule];
                            [arrDevices addObject:dict_ZoneList];
                            if([[[[arrList objectAtIndex:index] valueForKey:@"zoneStatus"] valueForKey:@"code"] isEqualToString:@"MANUALLY_ON"])
                            {
                                sprinkler_On_Count=1;
                                current_Active_On_Tag=index;
                            }
                        }
                    }
                }
                NSLog(@"%@",arrDevices);
                [self loadAlertsDatas_Sprinklers];
            }else{
               // sprinkler_On_Count=0;
                [self stop_PinWheel_Lights];
                self.viewSprinklerAlert_Device_FooterView.frame = CGRectMake(self.viewSprinklerAlert_Device_FooterView.frame.origin.x,160,self.viewSprinklerAlert_Device_FooterView.frame.size.width, self.viewSprinklerAlert_Device_FooterView.frame.size.height);
                self.viewSprinklerAlert_Device_FooterView.hidden=NO;
                self.viewSprinkler_Alert.layer.cornerRadius=16.0;
                [self swipeDown_Spinkler_PopUp];
            }
            
        }else{
           // sprinkler_On_Count=0;
            [self stop_PinWheel_Lights];
            if (![responseMessage isEqualToString:@"Zone information unavailable"]) {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            self.viewSprinklerAlert_Device_FooterView.frame = CGRectMake(self.viewSprinklerAlert_Device_FooterView.frame.origin.x,160,self.viewSprinklerAlert_Device_FooterView.frame.size.width, self.viewSprinklerAlert_Device_FooterView.frame.size.height);
            self.viewSprinklerAlert_Device_FooterView.hidden=NO;
            self.viewSprinkler_Alert.layer.cornerRadius=16.0;
            [self swipeDown_Spinkler_PopUp];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getZoneScheduleList
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/zoneSchedules",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for sprinkler zone schedule list==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSpinkler_ZoneScheduleList) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sprinkler zone schedule list ==%@",resErrorString);
        strResponseError=resErrorString;
        [self reset_SprinklerSchedule_Status];
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseSpinkler_ZoneScheduleList
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        arr_Schedule_Sprinklers = [[NSMutableArray alloc] init];
        if([responseCode isEqualToString:@"200"]){
            arr_Schedule_Sprinklers = [[responseDict valueForKey:@"data"] valueForKey:@"zoneScheduleDetails"];
            NSLog(@"%lu",(unsigned long)[arr_Schedule_Sprinklers count]);
            if ([arr_Schedule_Sprinklers count]>0) {
                NSString *vacMode = [[[responseDict valueForKey:@"data"]valueForKey:@"deviceMode"] valueForKey:@"deviceModeCode"];
                if ([vacMode isEqualToString:@"VACATION"]) {
                    vacationModeStatus=@"YES";
                }else{
                    vacationModeStatus=@"NO";
                }
                [self drawBodyContent_Sprinklers_Schedule];
            }else{
                [self stop_PinWheel_Lights];
                self.viewSprinklerAlert_Schedule_FooterView.frame = CGRectMake(self.viewSprinklerAlert_Schedule_FooterView.frame.origin.x,160,self.viewSprinklerAlert_Schedule_FooterView.frame.size.width, self.viewSprinklerAlert_Schedule_FooterView.frame.size.height);
                self.viewSprinklerAlert_Schedule_FooterView.hidden=NO;
                self.viewSprinkler_Alert.layer.cornerRadius=16.0;
                [self reset_SprinklerSchedule_Status];
                [self swipeDown_Spinkler_PopUp];
            }
        }else{
            [self stop_PinWheel_Lights];
            if (![responseMessage isEqualToString:@"Zone schedule information unavailable"]) {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            self.viewSprinklerAlert_Schedule_FooterView.frame = CGRectMake(self.viewSprinklerAlert_Schedule_FooterView.frame.origin.x,160,self.viewSprinklerAlert_Schedule_FooterView.frame.size.width, self.viewSprinklerAlert_Schedule_FooterView.frame.size.height);
            self.viewSprinklerAlert_Schedule_FooterView.hidden=NO;
            self.viewSprinkler_Alert.layer.cornerRadius=16.0;
            [self reset_SprinklerSchedule_Status];
            [self swipeDown_Spinkler_PopUp];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self reset_SprinklerSchedule_Status];
    }
}

-(void)update_Sprinkler_ZoneModeStatus
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/zones/profileMode",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    
    NSDictionary *parameters;
    NSMutableDictionary *dictZoneStatus=[[NSMutableDictionary alloc] init];
    [dictZoneStatus setObject:strzoneModeStatus forKey:kZoneStatusID];
    
    parameters=[SCM zone_Status_Update:dictZoneStatus];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for sprinkler zone mode status==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSpinkler_ZoneModeStatus) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sprinkler zone mode status ==%@",resErrorString);
        strResponseError=resErrorString;
        [self resetZoneModeStatus];
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseSpinkler_ZoneModeStatus
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSLog(@"%@",[responseDict valueForKey:@"data"]);
            [self changeVacation_Mode_OldState_Sprinkler];
            [self stop_PinWheel_Lights];
        }else{
            [self resetZoneModeStatus];
            [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self resetZoneModeStatus];
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)resetZoneModeStatus
{
    if ([vacationModeStatus isEqualToString:@"YES"]) {
        vacationModeStatus=@"NO";
    }else{
        vacationModeStatus=@"YES";
    }
}


-(void)update_SprinklerDeviceStatus
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/zones/%@/profileStatus",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],[[arrDevices objectAtIndex:deviceTag] objectForKey:kDeviceID],[[arrDevices objectAtIndex:deviceTag] objectForKey:kZoneID]];
    NSLog(@"method name =%@",strMethodNameWith_Value);
    NSDictionary *parameters;
    NSMutableDictionary *dict_Zone_ON_OFF=[[NSMutableDictionary alloc] init];
    [dict_Zone_ON_OFF setObject:strManualType forKey:kZoneStatusID];
    
    parameters=[SCM zone_ON_OFF_Status:dict_Zone_ON_OFF];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Device Manual On Off status==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDeviceManualStatus) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Device Manual On Off status==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(resetDeviceCardSwitchOldPos) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
        self.view.userInteractionEnabled=YES;
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

#pragma mark - The Good Stuff
-(void)testingArrayMap
{
    arrPropertyDevices = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:@"0" forKey:@"deviceindexid"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:@"1001" forKey:@"userid"];
    [dict setObject:@"11.0104" forKey:@"latitude"];
    [dict setObject:@"76.9499" forKey:@"longitude"];
    [dict setObject:@"5" forKey:@"count"];
    [arrPropertyDevices addObject:dict];
    
    dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"1" forKey:@"deviceindexid"];
    [dict setObject:@"3" forKey:@"type"];
    [dict setObject:@"1011" forKey:@"userid"];
    [dict setObject:@"11.0154" forKey:@"latitude"];
    [dict setObject:@"76.9399" forKey:@"longitude"];
    [dict setObject:@"0" forKey:@"count"];
    [arrPropertyDevices addObject:dict];
    
    dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"2" forKey:@"deviceindexid"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:@"1101" forKey:@"userid"];
    [dict setObject:@"11.0204" forKey:@"latitude"];
    [dict setObject:@"76.9599" forKey:@"longitude"];
    [dict setObject:@"2" forKey:@"count"];
    [arrPropertyDevices addObject:dict];
}
-(void)resettestingArrayMap
{
    arrPropertyDevices = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    [dict setObject:@"0" forKey:@"deviceindexid"];
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:@"1001" forKey:@"userid"];
    [dict setObject:@"11.0104" forKey:@"latitude"];
    [dict setObject:@"76.9499" forKey:@"longitude"];
    [dict setObject:@"5" forKey:@"count"];
    [arrPropertyDevices addObject:dict];
    
    dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"1" forKey:@"deviceindexid"];
    [dict setObject:@"3" forKey:@"type"];
    [dict setObject:@"1011" forKey:@"userid"];
    [dict setObject:@"11.0154" forKey:@"latitude"];
    [dict setObject:@"76.9399" forKey:@"longitude"];
    [dict setObject:@"0" forKey:@"count"];
    [arrPropertyDevices addObject:dict];
    
    dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@"2" forKey:@"deviceindexid"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:@"1101" forKey:@"userid"];
    [dict setObject:@"11.0204" forKey:@"latitude"];
    [dict setObject:@"76.9599" forKey:@"longitude"];
    [dict setObject:@"2" forKey:@"count"];
    [arrPropertyDevices addObject:dict];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MyAnnotation class]]){
        // Try to dequeue an existing pin view first.
        CustomAnnotationView* pinView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        NSString *strType=((MyAnnotation *)annotation).annCardType;
        NSString *strCardid=((MyAnnotation *)annotation).annCardID;
        NSLog(@"stype=%@",strType);
        NSLog(@"strID=%@",strCardid);
        if (!pinView){
            // If an existing pin view was not available, create one.
            pinView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:@"CustomPinAnnotationView"];
            //[pinView setPinColor:MKPinAnnotationColorGreen];
            if([strType isEqualToString:@"LIGHT"])
            {
                pinView.image=[UIImage imageNamed:@"mapLigths"];
            }else if([strType isEqualToString:@"OTHERS"])
            {
                pinView.image=[UIImage imageNamed:@"mapOthers"];
            }else{
                pinView.image=[UIImage imageNamed:@"mapSprinklers"];
            }
            [pinView setDraggable:NO];
        }
        else
        {
            if([strType isEqualToString:@"LIGHT"])
            {
                pinView.image=[UIImage imageNamed:@"mapLigths"];
            }else if([strType isEqualToString:@"OTHERS"])
            {
                pinView.image=[UIImage imageNamed:@"mapOthers"];
            }else {
                pinView.image=[UIImage imageNamed:@"mapSprinklers"];
            }
            pinView.annotation = annotation;
            [pinView setDraggable:NO];
        }
        
        return pinView;
    }
    
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //if you did all the steps this methosd will be called when a user taps the annotation on the map.
    NSLog(@"did selecte working");
    
    id<MKAnnotation> annotation = view.annotation;
    if (!annotation || ![view isSelected])
        return;
    
    strCallout = @"select";
    MyAnnotation *anns=view.annotation;
    self.parentAnnotationView=view;
    NSLog(@"view device tapped");
    // annotationTag = [mapView.annotations indexOfObject:annotation];
    //  NSLog(@"tag == %d",annotationTag); not use
    
    //Anitha code
    CGPoint mapViewOriginRelativeToParent = [self.mapViewProperty convertPoint:self.mapViewProperty.frame.origin toView:self.parentAnnotationView];
    
    NSLog(@"%f",self.parentAnnotationView.frame.size.width);
    CGFloat pixelsFromRightOfMapView = self.mapViewProperty.frame.size.width + mapViewOriginRelativeToParent.x- self.parentAnnotationView.frame.size.width;
    NSLog(@"pixelsFromRightOfMapView%f",pixelsFromRightOfMapView);
    
    CGFloat pixelsFromTopOfMapView = -(mapViewOriginRelativeToParent.y + 84 - 6);
    NSLog(@"pixelsFromTopOfMapView%f",pixelsFromTopOfMapView);
    CGFloat pixelsFromBottomOfMapView = self.mapViewProperty.frame.size.height + mapViewOriginRelativeToParent.y - self.parentAnnotationView.frame.size.height;
    NSLog(@"pixelsFromBottomOfMapView%f",pixelsFromBottomOfMapView);
    //
    
    select_Map_DeviceType=[NSString stringWithFormat:@"%@",anns.annCardType];
    NSLog(@"profile type==%@",select_Map_DeviceType);
    
    select_Map_DeviceID=[NSString stringWithFormat:@"%@",anns.annCardID];
    NSLog(@"device id ==%@",select_Map_DeviceID);
    
    select_Map_ZoneID=[NSString stringWithFormat:@"%@",anns.annCardZoneID];
    NSLog(@"zone id ==%@",select_Map_ZoneID);
    
    select_Map_ZoneLevel=[NSString stringWithFormat:@"%@",anns.annZoneLevel];
    NSLog(@"zone level ==%@",select_Map_ZoneLevel);
    
    select_Map_ZoneStatus=[NSString stringWithFormat:@"%@",anns.annZoneStatus];
    NSLog(@"zone status ==%@",select_Map_ZoneStatus);
    
    select_Map_ZoneStatusID=[NSString stringWithFormat:@"%@",anns.annZoneStatusID];
    NSLog(@"status id ==%@",select_Map_ZoneStatusID);
    
    select_Map_DeviceMode=[NSString stringWithFormat:@"%@",anns.annDeviceMode];
    NSLog(@"device mode ==%@",select_Map_DeviceMode);
    
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        viewCallout=[[UIView alloc] initWithFrame:CGRectMake(320-pixelsFromRightOfMapView-15 , 360-pixelsFromBottomOfMapView+30, 150, 84)];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        viewCallout=[[UIView alloc] initWithFrame:CGRectMake(414-pixelsFromRightOfMapView-15 , 484-pixelsFromBottomOfMapView+30, 150, 84)];
    }else{
        viewCallout=[[UIView alloc] initWithFrame:CGRectMake(375-pixelsFromRightOfMapView-15 , 437-pixelsFromBottomOfMapView+30, 150, 84)];
    }

    //  viewCallout=[[UIView alloc] initWithFrame:CGRectMake(self.mapViewProperty.frame.size.width/2, self.mapViewProperty.frame.size.height/2, 231, 124)];
    viewCallout.backgroundColor=lblRGBA(77, 77, 79, 1);
    [self.mapViewProperty addSubview:viewCallout];
    
    //view Device button
    UIButton *btnViewDevice=[UIButton buttonWithType:UIButtonTypeCustom];
    btnViewDevice.frame=CGRectMake(0, 0, 150, 27);
    [btnViewDevice setTitle:@"View Device" forState:UIControlStateNormal];
    btnViewDevice.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:13];
    btnViewDevice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnViewDevice.contentEdgeInsets = UIEdgeInsetsMake(10, 7, 0, 0);
    [btnViewDevice setBackgroundColor:[UIColor clearColor]];
    [btnViewDevice setTag:0];
    [btnViewDevice addTarget:self action:@selector(calloutAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewCallout addSubview:btnViewDevice];
    
    UIButton *btnAlertDevice=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAlertDevice.frame=CGRectMake(0, 29, 150, 27);
    [btnAlertDevice setTitle:@"View Alerts" forState:UIControlStateNormal];
    btnAlertDevice.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:13];
    [btnAlertDevice setBackgroundColor:[UIColor clearColor]];
    btnAlertDevice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnAlertDevice.contentEdgeInsets = UIEdgeInsetsMake(10, 7, 0, 0);
    [btnAlertDevice setTag:1];
    [btnAlertDevice addTarget:self action:@selector(calloutAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewCallout addSubview:btnAlertDevice];
    
    
    UIButton *btnMoveDevice=[UIButton buttonWithType:UIButtonTypeCustom];
    btnMoveDevice.frame=CGRectMake(0, 57, 150, 27);
    [btnMoveDevice setTitle:@"Move Device" forState:UIControlStateNormal];
    btnMoveDevice.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:13];
    [btnMoveDevice setBackgroundColor:[UIColor clearColor]];
    btnMoveDevice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnMoveDevice.contentEdgeInsets = UIEdgeInsetsMake(10, 7, 0, 0);
    [btnMoveDevice setTag:2];
    [btnMoveDevice addTarget:self action:@selector(calloutAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewCallout addSubview:btnMoveDevice];
    
    UIView *viewDivider = [[UIView alloc] init];
    viewDivider.frame = CGRectMake(0, 28, 150, 1);
    viewDivider.backgroundColor = lblRGBA(98, 99, 102, 1);
    [viewCallout addSubview:viewDivider];
    
    UIView *viewDivider1 = [[UIView alloc] init];
    viewDivider1.frame = CGRectMake(0, 56, 150, 1);
    viewDivider1.backgroundColor = lblRGBA(98, 99, 102, 1);
    [viewCallout addSubview:viewDivider1];

    [mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

-(void)calloutAction:(UIButton *)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    switch (sender.tag) {
        case 0:
        {            
            // view device details
            //   NSLog(@"selected device details ==%@",[arrPropertyDevices objectAtIndex:annotationTag]);
           // [viewCallout setHidden:YES];
            NSArray *selectedAnnotations = mapViewProperty.selectedAnnotations;
            for(id annotation in selectedAnnotations) {
                [mapViewProperty deselectAnnotation:annotation animated:NO];
            }
            LightsViewController *LVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LightsViewController"];
            [LVC setDelegate:self];
            if ([select_Map_DeviceType isEqualToString:@"SPRINKLER"]) {
                LVC.strDeviceID=select_Map_DeviceID;
                LVC.strDeviceMode=select_Map_DeviceMode;
                LVC.strZoneID=select_Map_ZoneID;
                LVC.strZoneStatusID=select_Map_ZoneStatusID;
                LVC.strZoneLevel=select_Map_ZoneLevel;
                LVC.strZoneStatus=select_Map_ZoneStatus;
                LVC.str_HasSchedule=@"YES";
                LVC.strDeviceType=@"sprinklers";
            }else{
                NSLog(@"selected device id == %@",select_Map_DeviceID);
                LVC.strDeviceID=select_Map_DeviceID;
                LVC.strDeviceMode=select_Map_DeviceMode;
                LVC.str_HasSchedule=@"YES";
                if ([select_Map_DeviceType isEqualToString:@"LIGHT"]) {
                    LVC.strDeviceType=@"lights";
                }else{
                    LVC.strDeviceType=@"others";
                }
            }
            [Common viewSlide_FromRight_ToLeft:self.navigationController.view];
            [self.navigationController pushViewController:LVC animated:NO];
            
        }
            break;
            
        case 1:
        {
            NSLog(@"view alerts tapped");
        }
            break;
        case 2:
        {
            NSLog(@"move device tapped");
            if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
            {
                NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
                if([appDelegate.strNetworkPermission isEqualToString:@"2"]||[appDelegate.strNetworkPermission isEqualToString:@"3"])
                {
                    [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
                    return;
                }
            }
            [viewCallout setHidden:YES];
            CustomAnnotationView  *cView=(CustomAnnotationView *)self.parentAnnotationView;
            cView.draggable=YES;
            cView.dragState=YES;
        }
            break;
    }
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//}
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
//{
//    NSLog(@"annotation selcted");
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.strDeviceDragStatus=@"";
//    id<MKAnnotation> annotation = aView.annotation;
//    if (!annotation || ![aView isSelected])
//        return;
//    NSUInteger index = [mapView.annotations indexOfObject:annotation];
//    NSLog(@"index pos==%lu",(unsigned long)index);
//    NSLog(@" selected index value is ==%@",[arrPropertyDevices objectAtIndex:index]);
//    if ( NO == [annotation isKindOfClass:[MultiRowCalloutCell class]] &&
//        [annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)] )
//    {
//        NSObject <MultiRowAnnotationProtocol> *pinAnnotation = (NSObject <MultiRowAnnotationProtocol> *)annotation;
//        if (!_calloutAnnotation)
//        {
//            _calloutAnnotation = [[MultiRowAnnotation alloc] init];
//            [_calloutAnnotation copyAttributesFromAnnotation:pinAnnotation];
//            
//            int unReadCount=(int)[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"unReadAlerts"] count];
//            NSLog(@"count==%lu",(unsigned long)unReadCount);
//            appDelegate.strAlertDeviceCount=[NSString stringWithFormat:@"%d",unReadCount];
//            appDelegate.strProp_DeviceID=[NSString stringWithFormat:@"%@",[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceId"] stringValue]];
//            if([[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceType"] objectForKey:@"code"] isEqualToString:@"LIGHT"])
//            {
//                appDelegate.strProp_DeviceType=@"lights";
//            }else if([[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceType"] objectForKey:@"code"] isEqualToString:@"OTHERS"])
//            {
//                appDelegate.strProp_DeviceType=@"others";
//            }
//            else if([[[[arrPropertyDevices objectAtIndex:index] objectForKey:@"deviceType"] objectForKey:@"code"] isEqualToString:@"SPRINKLER"])
//            {
//                appDelegate.strProp_DeviceType=@"sprinkler";
//            }
//            selectedIndexPin=(int)index;
//            [mapView addAnnotation:_calloutAnnotation];
//        }
//        _selectedAnnotationView = aView;
//        aView.draggable=NO;
//        aView.dragState=FALSE;
//        return;
//    }
//    [mapView setCenterCoordinate:annotation.coordinate animated:YES];
//    _selectedAnnotationView = aView;
//}
- (double)getZoomLevel
{
    CLLocationDegrees longitudeDelta = self.mapViewProperty.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.mapViewProperty.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    //  zoomer = round(zoomer);
    return zoomer;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)aView
{
    NSLog(@"annotation deselcted");
    strCallout = @"deselect";
    [viewCallout removeFromSuperview];
    
}

//- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)aView
//{
//    NSLog(@"annotation deselcted");
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.strDeviceDragStatus=@"YES";
//    if ( NO == [aView.annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)] )
//        return;
//    if ([aView.annotation isKindOfClass:[MultiRowAnnotation class]])
//        return;
//    GenericPinAnnotationView *pinView = (GenericPinAnnotationView *)aView;
//    
//    if (_calloutAnnotation && !pinView.preventSelectionChange)
//    {
//        [mapView removeAnnotation:_calloutAnnotation];
//        _calloutAnnotation = nil;
//    }
//}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    @try {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (newState == MKAnnotationViewDragStateEnding)
        {
            CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
            NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
            strUpdatedLat=[NSString stringWithFormat:@"%f",droppedAt.latitude];
            strUpdatedLong=[NSString stringWithFormat:@"%f",droppedAt.longitude];
            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(updateDeviceCo_Location) withObject:self];
        }
        // }
        
    }
    @catch (NSException *exception) {
        [Common showAlert:kAlertTitleWarning withMessage:exception.description];
    }
    
    
}

//- (void)mapView:(MKMapView *)mapView
// annotationView:(MKAnnotationView *)annotationView
//didChangeDragState:(MKAnnotationViewDragState)newState
//   fromOldState:(MKAnnotationViewDragState)oldState
//{
//    @try {
//        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        if (newState == MKAnnotationViewDragStateEnding)
//        {
//            CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
//            NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
//            strUpdatedLat=[NSString stringWithFormat:@"%f",droppedAt.latitude];
//            strUpdatedLong=[NSString stringWithFormat:@"%f",droppedAt.longitude];
//            NSLog(@"selcted Index array =%@",[arrPropertyDevices objectAtIndex:selectedIndexPin]);
//            [self performSelectorOnMainThread:@selector(start_PinWheel_Lights) withObject:self waitUntilDone:YES];
//            [self performSelectorInBackground:@selector(updateDeviceCo_Location) withObject:self];
//        }
//    }
//    @catch (NSException *exception) {
//        [Common showAlert:kAlertTitleWarning withMessage:exception.description];
//    }
//}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MapOverlay *mapOverlay = (MapOverlay *)overlay;
    MapOverlayView *mapOverlayView = [[MapOverlayView alloc] initWithOverlay:mapOverlay];
    return mapOverlayView;
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //Anitha Code
    
    NSLog(@"zoom level %f",mapView.region.span.latitudeDelta);
    CLLocationDegrees deltaLatitude = mapView.region.span.latitudeDelta;
    NSLog(@"y: %f",deltaLatitude * 40008000 / 360);
    footView = deltaLatitude * 40008000 / 360;
    defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%f",footView] forKey:@"FOOTVIEW"];
    [defaults synchronize];
    
    if ([strCallout isEqualToString:@"select"]) {
        
        //[viewCallout removeFromSuperview];
        CGRect calloutFrame = viewCallout.frame;
        
        CGPoint mapViewOriginRelativeToParent = [self.mapViewProperty convertPoint:self.mapViewProperty.frame.origin toView:self.parentAnnotationView];
        
        NSLog(@"%f",self.parentAnnotationView.frame.size.width);
        CGFloat pixelsFromRightOfMapView = self.mapViewProperty.frame.size.width + mapViewOriginRelativeToParent.x- self.parentAnnotationView.frame.size.width;
        NSLog(@"pixelsFromRightOfMapView%f",pixelsFromRightOfMapView);
        //124 - 6
        CGFloat pixelsFromTopOfMapView  = -(mapViewOriginRelativeToParent.y + 78);
        NSLog(@"pixelsFromTopOfMapView%f",pixelsFromTopOfMapView);
        CGFloat pixelsFromBottomOfMapView = self.mapViewProperty.frame.size.height + mapViewOriginRelativeToParent.y - self.parentAnnotationView.frame.size.height;
        NSLog(@"pixelsFromBottomOfMapView%f",pixelsFromBottomOfMapView);
        //768-pixelsFromRightOfMapView-25
        //641-pixelsFromBottomOfMapView+55
        // viewCallout=[[UIView alloc] initWithFrame:CGRectMake(743-pixelsFromRightOfMapView , 696-pixelsFromBottomOfMapView, 231, 124)];
        
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            calloutFrame.origin.x = 305-pixelsFromRightOfMapView;
            calloutFrame.origin.y = 390-pixelsFromBottomOfMapView;
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            calloutFrame.origin.x = 399-pixelsFromRightOfMapView;
            calloutFrame.origin.y = 514-pixelsFromBottomOfMapView;
        }else{
            calloutFrame.origin.x = 360-pixelsFromRightOfMapView;
            calloutFrame.origin.y = 467-pixelsFromBottomOfMapView;
        }
        
        viewCallout.frame = calloutFrame;
    }
    
    CLLocationCoordinate2D centre = [mapView centerCoordinate];
    
    NSLog(@"MAP CENTER = %f,%f",centre.latitude,centre.longitude);
    
    topLeft = [self.mapViewProperty convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapViewProperty];
    NSLog(@"top left lat==%f",topLeft.latitude);
    NSLog(@"top left long==%f",topLeft.longitude);
    
    topRight = [self.mapViewProperty convertPoint:CGPointMake(self.mapViewProperty.frame.size.width, 0) toCoordinateFromView:self.mapViewProperty];
    NSLog(@"top right lat==%f",topRight.latitude);
    NSLog(@"top right long==%f",topRight.longitude);
    
    
    bottomLeft = [self.mapViewProperty convertPoint:CGPointMake(0, self.mapViewProperty.frame.size.height) toCoordinateFromView:self.mapViewProperty];
    NSLog(@"bottom left lat==%f",bottomLeft.latitude);
    NSLog(@"bottom left long==%f",bottomLeft.longitude);
    
    bottomRight = [self.mapViewProperty convertPoint:CGPointMake(self.mapViewProperty.frame.size.width, self.mapViewProperty.frame.size.height) toCoordinateFromView:self.mapViewProperty];
    NSLog(@"bottom left lat==%f",bottomRight.latitude);
    NSLog(@"bottom left long==%f",bottomRight.longitude);
    
    newCoordianteOverlay.latitude=centre.latitude;
    newCoordianteOverlay.longitude=centre.latitude;
    // mRect = self.mapViewProperty.visibleMapRect;
    
    
}

-(void)updateDeviceCoordinates
{
    [self.mapViewProperty removeAnnotations:self.mapViewProperty.annotations];
    [mapViewProperty removeFromSuperview];
    mapViewProperty = [[MKMapView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        mapViewProperty.frame = CGRectMake(0, 43, 320, 360);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        mapViewProperty.frame = CGRectMake(0, 53, 414, 484);
    }else{
        mapViewProperty.frame = CGRectMake(0, 43, 375, 437);
    }
    [BodyView_PropertyMap addSubview:mapViewProperty];
    [mapViewProperty setRotateEnabled:NO];
    
    btn_PropertyMap_Location = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        btn_PropertyMap_Location.frame = CGRectMake(280, 320, 25, 25);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        btn_PropertyMap_Location.frame = CGRectMake(330, 404, 35, 35);
    }else{
        btn_PropertyMap_Location.frame = CGRectMake(320, 390, 30, 30);
    }
    [btn_PropertyMap_Location setBackgroundImage:[UIImage imageNamed:@"locationGrayImage"] forState:UIControlStateNormal];
    [btn_PropertyMap_Location addTarget:self action:@selector(backToUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    [mapViewProperty addSubview:btn_PropertyMap_Location];
    btn_PropertyMap_Location.hidden=YES;

    [self bringToSuper];
}

-(void)getPropertyMapService
{
    arrPropertyDevices=[[NSMutableArray alloc] init];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    
    NSString *sLat=[appDelegate.dict_NetworkControllerDatas valueForKey:kLat];
    sLat=[NSString stringWithFormat:@"%.2f",[sLat floatValue]];
    NSString *sLong=[appDelegate.dict_NetworkControllerDatas valueForKey:kLong];
    sLong=[NSString stringWithFormat:@"%.2f",[sLong floatValue]];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/propertyMap",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for property map list==%@",dict);
        responseDict_Weather=dict;
        [self performSelectorOnMainThread:@selector(parsePropertyMap) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for property map list ==%@",resErrorString);
        strResponseError = resErrorString;
        btn_currentWeather.userInteractionEnabled=NO;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)parsePropertyMap
{
    @try {
        NSString *responseCode = [[responseDict_Weather valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict_Weather valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arrPropertyDevices=[[NSMutableArray alloc] init];
            arrPropertyDevices=[[responseDict_Weather objectForKey:@"data"] objectForKey:@"propertyDetails"];
            dictProperty_NetworkDetails=[[responseDict_Weather objectForKey:@"data"] objectForKey:@"networkDetails"];
            NSLog(@"array count ==%lu",(unsigned long)arrPropertyDevices.count);
            if([arrPropertyDevices count]>0||[arrPropertyDevices count]==0)
            {
                [self getPropertyMaps];
            }else{
                if([propertyLoaderStatus isEqualToString:@"YES"])
                {
                    [self getPropertyMaps];
                }else{
                   [self stop_PinWheel_Lights];
                }
               // [self stop_PinWheel_Lights];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            if([propertyLoaderStatus isEqualToString:@"YES"])
            {
                [self getPropertyMaps];
            }
            else{
                [self stop_PinWheel_Lights];
            }
           // [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        if([propertyLoaderStatus isEqualToString:@"YES"])
        {
            [self getPropertyMaps];
        }
        else{
            [self stop_PinWheel_Lights];
        }
       // [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:exception.description];
    }
}

-(void)updateDeviceCo_Location
{
    NSDictionary *parameters;
    defaults=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSLog(@"device id ==%@",[[arrPropertyDevices objectAtIndex:selectedIndexPin] objectForKey:@"deviceId"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
//    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/profileLocation",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],[[[arrPropertyDevices objectAtIndex:selectedIndexPin] objectForKey:@"deviceId"] stringValue]];
//    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    NSString *strMethodNameWith_Value=@"";
    if([select_Map_DeviceType isEqualToString:@"SPRINKLER"])
    {
        strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/zones/%@/profileLocation",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],select_Map_DeviceID,select_Map_ZoneID];
    }else{
        strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/profileLocation",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],select_Map_DeviceID];
    }
    
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    NSMutableDictionary *dictDevice_Co=[[NSMutableDictionary alloc] init];
    [dictDevice_Co setObject:strUpdatedLat forKey:kLat];
    [dictDevice_Co setObject:strUpdatedLong forKey:kLong];
    
    NSLog(@"dict values going to update user acc name ==%@",dictDevice_Co);
    parameters=[SCM update_PropertyDeviceLocation:dictDevice_Co];
    NSLog(@"%@",parameters);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Device Location==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDeviceUpdateLocation) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update User acc Name==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseDeviceUpdateLocation
{
    @try {
        NSString *responseCode = [[responseDict_Weather valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict_Weather valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self performSelectorInBackground:@selector(getPropertyMapService) withObject:self];
        }else{
            [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:exception.description];
    }
}
-(void)propertyImageUpdate
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/propertyMap",[defaults objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];
    NSDictionary *parameters;
    NSMutableDictionary *dict_Property_Image=[[NSMutableDictionary alloc] init];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",newCoordianteOverlay.latitude] forKey:kcenterLat];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",newCoordianteOverlay.longitude] forKey:kcenterLong];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",topLeft.latitude] forKey:ktopLeftLat];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",topLeft.longitude] forKey:ktopLeftLong];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",topRight.latitude] forKey:ktopRightLat];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",topRight.longitude] forKey:ktopRightLong];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",bottomLeft.latitude] forKey:kbottomLeftLat];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",bottomLeft.longitude] forKey:kbottomLeftLong];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",bottomRight.latitude] forKey:kbottomRightLat];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",bottomRight.longitude] forKey:kbottomRightLong];
    [dict_Property_Image setObject:[NSString stringWithFormat:@"%f",self.mapViewProperty.region.span.latitudeDelta] forKey:kzoomLevel];[dict_Property_Image setObject:strEncoded_ControllerImage forKey:kpropertyMapImage];
    
    
    parameters=[SCM update_Property_MapImage:dict_Property_Image];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Property Image==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUpdatePropertyImage) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Property Image==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Lights) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorListDevices) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseUpdatePropertyImage
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            if([strEncoded_ControllerImage isEqualToString:@""])
            {
                NSArray *pointsArray = [self.mapViewProperty overlays];
                [mapViewProperty removeOverlays:pointsArray];
                [deleteProfilebtn setHidden:YES];
                 [self iconsPositionNew_PropertyMap];
                self.mapViewProperty.zoomEnabled=YES;
            }
            [self stop_PinWheel_Lights];
        }
        else{
            [self stop_PinWheel_Lights];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Lights];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}


@end
