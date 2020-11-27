//
//  LightsViewController.m
//  NOID
//
//  Created by iExemplar on 09/07/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "LightsViewController.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "NetworkHomeViewController.h"
#import "TimeLineViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"
#import "ServiceConnectorModel.h"
#import "MBProgressHUD.h"
#import "Base64.h"
#import "MyAnnotation.h"
#import "LightScheduleViewController.h"
#import "AddSprinklerScheldule.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kButtonIndex 100

@interface LightsViewController ()
{
    UIView *view_ScheduleCell[kButtonIndex];
    UIView *viewTapGesture_ScheduleCell[kButtonIndex];
    UIView *view_Schedule_Sub[kButtonIndex];
    UIView *viewTapGesture_Schedule_Sub[kButtonIndex];
    UIView *view_Schedule_ContentView[kButtonIndex];
    UIView *view_Schedule_DaysSubView[kButtonIndex];
    UIView *cellTapGestureView[kButtonIndex];
    UILabel *lblSchedule[kButtonIndex];
    UITextField *txt_Schedule[kButtonIndex];
    UILabel *lblSchedule_Time[kButtonIndex];
    UIImageView *imgClock[kButtonIndex];
    UIImageView *imgViewSchedule[kButtonIndex];
    UIButton *btn_Save_Schedule[kButtonIndex];
    UIButton *btn_Edit_Schedule[kButtonIndex];
    UIButton *btn_Close_Schedule[kButtonIndex];
}
@end

@implementation LightsViewController
@synthesize lbl_deviceName_lights,txtfld_DeviceName_Lights,btn_close_lights,btn_edit_lights,btn_save_lights,lbl_HeaderName_lights,Device_Del_View,delegate,header_View_Lights,view_BackLights,deleteProfilebtn,cameraProfilebtn,gallaryProfilebtn,imgProfile,strDeviceType,header_Back_Arrow_Btn,header_Back_Text_Btn,btn_edit_category,tableView_Category,arrDeviceCategory,btn_DeviceCategory,deviceCategoryView,btn_save_categoryDevice,btn_close_categoryDevice;
@synthesize lightScheduleView,lightsContainerView,lightslocationView,lightsprofileView;
@synthesize imglightSchedule,imglightsLocation,imglightsProfile,lbl_lightSchedule,lbl_lightsLocation,lbl_lightsProfile;
@synthesize mapView_lights,locationManager_lights;
@synthesize view_AddSchedule,view_infoAlert,view_VacationMode,btn_AddSchedule,btn_Info,btn_Vacation,infoAlertView,lbl_vacationMode,str_CheckAction,popUpScheduleView,scrollViewSchedule,strDeviceName,lbl_addSchedule_lights,img_addSchedule_lights;
@synthesize strDeviceID;
@synthesize arr_Schedule,pickerView,timePicker,lightTabView,str_HasSchedule,btnUserLocation,viewAlert_PlanDowngrade,viewAlert_PlanDowngrade_Confirm,lbl_PlanDowngrade_Charge,strZoneID,view_Category_device,lbl_deleteDevice_Zone,lbl_deleteZone_popUp,lbl_deviceName,strDeviceMode,lbl_PlanDowngrade_Quote,btnCancelPicker,btnOkPicker,view_DeleteDevice,view_EditDevice;

#pragma mark - View LifeCycle
/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",strDeviceMode);
    [self flagSetup_Lights];
    [self device_initialSetup];
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        if ([strDeviceType isEqualToString:@"sprinklers"]) {
            [self performSelectorInBackground:@selector(getZoneDetails_NOID) withObject:self];
        }else{
            [self performSelectorInBackground:@selector(getDeviceDetails_NOID) withObject:self];
        }
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    [self swipeBackToHome];
    [self infoPopUpSetup];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"landscape");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strScheduleWay isEqualToString:@"YES"])
    {
        view_AddSchedule.hidden=YES;
        btn_Info.hidden=YES;
        appDelegate.strScheduleWay=@"";
        for (int index=0;index<[arr_Schedule count];index++){
            [view_ScheduleCell[index] removeFromSuperview];
        }
        if ([strDeviceType isEqualToString:@"sprinklers"]) {
            if([Common reachabilityChanged]==YES){
                appDelegate.strScheduleAddedStatus=@"YES";
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getDevice_ZoneScheduleList) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            return;
        }

        cellExpandStatus=YES;
        strStatus=@"NO";
        if([strDeviceType isEqualToString:@"others"]){
            view_AddSchedule.backgroundColor = lblRGBA(49, 165, 222,1);
        }
       
        view_VacationMode.hidden=YES;
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getDeviceScheduleList) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
        
    }else if ([appDelegate.strTimeZoneChanged_Status isEqualToString:@"YES"] && [strSelectedTab isEqualToString:@"lightSchedule"]) {
        strStatus=@"";
        [self.scrollViewSchedule setContentOffset:CGPointZero animated:YES];
        for (int index=0;index<[arr_Schedule count];index++){
            [view_ScheduleCell[index] removeFromSuperview];
        }
        self.view_AddSchedule.hidden=YES;
        self.view_VacationMode.hidden=YES;
        self.btn_Info.hidden=YES;
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
            if([strDeviceType isEqualToString:@"sprinklers"]){
                [self performSelectorInBackground:@selector(getDevice_ZoneScheduleList) withObject:self];
            }else{
                [self performSelectorInBackground:@selector(getDeviceScheduleList) withObject:self];
            }
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }


//    if(([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) | ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight))
//    {
//        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
//        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
//        [self.navigationController pushViewController:TLVC animated:NO];
//    }
    [super viewWillAppear:animated];
}

-(void)uiconfiguration_Profiles:(NSString *)imageData{
    NSLog(@"%@",imageData);
    dispatch_async(kBgQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            imgProfile.image=[UIImage imageWithData:[Base64 decode:imageData]];
            imageStatus=YES;
            strEncoded_ControllerImage=imageData;
            strDeviceImage = strEncoded_ControllerImage;
        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Defined Methods
/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Flag setup for the view
 Method Name : flagSetup_Lights(User Defined Methods)
 ************************************************************************************* */
-(void)flagSetup_Lights
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    strHubActiveStatus=@"";
    strAllowDuplicate=@"false";
    self.lightsprofileView.hidden=YES;
    txtfld_DeviceName_Lights.delegate=self;
    txtfld_DeviceName_Lights.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtfld_DeviceName_Lights setValue:lblRGBA(65, 64, 66, 1) forKeyPath:@"_placeholderLabel.textColor"];

    [btn_close_lights setHidden:YES];
    [btn_save_lights setHidden:YES];
    btn_close_categoryDevice.hidden=YES;
    btn_save_categoryDevice.hidden=YES;
    [txtfld_DeviceName_Lights setHidden:YES];
    [self.Device_Del_View setHidden:YES];
    [lightslocationView setHidden:YES];
    [lightScheduleView setHidden:YES];
    changeTabStatus = @"lightsprofile";
    strSelectedTab=@"lightsProfile";
    strPreviousTab=@"lightsProfile";
    [popUpScheduleView setHidden:YES];
    [view_infoAlert setHidden:YES];
    strEncoded_ControllerImage=@"";
    btn_edit_category.hidden=NO;
    deviceCategoryView.hidden=YES;

    //flag for Device Schedule
    self.view_AddSchedule.hidden=YES;
    self.view_VacationMode.hidden=YES;
    self.btn_Info.hidden=YES;
    strDeviceEditMode = @"";
    strDeviceImage=@"";
    strDeviceCategoryChangedStatus = @"NO";
    btn_DeviceCategory.userInteractionEnabled=NO;
    self.viewAlert_PlanDowngrade.hidden=YES;
    self.viewAlert_PlanDowngrade_Confirm.hidden=YES;
    strprorationTime=@"";
    strScheduleStatus=@"";
//    if([strDeviceType isEqualToString:@"lights"])
//    {
        [timePicker setValue:lblRGBA(255, 255, 255, 1) forKeyPath:@"textColor"];
        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
        btnOkPicker.layer.cornerRadius=5.0;
        btnCancelPicker.layer.cornerRadius=5.0;

//        [btnOkPicker setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
//        [btnCancelPicker setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
//    }else{
//        [timePicker setValue:lblRGBA(40, 165, 222, 1) forKeyPath:@"textColor"];
//        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
//        [btnOkPicker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//        [btnCancelPicker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//    }
}

-(void)reset_Profile_Category
{
    [btn_DeviceCategory setTitle:strDeviceOldName forState:UIControlStateNormal];
    btn_DeviceCategory.userInteractionEnabled=NO;
    [deviceCategoryView setHidden:YES];
    btn_save_categoryDevice.hidden=YES;
    btn_close_categoryDevice.hidden=YES;
//    if([strDeviceType isEqualToString:@"sprinklers"]){
//        [btn_edit_category setHidden:YES];
//    }else{
//        [btn_edit_category setHidden:NO];
//    }
    [btn_edit_category setHidden:NO];
}
/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Flag setup for the view
 Method Name : device_initialSetup(User Defined Methods)
 ************************************************************************************* */
-(void)device_initialSetup
{
    if([strDeviceType isEqualToString:@"sprinklers"]){
//        [btn_edit_category setHidden:YES];
        view_DeleteDevice.frame = CGRectMake(view_DeleteDevice.frame.origin.x, view_EditDevice.frame.origin.y+view_Category_device.frame.origin.y-2, view_DeleteDevice.frame.size.width, view_DeleteDevice.frame.size.height);
        [view_Category_device setHidden:YES];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"green_back_btn"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"greenEditImage"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreen"];
            view_AddSchedule.frame = CGRectMake(93, view_AddSchedule.frame.origin.y, view_AddSchedule.frame.size.width, view_AddSchedule.frame.size.height);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"green_back_btni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"greenEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreeni6plus"];
            view_AddSchedule.frame = CGRectMake(120, view_AddSchedule.frame.origin.y, view_AddSchedule.frame.size.width, view_AddSchedule.frame.size.height);
        }else{
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"green_back_btni6"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"greenEditImagei6"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreeni6"];
            view_AddSchedule.frame = CGRectMake(109, view_AddSchedule.frame.origin.y, view_AddSchedule.frame.size.width, view_AddSchedule.frame.size.height);
        }
        
        [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"green_back_btni6plus"] forState:UIControlStateNormal];
        [self.btn_edit_lights setImage:[UIImage imageNamed:@"greenEditImagei6plus"] forState:UIControlStateNormal];
        imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreeni6plus"];

        [self.header_Back_Text_Btn setTitleColor:[UIColor colorWithRed:136/255.0 green:197/255.0 blue:65/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_DeviceCategory setTitle:@"SPRINKLERS" forState:UIControlStateNormal];
         lbl_lightsProfile.textColor=lblRGBA(136, 197, 65,1);
        [self.header_Back_Text_Btn setTitle:@"SPRINKLERS" forState:UIControlStateNormal];
       
        [self.deleteProfilebtn setBackgroundColor:[UIColor colorWithRed:136/255.0 green:197/255.0 blue:65/255.0 alpha:1.0]];
        [self.cameraProfilebtn setBackgroundColor:[UIColor colorWithRed:136/255.0 green:197/255.0 blue:65/255.0 alpha:1.0]];
        [self.gallaryProfilebtn setBackgroundColor:[UIColor colorWithRed:136/255.0 green:197/255.0 blue:65/255.0 alpha:1.0]];
        [self.btnUserLocation setImage:[UIImage imageNamed:@"locationGreenImage"] forState:UIControlStateNormal];
        view_AddSchedule.backgroundColor = lblRGBA(136, 197, 65,1);
        lbl_deleteDevice_Zone.text = @"DELETE ZONE";
        lbl_deviceName.text = @"ZONE NAME";
        txtfld_DeviceName_Lights.placeholder = @"ZONE NAME";
        lbl_deleteZone_popUp.text=@"Are you sure you want to delete this zone, all schedules and detail will be lost?";
    }else if([strDeviceType isEqualToString:@"others"]){
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBlue"];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];
//        }else{
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6"];
//        }
        
        [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
        [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
        [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
        imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];

        [self.header_Back_Text_Btn setTitleColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_DeviceCategory setTitle:@"OTHER" forState:UIControlStateNormal];
        lbl_lightsProfile.textColor=lblRGBA(49, 165, 222,1);
        [self.header_Back_Text_Btn setTitle:@"OTHER" forState:UIControlStateNormal];
        [self.deleteProfilebtn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0]];
        [self.cameraProfilebtn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0]];
        [self.gallaryProfilebtn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0]];
        [self.btnUserLocation setImage:[UIImage imageNamed:@"locationBlueImage"] forState:UIControlStateNormal];
        view_AddSchedule.backgroundColor = lblRGBA(49, 165, 222, 1);
    }
    strDeviceOldName=btn_DeviceCategory.currentTitle;
}
-(void)changeCategotySetupDevice
{
    if([strDeviceType isEqualToString:@"lights"]&&[btn_DeviceCategory.currentTitle isEqualToString:@"OTHER"])
    {
        
        [self.header_Back_Text_Btn setTitleColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.header_Back_Text_Btn setTitle:@"OTHER" forState:UIControlStateNormal];
        self.lbl_lightsProfile.textColor=[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];
//        }else{
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];
//        }
        
        [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
        [self.btn_edit_category setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
        [self.btn_edit_lights setImage:[UIImage imageNamed:@"blueEditImagei6plus"] forState:UIControlStateNormal];
        imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];

        [self.deleteProfilebtn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0]];
        [self.cameraProfilebtn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0]];
        [self.gallaryProfilebtn setBackgroundColor:[UIColor colorWithRed:49/255.0 green:165/255.0 blue:222/255.0 alpha:1.0]];
        [self.btnUserLocation setImage:[UIImage imageNamed:@"locationBlueImage"] forState:UIControlStateNormal];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            annotationView.image = [UIImage imageNamed:@"Placemarker_icon"];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            annotationView.image = [UIImage imageNamed:@"Placemarker_iconi6plus"];
//        }else{
            annotationView.image = [UIImage imageNamed:@"Placemarker_iconi6"];
//        }
        if(![strVacStatus isEqualToString:@"YES"])
        {
            view_AddSchedule.backgroundColor=lblRGBA(49, 165, 222, 1);
            if([strStatus isEqualToString:@"YES"])
            {
                for (int index=0;index<[arr_Schedule count];index++){
                    [view_ScheduleCell[index] setBackgroundColor:lblRGBA(49, 165, 222, 1)];
                    [view_Schedule_Sub[index] setBackgroundColor:lblRGBA(116, 196, 234, 1)];
                }
                
            }
        }
        
        strDeviceType=@"others";
        if([strEncoded_ControllerImage isEqualToString:@""])
        {
            imgProfile.image = [UIImage imageNamed:@"dbigOther"];
        }
        
    }else if([strDeviceType isEqualToString:@"others"]&&[btn_DeviceCategory.currentTitle isEqualToString:@"LIGHTS"])
    {
        
        [self.header_Back_Text_Btn setTitleColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:52/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.header_Back_Text_Btn setTitle:@"LIGHTS" forState:UIControlStateNormal];
        self.lbl_lightsProfile.textColor=[UIColor colorWithRed:255/255.0 green:206/255.0 blue:52/255.0 alpha:1.0];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"yellowBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImage"];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"yellowBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImagei6plus"];
//        }else{
//            [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"yellowBackBtni6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_category setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
//            [self.btn_edit_lights setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
//            imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImagei6"];
//        }

        [self.header_Back_Arrow_Btn setImage:[UIImage imageNamed:@"yellowBackBtni6plus"] forState:UIControlStateNormal];
        [self.btn_edit_category setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
        [self.btn_edit_lights setImage:[UIImage imageNamed:@"yellowEditImagei6plus"] forState:UIControlStateNormal];
        imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImagei6plus"];

        [self.deleteProfilebtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:52/255.0 alpha:1.0]];
        [self.cameraProfilebtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:52/255.0 alpha:1.0]];
        [self.gallaryProfilebtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:52/255.0 alpha:1.0]];
        [self.btnUserLocation setImage:[UIImage imageNamed:@"locationYellowImage"] forState:UIControlStateNormal];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            annotationView.image = [UIImage imageNamed:@"Placemarker_icon_Yellow"];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            annotationView.image = [UIImage imageNamed:@"Placemarker_icon_Yellowi6plus"];
//        }else{
            annotationView.image = [UIImage imageNamed:@"Placemarker_icon_Yellowi6"];
//        }
        if(![strVacStatus isEqualToString:@"YES"])
        {
            view_AddSchedule.backgroundColor=lblRGBA(255, 206, 52, 1);
            if([strStatus isEqualToString:@"YES"])
            {
                for (int index=0;index<[arr_Schedule count];index++){
                    [view_ScheduleCell[index] setBackgroundColor:lblRGBA(255, 206, 52, 1)];
                    [view_Schedule_Sub[index] setBackgroundColor:lblRGBA(255, 216, 74, 1)];
                }
                
            }
        }
        
        strDeviceType=@"lights";
        if([strEncoded_ControllerImage isEqualToString:@""])
        {
            imgProfile.image = [UIImage imageNamed:@"dbigLight"];
        }
    }
    if(cellExpandStatus==NO)
    {
        if([strStatus_Schedule isEqualToString:@"YES"]){
            [txt_Schedule[viewTagValue] resignFirstResponder];
            [txt_Schedule[viewTagValue] setHidden:YES];
            [btn_Save_Schedule[viewTagValue] setHidden:YES];
        }
        [self collapseSchedule];
    }
//    if([strDeviceType isEqualToString:@"lights"])
//    {
//        [timePicker setValue:lblRGBA(255, 205, 52, 1) forKeyPath:@"textColor"];
//        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
//        [btnOkPicker setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
//        [btnCancelPicker setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
//    }else{
//        [timePicker setValue:lblRGBA(40, 165, 222, 1) forKeyPath:@"textColor"];
//        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
//        [btnOkPicker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//        [btnCancelPicker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//    }
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Enable and disable the required fields
 Method Name : fields_Enable_Disable(User Defined Methods)
 ************************************************************************************* */
-(void)fields_Enable_Disable
{
    [btn_save_lights setHidden:YES];
    [btn_close_lights setHidden:YES];
    [btn_edit_lights setHidden:NO];
    [txtfld_DeviceName_Lights setHidden:YES];
    [lbl_deviceName_lights setHidden:NO];
    txtfld_DeviceName_Lights.text = lbl_deviceName_lights.text;
    [txtfld_DeviceName_Lights resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal call
 Method Name : processCompleteLights(User Defined Methods)
 ************************************************************************************* */
- (void)processCompleteLights
{
    [[self delegate] processSuccessful_Back_To_NetworkHome_Via_Lights:YES];
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Swipe to navigate back to home screen
 Method Name : swipeBackToHome(User Defined Methods)
 ************************************************************************************* */
-(void)swipeBackToHome
{
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLights:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [view_BackLights addGestureRecognizer:swipeRight];
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Swipe Gesture action
 Method Name : handleSwipeLights(User Defined Methods)
 ************************************************************************************* */
- (void)handleSwipeLights:(UISwipeGestureRecognizer *)swipe {

    [self.navigationController popViewControllerAnimated:YES];
}




/* **********************************************************************************
 Date : 22/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : tableView Setup
 Method Name : tableView_Category_Setup(User Defined Methods)
 ************************************************************************************* */
-(void)tableView_Category_Setup
{
    tableView_Category.delegate=self;
    tableView_Category.dataSource=self;
    tableView_Category.layer.masksToBounds=YES;
    self.tableView_Category.layer.cornerRadius=5.0;
    [self.tableView_Category setBackgroundView:nil];
    [tableView_Category setBackgroundColor:lblRGBA(65, 64, 66, 1)];
    arrDeviceCategory = [[NSMutableArray alloc] initWithObjects:@"LIGHTS",@"OTHER", nil];
    
    deviceCategoryView.layer.cornerRadius=3.0;
    deviceCategoryView.layer.borderColor=[UIColor whiteColor].CGColor;
    deviceCategoryView.layer.borderWidth=1.0;
    [self.tableView_Category reloadData];
}



-(void)navigateTo_AddSprinklerSchedule_Lights
{
    AddSprinklerScheldule *addSprinklr = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
  //  addSprinklr.strBackStatus_SprinklerSchedule = @"sprinkler";
    [self.navigationController pushViewController:addSprinklr animated:YES];
}

/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Fetch user current location
 Method Name : Geolocation
 ************************************************************************************* */
-(void)Geolocation
{
    MyAnnotation *ann;
    mapView_lights.delegate = self;
    btnUserLocation.hidden = YES;
    mapView_lights.showsUserLocation = YES;
    mapView_lights.mapType = MKMapTypeSatellite;
    [mapView_lights setZoomEnabled:YES];
    [mapView_lights setScrollEnabled:YES];
    CLLocationCoordinate2D newCoordiante;
    newCoordiante.latitude=[[NSString stringWithFormat:@"%@",latitude] doubleValue];
    newCoordiante.longitude=[[NSString stringWithFormat:@"%@",longitude] doubleValue];
    ann=[[MyAnnotation alloc] initWithLocation:newCoordiante];
    [mapView_lights addAnnotation:ann];
    [mapView_lights setRegion:MKCoordinateRegionMakeWithDistance(ann.coordinate, 300,300)];
    [mapView_lights selectAnnotation:ann animated:YES];
   
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView_lights addGestureRecognizer:panRec];
        
    geoStatus=@"YES";
    
}//375 423

/* **********************************************************************************
 Date : 11/07/2014
 Author : iExemplar Software India Pvt Ltd.
 Title: Map View touch options
 Description : when map tapped call this function
 Method Name : gestureRecognizer (delegate Method for tapGuster)
 ************************************************************************************* */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


/* **********************************************************************************
 Date : 11/07/2014
 Author : iExemplar Software India Pvt Ltd.
 Title: Map View touch options
 Description : when user drag the map aprat from current location call this function.
 purpose of this function is
 Method Name : gestureRecognizer (delegate Method for tapGuster)
 ************************************************************************************* */
- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"drag ended");
        [btnUserLocation setHidden:NO];
    }
}

#pragma mark - Schedule User Defined Methods
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : initial Setup for the light schedule screen
 Method Name : initalSetup_LightSchedule
 ************************************************************************************* */
-(void)initalSetup_LightSchedule
{
    [self ScrollView_Configuration_Schedule];
//    if([self.strDeviceType isEqualToString:@"others"]){
//        view_AddSchedule.backgroundColor=lblRGBA(49, 165, 222, 1);
//    }
//    else if([self.strDeviceType isEqualToString:@"lights"])
//    {
//        view_AddSchedule.backgroundColor=lblRGBA(255, 206, 52, 1);
//    }else{
//        view_AddSchedule.backgroundColor=lblRGBA(136, 197, 65, 1);
//    }
    //
    NSLog(@"self.strDeviceMode=%@",self.strDeviceMode);
    if([self.strDeviceMode isEqualToString:@"VACATION"])
    {
        // vacationModeStatus=NO;
        [self changeVacationNewState];
        strVacStatus=@"YES";
    }else
    {
        vacationModeStatus=YES;
        strVacStatus=@"NO";
    }
    
    cellExpandStatus=YES;
//    if([strDeviceType isEqualToString:@"lights"])
//    {
//        [timePicker setValue:lblRGBA(255, 205, 52, 1) forKeyPath:@"textColor"];
//        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
//        [btnOkPicker setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
//        [btnCancelPicker setTitleColor:lblRGBA(255, 205, 52, 1) forState:UIControlStateNormal];
//    }else{
//        [timePicker setValue:lblRGBA(40, 165, 222, 1) forKeyPath:@"textColor"];
//        timePicker.backgroundColor = lblRGBA(65, 64, 66, 1);
//        [btnOkPicker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//        [btnCancelPicker setTitleColor:lblRGBA(40, 165, 222, 1) forState:UIControlStateNormal];
//    }
//    [timePicker setValue:[UIColor blackColor] forKeyPath:@"textColor"];
//    timePicker.backgroundColor = [UIColor whiteColor];
}

-(void)drawBodyContent_Schedule
{
    @try {
        float yOffSet=0;
        for (int index=0;index<[arr_Schedule count];index++){
            view_ScheduleCell[index]=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_ScheduleCell[index].frame = CGRectMake(0, yOffSet, self.view.frame.size.width, 43);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_ScheduleCell[index].frame = CGRectMake(0, yOffSet, self.view.frame.size.width, 55);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_ScheduleCell[index].frame = CGRectMake(0, yOffSet, self.view.frame.size.width, 50);
            }
            if([strDeviceType isEqualToString:@"others"]){
                [view_ScheduleCell[index] setBackgroundColor:lblRGBA(49, 165, 222, 1)];
            }
            else if([strDeviceType isEqualToString:@"lights"])
            {
                [view_ScheduleCell[index] setBackgroundColor:lblRGBA(255, 206, 52, 1)];
            }else{
                [view_ScheduleCell[index] setBackgroundColor:lblRGBA(136, 197, 65, 1)];
            }
            
            [view_ScheduleCell[index] setTag:index];
            [scrollViewSchedule addSubview:view_ScheduleCell[index]];
            
            viewTapGesture_ScheduleCell[index] = [[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                viewTapGesture_ScheduleCell[index].frame = CGRectMake(0, 0, 190, 43);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                viewTapGesture_ScheduleCell[index].frame = CGRectMake(0, 0, 250, 55);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                viewTapGesture_ScheduleCell[index].frame = CGRectMake(0, 0, 230, 50);
            }
            viewTapGesture_ScheduleCell[index].backgroundColor = [UIColor clearColor];
            viewTapGesture_ScheduleCell[index].tag = index;
            [view_ScheduleCell[index] addSubview:viewTapGesture_ScheduleCell[index]];
            
            
//            if([strDeviceType isEqualToString:@"others"]||[strDeviceType isEqualToString:@"lights"]){
                UITapGestureRecognizer *tapGestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandSchedule_View_onClick:)];
                [viewTapGesture_ScheduleCell[index] addGestureRecognizer:tapGestureView];
                [viewTapGesture_ScheduleCell[index] setExclusiveTouch:YES];
//            }else{
//            }
            
            imgViewSchedule[index] = [[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgViewSchedule[index].frame = CGRectMake(10, 13, 16, 16);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgViewSchedule[index].frame = CGRectMake(10, 15, 25, 25);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgViewSchedule[index].frame = CGRectMake(10, 15, 20, 20);
            }//addschedulesprinki6plus
            imgViewSchedule[index].image=[UIImage imageNamed:@"addschedulesprinki6plus"];
//            imgViewSchedule[index].image=[UIImage imageNamed:@"scheduleCalenderImagei6plus"];
            imgViewSchedule[index].tag=index;
            [view_ScheduleCell[index] addSubview:imgViewSchedule[index]];
            
            lblSchedule[index] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblSchedule[index].frame = CGRectMake(34, 0, 156, 43);
                lblSchedule[index].font = [UIFont fontWithName:@"NexaBold" size:11];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblSchedule[index].frame = CGRectMake(43, 0, 203, 55);
                lblSchedule[index].font = [UIFont fontWithName:@"NexaBold" size:15];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblSchedule[index].frame = CGRectMake(38, 0, 187, 50);
                lblSchedule[index].font = [UIFont fontWithName:@"NexaBold" size:12];
            }
            if ([self.strDeviceType isEqualToString:@"sprinklers"]) {
                lblSchedule[index].text = [[arr_Schedule objectAtIndex:index] valueForKey:@"scheduleName"];
            }else{
                lblSchedule[index].text = [[arr_Schedule objectAtIndex:index] valueForKey:kscheduleName];
            }
            lblSchedule[index].textColor = lblRGBA(255, 255, 255, 1);
            lblSchedule[index].tag=index;
            [view_ScheduleCell[index] addSubview:lblSchedule[index]];
            
            txt_Schedule[index] =[[UITextField alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                txt_Schedule[index].frame = CGRectMake(34, 0, 156, 43);
                txt_Schedule[index].font = [UIFont fontWithName:@"NexaBold" size:11];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                txt_Schedule[index].frame = CGRectMake(43, 0, 203, 55);
                txt_Schedule[index].font = [UIFont fontWithName:@"NexaBold" size:15];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                txt_Schedule[index].frame = CGRectMake(38, 0, 187, 50);
                txt_Schedule[index].font = [UIFont fontWithName:@"NexaBold" size:12];
            }
            txt_Schedule[index].backgroundColor=[UIColor clearColor];
            txt_Schedule[index].textColor = lblRGBA(255, 255, 255, 1);
            txt_Schedule[index].autocapitalizationType = UITextAutocapitalizationTypeWords;
            txt_Schedule[index].clearButtonMode = UITextFieldViewModeWhileEditing;
            txt_Schedule[index].placeholder = @"ENTER SCHEDULE NAME";
            [txt_Schedule[index] setValue:lblRGBA(255, 255, 255, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
            if ([self.strDeviceType isEqualToString:@"sprinklers"]) {
                txt_Schedule[index].text = [[arr_Schedule objectAtIndex:index] valueForKey:@"scheduleName"];
            }else{
                txt_Schedule[index].text = [[arr_Schedule objectAtIndex:index] valueForKey:kscheduleName];
            }
            txt_Schedule[index].delegate=self;
            txt_Schedule[index].tag=index;
            [view_ScheduleCell[index] addSubview:txt_Schedule[index]];
            [txt_Schedule[index] setHidden:YES];
            
            view_Schedule_Sub[index]=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_Schedule_Sub[index].frame = CGRectMake(190, 0, 130, 43);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_Schedule_Sub[index].frame = CGRectMake(250, 0, 164, 55);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_Schedule_Sub[index].frame = CGRectMake(230, 0, 145, 50);
            }
            if([strDeviceType isEqualToString:@"others"]){
                view_Schedule_Sub[index].backgroundColor=lblRGBA(116, 196, 234, 1);
            }else if([strDeviceType isEqualToString:@"lights"]){
                view_Schedule_Sub[index].backgroundColor=lblRGBA(255, 216, 74, 1);
            }else{
                view_Schedule_Sub[index].backgroundColor=lblRGBA(159, 206, 101, 1);
            }
            [view_ScheduleCell[index] addSubview:view_Schedule_Sub[index]];
            
            viewTapGesture_Schedule_Sub[index] = [[UIView alloc] init];
            viewTapGesture_Schedule_Sub[index].frame = CGRectMake(0, 0, view_Schedule_Sub[index].frame.size.width, view_Schedule_Sub[index].frame.size.height);
            viewTapGesture_Schedule_Sub[index].backgroundColor = [UIColor clearColor];
            viewTapGesture_Schedule_Sub[index].tag = index;
            [view_Schedule_Sub[index] addSubview:viewTapGesture_Schedule_Sub[index]];
            
            
//            if([strDeviceType isEqualToString:@"others"]||[strDeviceType isEqualToString:@"lights"]){
                UITapGestureRecognizer *tapGestureView1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandSchedule_View_onClick:)];
                [viewTapGesture_Schedule_Sub[index] addGestureRecognizer:tapGestureView1];
                [viewTapGesture_Schedule_Sub[index] setExclusiveTouch:YES];
//            }
            
            imgClock[index] = [[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgClock[index].frame = CGRectMake(10, 14, 16, 16);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgClock[index].frame = CGRectMake(10, 18, 19, 19);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgClock[index].frame = CGRectMake(10, 16, 18, 18);
            }
            imgClock[index].image = [UIImage imageNamed:@"ClockImagei6plus"];
            [view_Schedule_Sub[index] addSubview:imgClock[index]];
            
            NSString *strTime=@"";
            if ([self.strDeviceType isEqualToString:@"sprinklers"]) {
                strTime = [[arr_Schedule objectAtIndex:index] valueForKey:@"startTime"];
            }else{
                if([[[arr_Schedule objectAtIndex:index] valueForKey:kScheduleCategoryID] isEqualToString:@"5"]){
                    strTime=[NSString stringWithFormat:@"%@ To %@",[[arr_Schedule objectAtIndex:index] valueForKey:kStartTime],[[arr_Schedule objectAtIndex:index] valueForKey:kEndTime]];
                }else
                {
                    strTime=[[arr_Schedule objectAtIndex:index] valueForKey:kScheduleCategoryCode];
                }
            }
            
            lblSchedule_Time[index] = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblSchedule_Time[index].frame = CGRectMake(34, 0, 83, 43);
                lblSchedule_Time[index].font = [UIFont fontWithName:@"NexaBold" size:9];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblSchedule_Time[index].frame = CGRectMake(37, 0, 119, 55);
                lblSchedule_Time[index].font = [UIFont fontWithName:@"NexaBold" size:15];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblSchedule_Time[index].frame = CGRectMake(36, 0, 101, 50);
                lblSchedule_Time[index].font = [UIFont fontWithName:@"NexaBold" size:11];
            }
            lblSchedule_Time[index].text = strTime;
            lblSchedule_Time[index].textAlignment=NSTextAlignmentRight;
            lblSchedule_Time[index].textColor = lblRGBA(65, 64, 66, 1);
            lblSchedule_Time[index].numberOfLines=2;
            [view_Schedule_Sub[index] addSubview:lblSchedule_Time[index]];
            
            btn_Save_Schedule[index] = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Save_Schedule[index].frame=CGRectMake(242, 0, 47, 43);
                btn_Save_Schedule[index].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Save_Schedule[index].frame=CGRectMake(321, 0, 47, 55);
                btn_Save_Schedule[index].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:13.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Save_Schedule[index].frame=CGRectMake(283, 0, 47, 50);
                btn_Save_Schedule[index].titleLabel.font = [UIFont fontWithName:@"NexaBold" size:12.0];
            }
            [btn_Save_Schedule[index] setTitle:@"SAVE"  forState:UIControlStateNormal];
            [btn_Save_Schedule[index] setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            [btn_Save_Schedule[index] addTarget:self action:@selector(save_Schedule_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [btn_Save_Schedule[index] setTag:index];
            [btn_Save_Schedule[index] setHidden:YES];
            [view_ScheduleCell[index] addSubview:btn_Save_Schedule[index]];
            
            btn_Edit_Schedule[index] = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Edit_Schedule[index].frame=CGRectMake(285, 3, 35, 40);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Edit_Schedule[index].frame=CGRectMake(374, 8, 32, 40);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Edit_Schedule[index].frame=CGRectMake(337, 5, 35, 40);
            }
            [btn_Edit_Schedule[index] setImage:[UIImage imageNamed:@"WhiteEditImagei6plus"] forState:UIControlStateNormal];
            [btn_Edit_Schedule[index] addTarget:self action:@selector(edit_Schedule_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [btn_Edit_Schedule[index] setTag:index];
            [btn_Edit_Schedule[index] setHidden:YES];
            [view_ScheduleCell[index] addSubview:btn_Edit_Schedule[index]];
            
            btn_Close_Schedule[index] = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Close_Schedule[index].frame=CGRectMake(286, 12, 18, 18);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Close_Schedule[index].frame=CGRectMake(376, 15, 25, 25);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Close_Schedule[index].frame=CGRectMake(337, 15, 20, 20);
            }
          //  [btn_Close_Schedule[index] setImage:[UIImage imageNamed:@"WhiteCloseImagei6plus"] forState:UIControlStateNormal];
            [btn_Close_Schedule[index] setImage:[UIImage imageNamed:@"cancelImagei6plus"] forState:UIControlStateNormal];
            [btn_Close_Schedule[index] addTarget:self action:@selector(close_Schedule_Tapped:) forControlEvents:UIControlEventTouchUpInside];
            [btn_Close_Schedule[index] setTag:index];
            [btn_Close_Schedule[index] setHidden:YES];
            [view_ScheduleCell[index] addSubview:btn_Close_Schedule[index]];
            
            
            yOffSet=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
        }
        yOffSet=yOffSet+10;
        [self scroll_Footer_Setup:yOffSet];
        strStatus=@"YES";
        self.btn_Info.hidden=NO;
        self.view_AddSchedule.hidden=NO;
        if ([self.strDeviceType isEqualToString:@"sprinklers"]) {
            view_VacationMode.hidden=YES;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Info.frame = CGRectMake(204, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Info.frame = CGRectMake(270, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Info.frame = CGRectMake(243, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
            }
        }else{
            self.view_VacationMode.hidden=NO;
            self.view_VacationMode.userInteractionEnabled=YES;
        }
        [self initalSetup_LightSchedule];
    }
    @catch (NSException *exception) {
        NSLog(@"schedule cell exception==%@",exception.description);
    }
    [self stop_PinWheel_DeviceDetails];
}

-(void)scroll_Footer_Setup:(float)yAxis{
    yAxis=yAxis+10;
    view_AddSchedule.frame=CGRectMake(view_AddSchedule.frame.origin.x, yAxis, view_AddSchedule.frame.size.width, view_AddSchedule.frame.size.height);
    view_VacationMode.frame=CGRectMake(view_VacationMode.frame.origin.x, yAxis, view_VacationMode.frame.size.width, view_VacationMode.frame.size.height);
    yAxis=view_VacationMode.frame.origin.y+view_VacationMode.frame.size.height+5;
    btn_Info.frame=CGRectMake(btn_Info.frame.origin.x, yAxis, btn_Info.frame.size.width, btn_Info.frame.size.height);
    scrollViewSchedule.contentSize = CGSizeMake(scrollViewSchedule.frame.size.width, yAxis+btn_Info.frame.size.height);
}
-(void)resetSchedule{
    if([strStatus_Schedule isEqualToString:@"YES"]){
        [txt_Schedule[viewTagValue] resignFirstResponder];
        [txt_Schedule[viewTagValue] setHidden:YES];
        [btn_Save_Schedule[viewTagValue] setHidden:YES];
//        [self.scrollViewSchedule setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.userInteractionEnabled=NO;
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_ScheduleCell[viewTagValue].frame = CGRectMake(0, view_ScheduleCell[viewTagValue].frame.origin.y, self.view.frame.size.width, 43);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewTagValue].frame.origin.y, self.view.frame.size.width, 55);
        }else{
            view_ScheduleCell[viewTagValue].frame = CGRectMake(0, view_ScheduleCell[viewTagValue].frame.origin.y, self.view.frame.size.width, 50);
        }

        yOffSet_Content=view_ScheduleCell[viewTagValue].frame.origin.y+view_ScheduleCell[viewTagValue].frame.size.height+5;
        for (int index=0;index<[arr_Schedule count];index++){
            if (index>viewTagValue) {
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_ScheduleCell[index].frame = CGRectMake(0, yOffSet_Content, self.view.frame.size.width, 43);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_ScheduleCell[index].frame = CGRectMake(0, yOffSet_Content, self.view.frame.size.width, 55);
                }else{
                    view_ScheduleCell[index].frame = CGRectMake(0, yOffSet_Content, self.view.frame.size.width, 50);
                }
                yOffSet_Content=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
            }
        }
        [self scroll_Footer_Setup:yOffSet_Content];
        [view_Schedule_ContentView[viewTagValue] setHidden:YES];
        [view_Schedule_ContentView[viewTagValue] removeFromSuperview];
        [self show_Schedule_Header:(int)viewTagValue];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled=YES;
        cellExpandStatus=YES;
        
    }];
}
-(void)hide_Schedule_Header:(int)tagVal{
    [lblSchedule_Time[tagVal] setHidden:YES];
    [imgClock[tagVal] setHidden:YES];
    [btn_Edit_Schedule[tagVal] setHidden:NO];
    //[btn_Close_Schedule[tagVal] setHidden:NO];
    [btn_Close_Schedule[tagVal] setHidden:YES];
}
-(void)show_Schedule_Header:(int)tagVal{
    [lblSchedule_Time[tagVal] setHidden:NO];
    [lblSchedule[tagVal] setHidden:NO];
    [imgClock[tagVal] setHidden:NO];
    [btn_Edit_Schedule[tagVal] setHidden:YES];
    [btn_Close_Schedule[tagVal] setHidden:YES];
    strStatus_Schedule=@"NO";
    txt_Schedule[tagVal].text = lblSchedule[tagVal].text;
}
- (void)expandSchedule_View_onClick:(UITapGestureRecognizer*)sender {
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSLog(@"Owner==%@",appDelegate.strOwnerNetwork_Status);
//    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
//    {
//        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
//        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
//        {
//            [Common showAlert:kAlertTitleWarning withMessage:@"You have no permisson to do this"];
//            return;
//        }
//    }
    viewCurrent = sender.view;
    tag_Pos=(int)viewCurrent.tag;
    NSLog(@"tag==%ld",(long)viewCurrent.tag);
    if ([strDeviceType isEqualToString:@"sprinklers"]) {
        AddSprinklerScheldule *ASSVC = [[AddSprinklerScheldule alloc] initWithNibName:@"AddSprinklerScheldule" bundle:nil];
        ASSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
        ASSVC.strScheduleAction=@"EDIT";
        ASSVC.strStatus_Schedule=@"lightSchedule";
        ASSVC.dictScheduleList=[arr_Schedule objectAtIndex:tag_Pos];
        [Common viewFadeInSettings:self.navigationController.view];
        [self.navigationController pushViewController:ASSVC animated:NO];
        return;
    }
    strSelected_SchID=[[arr_Schedule objectAtIndex:tag_Pos] valueForKey:kSchMainID];
    if([strStatus_Schedule isEqualToString:@"YES"]){
        [txt_Schedule[viewTagValue] resignFirstResponder];
        [txt_Schedule[viewTagValue] setHidden:YES];
        [btn_Save_Schedule[viewTagValue] setHidden:YES];
        [self show_Schedule_Header:(int)viewTagValue];
    }
    @try {
        if (cellExpandStatus==YES) {
            [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
           // [self performSelectorOnMainThread:@selector(parseBodyScheduleWidget) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getScheduleDetail) withObject:self];
        }else{
            if (viewTagValue==viewCurrent.tag) {
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 43);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 55);
                    }else{
                        view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 50);
                    }
                    yOffSet_Content=view_ScheduleCell[viewCurrent.tag].frame.origin.y+view_ScheduleCell[viewCurrent.tag].frame.size.height+5;
                    for (int index=0;index<[arr_Schedule count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                                view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 55);
                            }else{
                                view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 50);
                            }
                            yOffSet_Content=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
                        }
                    }
                    [self scroll_Footer_Setup:yOffSet_Content];
                    [view_Schedule_ContentView[viewCurrent.tag] setHidden:YES];
                    [view_Schedule_ContentView[viewCurrent.tag] removeFromSuperview];
                    [self show_Schedule_Header:(int)viewTagValue];
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatus=YES;
                }];
            }else{
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                //[self performSelectorOnMainThread:@selector(parseBodyScheduleWidget) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getScheduleDetail) withObject:self];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}

-(void)parseBodyScheduleWidget
{
    @try {
        if (cellExpandStatus==YES) {
            self.view.userInteractionEnabled=NO;
            [self schedule_AddWidget:tag_Pos];
            
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 478); //947
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 596); //947
                }else{
                    view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 542); //947
                }
                yOffSet_Content=view_ScheduleCell[viewCurrent.tag].frame.origin.y+view_ScheduleCell[viewCurrent.tag].frame.size.height+5;
                for (int index=0;index<[arr_Schedule count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 55);
                        }else{
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 50);
                        }
                        yOffSet_Content=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
                    }
                }
                viewTagValue=viewCurrent.tag;
                [self scroll_Footer_Setup:yOffSet_Content];
                [self hide_Schedule_Header:(int)viewTagValue];
            } completion:^(BOOL finished) {
                view_Schedule_ContentView[tag_Pos].hidden=NO;
                cellExpandStatus=NO;
                self.view.userInteractionEnabled=YES;
            }];
            
            
        }else{
            self.view.userInteractionEnabled=NO;
            [self show_Schedule_Header:(int)viewTagValue];
            [self schedule_AddWidget:tag_Pos];
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_ScheduleCell[viewTagValue].frame=CGRectMake(0, view_ScheduleCell[viewTagValue].frame.origin.y, self.view.frame.size.width, 43);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_ScheduleCell[viewTagValue].frame=CGRectMake(0, view_ScheduleCell[viewTagValue].frame.origin.y, self.view.frame.size.width, 55);
                }else{
                    view_ScheduleCell[viewTagValue].frame=CGRectMake(0, view_ScheduleCell[viewTagValue].frame.origin.y, self.view.frame.size.width, 50);
                }
                yOffSet_Content=view_ScheduleCell[viewTagValue].frame.origin.y+view_ScheduleCell[viewTagValue].frame.size.height+5;
                [view_Schedule_ContentView[viewTagValue] setHidden:YES];
                [view_Schedule_ContentView[viewTagValue] removeFromSuperview];
                for (int index=0;index<[arr_Schedule count];index++){
                    if (index>viewTagValue) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 55);
                        }else{
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 50);
                        }
                        yOffSet_Content=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
                    }
                }
                
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 478);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 596);
                }else{
                    view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 542);
                }
                yOffSet_Content=view_ScheduleCell[viewCurrent.tag].frame.origin.y+view_ScheduleCell[viewCurrent.tag].frame.size.height+5;
                // [self testAddWidget:view.tag];
                for (int index=0;index<[arr_Schedule count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 55);
                        }else{
                            view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 50);
                        }
                        yOffSet_Content=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
                    }
                }
                viewTagValue=viewCurrent.tag;
                [self hide_Schedule_Header:(int)viewTagValue];
                [self scroll_Footer_Setup:yOffSet_Content];
                
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled=YES;
                // [self schedule_AddWidget:tag_Pos];
                cellExpandStatus=NO;
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}

-(void)toggleSwitchSetUp_ScheduleUpdate
{
    [duskSwitch_Stngs setOn:NO animated:NO];
    [duskSwitch_Stngs setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    duskSwitch_Stngs.backgroundColor=lblRGBA(98, 99, 102, 1);
    duskSwitch_Stngs.tintColor=lblRGBA(98, 99, 102, 1);
    duskSwitch_Stngs.layer.masksToBounds=YES;
    duskSwitch_Stngs.layer.cornerRadius=16.0;
    
    [dawnSwitch_Stngs setOn:NO animated:NO];
    [dawnSwitch_Stngs setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    dawnSwitch_Stngs.backgroundColor=lblRGBA(98, 99, 102, 1);
    dawnSwitch_Stngs.tintColor=lblRGBA(98, 99, 102, 1);
    dawnSwitch_Stngs.layer.masksToBounds=YES;
    dawnSwitch_Stngs.layer.cornerRadius=16.0;
    
    [duskSwitch_DuskView setOn:NO animated:NO];
    [duskSwitch_DuskView setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    duskSwitch_DuskView.backgroundColor=lblRGBA(98, 99, 102, 1);
    duskSwitch_DuskView.tintColor=lblRGBA(98, 99, 102, 1);
    duskSwitch_DuskView.layer.masksToBounds=YES;
    duskSwitch_DuskView.layer.cornerRadius=16.0;
    
    [dawnSwitch_DawnView setOn:NO animated:NO];
    [dawnSwitch_DawnView setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    dawnSwitch_DawnView.backgroundColor=lblRGBA(98, 99, 102, 1);
    dawnSwitch_DawnView.tintColor=lblRGBA(98, 99, 102, 1);
    dawnSwitch_DawnView.layer.masksToBounds=YES;
    dawnSwitch_DawnView.layer.cornerRadius=16.0;
    
    [switchTime setOn:NO animated:NO];
    [switchTime setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switchTime.backgroundColor=lblRGBA(98, 99, 102, 1);
    switchTime.tintColor=lblRGBA(98, 99, 102, 1);
    switchTime.layer.masksToBounds=YES;
    switchTime.layer.cornerRadius=16.0;
    
    [switch_RunOn_Header setOn:NO animated:NO];
    [switch_RunOn_Header setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_RunOn_Header.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_RunOn_Header.tintColor=lblRGBA(98, 99, 102, 1);
    switch_RunOn_Header.layer.masksToBounds=YES;
    switch_RunOn_Header.layer.cornerRadius=16.0;
    
    [switch_ODD_Days setOn:NO animated:NO];
    [switch_ODD_Days setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_ODD_Days.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_ODD_Days.tintColor=lblRGBA(98, 99, 102, 1);
    switch_ODD_Days.layer.masksToBounds=YES;
    switch_ODD_Days.layer.cornerRadius=16.0;
    
    [switch_Even_Days setOn:NO animated:NO];
    [switch_Even_Days setThumbTintColor:lblRGBA(255, 255, 255, 1)];
    switch_Even_Days.backgroundColor=lblRGBA(98, 99, 102, 1);
    switch_Even_Days.tintColor=lblRGBA(98, 99, 102, 1);
    switch_Even_Days.layer.masksToBounds=YES;
    switch_Even_Days.layer.cornerRadius=16.0;
    
}

-(void)showWarningPermission:(id)sender
{
    [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
}
-(void) schedule_AddWidget:(int)tag
{
    @try {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"Sch Selected Content==%@",dictGetSch_Content);
        view_Schedule_ContentView[tag].hidden=YES;
        view_Schedule_ContentView[tag]=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_Schedule_ContentView[tag].frame = CGRectMake(0, 43, self.view.frame.size.width, 435);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_Schedule_ContentView[tag].frame = CGRectMake(0, 55, self.view.frame.size.width, 541);
        }else{
            view_Schedule_ContentView[tag].frame = CGRectMake(0, 50, self.view.frame.size.width, 492);
        }
        view_Schedule_ContentView[tag].backgroundColor=lblRGBA(65, 64, 66, 1);
        [view_ScheduleCell[tag] addSubview:view_Schedule_ContentView[tag]];
        
        UIView *viewDuskSettings=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewDuskSettings.frame = CGRectMake(21, 2, 277, 33);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewDuskSettings.frame = CGRectMake(27, 5, 360, 39);
        }else{
            viewDuskSettings.frame = CGRectMake(24, 5, 327, 35);
        }
        viewDuskSettings.backgroundColor=lblRGBA(76, 76, 75, 1);
        [view_Schedule_ContentView[tag] addSubview:viewDuskSettings];
        
        UILabel *lblDusk_Stngs = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDusk_Stngs.frame = CGRectMake(8, 6, 145, 21);
            lblDusk_Stngs.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDusk_Stngs.frame = CGRectMake(8, 14, 237, 21);
            lblDusk_Stngs.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDusk_Stngs.frame = CGRectMake(8, 10, 206, 21);
            lblDusk_Stngs.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDusk_Stngs.text = @"DUSK TO DAWN SETTING";
        lblDusk_Stngs.textColor = lblRGBA(255, 255, 255, 1);
        [viewDuskSettings addSubview:lblDusk_Stngs];
        
        //Dusk To Dawn Switch
        duskSwitch_Stngs = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            duskSwitch_Stngs.frame = CGRectMake(219, 1, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            duskSwitch_Stngs.frame = CGRectMake(308, 5, 51, 31);
        }else{
            duskSwitch_Stngs.frame = CGRectMake(276, 3, 51, 31);
        }
        duskSwitch_Stngs.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        duskSwitch_Stngs.tag=tag;
        duskSwitch_Stngs.enabled=NO;
        [duskSwitch_Stngs setSelected:NO];
        [duskSwitch_Stngs addTarget:self action:@selector(duskToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewDuskSettings addSubview:duskSwitch_Stngs];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnDuskDawnStng = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnDuskDawnStng addTarget:self
                                    action:@selector(showWarningPermission:)
                          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnDuskDawnStng setTitle:@"" forState:UIControlStateNormal];
                btnDuskDawnStng.userInteractionEnabled=NO;
                //btnDuskDawnStng.frame = CGRectMake(566, 19, 51, 31);
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnDuskDawnStng.frame = CGRectMake(219, 1, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnDuskDawnStng.frame = CGRectMake(308, 5, 51, 31);
                }else{
                    btnDuskDawnStng.frame = CGRectMake(276, 3, 51, 31);
                }
                [viewDuskSettings addSubview:btnDuskDawnStng];
            }
        }
        
        
        UIView *viewDawnSettings=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewDawnSettings.frame = CGRectMake(21, 38, 277, 33);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewDawnSettings.frame = CGRectMake(27, 47, 360, 39);
        }else{
            viewDawnSettings.frame = CGRectMake(24, 43, 327, 35);
        }
        viewDawnSettings.backgroundColor=lblRGBA(76, 76, 75, 1);
        [view_Schedule_ContentView[tag] addSubview:viewDawnSettings];
        
        
        UILabel *lblDawn_Stngs = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDawn_Stngs.frame = CGRectMake(8, 6, 145, 21);
            lblDawn_Stngs.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDawn_Stngs.frame = CGRectMake(8, 14, 237, 21);
            lblDawn_Stngs.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDawn_Stngs.frame = CGRectMake(8, 10, 206, 21);
            lblDawn_Stngs.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDawn_Stngs.text = @"DAWN TO DUSK SETTING";
        lblDawn_Stngs.textColor = lblRGBA(255, 255, 255, 1);
        [viewDawnSettings addSubview:lblDawn_Stngs];
        
        //Dawn To Dusk Switch
        dawnSwitch_Stngs = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            dawnSwitch_Stngs.frame = CGRectMake(219, 1, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            dawnSwitch_Stngs.frame = CGRectMake(308, 5, 51, 31);
        }else{
            dawnSwitch_Stngs.frame = CGRectMake(276, 3, 51, 31);
        }
        dawnSwitch_Stngs.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        dawnSwitch_Stngs.tag=tag;
        dawnSwitch_Stngs.enabled=NO;
        [dawnSwitch_Stngs setSelected:NO];
        [dawnSwitch_Stngs addTarget:self action:@selector(dawnToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewDawnSettings addSubview:dawnSwitch_Stngs];
        
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnDawnDuskStng = [UIButton buttonWithType:UIButtonTypeCustom];
                btnDawnDuskStng.userInteractionEnabled=NO;
                [btnDawnDuskStng addTarget:self
                                    action:@selector(showWarningPermission:)
                          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnDawnDuskStng setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnDawnDuskStng.frame = CGRectMake(219, 1, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnDawnDuskStng.frame = CGRectMake(308, 5, 51, 31);
                }else{
                    btnDawnDuskStng.frame = CGRectMake(276, 3, 51, 31);
                }
                [viewDawnSettings addSubview:btnDawnDuskStng];
            }
        }
        
        UIView *viewDusk=[[UIView alloc] init]; //147
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewDusk.frame = CGRectMake(21, 107, 277, 30);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewDusk.frame = CGRectMake(27, 130, 360, 39);
        }else{
            viewDusk.frame = CGRectMake(24, 118, 327, 35);
        }
        viewDusk.backgroundColor=lblRGBA(76, 76, 75, 1);
        [view_Schedule_ContentView[tag] addSubview:viewDusk];
        
        UILabel *lblDusk_View=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDusk_View.frame = CGRectMake(8, 5, 42, 21);
            lblDusk_View.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDusk_View.frame = CGRectMake(8, 11, 68, 21);
            lblDusk_View.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDusk_View.frame = CGRectMake(8, 9, 61, 21);
            lblDusk_View.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDusk_View.text = @"DUSK";
        // lblDusk_View.textColor = lblRGBA(255, 206, 52, 1);
        [viewDusk addSubview:lblDusk_View];
        
        btn_Dusk_Plus=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Dusk_Plus.frame=CGRectMake(90, 4, 19, 22);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Dusk_Plus.frame=CGRectMake(132, 7, 24, 24);
        }else{
            btn_Dusk_Plus.frame=CGRectMake(104, 6, 22, 22);
        }
        btn_Dusk_Plus.backgroundColor=lblRGBA(98, 99, 102, 1);
        [btn_Dusk_Plus setImage:[UIImage imageNamed:@"PlusImagei6plus"] forState:UIControlStateNormal];
        [btn_Dusk_Plus setTag:2];
        btn_Dusk_Plus.userInteractionEnabled=NO;
        [btn_Dusk_Plus addTarget:self action:@selector(dusk_Dawn_Increment_Dec_Action:) forControlEvents:UIControlEventTouchUpInside];
        [viewDusk addSubview:btn_Dusk_Plus];
        
        
        btn_Dusk_Minus=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_Dusk_Minus.frame=CGRectMake(237, 12, 45, 45);
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Dusk_Minus.frame=CGRectMake(110, 4, 19, 22);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Dusk_Minus.frame=CGRectMake(157, 7, 24, 24);
        }else{
            btn_Dusk_Minus.frame=CGRectMake(127, 6, 22, 22);
        }
        btn_Dusk_Minus.backgroundColor=lblRGBA(98, 99, 102, 1);
        [btn_Dusk_Minus setImage:[UIImage imageNamed:@"MinusImagei6plus"] forState:UIControlStateNormal];
        [btn_Dusk_Minus setTag:3];
        btn_Dusk_Minus.userInteractionEnabled=NO;
        [btn_Dusk_Minus addTarget:self action:@selector(dusk_Dawn_Increment_Dec_Action:) forControlEvents:UIControlEventTouchUpInside];
        [viewDusk addSubview:btn_Dusk_Minus];
        
        lblDuskHours_View=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDuskHours_View.frame=CGRectMake(142, 5, 70, 21);
            lblDuskHours_View.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDuskHours_View.frame=CGRectMake(205, 11, 89, 21);
            lblDuskHours_View.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDuskHours_View.frame=CGRectMake(180, 9, 80, 21);
            lblDuskHours_View.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDuskHours_View.text = @"0 HOUR";
        lblDuskHours_View.textColor = lblRGBA(255, 255, 255, 1);
        [viewDusk addSubview:lblDuskHours_View];
        
        
        //DUSK
        duskSwitch_DuskView = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            duskSwitch_DuskView.frame = CGRectMake(219, 1, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            duskSwitch_DuskView.frame = CGRectMake(308, 5, 51, 31);
        }else{
            duskSwitch_DuskView.frame = CGRectMake(276, 3, 51, 31);
        }
        duskSwitch_DuskView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        duskSwitch_DuskView.tag=tag;
        duskSwitch_DuskView.enabled=NO;
        [duskSwitch_DuskView setSelected:NO];
        [duskSwitch_DuskView addTarget:self action:@selector(dusk_ViewToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewDusk addSubview:duskSwitch_DuskView];
        
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnDusk = [UIButton buttonWithType:UIButtonTypeCustom];
                btnDusk.userInteractionEnabled=NO;
                [btnDusk addTarget:self
                            action:@selector(showWarningPermission:)
                  forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnDusk setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnDusk.frame = CGRectMake(219, 1, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnDusk.frame = CGRectMake(308, 5, 51, 31);
                }else{
                    btnDusk.frame = CGRectMake(276, 3, 51, 31);
                }
                [viewDusk addSubview:btnDusk];
            }
        }
        
        
        UIView *viewDawn=[[UIView alloc] init]; //224
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewDawn.frame = CGRectMake(21, 74, 277, 30);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewDawn.frame = CGRectMake(27, 89, 360, 39);
        }else{
            viewDawn.frame = CGRectMake(24, 81, 327, 35);
        }
        viewDawn.backgroundColor=lblRGBA(76, 76, 75, 1);
        [view_Schedule_ContentView[tag] addSubview:viewDawn];
        
        UILabel *lblDawn_View=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDawn_View.frame = CGRectMake(8, 5, 42, 21);
            lblDawn_View.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDawn_View.frame = CGRectMake(8, 11, 76, 21);
            lblDawn_View.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDawn_View.frame = CGRectMake(8, 9, 61, 21);
            lblDawn_View.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDawn_View.text = @"DAWN";
        // lblDawn_View.textColor = lblRGBA(255, 206, 52, 1);
        [viewDawn addSubview:lblDawn_View];
        
        btn_Dawn_Plus=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Dawn_Plus.frame=CGRectMake(90, 4, 19, 22);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Dawn_Plus.frame=CGRectMake(132, 7, 24, 24);
        }else{
            btn_Dawn_Plus.frame=CGRectMake(104, 6, 22, 22);
        }
        [btn_Dawn_Plus setImage:[UIImage imageNamed:@"PlusImagei6plus"] forState:UIControlStateNormal];
        btn_Dawn_Plus.backgroundColor=lblRGBA(98, 99, 102, 1);
        btn_Dawn_Plus.userInteractionEnabled=NO;
        [btn_Dawn_Plus addTarget:self action:@selector(dusk_Dawn_Increment_Dec_Action:) forControlEvents:UIControlEventTouchUpInside];
        [viewDawn addSubview:btn_Dawn_Plus];
        
        btn_Dawn_Minus=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Dawn_Minus.frame=CGRectMake(110, 4, 19, 22);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Dawn_Minus.frame=CGRectMake(157, 7, 24, 24);
        }else{
            btn_Dawn_Minus.frame=CGRectMake(127, 6, 22, 22);
        }
        [btn_Dawn_Minus setImage:[UIImage imageNamed:@"MinusImagei6plus"] forState:UIControlStateNormal];
        btn_Dawn_Minus.backgroundColor=lblRGBA(98, 99, 102, 1);
        [btn_Dawn_Minus setTag:1];
        btn_Dawn_Minus.userInteractionEnabled=NO;
        [btn_Dawn_Minus addTarget:self action:@selector(dusk_Dawn_Increment_Dec_Action:) forControlEvents:UIControlEventTouchUpInside];
        [viewDawn addSubview:btn_Dawn_Minus];
        
        lblDawnHours_View=[[UILabel alloc] initWithFrame:CGRectMake(310, 17, 164, 35)];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDawnHours_View.frame=CGRectMake(142, 5, 70, 21);
            lblDawnHours_View.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDawnHours_View.frame=CGRectMake(205, 11, 89, 21);
            lblDawnHours_View.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDawnHours_View.frame=CGRectMake(180, 9, 80, 21);
            lblDawnHours_View.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDawnHours_View.text = @"0 HOUR";
        lblDawnHours_View.textColor = lblRGBA(255, 255, 255, 1);
        [viewDawn addSubview:lblDawnHours_View];
        
        //DAWN
        dawnSwitch_DawnView = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            dawnSwitch_DawnView.frame = CGRectMake(219, 1, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            dawnSwitch_DawnView.frame = CGRectMake(308, 5, 51, 31);
        }else{
            dawnSwitch_DawnView.frame = CGRectMake(276, 3, 51, 31);
        }
        dawnSwitch_DawnView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        dawnSwitch_DawnView.tag=tag;
        dawnSwitch_DawnView.enabled=NO;
        [dawnSwitch_DawnView setSelected:NO];
        [dawnSwitch_DawnView addTarget:self action:@selector(dawn_ViewToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewDawn addSubview:dawnSwitch_DawnView];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnDawn = [UIButton buttonWithType:UIButtonTypeCustom];
                btnDawn.userInteractionEnabled=NO;
                [btnDawn addTarget:self
                            action:@selector(showWarningPermission:)
                  forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnDawn setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnDawn.frame = CGRectMake(219, 1, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnDawn.frame = CGRectMake(308, 5, 51, 31);
                }else{
                    btnDawn.frame = CGRectMake(276, 3, 51, 31);
                }
                [viewDawn addSubview:btnDawn];
            }
        }
        
        UIView *viewTime=[[UIView alloc] init]; //301
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewTime.frame = CGRectMake(21, 140, 277, 30);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewTime.frame = CGRectMake(27, 171, 360, 39);
        }else{
            viewTime.frame = CGRectMake(24, 155, 327, 35);
        }
        viewTime.backgroundColor=lblRGBA(76, 76, 75, 1);
        [view_Schedule_ContentView[tag] addSubview:viewTime];
        
        btn_StartTime=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_StartTime.frame = CGRectMake(20,17,149,35);
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_StartTime.frame = CGRectMake(5, 5, 72, 21);
            btn_StartTime.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_StartTime.frame = CGRectMake(8, 11, 92, 21);
            btn_StartTime.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:16];
        }else{
            btn_StartTime.frame = CGRectMake(8, 9, 83, 21);
            btn_StartTime.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:15];
        }
        btn_StartTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn_StartTime addTarget:self action:@selector(timePickerUpdate:) forControlEvents:UIControlEventTouchUpInside];
        [btn_StartTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_StartTime setTag:0];
        [viewTime addSubview:btn_StartTime];

        UILabel *lblTo_View=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblTo_View.frame = CGRectMake(90, 1, 39, 29);
            lblTo_View.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblTo_View.frame = CGRectMake(133, 4, 48, 31);
            lblTo_View.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblTo_View.frame = CGRectMake(105, 2, 44, 31);
            lblTo_View.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblTo_View.text = @"TO";
        lblTo_View.textColor = lblRGBA(255, 255, 255, 1);
        lblTo_View.backgroundColor=lblRGBA(98, 99, 102, 1);
        lblTo_View.textAlignment=NSTextAlignmentCenter;
        [viewTime addSubview:lblTo_View];
        
        btn_EndTime=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_EndTime.frame = CGRectMake(310,17,164,35);
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_EndTime.frame = CGRectMake(142, 5, 65, 21);
            btn_EndTime.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_EndTime.frame = CGRectMake(205, 11, 88, 21);
            btn_EndTime.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:16];
        }else{
            btn_EndTime.frame = CGRectMake(180, 9, 80, 21);
            btn_EndTime.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:15];
        }
        [btn_EndTime addTarget:self action:@selector(timePickerUpdate:) forControlEvents:UIControlEventTouchUpInside];
        [btn_EndTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_EndTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn_EndTime setTag:1];
        [viewTime addSubview:btn_EndTime];
        
        //Manual
        switchTime = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            switchTime.frame = CGRectMake(219, 1, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            switchTime.frame = CGRectMake(308, 5, 51, 31);
        }else{
            switchTime.frame = CGRectMake(276, 3, 51, 31);
        }
        switchTime.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        switchTime.tag=tag;
        switchTime.enabled=NO;
        [switchTime setSelected:NO];
        [switchTime addTarget:self action:@selector(switch_Time_ToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewTime addSubview:switchTime];
        
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnManual = [UIButton buttonWithType:UIButtonTypeCustom];
                btnManual.userInteractionEnabled=NO;
                [btnManual addTarget:self
                              action:@selector(showWarningPermission:)
                    forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnManual setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnManual.frame = CGRectMake(219, 1, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnManual.frame = CGRectMake(308, 5, 51, 31);
                }else{
                    btnManual.frame = CGRectMake(276, 3, 51, 31);
                }
                [viewTime addSubview:btnManual];
            }
        }
        
        UIView *viewOdd_Even=[[UIView alloc] init]; //377 and 69
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewOdd_Even.frame = CGRectMake(21, 173, 277, 64);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewOdd_Even.frame = CGRectMake(27, 212, 360, 78);
        }else{
            viewOdd_Even.frame = CGRectMake(24, 192, 327, 70);
        }
        viewOdd_Even.backgroundColor=lblRGBA(76, 76, 75, 1);
        [view_Schedule_ContentView[tag] addSubview:viewOdd_Even];
        
        UILabel *lblRunOddDays=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblRunOddDays.frame = CGRectMake(5, 5, 60, 21);
            lblRunOddDays.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblRunOddDays.frame = CGRectMake(8, 11, 81, 21);
            lblRunOddDays.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblRunOddDays.frame = CGRectMake(8, 9, 72, 21);
            lblRunOddDays.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblRunOddDays.text = @"RUN ON";
        lblRunOddDays.textColor = lblRGBA(255, 255, 255, 1);
        [viewOdd_Even addSubview:lblRunOddDays];
        
        //Run On Switch
        switch_RunOn_Header = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            switch_RunOn_Header.frame = CGRectMake(219, 1, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            switch_RunOn_Header.frame = CGRectMake(308, 5, 51, 31);
        }else{
            switch_RunOn_Header.frame = CGRectMake(276, 3, 51, 31);
        }
        switch_RunOn_Header.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        switch_RunOn_Header.backgroundColor=[UIColor whiteColor];
        switch_RunOn_Header.layer.masksToBounds=YES;
        switch_RunOn_Header.layer.cornerRadius=16.0;
        [switch_RunOn_Header setSelected:NO];
       // switch_RunOn_Header.enabled=NO; //Extra
        switch_RunOn_Header.tag=tag;
        [switch_RunOn_Header addTarget:self action:@selector(switch_RunON_ToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [switch_RunOn_Header setOn:NO animated:NO];
        [viewOdd_Even addSubview:switch_RunOn_Header];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnRunOn = [UIButton buttonWithType:UIButtonTypeCustom];
                btnRunOn.userInteractionEnabled=NO;
                [btnRunOn addTarget:self
                             action:@selector(showWarningPermission:)
                   forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnRunOn setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnRunOn.frame = CGRectMake(219, 1, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnRunOn.frame = CGRectMake(308, 5, 51, 31);
                }else{
                    btnRunOn.frame = CGRectMake(276, 3, 51, 31);
                }
                [viewOdd_Even addSubview:btnRunOn];
            }
        }
        
        //view_Schedule_DaysSubView[tag]
        viewSchedule_RunON_Header=[[UIView alloc] init]; //377 and 69
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewSchedule_RunON_Header.frame = CGRectMake(0, 32, 277, 32);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewSchedule_RunON_Header.frame = CGRectMake(0, 39, 360, 39);
        }else{
            viewSchedule_RunON_Header.frame = CGRectMake(0, 35, 327, 35);
        }
        viewSchedule_RunON_Header.backgroundColor=lblRGBA(76, 76, 75, 1);
        viewSchedule_RunON_Header.alpha=0.6;
        viewSchedule_RunON_Header.userInteractionEnabled=NO;
        [viewOdd_Even addSubview:viewSchedule_RunON_Header];
        
        UILabel *lblRunOdd=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblRunOdd.frame = CGRectMake(5, 5, 35, 21);
            lblRunOdd.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblRunOdd.frame = CGRectMake(8, 9, 44, 21);
            lblRunOdd.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblRunOdd.frame = CGRectMake(8, 7, 44, 21);
            lblRunOdd.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblRunOdd.text = @"ODD";
        lblRunOdd.textColor = lblRGBA(255, 255, 255, 1);
        [viewSchedule_RunON_Header addSubview:lblRunOdd];
        
        switch_ODD_Days = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            switch_ODD_Days.frame = CGRectMake(49, 0, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            switch_ODD_Days.frame = CGRectMake(69, 4, 51, 31);
        }else{
            switch_ODD_Days.frame = CGRectMake(65, 2, 51, 31);
        }
        switch_ODD_Days.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        switch_ODD_Days.tag=tag;
        switch_ODD_Days.enabled=NO;
        [switch_ODD_Days setSelected:NO];
        [switch_ODD_Days addTarget:self action:@selector(switch_ODD_ToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewSchedule_RunON_Header addSubview:switch_ODD_Days];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnOdd = [UIButton buttonWithType:UIButtonTypeCustom];
                btnOdd.userInteractionEnabled=NO;
                [btnOdd addTarget:self
                           action:@selector(showWarningPermission:)
                 forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnOdd setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnOdd.frame = CGRectMake(49, 0, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnOdd.frame = CGRectMake(69, 4, 51, 31);
                }else{
                    btnOdd.frame = CGRectMake(65, 2, 51, 31);
                }
                [viewSchedule_RunON_Header addSubview:btnOdd];
            }
        }
        
        
        UILabel *lblEvenDays=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblEvenDays.frame = CGRectMake(118, 5, 36, 21);
            lblEvenDays.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblEvenDays.frame = CGRectMake(153, 9, 48, 21);
            lblEvenDays.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblEvenDays.frame = CGRectMake(135, 7, 44, 21);
            lblEvenDays.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblEvenDays.text = @"EVEN";
        lblEvenDays.textColor = lblRGBA(255, 255, 255, 1);
        [viewSchedule_RunON_Header addSubview:lblEvenDays];
        
        switch_Even_Days = [[UISwitch alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            switch_Even_Days.frame = CGRectMake(165, 0, 51, 31);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            switch_Even_Days.frame = CGRectMake(218, 4, 51, 31);
        }else{
            switch_Even_Days.frame = CGRectMake(197, 2, 51, 31);
        }
        switch_Even_Days.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        switch_Even_Days.tag=tag;
        switch_Even_Days.enabled=NO;
        [switch_Even_Days setSelected:NO];
        [switch_Even_Days addTarget:self action:@selector(switch_EVEN_ToggledSettings:) forControlEvents:UIControlEventValueChanged];
        [viewSchedule_RunON_Header addSubview:switch_Even_Days];
        if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
        {
            NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
            if([appDelegate.strNetworkPermission isEqualToString:@"2"])
            {
                btnEven = [UIButton buttonWithType:UIButtonTypeCustom];
                btnEven.userInteractionEnabled=NO;
                [btnEven addTarget:self
                            action:@selector(showWarningPermission:)
                  forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [btnEven setTitle:@"" forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btnEven.frame = CGRectMake(165, 0, 51, 31);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btnEven.frame = CGRectMake(218, 4, 51, 31);
                }else{
                    btnEven.frame = CGRectMake(197, 2, 51, 31);
                }
                [viewSchedule_RunON_Header addSubview:btnEven];
            }
        }
        
        [self toggleSwitchSetUp_ScheduleUpdate];

        UILabel *lblDays=[[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblDays.frame = CGRectMake(226, 5, 36, 21);
            lblDays.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblDays.frame = CGRectMake(311, 9, 48, 21);
            lblDays.font = [UIFont fontWithName:@"NexaBold" size:16];
        }else{
            lblDays.frame = CGRectMake(280, 7, 44, 21);
            lblDays.font = [UIFont fontWithName:@"NexaBold" size:15];
        }
        lblDays.text = @"DAYS";
        lblDays.textColor = lblRGBA(255, 255, 255, 1);
        [viewSchedule_RunON_Header addSubview:lblDays];
        
        
        UILabel *lblCaption_Days=[[UILabel alloc] init]; //534
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblCaption_Days.frame = CGRectMake(22, 244, 223, 16);
            lblCaption_Days.font = [UIFont fontWithName:@"NexaBold" size:7];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblCaption_Days.frame = CGRectMake(26, 299, 342, 16);
            lblCaption_Days.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else{
            lblCaption_Days.frame = CGRectMake(23, 270, 284, 16);
            lblCaption_Days.font = [UIFont fontWithName:@"NexaBold" size:9];
        }
        lblCaption_Days.text = @"SELECT THE DAYS YOU WISH YOUR DEVICE TO FUNCTION ON";
        lblCaption_Days.textColor = lblRGBA(98, 99, 102, 1);
        [view_Schedule_ContentView[tag] addSubview:lblCaption_Days];
        
        
        btn_Mon_Day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Mon_Day setTitle:@"MON" forState:UIControlStateNormal];
        [btn_Mon_Day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Mon_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Mon_Day.frame = CGRectMake(21,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Mon_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Mon_Day.frame = CGRectMake(27,323,49, 49);//554
        }else{
            btn_Mon_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Mon_Day.frame = CGRectMake(24,292,45, 45);//554
        }
        btn_Mon_Day.userInteractionEnabled=NO;
        [btn_Mon_Day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Mon_Day.tag=0;
        [view_Schedule_ContentView[tag] addSubview:btn_Mon_Day];
        
        btn_Tue_Day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Tue_Day setTitle:@"TUES" forState:UIControlStateNormal];
        [btn_Tue_Day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Tue_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Tue_Day.frame = CGRectMake(61,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Tue_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Tue_Day.frame = CGRectMake(79,323,49, 49);//554
        }else{
            btn_Tue_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Tue_Day.frame = CGRectMake(71,292,45, 45);//554
        }
        btn_Tue_Day.userInteractionEnabled=NO;
        [btn_Tue_Day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Tue_Day.tag=1;
        [view_Schedule_ContentView[tag] addSubview:btn_Tue_Day];
        
        btn_Wed_Day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Wed_Day setTitle:@"WED" forState:UIControlStateNormal];
        [btn_Wed_Day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Wed_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Wed_Day.frame = CGRectMake(101,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Wed_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Wed_Day.frame = CGRectMake(131,323,49, 49);//554
        }else{
            btn_Wed_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Wed_Day.frame = CGRectMake(118,292,45, 45);//554
        }
        btn_Wed_Day.userInteractionEnabled=NO;
        [btn_Wed_Day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Wed_Day.tag=2;
        [view_Schedule_ContentView[tag] addSubview:btn_Wed_Day];
        
        btn_Turs_day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Turs_day setTitle:@"THURS" forState:UIControlStateNormal];
        [btn_Turs_day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Turs_day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Turs_day.frame = CGRectMake(141,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Turs_day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Turs_day.frame = CGRectMake(183,323,49, 49);//554
        }else{
            btn_Turs_day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Turs_day.frame = CGRectMake(165,292,45, 45);//554
        }
        btn_Turs_day.userInteractionEnabled=NO;
        [btn_Turs_day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Turs_day.tag=3;
        [view_Schedule_ContentView[tag] addSubview:btn_Turs_day];
        
        btn_Fri_Day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Fri_Day setTitle:@"FRI" forState:UIControlStateNormal];
        [btn_Fri_Day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Fri_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Fri_Day.frame = CGRectMake(181,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Fri_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Fri_Day.frame = CGRectMake(235,323,49, 49);//554
        }else{
            btn_Fri_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Fri_Day.frame = CGRectMake(212,292,45, 45);//554
        }
        btn_Fri_Day.userInteractionEnabled=NO;
        [btn_Fri_Day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Fri_Day.tag=4;
        [view_Schedule_ContentView[tag] addSubview:btn_Fri_Day];
        
        btn_Sat_Day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Sat_Day setTitle:@"SAT" forState:UIControlStateNormal];
        [btn_Sat_Day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Sat_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Sat_Day.frame = CGRectMake(221,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Sat_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Sat_Day.frame = CGRectMake(287,323,49, 49);//554
        }else{
            btn_Sat_Day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Sat_Day.frame = CGRectMake(259,292,45, 45);//554
        }
        btn_Sat_Day.userInteractionEnabled=NO;
        [btn_Sat_Day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Sat_Day.tag=5;
        [view_Schedule_ContentView[tag] addSubview:btn_Sat_Day];
        
        btn_Sun_day=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Sun_day setTitle:@"SUN" forState:UIControlStateNormal];
        [btn_Sun_day setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Sun_day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Sun_day.frame = CGRectMake(261,264,38, 38);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Sun_day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:12];
            btn_Sun_day.frame = CGRectMake(339,323,49, 49);//554
        }else{
            btn_Sun_day.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:10];
            btn_Sun_day.frame = CGRectMake(306,292,45, 45);//554
        }
        btn_Sun_day.userInteractionEnabled=NO;
        [btn_Sun_day addTarget:self action:@selector(day_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Sun_day.tag=6;
        [view_Schedule_ContentView[tag] addSubview:btn_Sun_day];
        
        
        UILabel *lblCaption_Months=[[UILabel alloc] initWithFrame:CGRectMake(68, 668, 600, 25)]; //649
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblCaption_Months.frame = CGRectMake(18,306,223, 16);//554
            lblCaption_Months.font = [UIFont fontWithName:@"NexaBold" size:7];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblCaption_Months.frame = CGRectMake(26,383,361, 16);//554
            lblCaption_Months.font = [UIFont fontWithName:@"NexaBold" size:11];
        }else{
            lblCaption_Months.frame = CGRectMake(23,344,284, 16);//554
            lblCaption_Months.font = [UIFont fontWithName:@"NexaBold" size:9];
        }
        lblCaption_Months.text = @"SELECT THE MONTHS YOU WISH YOUR DEVICE TO FUNCTION ON";
        lblCaption_Months.textColor = lblRGBA(98, 99, 102, 1);
        [view_Schedule_ContentView[tag] addSubview:lblCaption_Months];
        
        //632
        
        btn_Jan=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Jan setTitle:@"JAN" forState:UIControlStateNormal];
        [btn_Jan setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Jan.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Jan.frame = CGRectMake(18,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Jan.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Jan.frame = CGRectMake(27,405,28, 28);//554
        }else{
            btn_Jan.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Jan.frame = CGRectMake(24,367,26, 26);//554
        }
        [btn_Jan addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Jan.tag=0;
        [view_Schedule_ContentView[tag] addSubview:btn_Jan];
        
        btn_Feb=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Feb setTitle:@"FEB" forState:UIControlStateNormal];
        [btn_Feb setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Feb.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Feb.frame = CGRectMake(42,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Feb.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Feb.frame = CGRectMake(57,405,28, 28);//554
        }else{
            btn_Feb.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Feb.frame = CGRectMake(51,367,26, 26);//554
        }
        [btn_Feb addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Feb.tag=1;
        [view_Schedule_ContentView[tag] addSubview:btn_Feb];
        
        btn_Mar=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Mar setTitle:@"MAR" forState:UIControlStateNormal];
        [btn_Mar setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Mar.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Mar.frame = CGRectMake(66,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Mar.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Mar.frame = CGRectMake(87,405,28, 28);//554
        }else{
            btn_Mar.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Mar.frame = CGRectMake(78,367,26, 26);//554
        }
        [btn_Mar addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Mar.tag=2;
        [view_Schedule_ContentView[tag] addSubview:btn_Mar];
        
        btn_Apr=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Apr setTitle:@"APR" forState:UIControlStateNormal];
        [btn_Apr setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Apr.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Apr.frame = CGRectMake(90,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Apr.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Apr.frame = CGRectMake(117,405,28, 28);//554
        }else{
            btn_Apr.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Apr.frame = CGRectMake(105,367,26, 26);//554
        }
        [btn_Apr addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Apr.tag=3;
        [view_Schedule_ContentView[tag] addSubview:btn_Apr];
        
        btn_May=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_May setTitle:@"MAY" forState:UIControlStateNormal];
        [btn_May setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_May.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_May.frame = CGRectMake(114,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_May.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_May.frame = CGRectMake(147,405,28, 28);//554
        }else{
            btn_May.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_May.frame = CGRectMake(132,367,26, 26);//554
        }
        [btn_May addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_May.tag=4;
        [view_Schedule_ContentView[tag] addSubview:btn_May];
        
        btn_Jun=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Jun setTitle:@"JUN" forState:UIControlStateNormal];
        [btn_Jun setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Jun.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Jun.frame = CGRectMake(138,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Jun.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Jun.frame = CGRectMake(177,405,28, 28);//554
        }else{
            btn_Jun.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Jun.frame = CGRectMake(159,367,26, 26);//554
        }
        [btn_Jun addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Jun.tag=5;
        [view_Schedule_ContentView[tag] addSubview:btn_Jun];
        
        btn_July=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_July setTitle:@"JUL" forState:UIControlStateNormal];
        [btn_July setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_July.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_July.frame = CGRectMake(162,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_July.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_July.frame = CGRectMake(207,405,28, 28);//554
        }else{
            btn_July.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_July.frame = CGRectMake(186,367,26, 26);//554
        }
        [btn_July addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_July.tag=6;
        [view_Schedule_ContentView[tag] addSubview:btn_July];
        
        btn_Aug=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Aug setTitle:@"AUG" forState:UIControlStateNormal];
        [btn_Aug setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Aug.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Aug.frame = CGRectMake(186,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Aug.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Aug.frame = CGRectMake(237,405,28, 28);//554
        }else{
            btn_Aug.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Aug.frame = CGRectMake(213,367,26, 26);//554
        }
        [btn_Aug addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Aug.tag=7;
        [view_Schedule_ContentView[tag] addSubview:btn_Aug];
        
        btn_Sep=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Sep setTitle:@"SEP" forState:UIControlStateNormal];
        [btn_Sep setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Sep.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Sep.frame = CGRectMake(210,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Sep.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Sep.frame = CGRectMake(267,405,28, 28);//554
        }else{
            btn_Sep.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Sep.frame = CGRectMake(240,367,26, 26);//554
        }
        [btn_Sep addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Sep.tag=8;
        [view_Schedule_ContentView[tag] addSubview:btn_Sep];
        
        btn_Oct=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Oct setTitle:@"OCT" forState:UIControlStateNormal];
        [btn_Oct setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Oct.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Oct.frame = CGRectMake(234,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Oct.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Oct.frame = CGRectMake(297,405,28, 28);//554
        }else{
            btn_Oct.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Oct.frame = CGRectMake(268,367,26, 26);//554
        }
        [btn_Oct addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Oct.tag=9;
        [view_Schedule_ContentView[tag] addSubview:btn_Oct];
        
        btn_Nov=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Nov setTitle:@"NOV" forState:UIControlStateNormal];
        [btn_Nov setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Nov.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Nov.frame = CGRectMake(258,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Nov.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Nov.frame = CGRectMake(328,405,28, 28);//554
        }else{
            btn_Nov.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Nov.frame = CGRectMake(296,367,26, 26);//554
        }
        [btn_Nov addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Nov.tag=10;
        [view_Schedule_ContentView[tag] addSubview:btn_Nov];
        
        btn_Dec=[UIButton buttonWithType:UIButtonTypeSystem];
        [btn_Dec setTitle:@"DEC" forState:UIControlStateNormal];
        [btn_Dec setTitleColor:lblRGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_Dec.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:5];
            btn_Dec.frame = CGRectMake(282,324,22, 22);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_Dec.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:8];
            btn_Dec.frame = CGRectMake(359,405,28, 28);//554
        }else{
            btn_Dec.titleLabel.font=[UIFont fontWithName:@"NexaBold" size:7];
            btn_Dec.frame = CGRectMake(324,367,26, 26);//554
        }
        [btn_Dec addTarget:self action:@selector(month_Tapped_Update:) forControlEvents:UIControlEventTouchUpInside];
        btn_Dec.tag=11;
        [view_Schedule_ContentView[tag] addSubview:btn_Dec];
        
        
        //Delete Schedule
        UIView *viewDelete=[[UIView alloc] init]; //682
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewDelete.frame = CGRectMake(21,360,134, 64);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewDelete.frame = CGRectMake(27,448,174, 83);//554
        }else{
            viewDelete.frame = CGRectMake(24,407,157, 75);//554
        }
        viewDelete.backgroundColor=lblRGBA(211, 7, 25, 1);
        [view_Schedule_ContentView[tag] addSubview:viewDelete];
        
        UIImageView *tickImg_Del=[[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            tickImg_Del.frame = CGRectMake(52,8,24, 24);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            tickImg_Del.frame = CGRectMake(62,8,40, 40);//554
        }else{
            tickImg_Del.frame = CGRectMake(63,8,30, 30);//554
        }
        tickImg_Del.image=[UIImage imageNamed:@"cancelImagei6plus"];
        [viewDelete addSubview:tickImg_Del];
        
        
        UILabel *lbl_Delete=[[UILabel alloc] init];
        lbl_Delete.text = @"DELETE SCHEDULE";
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Delete.frame = CGRectMake(0,40,134, 15);//554
            lbl_Delete.font = [UIFont fontWithName:@"NexaBold" size:10];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Delete.frame = CGRectMake(0,60,174, 15);//554
            lbl_Delete.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else{
            lbl_Delete.frame = CGRectMake(0,49,157, 15);//554
            lbl_Delete.font = [UIFont fontWithName:@"NexaBold" size:11];
        }
        lbl_Delete.textColor = lblRGBA(255, 255, 255, 1);
        lbl_Delete.textAlignment=NSTextAlignmentCenter;
        [viewDelete addSubview:lbl_Delete];
        
        UIButton *btnDelete_Sch=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btnDelete_Sch.frame = CGRectMake(0,0,134, 64);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btnDelete_Sch.frame = CGRectMake(0,0,174, 83);//554
        }else{
            btnDelete_Sch.frame = CGRectMake(0,0,157, 75);//554
        }
        [btnDelete_Sch addTarget:self action:@selector(deleteSch_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete_Sch setTag:tag];
        [viewDelete addSubview:btnDelete_Sch];
        //End
        
        //Save Schedule
        UIView *viewSave=[[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            viewSave.frame = CGRectMake(164,360,134, 64);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewSave.frame = CGRectMake(212,448,174, 83);//554
        }else{
            viewSave.frame = CGRectMake(194,407,157, 75);//554
        }
        [view_Schedule_ContentView[tag] addSubview:viewSave];
        
        UIImageView *tickImg=[[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            tickImg.frame = CGRectMake(52,8,24, 24);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            tickImg.frame = CGRectMake(62,8,40, 40);//554
        }else{
            tickImg.frame = CGRectMake(63,8,30, 30);//554
        }
        tickImg.image=[UIImage imageNamed:@"proceedImagei6plus"];
        [viewSave addSubview:tickImg];
        
        UIButton *btnSave_Sch=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSave_Sch.frame = CGRectMake(0.0,0.0,311.0, 149.0);
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btnSave_Sch.frame = CGRectMake(0,0,134, 64);//554
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btnSave_Sch.frame = CGRectMake(0,0,174, 83);//554
        }else{
            btnSave_Sch.frame = CGRectMake(0,0,157, 75);//554
        }
        [btnSave_Sch addTarget:self action:@selector(saveSch_Tapped:) forControlEvents:UIControlEventTouchUpInside];
        [btnSave_Sch setTag:tag];
        [viewSave addSubview:btnSave_Sch];
        
        UILabel *lbl_Save=[[UILabel alloc] init];
        lbl_Save.text = @"SAVE SCHEDULE";
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_Save.frame = CGRectMake(0,40,134, 15);//554
            lbl_Save.font = [UIFont fontWithName:@"NexaBold" size:10];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_Save.frame = CGRectMake(0,60,174, 15);//554
            lbl_Save.font = [UIFont fontWithName:@"NexaBold" size:12];
        }else{
            lbl_Save.frame = CGRectMake(0,49,157, 15);//554
            lbl_Save.font = [UIFont fontWithName:@"NexaBold" size:11];
        }
        lbl_Save.textColor = lblRGBA(255, 255, 255, 1);
        lbl_Save.textAlignment=NSTextAlignmentCenter;
        [viewSave addSubview:lbl_Save];
        
        if([[dictGetSch_Content valueForKey:kOddDay] boolValue]||[[dictGetSch_Content valueForKey:kEvenDay] boolValue])
        {
            str_Schedule_Day_Type=@"RunOn";
            if([strDeviceType isEqualToString:@"lights"]){
                [switch_RunOn_Header setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
            }
            else if([strDeviceType isEqualToString:@"others"]){
                [switch_RunOn_Header setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
            }
            [switch_RunOn_Header setOn:YES animated:NO];
            [switch_RunOn_Header setSelected:YES];
            btnRunOn.userInteractionEnabled=YES;
            if([[dictGetSch_Content valueForKey:kOddDay] boolValue])
            {
                strOddDay=@"true";
                oddDays=YES;
                [switch_ODD_Days setOn:YES animated:NO];
                [switch_ODD_Days setSelected:YES];
                btnOdd.userInteractionEnabled=YES;
                if([strDeviceType isEqualToString:@"lights"]){
                    [switch_ODD_Days setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
                }
                else if([strDeviceType isEqualToString:@"others"]){
                    [switch_ODD_Days setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
                }
                //[switch_ODD_Days setThumbTintColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.000]];
            }else{
                strOddDay=@"false";
                oddDays=NO;
            }
            if([[dictGetSch_Content valueForKey:kEvenDay] boolValue])
            {
                strEvenDay=@"true";
                evenDays=YES;
                [switch_Even_Days setOn:YES animated:NO];
                [switch_Even_Days setSelected:YES];
                btnEven.userInteractionEnabled=YES;
                if([strDeviceType isEqualToString:@"lights"]){
                    [switch_Even_Days setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
                }
                else if([strDeviceType isEqualToString:@"others"]){
                    [switch_Even_Days setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
                }
                // [switch_Even_Days setThumbTintColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.000]];
            }else{
                strEvenDay=@"false";
                evenDays=NO;
            }
            [self runOnEnabled_DaysDisable];
        }else{
            btn_Sun_day.userInteractionEnabled=YES;
            btn_Mon_Day.userInteractionEnabled=YES;
            btn_Tue_Day.userInteractionEnabled=YES;
            btn_Wed_Day.userInteractionEnabled=YES;
            btn_Turs_day.userInteractionEnabled=YES;
            btn_Fri_Day.userInteractionEnabled=YES;
            btn_Sat_Day.userInteractionEnabled=YES;
            strOddDay=@"false";
            strEvenDay=@"false";
            oddDays=NO,evenDays=NO;
            str_Schedule_Day_Type=@"ManualDays";
            if([[dictGetSch_Content valueForKey:kSun] boolValue])
            {
                daySun=YES;
                strSun=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Sun_day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Sun_day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
                
            }else{
                daySun=NO;
                strSun=@"false";
                btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
            if([[dictGetSch_Content valueForKey:kMon] boolValue])
            {
                dayMon=YES;
                strMon=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Mon_Day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Mon_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }else{
                dayMon=NO;
                strMon=@"false";
                btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
            if([[dictGetSch_Content valueForKey:kTue] boolValue])
            {
                dayTus=YES;
                strTue=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Tue_Day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Tue_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
                
            }else{
                dayTus=NO;
                strTue=@"false";
                btn_Tue_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
            if([[dictGetSch_Content valueForKey:kWed] boolValue])
            {
                dayWed=YES;
                strWed=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Wed_Day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Wed_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }else{
                dayWed=NO;
                strWed=@"false";
                btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
            if([[dictGetSch_Content valueForKey:kThr] boolValue])
            {
                dayThurs=YES;
                strThr=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Turs_day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Turs_day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }else{
                dayThurs=NO;
                strThr=@"false";
                btn_Turs_day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
            if([[dictGetSch_Content valueForKey:kFri] boolValue])
            {
                dayFri=YES;
                strFri=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Fri_Day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Fri_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }else{
                dayFri=NO;
                strFri=@"false";
                btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
            if([[dictGetSch_Content valueForKey:kSat] boolValue])
            {
                daySat=YES;
                strSat=@"true";
                if([strDeviceType isEqualToString:@"others"]){
                    btn_Sat_Day.backgroundColor=lblRGBA(49,165, 222, 1);
                }else{
                    btn_Sat_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
                
            }else{
                daySat=NO;
                strSat=@"false";
                btn_Sat_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }
        }
        
        
        
        str_Schedule_Month=@"Month";
        if([[dictGetSch_Content valueForKey:kJan] boolValue])
        {
            
            monJan=YES;
            strJan=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Jan.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Jan.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monJan=NO;
            strJan=@"false";
            btn_Jan.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kFeb] boolValue])
        {
            monFeb=YES;
            strFeb=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Feb.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Feb.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monFeb=NO;
            strFeb=@"false";
            btn_Feb.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kMar] boolValue])
        {
            monMar=YES;
            strMar=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Mar.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Mar.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monMar=NO;
            strMar=@"false";
            btn_Mar.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kApr] boolValue])
        {
            monApr=YES;
            strApr=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Apr.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Apr.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monApr=NO;
            strApr=@"false";
            btn_Apr.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kMay] boolValue])
        {
            monMay=YES;
            strMay=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_May.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_May.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monMay=NO;
            strMay=@"false";
            btn_May.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kJun] boolValue])
        {
            monJun=YES;
            strJun=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Jun.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Jun.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monJun=NO;
            strJun=@"false";
            btn_Jun.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kJly] boolValue])
        {
            monJly=YES;
            strJly=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_July.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_July.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monJly=NO;
            strJly=@"false";
            btn_July.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kAug] boolValue])
        {
            monAug=YES;
            strAug=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Aug.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Aug.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monAug=NO;
            strAug=@"false";
            btn_Aug.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kSep] boolValue])
        {
            monSep=YES;
            strSep=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Sep.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Sep.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monSep=NO;
            strSep=@"false";
            btn_Sep.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kOct] boolValue])
        {
            monOct=YES;
            strOct=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Oct.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Oct.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monOct=NO;
            strOct=@"false";
            btn_Oct.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kNov] boolValue])
        {
            monNov=YES;
            strNov=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Nov.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Nov.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monNov=NO;
            strNov=@"false";
            btn_Nov.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([[dictGetSch_Content valueForKey:kDec] boolValue])
        {
            monDec=YES;
            strDec=@"true";
            if([strDeviceType isEqualToString:@"others"]){
                btn_Dec.backgroundColor=lblRGBA(49,165, 222, 1);
            }else{
                btn_Dec.backgroundColor=lblRGBA(255, 206, 52, 1);
            }
            
        }else{
            monDec=NO;
            strDec=@"false";
            btn_Dec.backgroundColor=lblRGBA(98, 99, 102, 1);
        }
        
        if([strDeviceType isEqualToString:@"others"]){
            lblDusk_View.textColor =lblRGBA(49,165, 222, 1);
            lblDawn_View.textColor =lblRGBA(49,165, 222, 1);
            viewSave.backgroundColor=lblRGBA(49,165, 222, 1);
        }else{
            lblDusk_View.textColor = lblRGBA(255, 206, 52, 1);
            lblDawn_View.textColor = lblRGBA(255, 206, 52, 1);
            viewSave.backgroundColor = lblRGBA(255, 206, 52, 1);
        }
        
        /*
         id 5 - custom time or Timing based Schedule,
         id 4 - Dusk Schedule,
         id 3 - Dawn Schedule,
         id 2 - Dusk to Dawn Schedule,
         id 1 - Dawn to Dusk Schedule
         */
        NSLog(@"sch category ==%@",[dictGetSch_Content valueForKey:kScheduleCategoryID]);
        if([[dictGetSch_Content valueForKey:kScheduleCategoryID] isEqualToString:@"1"])
        {
            [btn_StartTime setTitle:@"00:00AM" forState:UIControlStateNormal];
            [btn_EndTime setTitle:@"00:00PM" forState:UIControlStateNormal];
            dawnSwitch_Stngs.enabled=YES;
            strSelecteCategoryID=@"1";//[[dictGetSch_Content valueForKey:kScheduleCategoryID] stringValue];
            startTime=[dictGetSch_Content valueForKey:kStartTime];
            endTime=[dictGetSch_Content valueForKey:kEndTime];
            
            [dawnSwitch_Stngs setOn:YES animated:NO];
            [dawnSwitch_Stngs setSelected:YES];
            if([strDeviceType isEqualToString:@"lights"]){
                [dawnSwitch_Stngs setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
            }
            else if([strDeviceType isEqualToString:@"others"]){
                [dawnSwitch_Stngs setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
            }
            btn_StartTime.userInteractionEnabled=NO;
            btn_EndTime.userInteractionEnabled=NO;
            btnDawnDuskStng.userInteractionEnabled=YES;
        }
        else if([[dictGetSch_Content valueForKey:kScheduleCategoryID]  isEqualToString:@"2"])
        {
            [btn_StartTime setTitle:@"00:00AM" forState:UIControlStateNormal];
            [btn_EndTime setTitle:@"00:00PM" forState:UIControlStateNormal];
            duskSwitch_Stngs.enabled=YES;
            strSelecteCategoryID=@"2";//[[dictGetSch_Content valueForKey:kScheduleCategoryID] stringValue];
            startTime=[dictGetSch_Content valueForKey:kStartTime];
            endTime=[dictGetSch_Content valueForKey:kEndTime];
            [duskSwitch_Stngs setOn:YES animated:NO];
            [duskSwitch_Stngs setSelected:YES];
            if([strDeviceType isEqualToString:@"lights"]){
                [duskSwitch_Stngs setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
            }
            else if([strDeviceType isEqualToString:@"others"]){
                [duskSwitch_Stngs setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
            }
            btn_StartTime.userInteractionEnabled=NO;
            btn_EndTime.userInteractionEnabled=NO;
            btnDuskDawnStng.userInteractionEnabled=YES;
        }
        else if([[dictGetSch_Content valueForKey:kScheduleCategoryID] isEqualToString:@"3"])
        {
            NSArray *arrTime;
            NSString *strDAWNStatus;
            if(![[dictGetSch_Content valueForKey:kStartTime] isEqualToString:@"00:00:00"])
            {
                arrTime = [[dictGetSch_Content valueForKey:kStartTime] componentsSeparatedByString: @":"];
                strDAWNStatus=@"DAWNMINUS";
            }else if(![[dictGetSch_Content valueForKey:kEndTime] isEqualToString:@"00:00:00"])
            {
                arrTime = [[dictGetSch_Content valueForKey:kEndTime] componentsSeparatedByString: @":"];
                strDAWNStatus=@"DAWNPLUS";
            }
            if([arrTime count]>0)
            {
                NSString *firstBit = [arrTime objectAtIndex:0];
                if([firstBit isEqualToString:@"01"]||[firstBit isEqualToString:@"1"])
                {
                    if ([firstBit hasPrefix:@"0"] && [firstBit length] > 1) {
                        firstBit = [firstBit substringFromIndex:1];
                    }
                    lblDawnHours_View.text=[NSString stringWithFormat:@"%@ HOUR",firstBit];
                }else{
                    if ([firstBit hasPrefix:@"0"] && [firstBit length] > 1) {
                        firstBit = [firstBit substringFromIndex:1];
                    }
                    lblDawnHours_View.text=[NSString stringWithFormat:@"%@ HOURS",firstBit];
                }
                if([strDAWNStatus isEqualToString:@"DAWNPLUS"]){
                    intDawnPlusHrs=[firstBit intValue];
                    intDawnMinusHrs=0;
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dawn_Plus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dawn_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                }else{
                    intDawnMinusHrs=[firstBit intValue];
                    intDawnPlusHrs=0;
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dawn_Minus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dawn_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                }
            }
            NSLog(@"dawn plus =%d",intDawnPlusHrs);
            NSLog(@"dawn minus =%d",intDawnMinusHrs);
            [btn_StartTime setTitle:@"00:00AM" forState:UIControlStateNormal];
            [btn_EndTime setTitle:@"00:00PM" forState:UIControlStateNormal];
            dawnSwitch_DawnView.enabled=YES;
            btn_Dawn_Plus.userInteractionEnabled=YES;
            btn_Dawn_Minus.userInteractionEnabled=YES;
            strSelecteCategoryID=@"3";//[[dictGetSch_Content valueForKey:kScheduleCategoryID] stringValue];
            startTime=[dictGetSch_Content valueForKey:kStartTime];
            endTime=[dictGetSch_Content valueForKey:kEndTime];
            [dawnSwitch_DawnView setOn:YES animated:NO];
            [dawnSwitch_DawnView setSelected:YES];
            if([strDeviceType isEqualToString:@"lights"]){
                [dawnSwitch_DawnView setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
            }
            else if([strDeviceType isEqualToString:@"others"]){
                [dawnSwitch_DawnView setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
            }
            btn_StartTime.userInteractionEnabled=NO;
            btn_EndTime.userInteractionEnabled=NO;
            btnDawn.userInteractionEnabled=YES;
        }
        else if([[dictGetSch_Content valueForKey:kScheduleCategoryID] isEqualToString:@"4"])
        {
            NSArray *arrTime;
            NSString *strDAWNStatus;
            if(![[dictGetSch_Content valueForKey:kStartTime] isEqualToString:@"00:00:00"])
            {
                arrTime = [[dictGetSch_Content valueForKey:kStartTime] componentsSeparatedByString: @":"];
                strDAWNStatus=@"DUSKMINUS";
            }else if(![[dictGetSch_Content valueForKey:kEndTime] isEqualToString:@"00:00:00"])
            {
                arrTime = [[dictGetSch_Content valueForKey:kEndTime] componentsSeparatedByString: @":"];
                strDAWNStatus=@"DUSKPLUS";
            }
            if([arrTime count]>0)
            {
                NSString *firstBit = [arrTime objectAtIndex:0];
                if([firstBit isEqualToString:@"01"]||[firstBit isEqualToString:@"1"])
                {
                    if ([firstBit hasPrefix:@"0"] && [firstBit length] > 1) {
                        firstBit = [firstBit substringFromIndex:1];
                    }
                    lblDuskHours_View.text=[NSString stringWithFormat:@"%@ HOUR",firstBit];
                }else{
                    if ([firstBit hasPrefix:@"0"] && [firstBit length] > 1) {
                        firstBit = [firstBit substringFromIndex:1];
                    }
                    lblDuskHours_View.text=[NSString stringWithFormat:@"%@ HOURS",firstBit];
                }
                if([strDAWNStatus isEqualToString:@"DUSKPLUS"]){
                    intDuskPlusHrs=[firstBit intValue];
                    intDuskMinusHrs=0;
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dusk_Plus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dusk_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                }else{
                    intDuskMinusHrs=[firstBit intValue];
                    intDuskPlusHrs=0;
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dusk_Minus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dusk_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    }
                }
            }
            
            
            [btn_StartTime setTitle:@"00:00AM" forState:UIControlStateNormal];
            [btn_EndTime setTitle:@"00:00PM" forState:UIControlStateNormal];
            duskSwitch_DuskView.enabled=YES;
            btn_Dusk_Plus.userInteractionEnabled=YES;
            btn_Dusk_Minus.userInteractionEnabled=YES;
            strSelecteCategoryID=@"4";//[[dictGetSch_Content valueForKey:kScheduleCategoryID] stringValue];
            startTime=[dictGetSch_Content valueForKey:kStartTime];
            endTime=[dictGetSch_Content valueForKey:kEndTime];
            [duskSwitch_DuskView setOn:YES animated:NO];
            [duskSwitch_DuskView setSelected:YES];
            if([strDeviceType isEqualToString:@"lights"]){
                [duskSwitch_DuskView setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
            }
            else if([strDeviceType isEqualToString:@"others"]){
                [duskSwitch_DuskView setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
            }
            btn_StartTime.userInteractionEnabled=NO;
            btn_EndTime.userInteractionEnabled=NO;
            btnDusk.userInteractionEnabled=YES;
        }
        else{
            hour=1;
            hours=1;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm:ss";
            NSDate *date = [dateFormatter dateFromString:[dictGetSch_Content valueForKey:kStartTime]];
            NSDate *enddate = [dateFormatter dateFromString:[dictGetSch_Content valueForKey:kEndTime]];
            dateFormatter.dateFormat = @"hh:mm a";
            // lblTime_View.text = [dateFormatter stringFromDate:date];
            [btn_StartTime setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
            [btn_EndTime setTitle:[dateFormatter stringFromDate:enddate] forState:UIControlStateNormal];
            switchTime.enabled=YES;
            strSelecteCategoryID=@"5";//[[dictGetSch_Content valueForKey:kScheduleCategoryID] stringValue];
            startTime=[dictGetSch_Content valueForKey:kStartTime];
            endTime=[dictGetSch_Content valueForKey:kEndTime];
            formatedDateFrom=startTime;
            formatedDateTo=endTime;
            [switchTime setOn:YES animated:NO];
            [switchTime setSelected:YES];
            if([strDeviceType isEqualToString:@"lights"]){
                [switchTime setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
            }
            else if([strDeviceType isEqualToString:@"others"]){
                [switchTime setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
            }
            btn_StartTime.userInteractionEnabled=YES;
            btn_EndTime.userInteractionEnabled=YES;
            btnManual.userInteractionEnabled=YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception draw Contentview ==%@",exception.description);
    }
    [self stop_PinWheel_DeviceDetails];
}

-(void)timePickerUpdate:(UIButton *)sender
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    NSLog(@" tag value is ==%ld",(long)sender.tag);
//    hour=1;
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Start Time
        {
            timerType=@"From";
            [self.lightsContainerView setUserInteractionEnabled:NO];
            [self.lightsContainerView setAlpha:0.4];
            [self.lightTabView setUserInteractionEnabled:NO];
            [self.lightTabView setAlpha:0.4];
            [UIView animateWithDuration:.25 animations:^{
                pickerView .frame=CGRectMake(0, self.view.frame.size.height-pickerView.frame.size.height+20, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
            
        }
            break;
        case 1: //End Time
        {
            timerType=@"To";
            [self.lightsContainerView setUserInteractionEnabled:NO];
            [self.lightsContainerView setAlpha:0.4];
            [self.lightTabView setUserInteractionEnabled:NO];
            [self.lightTabView setAlpha:0.4];
            [UIView animateWithDuration:.25 animations:^{
                pickerView .frame=CGRectMake(0, self.view.frame.size.height-pickerView.frame.size.height+20, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
        }
            break;
    }
}
-(void)dusk_Dawn_Increment_Dec_Action:(UIButton *)sender
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }

    NSLog(@"start time = %@ and end time = %@",startTime,endTime);
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //DAWN PLUS
        {
            NSLog(@"dawnplushrs=%d",intDawnPlusHrs);
            NSLog(@"dawnminushrs=%d",intDawnMinusHrs);
            
            if (intDawnMinusHrs<=23 && intDawnMinusHrs!=0){
                if(incDawnStatus==YES){
                    intDawnPlusHrs=intDawnPlusHrs+1;
                    intDawnMinusHrs=0;
                }else{
                    intDawnPlusHrs = intDawnMinusHrs-1;
                    intDawnMinusHrs = intDawnPlusHrs;
                }
                if (intDawnPlusHrs==0) {
                    btn_Dawn_Plus.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_Dawn_Minus.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }
            else if (intDawnPlusHrs<23 || intDawnPlusHrs==0)
            {
                intDawnPlusHrs = intDawnPlusHrs+1;
                incDawnStatus=YES;
                decDawnStatus=NO;
                if(intDawnMinusHrs==0&&decDawnStatus==NO){
                    // btn_Dawn_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dawn_Plus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dawn_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                        
                    }
                }
            }
            else if(intDawnPlusHrs>=23) {
                incDawnStatus=YES;
                decDawnStatus=NO;
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Dawn_Plus.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Dawn_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    
                }
                // btn_Dawn_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                return;
            }
            
            if (intDawnPlusHrs<=1) {
                lblDawnHours_View.text = [NSString stringWithFormat:@"%d HOUR",intDawnPlusHrs];
               // startTime=[NSString stringWithFormat:@"00:00:00"];
            }else{
                lblDawnHours_View.text = [NSString stringWithFormat:@"%d HOURS",intDawnPlusHrs];
               // startTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnPlusHrs];
//            if(stringToHours.length>1)
//            {
//                endTime=[NSString stringWithFormat:@"%d:00:00",intDawnPlusHrs];
//                
//            }else{
//                endTime=[NSString stringWithFormat:@"0%d:00:00",intDawnPlusHrs];
//            }
        }
            //[self dawn_dusk_Time_Disable];
            
            break;
        case 1:  //DAWN MINUS
        {
            if (intDawnPlusHrs<=23 && intDawnPlusHrs!=0) {
                if(decDawnStatus==YES){
                    intDawnMinusHrs=intDawnMinusHrs+1;
                    intDawnPlusHrs=0;
                }else{
                    intDawnMinusHrs = intDawnPlusHrs-1;
                    intDawnPlusHrs = intDawnMinusHrs;
                }
                //  btn_DawnPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                if (intDawnMinusHrs==0) {
                    btn_Dawn_Minus.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_Dawn_Plus.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }else if (intDawnMinusHrs==0 || intDawnMinusHrs<23) {
                incDawnStatus=NO;
                decDawnStatus=YES;
                intDawnMinusHrs = intDawnMinusHrs+1;
                if(intDawnPlusHrs==0&&incDawnStatus==NO){
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dawn_Minus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dawn_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                        
                    }
                    // btn_Dawn_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
            }else if (intDawnMinusHrs>=23){
                incDawnStatus=NO;
                decDawnStatus=YES;
                //  btn_Dawn_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Dawn_Minus.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Dawn_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    
                }
                return;
            }
            
            if (intDawnMinusHrs<=1) {
                lblDawnHours_View.text = [NSString stringWithFormat:@"%d HOUR",intDawnMinusHrs];
               // endTime=[NSString stringWithFormat:@"00:00:00"];
            }else{
                lblDawnHours_View.text = [NSString stringWithFormat:@"%d HOURS",intDawnMinusHrs];
               // endTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnMinusHrs];
//            if(stringToHours.length>1)
//            {
//                startTime=[NSString stringWithFormat:@"%d:00:00",intDawnMinusHrs];
//            }else{
//                startTime=[NSString stringWithFormat:@"0%d:00:00",intDawnMinusHrs];
//            }
        }
            //  [self dawn_dusk_Time_Disable];
            
            break;
        case 2:  //DUSK PLUS
        {
            NSLog(@"duskplushrs=%d",intDuskPlusHrs);
            NSLog(@"duskminushrs=%d",intDuskMinusHrs);
            
            if (intDuskMinusHrs<=23 && intDuskMinusHrs!=0){
                if(incDuskStatus==YES){
                    intDuskPlusHrs=intDuskPlusHrs+1;
                    intDuskMinusHrs=0;
                }else{
                    intDuskPlusHrs = intDuskMinusHrs-1;
                    intDuskMinusHrs = intDuskPlusHrs;
                }
                if (intDuskPlusHrs==0) {
                    btn_Dusk_Plus.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_Dusk_Minus.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }
            else if (intDuskPlusHrs<23 || intDuskPlusHrs==0)
            {
                intDuskPlusHrs = intDuskPlusHrs+1;
                incDuskStatus=YES;
                decDuskStatus=NO;
                if(intDuskMinusHrs==0&&decDuskStatus==NO){
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dusk_Plus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dusk_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                        
                    }
                    // btn_Dusk_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
            }
            else if(intDuskPlusHrs>=23) {
                incDuskStatus=YES;
                decDuskStatus=NO;
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Dusk_Plus.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Dusk_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    
                }
                //btn_Dusk_Plus.backgroundColor = lblRGBA(255, 206, 52, 1);
                return;
            }
            
            if (intDuskPlusHrs<=1) {
                lblDuskHours_View.text = [NSString stringWithFormat:@"%d HOUR",intDuskPlusHrs];
              //  startTime=[NSString stringWithFormat:@"00:00:00"];
            }else{
                lblDuskHours_View.text = [NSString stringWithFormat:@"%d HOURS",intDuskPlusHrs];
                //startTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskPlusHrs];
//            if(stringToHours.length>1)
//            {
//                endTime=[NSString stringWithFormat:@"%d:00:00",intDuskPlusHrs];
//            }else{
//                endTime=[NSString stringWithFormat:@"0%d:00:00",intDuskPlusHrs];
//            }
        }
            break;
        case 3:  //DUSK MINUS
        {
            if (intDuskPlusHrs<=23 && intDuskPlusHrs!=0) {
                if(decDuskStatus==YES){
                    intDuskMinusHrs=intDuskMinusHrs+1;
                    intDuskPlusHrs=0;
                }else{
                    intDuskMinusHrs = intDuskPlusHrs-1;
                    intDuskPlusHrs = intDuskMinusHrs;
                }
                //  btn_DawnPlus_Schedule.backgroundColor = lblRGBA(255, 206, 52, 1);
                if (intDuskMinusHrs==0) {
                    btn_Dusk_Plus.backgroundColor = lblRGBA(98, 99, 102, 1);
                    btn_Dusk_Minus.backgroundColor = lblRGBA(98, 99, 102, 1);
                }
            }else if (intDuskMinusHrs==0 || intDuskMinusHrs<23) {
                incDuskStatus=NO;
                decDuskStatus=YES;
                intDuskMinusHrs = intDuskMinusHrs+1;
                if(intDuskPlusHrs==0&&incDuskStatus==NO){
                    if ([strDeviceType isEqualToString:@"others"]) {
                        btn_Dusk_Minus.backgroundColor = lblRGBA(49, 165, 222, 1);
                    }else{
                        btn_Dusk_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                        
                    }
                    //btn_Dusk_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                }
            }else if (intDuskMinusHrs>=23){
                incDuskStatus=NO;
                decDuskStatus=YES;
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Dusk_Minus.backgroundColor = lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Dusk_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                    
                }
                // btn_Dusk_Minus.backgroundColor = lblRGBA(255, 206, 52, 1);
                return;
            }
            
            if (intDuskMinusHrs<=1) {
                lblDuskHours_View.text = [NSString stringWithFormat:@"%d HOUR",intDuskMinusHrs];
               // endTime=[NSString stringWithFormat:@"00:00:00"];
            }else{
                lblDuskHours_View.text = [NSString stringWithFormat:@"%d HOURS",intDuskMinusHrs];
               // endTime=[NSString stringWithFormat:@"00:00:00"];
            }
//            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskMinusHrs];
//            if(stringToHours.length>1)
//            {
//                startTime=[NSString stringWithFormat:@"%d:00:00",intDuskMinusHrs];
//            }else{
//                startTime=[NSString stringWithFormat:@"0%d:00:00",intDuskMinusHrs];
//            }
        }
            break;
            
    }
}


-(void)day_Tapped_Update:(UIButton *)sender{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    NSLog(@" tag value is ==%ld",(long)sender.tag);
    switch (sender.tag) {
        case 0:
        {
            if(dayMon==YES){
                dayMon=NO;
                strMon=@"false";
                btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayMon=YES;
                strMon=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Mon_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Mon_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 1:
        {
            if(dayTus==YES){
                dayTus=NO;
                strTue=@"false";
                btn_Tue_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayTus=YES;
                strTue=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Tue_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Tue_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 2:
        {
            if(dayWed==YES){
                dayWed=NO;
                strWed=@"false";
                btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayWed=YES;
                strWed=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Wed_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Wed_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 3:
        {
            if(dayThurs==YES){
                dayThurs=NO;
                strThr=@"false";
                btn_Turs_day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayThurs=YES;
                strThr=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Turs_day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Turs_day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 4:
        {
            if(dayFri==YES){
                dayFri=NO;
                strFri=@"false";
                btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                dayFri=YES;
                strFri=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Fri_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Fri_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 5:
        {
            if(daySat==YES){
                daySat=NO;
                strSat=@"false";
                btn_Sat_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                daySat=YES;
                strSat=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Sat_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Sat_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 6:
        {
            if(daySun==YES){
                daySun=NO;
                strSun=@"false";
                btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                daySun=YES;
                strSun=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Sun_day.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Sun_day.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
    }
    if (dayMon==YES || dayTus==YES || dayWed==YES || dayThurs==YES || dayFri==YES || daySat==YES || daySun==YES) {
        str_Schedule_Day_Type=@"ManualDays";
    }else {
        str_Schedule_Day_Type=@"";
    }
}
-(void)month_Tapped_Update:(UIButton *)sender{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    NSLog(@" tag value is ==%ld",(long)sender.tag);
    switch(sender.tag){
        case 0:
        {
            if(monJan==YES){
                monJan=NO;
                strJan=@"false";
                btn_Jan.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monJan=YES;
                strJan=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Jan.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Jan.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
            
        }
            break;
        case 1:
        {
            if(monFeb==YES){
                monFeb=NO;
                strFeb=@"false";
                btn_Feb.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monFeb=YES;
                strFeb=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Feb.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Feb.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 2:
        {
            if(monMar==YES){
                monMar=NO;
                strMar=@"false";
                btn_Mar.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monMar=YES;
                strMar=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Mar.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Mar.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 3:
        {
            if(monApr==YES){
                monApr=NO;
                strApr=@"false";
                btn_Apr.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monApr=YES;
                strApr=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Apr.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Apr.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 4:
        {
            if(monMay==YES){
                monMay=NO;
                strMay=@"false";
                btn_May.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monMay=YES;
                strMay=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_May.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_May.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 5:
        {
            if(monJun==YES){
                monJun=NO;
                strJun=@"false";
                btn_Jun.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monJun=YES;
                strJun=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Jun.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Jun.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 6:
        {
            if(monJly==YES){
                monJly=NO;
                strJly=@"false";
                btn_July.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monJly=YES;
                strJly=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_July.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_July.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 7:
        {
            if(monAug==YES){
                monAug=NO;
                strAug=@"false";
                btn_Aug.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monAug=YES;
                strAug=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Aug.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Aug.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 8:
        {
            if(monSep==YES){
                monSep=NO;
                strSep=@"false";
                btn_Sep.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monSep=YES;
                strSep=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Sep.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Sep.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 9:
        {
            if(monOct==YES){
                monOct=NO;
                strOct=@"false";
                btn_Oct.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monOct=YES;
                strOct=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Oct.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Oct.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 10:
        {
            if(monNov==YES){
                monNov=NO;
                strNov=@"false";
                btn_Nov.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monNov=YES;
                strNov=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Nov.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Nov.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
        case 11:
        {
            if(monDec==YES){
                monDec=NO;
                strDec=@"false";
                btn_Dec.backgroundColor=lblRGBA(98, 99, 102, 1);
            }else{
                monDec=YES;
                strDec=@"true";
                if ([strDeviceType isEqualToString:@"others"]) {
                    btn_Dec.backgroundColor=lblRGBA(49, 165, 222, 1);
                }else{
                    btn_Dec.backgroundColor=lblRGBA(255, 206, 52, 1);
                }
            }
        }
            break;
    }
    if (monJan==YES || monFeb==YES || monMar==YES || monApr==YES || monMay==YES || monJun==YES || monJly==YES || monAug==YES || monSep==YES || monOct==YES || monNov==YES || monDec==YES) {
        str_Schedule_Month=@"Month";
    }else{
        str_Schedule_Month=@"";
    }
}

-(void)runOnEnabled_DaysDisable
{
    //switch_RunOn_Header.enabled=YES;
    switch_ODD_Days.enabled=YES;
    switch_Even_Days.enabled=YES;
    btn_Sun_day.userInteractionEnabled=NO;
    btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Mon_Day.userInteractionEnabled=NO;
    btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Tue_Day.userInteractionEnabled=NO;
    btn_Tue_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Wed_Day.userInteractionEnabled=NO;
    btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Turs_day.userInteractionEnabled=NO;
    btn_Turs_day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Fri_Day.userInteractionEnabled=NO;
    btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Sat_Day.userInteractionEnabled=NO;
    btn_Sat_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    viewSchedule_RunON_Header.userInteractionEnabled=YES;
    viewSchedule_RunON_Header.alpha=1.0;
    strSun=@"false",strMon=@"false",strTue=@"false",strThr=@"false",strFri=@"false",strSat=@"false", strWed=@"false";
    dayMon=NO,dayTus=NO,dayWed=NO,dayThurs=NO,dayFri=NO,daySat=NO,daySun=NO;
}

-(void)runOnDisabled_DaysEnabled
{
    // switch_RunOn_Header.enabled=NO;
    switch_ODD_Days.enabled=NO;
    switch_Even_Days.enabled=NO;
    [switch_ODD_Days setOn:NO animated:NO];
    [switch_Even_Days setOn:NO animated:NO];
    btn_Sun_day.userInteractionEnabled=YES;
    btn_Mon_Day.userInteractionEnabled=YES;
    btn_Tue_Day.userInteractionEnabled=YES;
    btn_Wed_Day.userInteractionEnabled=YES;
    btn_Turs_day.userInteractionEnabled=YES;
    btn_Fri_Day.userInteractionEnabled=YES;
    btn_Sat_Day.userInteractionEnabled=YES;
    viewSchedule_RunON_Header.userInteractionEnabled=NO;
    viewSchedule_RunON_Header.alpha=0.4;
    oddDays=NO,evenDays=NO;
    strOddDay=@"false";
    strEvenDay=@"false";
    if ([self.strDeviceType isEqualToString:@"others"])
    {
        btn_Mon_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Tue_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Wed_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Turs_day.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Fri_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sat_Day.backgroundColor=lblRGBA(49, 165, 222, 1);
        btn_Sun_day.backgroundColor=lblRGBA(49, 165, 222, 1);
    }else{
        btn_Mon_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Tue_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Wed_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Turs_day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Fri_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Sat_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Sun_day.backgroundColor=lblRGBA(255, 206, 52, 1);
    }
    
    str_Schedule_Day_Type=@"ManualDays";
    strSun=@"true",strMon=@"true",strTue=@"true",strThr=@"true",strFri=@"true",strSat=@"true",strWed=@"true";
    dayMon=YES,dayTus=YES,dayWed=YES,dayThurs=YES,dayFri=YES,daySat=YES,daySun=YES;
}

//Dusk To Dawn
- (void)duskToggledSettings:(UISwitch *)twistedSwitch
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    //UISwitch *switchTag=(UISwitch *)sender;
    if([twistedSwitch isOn] && (![twistedSwitch isSelected]))
    {
        NSLog(@"Switch is ON");
        strSelecteCategoryID=@"2";
        [self dawn_dusk_switch_Disable_Updte];
        duskSwitch_Stngs.enabled=YES;
        [duskSwitch_Stngs setOn:YES animated:YES];
        [duskSwitch_Stngs setSelected:YES];
        if([strDeviceType isEqualToString:@"lights"]){
            [duskSwitch_Stngs setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }
        else if([strDeviceType isEqualToString:@"others"]){
            [duskSwitch_Stngs setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected])
    {
        NSLog(@"Switch is OFF");
        strSelecteCategoryID=@"0";
        [duskSwitch_Stngs setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [self dawn_dusk_switch_Enable_Update];
        [duskSwitch_Stngs setSelected:NO];
    }
    
}

//Dawn To Dusk
- (void)dawnToggledSettings:(UISwitch *)twistedSwitch
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        strSelecteCategoryID=@"1";
        [self dawn_dusk_switch_Disable_Updte];
        dawnSwitch_Stngs.enabled=YES;
        [dawnSwitch_Stngs setOn:YES animated:YES];
        [dawnSwitch_Stngs setSelected:YES];
        if([strDeviceType isEqualToString:@"lights"]){
            [dawnSwitch_Stngs setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }
        else if([strDeviceType isEqualToString:@"others"]){
            [dawnSwitch_Stngs setOnTintColor:[UIColor colorWithRed:40.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        strSelecteCategoryID=@"0";
        [dawnSwitch_Stngs setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [self dawn_dusk_switch_Enable_Update];
        [dawnSwitch_Stngs setSelected:NO];
    }
    
}
//Dusk
- (void)dusk_ViewToggledSettings:(UISwitch *)twistedSwitch
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        strSelecteCategoryID=@"4";
        [self dawn_dusk_switch_Disable_Updte];
        duskSwitch_DuskView.enabled=YES;
        [duskSwitch_DuskView setOn:YES animated:YES];
        [duskSwitch_DuskView setSelected:YES];
        btn_Dusk_Minus.userInteractionEnabled=YES;
        btn_Dusk_Plus.userInteractionEnabled=YES;
        
        if([strDeviceType isEqualToString:@"lights"]){
            [duskSwitch_DuskView setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }
        else if([strDeviceType isEqualToString:@"others"]){
            [duskSwitch_DuskView setOnTintColor:[UIColor colorWithRed:40.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        strSelecteCategoryID=@"0";
        //startTime=@"00:00:00";
        // endTime=@"00:00:00";
        [duskSwitch_DuskView setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [self dawn_dusk_switch_Enable_Update];
        [duskSwitch_DuskView setSelected:NO];
    }
    
}
//DAWN
-(void)dawn_ViewToggledSettings:(UISwitch *)twistedSwitch
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        strSelecteCategoryID=@"3";
        [self dawn_dusk_switch_Disable_Updte];
        dawnSwitch_DawnView.enabled=YES;
        [dawnSwitch_DawnView setOn:YES animated:YES];
        [dawnSwitch_DawnView setSelected:YES];
        btn_Dawn_Minus.userInteractionEnabled=YES;
        btn_Dawn_Plus.userInteractionEnabled=YES;
        if([strDeviceType isEqualToString:@"lights"]){
            [dawnSwitch_DawnView setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }
        else if([strDeviceType isEqualToString:@"others"]){
            [dawnSwitch_DawnView setOnTintColor:[UIColor colorWithRed:40.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        strSelecteCategoryID=@"0";
        // startTime=@"00:00:00";
        // endTime=@"00:00:00";
        [dawnSwitch_DawnView setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [self dawn_dusk_switch_Enable_Update];
        [dawnSwitch_DawnView setSelected:NO];
    }
}
//Manual
-(void)switch_Time_ToggledSettings:(UISwitch *)twistedSwitch
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        strSelecteCategoryID=@"5";
        [self dawn_dusk_switch_Disable_Updte];
        switchTime.enabled=YES;
        [switchTime setOn:YES animated:YES];
        [switchTime setSelected:YES];
        btn_StartTime.userInteractionEnabled=YES;
        btn_EndTime.userInteractionEnabled=YES;
        if([strDeviceType isEqualToString:@"lights"]){
            [switchTime setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }else if([strDeviceType isEqualToString:@"others"]){
            [switchTime setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
        
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        strSelecteCategoryID=@"0";
        // startTime=@"00:00:00";
        // endTime=@"00:00:00";
        [btn_StartTime setTitle:@"00:00AM" forState:UIControlStateNormal];
        [btn_EndTime setTitle:@"00:00PM" forState:UIControlStateNormal];
        [switchTime setBackgroundColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:102.0/255 alpha:1.000]];
        [self dawn_dusk_switch_Enable_Update];
        [switchTime setSelected:NO];
    }
}
//Run on switch header
-(void)switch_RunON_ToggledSettings:(UISwitch *)twistedSwitch
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        str_Schedule_Day_Type=@"RunOn";
        [self runOnEnabled_DaysDisable];
        [switch_RunOn_Header setOn:YES animated:YES];
        [switch_RunOn_Header setSelected:YES];
        if([strDeviceType isEqualToString:@"lights"]){
            [switch_RunOn_Header setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.0]];
        }else if([strDeviceType isEqualToString:@"others"]){
            [switch_RunOn_Header setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.0]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        str_Schedule_Day_Type=@"";
        [switch_RunOn_Header setBackgroundColor:lblRGBA(98, 99, 102, 1)];
        [switch_ODD_Days setBackgroundColor:lblRGBA(98, 99, 102, 1)];
        [switch_Even_Days setBackgroundColor:lblRGBA(98, 99, 102, 1)];
        [self runOnDisabled_DaysEnabled];
        [switch_RunOn_Header setSelected:NO];
        [switch_ODD_Days setSelected:NO];
        [switch_ODD_Days setOn:NO animated:YES];
        [switch_Even_Days setSelected:NO];
        [switch_Even_Days setOn:NO animated:YES];
    }
}
//ODD Switch
-(void)switch_ODD_ToggledSettings:(UISwitch *)twistedSwitch{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        oddDays=YES;
        strOddDay=@"true";
        [switch_ODD_Days setOn:YES animated:YES];
        [switch_ODD_Days setSelected:YES];
        if([strDeviceType isEqualToString:@"lights"]){
            [switch_ODD_Days setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }else if([strDeviceType isEqualToString:@"others"]){
            [switch_ODD_Days setOnTintColor:[UIColor colorWithRed:40.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        oddDays=NO;
        strOddDay=@"false";
        [switch_ODD_Days setSelected:NO];
        [switch_ODD_Days setBackgroundColor:lblRGBA(98, 99, 102, 1)];
    }
    // [self changeDays_Months_Settings_For_Odd]; //not need
}
//Even switch run on
-(void)switch_EVEN_ToggledSettings:(UISwitch *)twistedSwitch{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([twistedSwitch isOn] && (![twistedSwitch isSelected])){
        NSLog(@"Switch is ON");
        evenDays=YES;
        strEvenDay=@"true";
        [switch_Even_Days setOn:YES animated:YES];
        [switch_Even_Days setSelected:YES];
        if([strDeviceType isEqualToString:@"lights"]){
            [switch_Even_Days setOnTintColor:[UIColor colorWithRed:255.0/255 green:206.0/255 blue:52.0/255 alpha:1.000]];
        }else if([strDeviceType isEqualToString:@"others"]){
            [switch_Even_Days setOnTintColor:[UIColor colorWithRed:49.0/255 green:165.0/255 blue:222.0/255 alpha:1.000]];
        }
    }
    else if((![twistedSwitch isOn]) && [twistedSwitch isSelected]){
        NSLog(@"Switch is OFF");
        evenDays=NO;
        strEvenDay=@"false";
        [switch_Even_Days setSelected:NO];
        [switch_Even_Days setBackgroundColor:lblRGBA(98, 99, 102, 1)];
    }
    // [self changeDays_Months_Settings_For_Even];  not need
}

-(void)changeDays_Months_Settings_For_Odd
{
    if([switch_ODD_Days isOn]){
        if([switch_Even_Days isOn]){
            return;
        }else{
            [self set_New_State_ODD_EVEN];
        }
    }else{
        if([switch_Even_Days isOn]){
            return;
        }else{
            [self reset_Old_State_ODD_EVEN];
        }
    }
}
-(void)reset_Old_State_ODD_EVEN
{
    if([strDeviceType isEqualToString:@"lights"]){
        btn_Mon_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Wed_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Fri_Day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Sun_day.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Jan.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Feb.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Mar.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Oct.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Nov.backgroundColor=lblRGBA(255, 206, 52, 1);
        btn_Dec.backgroundColor=lblRGBA(255, 206, 52, 1);
    }else if([strDeviceType isEqualToString:@"others"]){
        btn_Mon_Day.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Wed_Day.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Fri_Day.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Sun_day.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Jan.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Feb.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Mar.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Oct.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Nov.backgroundColor=lblRGBA(40, 165, 222, 1);
        btn_Dec.backgroundColor=lblRGBA(40, 165, 222, 1);
    }
    else{
        btn_Mon_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Wed_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Fri_Day.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Sun_day.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Jan.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Feb.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Mar.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Oct.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Nov.backgroundColor=lblRGBA(136, 197, 65, 1);
        btn_Dec.backgroundColor=lblRGBA(136, 197, 65, 1);
    }
    
}
-(void)set_New_State_ODD_EVEN
{
    btn_Mon_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Wed_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Fri_Day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Sun_day.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Jan.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Feb.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Mar.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Oct.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Nov.backgroundColor=lblRGBA(98, 99, 102, 1);
    btn_Dec.backgroundColor=lblRGBA(98, 99, 102, 1);
}
-(void)changeDays_Months_Settings_For_Even
{
    if([switch_Even_Days isOn]){
        if([switch_ODD_Days isOn]){
            return;
        }else{
            [self set_New_State_ODD_EVEN];
        }
    }else{
        if([switch_ODD_Days isOn]){
            return;
        }else{
            [self reset_Old_State_ODD_EVEN];
        }
    }
}

-(void)save_Schedule_Tapped:(UIButton*)sender{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    txt_Schedule[tag_Pos].text=[Common Trimming_Right_End_WhiteSpaces:txt_Schedule[tag_Pos].text];
    if(txt_Schedule[tag_Pos].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter schedule name"];
        return;
    }
    NSLog(@"sve tag value is ==%ld",(long)sender.tag);
    NSLog(@"tag pso ==%d",tag_Pos);
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(schedule_ScheduleNameUpdate) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}
-(void)deleteSch_Tapped:(UIButton *)sender{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }

    NSLog(@"cls tag value is ==%ld",(long)sender.tag);
    [self popUp_New_Configuration];
    [self.popUpScheduleView setHidden:NO];
}
-(void)saveSch_Tapped:(UIButton *)sender{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    NSLog(@"cls tag value is ==%ld",(long)sender.tag);
  //  strStatus_Schedule=@"ScheduleSave";
    [self validateScheduleContent];
}

-(void)edit_Schedule_Tapped:(UIButton*)sender{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }

    NSLog(@"edt tag value is ==%ld",(long)sender.tag);
    [txt_Schedule[sender.tag] setHidden:NO];
    [txt_Schedule[sender.tag] becomeFirstResponder];
    [lblSchedule[sender.tag] setHidden:YES];
    txt_Schedule[sender.tag].text=lblSchedule[sender.tag].text;
    [btn_Edit_Schedule[sender.tag] setHidden:YES];
    [btn_Close_Schedule[sender.tag] setHidden:NO];
    [btn_Save_Schedule[sender.tag] setHidden:NO];
    strStatus_Schedule=@"YES";
}
-(void)close_Schedule_Tapped:(UIButton*)sender{
    NSLog(@"sve tag value is ==%ld",(long)sender.tag);
    [lblSchedule[sender.tag] setHidden:NO];
    // lblSchedule[sender.tag].text=txt_Schedule[sender.tag].text;
    txt_Schedule[sender.tag].text = lblSchedule[sender.tag].text;
    [txt_Schedule[sender.tag] setHidden:YES];
    [txt_Schedule[sender.tag] resignFirstResponder];
    [self hide_Schedule_Header:(int)sender.tag];
    [btn_Save_Schedule[sender.tag] setHidden:YES];
}

-(void)validateScheduleContent
{
    txt_Schedule[tag_Pos].text=[Common Trimming_Right_End_WhiteSpaces:txt_Schedule[tag_Pos].text];
    if ([txt_Schedule[tag_Pos] resignFirstResponder]) {
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    if(txt_Schedule[tag_Pos].text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter schedule name"];
        return;
    }
    if([strSelecteCategoryID isEqualToString:@"0"]){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please select any one schedule time"];
        return;
    }
    else if([str_Schedule_Day_Type isEqualToString:@""])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Please select either run on days or manual days"];
        return;
    }
    else if([str_Schedule_Month isEqualToString:@""]){
        [Common showAlert:kAlertTitleWarning withMessage:@"Please select atleast one month"];
        return;
    }
    
    if([strSelecteCategoryID isEqualToString:@"3"])
    {
        if ([lblDawnHours_View.text isEqualToString:@"0 HOUR"]) {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please provide hours"];
            return;
        }
        if ([btn_Dawn_Plus.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_Dawn_Plus.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
        {
            NSLog(@"plus");
            startTime=[NSString stringWithFormat:@"00:00:00"];
            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnPlusHrs];
            if(stringToHours.length>1)
            {
                endTime=[NSString stringWithFormat:@"%d:00:00",intDawnPlusHrs];
                
            }else{
                endTime=[NSString stringWithFormat:@"0%d:00:00",intDawnPlusHrs];
            }
        }
        
        else if([btn_Dawn_Minus.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_Dawn_Minus.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
        {
            NSLog(@"minus");
            endTime=[NSString stringWithFormat:@"00:00:00"];
            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDawnMinusHrs];
            if(stringToHours.length>1)
            {
                startTime=[NSString stringWithFormat:@"%d:00:00",intDawnMinusHrs];
            }else{
                startTime=[NSString stringWithFormat:@"0%d:00:00",intDawnMinusHrs];
            }
        }
        
    }
    else if([strSelecteCategoryID isEqualToString:@"4"])
    {
        if ([lblDuskHours_View.text isEqualToString:@"0 HOUR"]) {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please provide hours"];
            return;
        }
        if ([btn_Dusk_Plus.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_Dusk_Plus.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
        {
            NSLog(@"plus");
            startTime=[NSString stringWithFormat:@"00:00:00"];
            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskPlusHrs];
            if(stringToHours.length>1)
            {
                endTime=[NSString stringWithFormat:@"%d:00:00",intDuskPlusHrs];
                
            }else{
                endTime=[NSString stringWithFormat:@"0%d:00:00",intDuskPlusHrs];
            }
        }
        
        else if([btn_Dusk_Minus.backgroundColor isEqual:lblRGBA(255, 206, 52, 1)]||[btn_Dusk_Minus.backgroundColor isEqual:lblRGBA(49, 165, 222, 1)])
        {
            NSLog(@"minus");
            endTime=[NSString stringWithFormat:@"00:00:00"];
            NSString *stringToHours = [NSString stringWithFormat:@"%d", intDuskMinusHrs];
            if(stringToHours.length>1)
            {
                startTime=[NSString stringWithFormat:@"%d:00:00",intDuskMinusHrs];
            }else{
                startTime=[NSString stringWithFormat:@"0%d:00:00",intDuskMinusHrs];
            }
        }
    }
    else if([strSelecteCategoryID isEqualToString:@"5"])
    {
        if([btn_StartTime.titleLabel.text isEqualToString:@"00:00AM"]&&[btn_EndTime.titleLabel.text isEqualToString:@"00:00PM"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please select start time and end time"];
            return;
        }
        else if([btn_StartTime.titleLabel.text isEqualToString:@"00:00AM"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please select start time "];
            return;
        }
        else if([btn_EndTime.titleLabel.text isEqualToString:@"00:00PM"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please select end time "];
            return;
        }
                
        else if([btn_StartTime.titleLabel.text isEqualToString:btn_EndTime.titleLabel.text])
        {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please select different end time"];
            return;
        }
        else{
            if ([btn_EndTime.titleLabel.text rangeOfString:@"AM"].location != NSNotFound && [btn_StartTime.titleLabel.text rangeOfString:@"PM"].location != NSNotFound) {
                NSLog(@"string contains AM");
                [Common showAlert:kAlertTitleWarning withMessage:@"Please select end time on same day"];
                return;
            }
            else if (([btn_EndTime.titleLabel.text rangeOfString:@"AM"].location != NSNotFound && [btn_StartTime.titleLabel.text rangeOfString:@"AM"].location != NSNotFound) || ([btn_EndTime.titleLabel.text rangeOfString:@"PM"].location != NSNotFound && [btn_StartTime.titleLabel.text rangeOfString:@"PM"].location != NSNotFound)) {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                
                NSDate *zeroDate = [dateFormatter dateFromString:formatedDateFrom];
                NSDate *offsetDate = [dateFormatter dateFromString:formatedDateTo];
                NSTimeInterval timeDifference = [offsetDate timeIntervalSinceDate:zeroDate];
                CGFloat minutes = (timeDifference/60);
                NSLog(@"minutes==%f",minutes);
                NSLog(@"%0.2fmins",minutes);
                if (minutes<0) {
                    [Common showAlert:kAlertTitleWarning withMessage:@"Please select end time on same day"];
                    return;
                }
            }
        }
        
        startTime=formatedDateFrom;   //formatedDateFromRail not need
        endTime=formatedDateTo;    // formatedDateToRail not need
        
    }
    if([str_Schedule_Day_Type isEqualToString:@"RunOn"]){
        if(oddDays==NO && evenDays==NO)
        {
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Select ODD or EVEN Days"];
            return;
        }
    }
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(schedule_Add_DeviceDetailsUpdate) withObject:self];
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : initial Setup for the ScrollView schedule
 Method Name : ScrollView_Configuration_Schedule
 ************************************************************************************* */
-(void)ScrollView_Configuration_Schedule
{
    scrollViewSchedule.showsHorizontalScrollIndicator=NO;
    scrollViewSchedule.scrollEnabled=YES;
    scrollViewSchedule.userInteractionEnabled=YES;
    scrollViewSchedule.delegate=self;
    scrollViewSchedule.scrollsToTop=NO;
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    //        scrollViewSchedule.contentSize=CGSizeMake(self.scrollViewSchedule.contentSize.width,1900);
    //    }else if ([[Common deviceType] isEqualToString:@"iPhone5"] || [[Common deviceType] isEqualToString:@"iPhone4"]){
    //        scrollViewSchedule.contentSize=CGSizeMake(self.scrollViewSchedule.contentSize.width,700);
    //    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
    //        scrollViewSchedule.contentSize=CGSizeMake(self.scrollViewSchedule.contentSize.width,750);
    //    }
}

/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Info Alertview Setup
 Method Name : infoPopUpSetup
 ************************************************************************************* */
-(void)infoPopUpSetup
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.infoAlertView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.infoAlertView.layer.mask = maskLayer;
}

-(void)dawn_dusk_switch_Disable_Updte
{
    duskSwitch_Stngs.enabled=NO;
    [duskSwitch_Stngs setOn:NO animated:YES];
    dawnSwitch_Stngs.enabled=NO;
    [dawnSwitch_Stngs setOn:NO animated:YES];
    duskSwitch_DuskView.enabled=NO;
    [duskSwitch_DuskView setOn:NO animated:YES];
    dawnSwitch_DawnView.enabled=NO;
    [dawnSwitch_DawnView setOn:NO animated:YES];
    switchTime.enabled=NO;
    [switchTime setOn:NO animated:YES];
    btn_StartTime.userInteractionEnabled=NO;
    btn_EndTime.userInteractionEnabled=NO;
}

-(void)dawn_dusk_switch_Enable_Update
{
    duskSwitch_Stngs.enabled=YES;
    dawnSwitch_Stngs.enabled=YES;
    duskSwitch_DuskView.enabled=YES;
    dawnSwitch_DawnView.enabled=YES;
    switchTime.enabled=YES;
    btn_Dusk_Minus.userInteractionEnabled=NO;
    btn_Dusk_Plus.userInteractionEnabled=NO;
    btn_Dawn_Minus.userInteractionEnabled=NO;
    btn_Dawn_Plus.userInteractionEnabled=NO;
    
    btn_Dawn_Plus.backgroundColor = lblRGBA(98, 99, 102, 1);
    btn_Dawn_Minus.backgroundColor = lblRGBA(98, 99, 102, 1);
    btn_Dusk_Plus.backgroundColor = lblRGBA(98, 99, 102, 1);
    btn_Dusk_Minus.backgroundColor = lblRGBA(98, 99, 102, 1);
    
    intDawnPlusHrs=0,intDawnMinusHrs=0,intDuskPlusHrs=0,intDuskMinusHrs=0;
    incDawnStatus=NO,decDawnStatus=NO,incDuskStatus=NO,decDuskStatus=NO;
    lblDawnHours_View.text=@"0 HOUR";
    lblDuskHours_View.text=@"0 HOUR";
    btn_StartTime.userInteractionEnabled=NO;
    btn_EndTime.userInteractionEnabled=NO;
}

#pragma mark - IBActions

-(IBAction)setUpSchedule_LightSchedule_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([strDeviceType isEqualToString:@"sprinklers"]){
        AddSprinklerScheldule *ASSVC = [[AddSprinklerScheldule alloc] initWithNibName:@"AddSprinklerScheldule" bundle:nil];
        ASSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSprinklerScheldule"];
        ASSVC.strStatus_Schedule=@"lightSchedule";
        //[ASSVC setDelegate:self];
       // ASSVC.strBackStatus_SprinklerSchedule=@"LightsDetail";
        [Common viewFadeInSettings:self.navigationController.view];
        [self.navigationController pushViewController:ASSVC animated:NO];
    }else{
        LightScheduleViewController *LSVC = [[LightScheduleViewController alloc] initWithNibName:@"LightScheduleViewController" bundle:nil];
        LSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LightScheduleViewController"];
        LSVC.strDeviceType_Schedule=strDeviceType;
        LSVC.strDeviceID=self.strDeviceID;
        LSVC.strStatus_Schedule = @"lightSchedule";
        [Common viewFadeInSettings:self.navigationController.view];
        [self.navigationController pushViewController:LSVC animated:NO];
    }
    
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Device name can be edited on click event.
 Method Name : Edit_lights_Action(User Defined Methods)
 ************************************************************************************* */
-(IBAction)Edit_lights_Action:(id)sender
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
            [btn_save_lights setHidden:NO];
            [btn_close_lights setHidden:NO];
            [btn_edit_lights setHidden:YES];
            [txtfld_DeviceName_Lights setHidden:NO];
            [lbl_deviceName_lights setHidden:YES];
            txtfld_DeviceName_Lights.text = lbl_deviceName_lights.text;
            [txtfld_DeviceName_Lights becomeFirstResponder];
            break;
        case 1:
            if([txtfld_DeviceName_Lights resignFirstResponder]){
                [txtfld_DeviceName_Lights resignFirstResponder];
            }
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self tableView_Category_Setup];
            NSLog(@"view size ==%f",self.lightsprofileView.frame.size.height);
            deviceCategoryView.hidden=NO;
            btn_edit_category.hidden=YES;
            btn_save_categoryDevice.hidden=NO;
            btn_close_categoryDevice.hidden=NO;
            btn_DeviceCategory.userInteractionEnabled=YES;
            break;
    }
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Calls the enable and disable method
 Method Name : Close_lights_Action(User Defined Methods)
 ************************************************************************************* */
-(IBAction)Close_lights_Action:(id)sender
{
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            [self fields_Enable_Disable];
            break;
        case 1:
            [self reset_Profile_Category];

            break;
    }
}


/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event saves the device name
 Method Name : Save_lights_Action(User Defined Methods)
 ************************************************************************************* */
-(IBAction)Save_lights_Action:(id)sender
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
            strDeviceEditMode = @"name";
            txtfld_DeviceName_Lights.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Lights.text];
            if ([txtfld_DeviceName_Lights resignFirstResponder]) {
                [txtfld_DeviceName_Lights resignFirstResponder];
            }
            if(txtfld_DeviceName_Lights.text.length==0){
                if ([strDeviceType isEqualToString:@"sprinklers"]) {
                    [Common showAlert:@"Warning" withMessage:@"Please enter zone name"];
                }else{
                    [Common showAlert:@"Warning" withMessage:@"Please enter device name"];
                }
                return;
            }
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                if ([strDeviceType isEqualToString:@"sprinklers"]) {
                    [self performSelectorInBackground:@selector(update_Zone_Details) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(update_Noid_Device) withObject:self];
                }
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            break;
        case 1:
            btn_DeviceCategory.userInteractionEnabled=NO;
            if([strDeviceType isEqualToString:@"sprinklers"]){
                btn_close_categoryDevice.hidden=YES;
                btn_save_categoryDevice.hidden=YES;
            }else{
                NSLog(@"selected categoty is == %@",btn_DeviceCategory.currentTitle);
                if(btn_save_lights.hidden==NO)
                {
                    txtfld_DeviceName_Lights.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Lights.text];
                    if ([txtfld_DeviceName_Lights resignFirstResponder]) {
                        [txtfld_DeviceName_Lights resignFirstResponder];
                    }
                    if(txtfld_DeviceName_Lights.text.length==0){
                        if ([strDeviceType isEqualToString:@"sprinklers"]) {
                            [Common showAlert:@"Warning" withMessage:@"Please enter zone name"];
                        }else{
                            [Common showAlert:@"Warning" withMessage:@"Please enter device name"];
                        }
                        return;
                    }
                }
                if(([strDeviceType isEqualToString:@"lights"]&&[btn_DeviceCategory.currentTitle isEqualToString:@"OTHER"])||([strDeviceType isEqualToString:@"others"]&&[btn_DeviceCategory.currentTitle isEqualToString:@"LIGHTS"]))
                {
                    if([Common reachabilityChanged]==YES){
                        [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                        [self performSelectorInBackground:@selector(update_Noid_DeviceCategory) withObject:self];
                        
                    }else{
                        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                    }
                }else{
                    deviceCategoryView.hidden=YES;
                    btn_close_categoryDevice.hidden=YES;
                    btn_edit_category.hidden=NO;
                    btn_save_categoryDevice.hidden=YES;
                }
            }
            break;
    }
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocol implementation
 Method Name : back_NetworkHome_Action_In_LightProfile(User Defined Methods)
 ************************************************************************************* */
-(IBAction)back_NetworkHome_Action_In_LightProfile:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if([appDelegate.strDeviceUpdated_Status isEqualToString:@"YES"])
//    {
//        appDelegate.strDeviceUpdated_Status=@"";
        appDelegate.strDevice_Added_Status=@"REMOVEPOPUPLOAD";
//    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self processCompleteLights];
    });
}

/* **********************************************************************************
 Date : 09/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates back to the previous screen
 Method Name : back_Action_LightsProfile(User Defined Methods)
 ************************************************************************************* */
-(IBAction)back_Action_LightsProfile:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![strDeviceCategoryChangedStatus isEqualToString:@"NO"])
    {
        NSLog(@"pop up change lights to others and others to lights");
        
        appDelegate.strDevice_Added_Status=@"CATEGORY";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // your navigation controller action goes here
        [self.navigationController popViewControllerAnimated:YES];
    });
}

/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event the device image can be changed or deleted.
 Method Name : change_delete_Deviceimg_Action (Media Picker Delegate Method)
 ************************************************************************************* */
-(IBAction)change_delete_Deviceimg_Action:(id)sender
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

    strDeviceEditMode = @"deviceImage";
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
            txtfld_DeviceName_Lights.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Lights.text];
            if(txtfld_DeviceName_Lights.text.length==0)
            {
                if ([strDeviceType isEqualToString:@"sprinklers"]) {
                    [Common showAlert:@"Warning" withMessage:@"Please enter zone name"];
                }else{
                    [Common showAlert:@"Warning" withMessage:@"Please enter device name"];
                }
                return;
            }
            strEncoded_ControllerImage=@"";
            imageStatus=NO;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                if ([strDeviceType isEqualToString:@"sprinklers"]) {
                    [self performSelectorInBackground:@selector(update_Zone_Details) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(update_Noid_Device) withObject:self];
                }
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            break;
    }
}

/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event navigates to the settings screen
 Method Name : setting_lightsProfile_Action
 ************************************************************************************* */
-(IBAction)setting_lightsProfile_Action:(id)sender
{
    if([txt_Schedule[tag_Pos] resignFirstResponder]){
        [txt_Schedule[tag_Pos] resignFirstResponder];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        SVC.str_gear_Type=@"lights";
        // [SVC setDelegate:self];
        [Common viewFadeInSettings:self.navigationController.view];
        [self.navigationController pushViewController:SVC animated:NO];
    });
}

-(void)checkOldWidgetLightsDismissOrNot
{
    if([strPreviousTab isEqualToString:@"lightsProfile"]){
        if([txtfld_DeviceName_Lights resignFirstResponder]){
            [txtfld_DeviceName_Lights resignFirstResponder];
        }
    }else if ([strPreviousTab isEqualToString:@"lightSchedule"]){
        if([txt_Schedule[tag_Pos] resignFirstResponder]){
            [txt_Schedule[tag_Pos] resignFirstResponder];
        }
    }
}
/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event navigates between the tabs
 Method Name : changeTab_From_lightsProfile_Action
 ************************************************************************************* */
-(IBAction)changeTab_From_lightsProfile_Action:(id)sender
{
    NSLog(@"devicetype=%@",strDeviceType);
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                strSelectedTab=@"lightsProfile";
                if([strSelectedTab isEqualToString:@"lightsProfile"] && ![strPreviousTab isEqualToString:@"lightsProfile"]){
                    [self checkOldWidgetLightsDismissOrNot];
                    strPreviousTab=strSelectedTab;
                    if([strDeviceType isEqualToString:@"others"]){
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBlue"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];
//                        }else {
//                            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6"];
//                        }
                        imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailImageBluei6plus"];
                        lbl_lightsProfile.textColor = lblRGBA(49, 165, 222, 1);
                    }
                    else if([strDeviceType isEqualToString:@"sprinklers"]){
                        view_Category_device.hidden=YES;
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreen"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreeni6plus"];
//                        }else {
//                            imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreeni6"];
//                        }
                        imglightsProfile.image = [UIImage imageNamed:@"ProfileDetailsImageGreeni6plus"];
                        lbl_lightsProfile.textColor = lblRGBA(136, 197, 65, 1);
                    }
                    else{
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImage"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImagei6plus"];
//                        }else {
//                            imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImagei6"];
//                        }
                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailsImagei6plus"];
                        lbl_lightsProfile.textColor = lblRGBA(255, 206, 52, 1);
                    }
//                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                        imglightsLocation.image = [UIImage imageNamed:@"locationImage"];
//                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImage"];
//                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                        imglightsLocation.image = [UIImage imageNamed:@"locationImagei6plus"];
//                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImagei6plus"];
//                    }else {
//                        imglightsLocation.image = [UIImage imageNamed:@"locationImagei6"];
//                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImagei6"];
//                    }
                    imglightsLocation.image = [UIImage imageNamed:@"locationImagei6plus"];
                    imglightSchedule.image = [UIImage imageNamed:@"scheduleImagei6plus"];
                    lbl_lightsLocation.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_lightSchedule.textColor = lblRGBA(99, 99, 102, 1);
                    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                    [Common viewFadeIn:self.navigationController.view];
                    [lightslocationView setHidden:YES];
                    [lightScheduleView setHidden:YES];
                    [lightsprofileView setHidden:NO];
                    changeTabStatus = @"lightsprofile";
                }
            });
        }
            break;
        case 1:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                strSelectedTab=@"lightSchedule";
                if([strSelectedTab isEqualToString:@"lightSchedule"] && ![strPreviousTab isEqualToString:@"lightSchedule"]){
                    [self checkOldWidgetLightsDismissOrNot];
                    strPreviousTab=strSelectedTab;
                    if ([appDelegate.strTimeZoneChanged_Status isEqualToString:@"YES"]) {
                        strStatus=@"";
                        [self.scrollViewSchedule setContentOffset:CGPointZero animated:YES];
                        for (int index=0;index<[arr_Schedule count];index++){
                            [view_ScheduleCell[index] removeFromSuperview];
                        }
                        self.view_AddSchedule.hidden=YES;
                        self.view_VacationMode.hidden=YES;
                        self.btn_Info.hidden=YES;
                    }
                    if([strDeviceType isEqualToString:@"others"]){
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightSchedule.image = [UIImage imageNamed:@"scheduleBlueImage"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightSchedule.image = [UIImage imageNamed:@"scheduleBlueImagei6plus"];
//                        }else {
//                            imglightSchedule.image = [UIImage imageNamed:@"scheduleBlueImagei6"];
//                        }
                        imglightSchedule.image = [UIImage imageNamed:@"scheduleBlueImagei6plus"];
                        lbl_lightSchedule.textColor = lblRGBA(49, 165, 222, 1);
                    } else if([strDeviceType isEqualToString:@"sprinklers"]){
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightSchedule.image = [UIImage imageNamed:@"scheduleImageGreen"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightSchedule.image = [UIImage imageNamed:@"scheduleImageGreeni6plus"];
//                        }else {
//                            imglightSchedule.image = [UIImage imageNamed:@"scheduleImageGreeni6"];
//                        }
                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImageGreeni6plus"];
                        lbl_lightSchedule.textColor = lblRGBA(136, 197, 65, 1);
                    }
                    else{
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightSchedule.image = [UIImage imageNamed:@"ScheduleImageYellow"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightSchedule.image = [UIImage imageNamed:@"ScheduleImageYellowi6plus"];
//                        }else {
//                            imglightSchedule.image = [UIImage imageNamed:@"ScheduleImageYellowi6"];
//                        }
                        imglightSchedule.image = [UIImage imageNamed:@"ScheduleImageYellowi6plus"];
                        lbl_lightSchedule.textColor = lblRGBA(255, 206, 52, 1);
                    }
                    
//                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                        imglightsLocation.image = [UIImage imageNamed:@"locationImage"];
//                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGrey"];
//                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                        imglightsLocation.image = [UIImage imageNamed:@"locationImagei6plus"];
//                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
//                    }else {
//                        imglightsLocation.image = [UIImage imageNamed:@"locationImagei6"];
//                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGreyi6"];
//                    }
                    imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
                    imglightsLocation.image = [UIImage imageNamed:@"locationImagei6plus"];
                    lbl_lightsLocation.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_lightsProfile.textColor = lblRGBA(99, 99, 102, 1);
                    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                    [Common viewFadeIn:self.navigationController.view];
                    [lightScheduleView setHidden:NO];
                    [lightslocationView setHidden:YES];
                    [lightsprofileView setHidden:YES];
                    changeTabStatus = @"schedule";
                    if(![strStatus isEqualToString:@"YES"]){
                        if([Common reachabilityChanged]==YES){
                            [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                            if([strDeviceType isEqualToString:@"sprinklers"]){
                                [self performSelectorInBackground:@selector(getDevice_ZoneScheduleList) withObject:self];
                            }else{
                                [self performSelectorInBackground:@selector(getDeviceScheduleList) withObject:self];
                            }
                        }else{
                            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                        }
                    }
                }
            });
        }
        break;
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self Geolocation];
                strSelectedTab=@"lightLocation";
                if([strSelectedTab isEqualToString:@"lightLocation"] && ![strPreviousTab isEqualToString:@"lightLocation"]){
                    [self checkOldWidgetLightsDismissOrNot];
                    if([geoStatus isEqualToString:@"NO"]){
                        [self Geolocation];
                    }
                    strPreviousTab=strSelectedTab;
                    if([strDeviceType isEqualToString:@"others"]){
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightsLocation.image = [UIImage imageNamed:@"lightsLocationBlue"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightsLocation.image = [UIImage imageNamed:@"lightsLocationBluei6plus"];
//                        }else {
//                            imglightsLocation.image = [UIImage imageNamed:@"lightsLocationBluei6"];
//                        }
                        imglightsLocation.image = [UIImage imageNamed:@"lightsLocationBluei6plus"];
                        lbl_lightsLocation.textColor = lblRGBA(49, 165, 222, 1);
                    }
                    else if([strDeviceType isEqualToString:@"sprinklers"]){
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightsLocation.image = [UIImage imageNamed:@"locationImageGreen"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightsLocation.image = [UIImage imageNamed:@"locationImageGreeni6plus"];
//                        }else {
//                            imglightsLocation.image = [UIImage imageNamed:@"locationImageGreeni6"];
//                        }
                        imglightsLocation.image = [UIImage imageNamed:@"locationImageGreeni6plus"];
                        lbl_lightsLocation.textColor = lblRGBA(136, 197, 65, 1);
                    }
                    else{
//                        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                            imglightsLocation.image = [UIImage imageNamed:@"lightsLocationYellow"];
//                        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                            imglightsLocation.image = [UIImage imageNamed:@"lightsLocationYellowi6plus"];
//                        }else {
//                            imglightsLocation.image = [UIImage imageNamed:@"lightsLocationYellowi6"];
//                        }
                        imglightsLocation.image = [UIImage imageNamed:@"lightsLocationYellowi6plus"];
                        lbl_lightsLocation.textColor = lblRGBA(255, 206, 52, 1);
                    }
//                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImage"];
//                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGrey"];
//                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImagei6plus"];
//                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
//                    }else {
//                        imglightSchedule.image = [UIImage imageNamed:@"scheduleImagei6"];
//                        imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGreyi6"];
//                    }
                    imglightsProfile.image = [UIImage imageNamed:@"profileDetailImageGreyi6plus"];
                    imglightSchedule.image = [UIImage imageNamed:@"scheduleImagei6plus"];
                    lbl_lightsProfile.textColor = lblRGBA(99, 99, 102, 1);
                    lbl_lightSchedule.textColor = lblRGBA(99, 99, 102, 1);
                    [txtfld_DeviceName_Lights resignFirstResponder];
                    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
                    [Common viewFadeIn:self.navigationController.view];
                    [lightslocationView setHidden:NO];
                    [lightsprofileView setHidden:YES];
                    [lightScheduleView setHidden:YES];
                }
            });
        }
            break;
    }
}

/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : on click event displays the device delete view
 Method Name : delete_Device_Action
 ************************************************************************************* */
-(IBAction)delete_Device_Action:(id)sender
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
    if ([strDeviceType isEqualToString:@"sprinklers"]) {
        if(![strHubActiveStatus isEqualToString:@"MANUALLY_OFF"] && [strScheduleStatus isEqualToString:@"ACTIVE"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:@"This zone is currently active. Please switch-off the zone and try again"];
            return;
        }
    }
    [self.Device_Del_View setHidden:NO];
//    [self.lightsContainerView setAlpha:0.6];
//    [self.header_View_Lights setAlpha:0.6];
    [self popUp_New_Configuration];
    [self fields_Enable_Disable];
}

-(void)popUp_New_Configuration{
    [self.header_View_Lights setAlpha:0.6];
    [self.lightsContainerView setAlpha:0.6];
    [self.view_BackLights setAlpha:0.6];
    [self.lightTabView setAlpha:0.6];
}
-(void)popUp_OLD_Configuration{
    [self.header_View_Lights setAlpha:1.0];
    [self.lightsContainerView setAlpha:1.0];
    [self.view_BackLights setAlpha:1.0];
    [self.lightTabView setAlpha:1.0];
}

/* **********************************************************************************
 Date : 01/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description :
 Method Name : close_DC_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)close_DC_Action:(id)sender
{
//    [self.Device_Del_View setHidden:YES];
//    [self.lightsprofileView setAlpha:1.0];
//    [self.header_View_Lights setAlpha:1.0];
    NSLog(@"Device Trace id ==%@",strDevice_TraceID);
    UIButton *btnTag=(UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                if ([strDeviceType isEqualToString:@"sprinklers"]) {
                    [self performSelectorInBackground:@selector(deleteZoneDetails_NOID) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(deleteDevice_NOID) withObject:self];
                }
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            [self.Device_Del_View setHidden:YES];
            [self popUp_OLD_Configuration];
        }
            break;
        case 1:
        {
            [self.Device_Del_View setHidden:YES];
            [self popUp_OLD_Configuration];
        }
            break;
    }
}


/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event hides the alert view from the superview
 Method Name : closeAlert
 ************************************************************************************* */
-(IBAction)closeAlert:(id)sender{
    [self change_Light_Schedule_Alpha];
    [popUpScheduleView setHidden:YES];
}

/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event set the alpha for the view
 Method Name : change_Light_Schedule_Alpha
 ************************************************************************************* */
-(void)change_Light_Schedule_Alpha
{
    [self.header_View_Lights setAlpha:1.0];
    [self.lightsContainerView setAlpha:1.0];
    [self.view_BackLights setAlpha:1.0];
    [self.lightTabView setAlpha:1.0];
}

-(IBAction)pickerView_Ok_Cancel_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //OK
        {
            hour=1;
            hours=1;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm:ss";
            NSDateFormatter *dateFormatter12 = [[NSDateFormatter alloc] init];
            dateFormatter12.dateFormat = @"hh:mm a";
            if([timerType isEqualToString:@"From"])
            {
                formatedDateFrom = [dateFormatter stringFromDate:timePicker.date];
                DateFrom = [dateFormatter12 stringFromDate:timePicker.date];
                NSLog(@"formatted date==%@",formatedDateFrom);
                [btn_StartTime setTitle:DateFrom forState:UIControlStateNormal];
                
            }
            else
            {
                formatedDateTo = [dateFormatter stringFromDate:timePicker.date];
                DateTo = [dateFormatter12 stringFromDate:timePicker.date];
                NSLog(@"formatted date==%@",formatedDateTo);
                [btn_EndTime setTitle:DateTo forState:UIControlStateNormal];
            }
            
            
//            NSDate * from = [dateFormatter dateFromString:formatedDateFrom];
//            NSDate * to = [dateFormatter dateFromString:formatedDateTo];
//            NSTimeInterval interval = [from timeIntervalSinceDate:to];
            
//            hours = fabs(interval / 3600);
//            NSLog(@"Difference %d",hours);
//            
//            if([btn_StartTime.titleLabel.text isEqualToString:@"00:00AM"]&&[btn_EndTime.titleLabel.text isEqualToString:@"00:00PM"])
//            {
                if([timerType isEqualToString:@"From"])
                {
                    [btn_StartTime setTitle:DateFrom forState:UIControlStateNormal];
                }else
                {
                    [btn_EndTime setTitle:DateTo forState:UIControlStateNormal];
                }
//            }
//            else{
//                if ([to compare:from] != NSOrderedDescending) {
//                    hour = 24-hours;
//                    NSLog(@"%d",hour);
//                }else{
//                    // hour=hours;
//                    NSLog(@"%d",hours);
//                }
//            }
            [UIView animateWithDuration:.25 animations:^{
                pickerView.frame=CGRectMake(0, 2000, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
            [self.lightsContainerView setUserInteractionEnabled:YES];
            [self.lightsContainerView setAlpha:1.0];
            [self.lightTabView setUserInteractionEnabled:YES];
            [self.lightTabView setAlpha:1.0];
            
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:.25 animations:^{
                pickerView.frame=CGRectMake(0, 2000, pickerView.frame.size.width, pickerView.frame.size.height);
            }];
            [self.lightsContainerView setUserInteractionEnabled:YES];
            [self.lightsContainerView setAlpha:1.0];
            [lightTabView setAlpha:1.0];
            lightTabView.userInteractionEnabled=YES;
        }
            break;
    }
}

/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event deletes the current cell
 Method Name : delete_ScheduleCell
 ************************************************************************************* */
-(IBAction)delete_ScheduleCell:(id)sender{
    [popUpScheduleView setHidden:YES];
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(deletScheduleService) withObject:self];
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    
}

-(IBAction)info_BtnAction:(id)sender{
    [self popUp_New_Configuration];
    [view_infoAlert setHidden:NO];
}

-(IBAction)closeInfoAlert:(id)sender{
    [view_infoAlert setHidden:YES];
    [self popUp_OLD_Configuration];
}

-(IBAction)vacationMode:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"])
    {
        NSLog(@"Permission =%@",appDelegate.strNetworkPermission);
        if([appDelegate.strNetworkPermission isEqualToString:@"2"])
        {
            [Common showAlert:kAlertTitleWarning withMessage:kAlertAccess];
            return;
        }
    }
    if([arr_Schedule count]==0)
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"No schedules available. Cannot turn ON vacation mode."];
        return;
    }
    if (vacationModeStatus==YES) {
        strVactionStatusFlag=@"2";
    }else if (vacationModeStatus==NO){
        strVactionStatusFlag=@"1";
    }
    [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
    [self performSelectorInBackground:@selector(update_DeviceMode) withObject:self];
}

-(void)changeVacationNewState
{
    for(int index=0;index<[arr_Schedule count];index++){
        view_ScheduleCell[index].userInteractionEnabled=NO;
        view_ScheduleCell[index].backgroundColor=lblRGBA(88,89,91,1);
        view_Schedule_Sub[index].backgroundColor=lblRGBA(88, 89,91,1);
        lblSchedule[index].textColor=lblRGBA(128, 130, 133, 1);
        [lblSchedule_Time[index] setHidden:YES];
        [imgClock[index] setHidden:YES];
        [imgViewSchedule[index] setAlpha:0.4];
    }
    str_CheckAction=@"VacationModeOff";
    view_VacationMode.backgroundColor=lblRGBA(217,38,50, 1);//red for vacation
    view_AddSchedule.backgroundColor=lblRGBA(88,89,91,1);
    lbl_vacationMode.text = @"TURN OFF VACATION MODE";
    vacationModeStatus=NO;
    view_AddSchedule.userInteractionEnabled=NO;
    view_AddSchedule.alpha=0.4;
}

-(void)changeVacation_Mode_OldState{
    for(int index=0;index<[arr_Schedule count];index++){
        view_ScheduleCell[index].userInteractionEnabled=YES;
        lblSchedule[index].textColor=lblRGBA(255, 255, 255, 1);
        [lblSchedule_Time[index] setHidden:NO];
        [imgClock[index] setHidden:NO];
        if([strDeviceType isEqualToString:@"lights"]){
            view_ScheduleCell[index].backgroundColor=lblRGBA(255, 206, 52, 1);
            view_Schedule_Sub[index].backgroundColor=lblRGBA(255, 216, 74, 1);
        }else if([strDeviceType isEqualToString:@"others"])
        {
            view_ScheduleCell[index].backgroundColor=lblRGBA(40, 165,222, 1);
            view_Schedule_Sub[index].backgroundColor=lblRGBA(116, 196, 234, 1);
        }
        else{
            view_ScheduleCell[index].backgroundColor=lblRGBA(136, 197, 65, 1);
            view_Schedule_Sub[index].backgroundColor=lblRGBA(159, 206, 101, 1);
        }
        [imgViewSchedule[index] setAlpha:1.0];
    }
    if([self.strDeviceType isEqualToString:@"others"]){
        view_AddSchedule.backgroundColor=lblRGBA(49, 165, 222, 1);
    }else if([strDeviceType isEqualToString:@"lights"]){
        view_AddSchedule.backgroundColor=lblRGBA(255, 206, 52, 1);
    }else{
        view_AddSchedule.backgroundColor=lblRGBA(136, 197, 65, 1);
    }
    str_CheckAction=@"VacationModeOn";
    view_VacationMode.backgroundColor=lblRGBA(88,89,91,1);
    lbl_vacationMode.text = @"TURN ON VACATION MODE";
    vacationModeStatus=YES;
    view_AddSchedule.userInteractionEnabled=YES;
    view_AddSchedule.alpha = 1.0;
}

-(IBAction)category_DropDown_Action:(id)sender{
    if (deviceCategoryView.hidden==YES) {
        deviceCategoryView.hidden=NO;
    }
}

/* **********************************************************************************
 Date : 11/07/2014
 Author : iExemplar Software India Pvt Ltd.
 Title: Jump To Current Locaiton
 Description : In Case User Moves apart from current location.
 Method Name : audioPlayerDidFinishPlaying (Delegate Method Name)
 ************************************************************************************* */
- (IBAction)recenterMapToUserLocation:(id)sender {
    btnUserLocation.hidden = YES;

    MyAnnotation *ann;
    
    CLLocationCoordinate2D newCoordiante;
    newCoordiante.latitude=[[NSString stringWithFormat:@"%@",latitude] doubleValue];
    newCoordiante.longitude=[[NSString stringWithFormat:@"%@",longitude] doubleValue];
    ann=[[MyAnnotation alloc] initWithLocation:newCoordiante];
    
    [mapView_lights setRegion:MKCoordinateRegionMakeWithDistance(ann.coordinate, 300,300)];
    
    NSLog(@"afatre assgn lat==%@",latitude);
    NSLog(@"afatre assgn long==%@",longitude);
}

-(IBAction)planDowngrade_Confirmation_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Downgrade Okay
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForDowngradeDevice) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //Downgrade Cancel
        {
            self.viewAlert_PlanDowngrade.hidden=YES;
            [self popUp_OLD_Configuration];
        }
            break;
        case 2: //Charge My card
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForDowngradeDeviceConfirmation) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 3: //Confirmation Alert Cancel
        {
            self.viewAlert_PlanDowngrade_Confirm.hidden=YES;
            [self popUp_OLD_Configuration];
        }
            break;
    }
}

//-(void)saveSchedule_OnClick:(UIButton *)sender
//{
//    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//        cellSchedule.lblScheduleName.text = cellSchedule.txtfldScheduleName.text;
//        cellSchedule.BtnEdit.hidden=NO;
//        cellSchedule.btn_save_schedule.hidden=YES;
//        [cellSchedule.txtfldScheduleName resignFirstResponder];
//    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//        cellSchedulei6plus.lblScheduleName.text = cellSchedule.txtfldScheduleName.text;
//        cellSchedulei6plus.BtnEdit.hidden=NO;
//        cellSchedulei6plus.btn_save_schedule.hidden=YES;
//        [cellSchedulei6plus.txtfldScheduleName resignFirstResponder];
//    }else{
//        cellSchedulei6.lblScheduleName.text = cellSchedule.txtfldScheduleName.text;
//        cellSchedulei6.BtnEdit.hidden=NO;
//        cellSchedulei6.btn_save_schedule.hidden=YES;
//        [cellSchedulei6.txtfldScheduleName resignFirstResponder];
//    }
//    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}
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
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *newImage;
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *img =  [info objectForKey:UIImagePickerControllerEditedImage];
//            imgProfile.image=img;
            
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
            //anitha code
//            newImage=img;
//            NSData *imageData1 = UIImageJPEGRepresentation(newImage, 1);
//            NSLog(@"Size of image = %lu KB",(imageData1.length/1024));
//            CGSize size=CGSizeMake(newImage.size.width/8,newImage.size.height/8);
//            newImage=[self resizeImageDeviceDetails:newImage newSize:size];
//            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
//            NSLog(@"Size of image = %lu KB",(imageData.length/1024));
            
            CGSize imgScalling;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgScalling = [Common imageScalling:img withScalingDetails:320 and:185];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgScalling = [Common imageScalling:img withScalingDetails:375 and:217];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgScalling = [Common imageScalling:img withScalingDetails:414 and:239];
            }
            newImage = [Common imageWithImage:newImage scaledToSize:imgScalling];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.05);
            NSLog(@"Size of big image = %lu KB",(imageData.length/1024));
            
        }else{
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            //anitha code
//            newImage=image;
//            NSData *imageData1 = UIImageJPEGRepresentation(newImage, 1);
//            NSLog(@"Size of image = %lu KB",(imageData1.length/1024));
//            CGSize size=CGSizeMake(newImage.size.width/8,newImage.size.height/8);
//            newImage=[self resizeImageDeviceDetails:newImage newSize:size];
//            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.05);
//            NSLog(@"Size of image = %lu KB",(imageData.length/1024));
//            imgProfile.image=newImage;
            
            CGSize imgScalling;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgScalling = [Common imageScalling:image withScalingDetails:320 and:185];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgScalling = [Common imageScalling:image withScalingDetails:375 and:217];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgScalling = [Common imageScalling:image withScalingDetails:414 and:239];
            }
            newImage = [Common imageWithImage:newImage scaledToSize:imgScalling];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
            NSLog(@"Size of big image = %lu KB",(imageData.length/1024));
        }
        NSData* data = UIImageJPEGRepresentation(newImage, 0.3f);
        strEncoded_ControllerImage = [Base64 encode:data];
        [picker dismissViewControllerAnimated:YES completion:NULL];
//        [deleteProfilebtn setHidden:NO];
        imageStatus=YES;
        txtfld_DeviceName_Lights.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Lights.text];
        if(txtfld_DeviceName_Lights.text.length==0)
        {
            if ([strDeviceType isEqualToString:@"sprinklers"]) {
                [Common showAlert:@"Warning" withMessage:@"Please enter zone name"];
            }else{
                [Common showAlert:@"Warning" withMessage:@"Please enter device name"];
            }
            return;
        }
        if([Common reachabilityChanged]==YES){
            [self performSelector:@selector(start_PinWheel_DeviceDetails) withObject:self afterDelay:0.1];
            if ([strDeviceType isEqualToString:@"sprinklers"]) {
                [self performSelectorInBackground:@selector(update_Zone_Details) withObject:self];
            }else{
                [self performSelectorInBackground:@selector(update_Noid_Device) withObject:self];
            }
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
}

- (UIImage *)resizeImageDeviceDetails:(UIImage*)image newSize:(CGSize)newSize {
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
    if ([strSelectedTab isEqualToString:@"lightSchedule"]) {
        [self.scrollViewSchedule setContentOffset:CGPointMake(0, view_ScheduleCell[tag_Pos].frame.origin.y+txt_Schedule[tag_Pos].frame.origin.y) animated:NO];
    }else{
        self.view.frame=CGRectMake(0, -150, self.view.frame.size.width,self.view.frame.size.height);
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Characters Entered");
    if ((range.location == 0 && [string isEqualToString:@" "]) || (range.location == 0 && [string isEqualToString:@"'"]))
    {
        return NO;
    }    
    if(textField==txtfld_DeviceName_Lights)
    {
        NSUInteger newLength = [txtfld_DeviceName_Lights.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }else if(textField==txt_Schedule[tag_Pos])
    {
        NSUInteger newLength = [txt_Schedule[tag_Pos].text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
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

#pragma mark - TableView Delegates and DataSource
/* **********************************************************************************
 Date : 22/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description :Method used to return the number of rows in the tableview
 Method Name :numberOfRowsInSection (Pre Defined Method)
 ************************************************************************************* */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrDeviceCategory count];
}

// Default is 1 if not implemented
/* **********************************************************************************
 Date : 22/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Returns the number of sections in the tableview
 Method Name : numberOfSectionsInTableView(TableView Delegate Method)
 ************************************************************************************* */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/* **********************************************************************************
 Date :
 Description : Method used to set values in each row automatically based on the index path
 Method Name :cellForRowAtIndexPath (Pre Defined Method)
 ************************************************************************************* */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView_Category dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[arrDeviceCategory objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"NexaBold" size:10.0];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : when user taps a particular cell or row in the tableview,this method is called
 Method Name : didSelectRowAtIndexPath (TableView Delegate Method Name)
 ************************************************************************************* */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [btn_DeviceCategory setTitle:[arrDeviceCategory objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    if(indexPath.row==0)
    {
        strDeviceCatType=@"1";
    }else{
        strDeviceCatType=@"3";
    }
    deviceCategoryView.hidden=YES;
}
//330
/* **********************************************************************************
 Date : 22/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Method used to return the height of each row in the tableview
 Method Name : heightForRowAtIndexPath(TableView Delegate Method)
 ************************************************************************************* */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Method used to return the height of the footer in the tableview
 Method Name : heightForFooterInSection(TableView Delegate Method)
 ************************************************************************************* */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - CLLocationManagerDelegate
/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Mapview delegate method
 Method Name : mapView
 ************************************************************************************* */
//- (void)mapView:(MKMapView *)mapView
//didUpdateUserLocation:(MKUserLocation *)userLocation {
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if([appDelegate.flagMap isEqualToString:@"1"]){
//        CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
//        mapView.region = region;
//        appDelegate.flagMap=@"0";
//    }
//}

#pragma mark - MapView Delegate
/* **********************************************************************************
 Date : 10/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : mapView delegate methods
 Method Name : viewForAnnotation
 ************************************************************************************* */
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *identifier = @"myAnnotation";
    NSLog(@"devicetype==%@",self.strDeviceType);
    annotationView = (MKAnnotationView *)[mapView_lights dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        if([self.strDeviceType isEqualToString:@"lights"]){
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//               annotationView.image = [UIImage imageNamed:@"Placemarker_icon_Yellow"];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                annotationView.image = [UIImage imageNamed:@"Placemarker_icon_Yellowi6plus"];
//            }else{
                annotationView.image = [UIImage imageNamed:@"Placemarker_icon_Yellowi6"];
//            }
        
        }else if([self.strDeviceType isEqualToString:@"sprinklers"]){
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                annotationView.image = [UIImage imageNamed:@"placeMarker_Green"];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                annotationView.image = [UIImage imageNamed:@"placeMarker_Greeni6plus"];
//            }else{
                annotationView.image = [UIImage imageNamed:@"placeMarker_Greeni6"];
//            }
        }
        else{
//            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//                annotationView.image = [UIImage imageNamed:@"Placemarker_icon"];
//            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//                annotationView.image = [UIImage imageNamed:@"Placemarker_iconi6plus"];
//            }else{
                annotationView.image = [UIImage imageNamed:@"Placemarker_iconi6"];
//            }
            
        }
        annotationView.canShowCallout=NO;
        annotationView.rightCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    MKCoordinateRegion region;
//    region.span.longitudeDelta  = 0.5;
//    region.span.latitudeDelta  = 0.5;
//}
//- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated{
//    region.span.longitudeDelta  = 0.5;
//    region.span.latitudeDelta  = 0.5;
//}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotation = [mapView viewForAnnotation:mapView.userLocation];
    annotation.hidden = YES;
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.strLaunchOrientation isEqualToString:@"YES"]) {
        return  UIInterfaceOrientationMaskPortrait;
    }else{
        return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
    }
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
        
    }
    
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
}

#pragma mark - WebService Method
-(void)getDeviceDetails_NOID
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices?deviceId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Device_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Device Details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseErrorDeviceDetails
{
    NSLog(@"%@",strResponseError);
    [Common showAlert:@"Warning" withMessage:strResponseError];
    // self.view_AddNetwork.hidden=NO;
}
-(void)parse_Device_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrDeviceDetails = [[NSMutableArray alloc] init];
            arrDeviceDetails=[responseDict objectForKey:@"data"];
            NSLog(@"arr_Network_Data==%@",arrDeviceDetails);
            NSLog(@"arr_Network_Data count==%lu",(unsigned long)arrDeviceDetails.count);
            if([arrDeviceDetails count]>0){
                NSLog(@"devicemode==%@",[[[arrDeviceDetails objectAtIndex:0] objectForKey:@"deviceMode"] objectForKey:@"deviceModeCode"]);
                
                NSDictionary *dictDeviceData =[[arrDeviceDetails objectAtIndex:0] objectForKey:@"deviceTrace"];
                lbl_HeaderName_lights.text=[[arrDeviceDetails objectAtIndex:0] objectForKey:@"name"];
                lbl_deviceName_lights.text=[[arrDeviceDetails objectAtIndex:0] objectForKey:@"name"];
                txtfld_DeviceName_Lights.text = lbl_deviceName_lights.text;
                if(![[[arrDeviceDetails objectAtIndex:0] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
                    [self uiconfiguration_Profiles:[[arrDeviceDetails objectAtIndex:0] objectForKey:@"thumbnailImage"]];
                    [deleteProfilebtn setHidden:NO];
                }else{
                    if([strDeviceType isEqualToString:@"others"]){
                        imgProfile.image = [UIImage imageNamed:@"dbigOther"];
                    }else{
                        imgProfile.image = [UIImage imageNamed:@"dbigLight"];
                    }
                    
                    [deleteProfilebtn setHidden:YES];
                }
                strDevice_TraceID=[dictDeviceData objectForKey:@"id"];

                latitude=[[arrDeviceDetails objectAtIndex:0] objectForKey:@"latitude"];
                longitude=[[arrDeviceDetails objectAtIndex:0] objectForKey:@"longitude"];
                self.lightsprofileView.hidden=NO;
                [self stop_PinWheel_DeviceDetails];
            }else{
                [self stop_PinWheel_DeviceDetails];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteDevice_NOID
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices?deviceId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID];
    NSLog(@"path==%@",strMethodNameWith_Value);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Device Delete==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Delete_Device_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Device Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

-(void)parse_Delete_Device_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strDevieDeleted_Status=@"YES";
            appDelegate.strAddNewSchedule=@"";
            appDelegate.strDeleteScheduleCount=@"";
            if(![strDeviceCategoryChangedStatus isEqualToString:@"NO"])
            {
                NSLog(@"pop up change lights to others and others to lights");
                appDelegate.strDevice_Added_Status=@"CATEGORY";
            }
            [self stop_PinWheel_DeviceDetails];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self stop_PinWheel_DeviceDetails];
            if([responseMessage isEqualToString:@"ACCT_DEVICE_MIN_LIMIT_REACHED"])
            {
                [self.viewAlert_PlanDowngrade setHidden:NO];
                [self popUp_New_Configuration];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)update_Noid_Device
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    NSDictionary *parameters;
    NSMutableDictionary *dictDeviceDetails=[[NSMutableDictionary alloc] init];
    [dictDeviceDetails setObject:self.strDeviceID forKey:kDeviceID];
    [dictDeviceDetails setObject:txtfld_DeviceName_Lights.text forKey:kDeviceName];
    [dictDeviceDetails setObject:@"" forKey:kDeviceImage];
    [dictDeviceDetails setObject:strEncoded_ControllerImage forKey:KThumbnailImage];
    [dictDeviceDetails setObject:strDevice_TraceID forKey:kDeviceTraceID];
    
    parameters=[SCM update_Noid_Device_Details:dictDeviceDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update wifi Controller Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseupdate_Device_DetailsNoid) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Controller wifi Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
        if ([strDeviceEditMode isEqualToString:@"deviceImage"]){
            strEncoded_ControllerImage = strDeviceImage;
        }
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseupdate_Device_DetailsNoid
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            
            if ([strDeviceEditMode isEqualToString:@"name"]) {
                lbl_deviceName_lights.text = txtfld_DeviceName_Lights.text;
                lbl_HeaderName_lights.text = txtfld_DeviceName_Lights.text;
                [self fields_Enable_Disable];
            }else if ([strDeviceEditMode isEqualToString:@"deviceImage"]){
                if ([strEncoded_ControllerImage isEqualToString:@""]) {
                    if([strDeviceType isEqualToString:@"others"]){
                        imgProfile.image = [UIImage imageNamed:@"dbigOther"];
                    }else{
                        imgProfile.image = [UIImage imageNamed:@"dbigLight"];
                    }
                    [deleteProfilebtn setHidden:YES];
                }else{
                    imgProfile.image=[UIImage imageWithData:[Base64 decode:strEncoded_ControllerImage]];
                    [deleteProfilebtn setHidden:NO];
                }
                strDeviceImage = strEncoded_ControllerImage;
            }

            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strDeviceUpdated_Status=@"YES"; //suppose navigate setting to noid logo need to reset this val
            [self stop_PinWheel_DeviceDetails];
//            [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_DeviceDetails];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Device Name Already Exists"];
                return;
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            
            if ([strDeviceEditMode isEqualToString:@"deviceImage"]){
                strEncoded_ControllerImage = strDeviceImage;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        // self.viewSetUp.userInteractionEnabled=YES;
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}


-(void)getDeviceScheduleList
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/deviceSchedules",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Device Schedule List==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_DeviceSchedule_List) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Device Schedule List ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)parse_DeviceSchedule_List
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrScheduleList = [[NSMutableArray alloc] init];
            arrScheduleList=[responseDict objectForKey:@"data"];
            NSLog(@"arr schedule list count==%lu",(unsigned long)arrScheduleList.count);
            arr_Schedule = [[NSMutableArray alloc] init];
            for(int index=0;index<[arrScheduleList count];index++)
            {
                NSMutableDictionary *dictScheduleData=[[NSMutableDictionary alloc] init];
                //Main Id
                NSLog(@"Main id common ==%@",[[arrScheduleList objectAtIndex:index] objectForKey:@"id"]);
                [dictScheduleData setObject:[[arrScheduleList objectAtIndex:index] objectForKey:@"id"] forKey:kSchMainID];
                
                
                //Over All Schedule
                NSDictionary *dictSchedule=[[arrScheduleList objectAtIndex:index] objectForKey:@"schedule"];
                
                //Sch ID
                [dictScheduleData setObject:[dictSchedule valueForKey:@"id"] forKey:kScheduleID];
                //Sch Name
                [dictScheduleData setObject:[dictSchedule valueForKey:@"scheduleName"] forKey:kscheduleName];
                
                //Get Over All Schedule Setting inside the Schedule
                NSDictionary *dictScheduleSettings=[dictSchedule valueForKey:@"scheduleSetting"];
                
                //Sch Settings ID
                [dictScheduleData setObject:[dictScheduleSettings valueForKey:@"id"] forKey:kScheduleSettingID];
                
                //Get Over All Schedule Time inside the schedule Settings
                NSDictionary *dictScheduleTime=[dictScheduleSettings valueForKey:@"scheduleTime"];
                //Sch Time ID
                [dictScheduleData setObject:[dictScheduleTime valueForKey:@"id"] forKey:kScheduleTimeID];
                //Sch Start Time
                [dictScheduleData setObject:[dictScheduleTime valueForKey:@"startTime"] forKey:kStartTime];
                //Sch End Time
                [dictScheduleData setObject:[dictScheduleTime valueForKey:@"endTime"] forKey:kEndTime];
                //Get Sch Category inside the Schedule Time
                NSDictionary *dictScheduleCat=[dictScheduleTime valueForKey:@"scheduleCategory"];
                //Sch Category ID
                [dictScheduleData setObject:[[dictScheduleCat valueForKey:@"id"] stringValue] forKey:kScheduleCategoryID];
                //Sch Category Code
                [dictScheduleData setObject:[dictScheduleCat valueForKey:@"scheduleCategoryCode"] forKey:kScheduleCategoryCode];
                [arr_Schedule addObject:dictScheduleData];
                NSLog(@"arra filter Conter Over all Schedule==%@",arr_Schedule);
            }
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([arr_Schedule count]>0 && [self.str_HasSchedule isEqualToString:@"NO"])
            {
                appDelegate.strScheduleAddedStatus=@"YES";
            }
            appDelegate.strTimeZoneChanged_Status=@"";
            if([arr_Schedule count]>0)
            {
                [self drawBodyContent_Schedule];
                
            }else{
                [self stop_PinWheel_DeviceDetails];
            }
        }else{
            self.view_AddSchedule.hidden=NO;
            self.view_VacationMode.hidden=NO;
            self.view_VacationMode.userInteractionEnabled=YES;
            self.btn_Info.hidden=NO;
            [self stop_PinWheel_DeviceDetails];
            if(![responseMessage isEqualToString:@"Device Schedule information is unavailable"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getScheduleDetail
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/deviceSchedules?deviceScheduleId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID,strSelected_SchID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Device Schedule Detail==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_DeviceSchedule_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Device Schedule Detail==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)parse_DeviceSchedule_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrScheduleList = [[NSMutableArray alloc] init];
            arrScheduleList=[responseDict objectForKey:@"data"];
            NSLog(@"arr device list count==%lu",(unsigned long)arrScheduleList.count);
            // arr_Schedule = [[NSMutableArray alloc] init];   //not need i think dictBody_Schedule
            dictGetSch_Content=[[NSMutableDictionary alloc] init];
            if([arrScheduleList count]>0)
            {
                //Main Id
                NSLog(@"Main id common ==%@",[[arrScheduleList objectAtIndex:0] objectForKey:@"id"]);
                [dictGetSch_Content setObject:[[arrScheduleList objectAtIndex:0] objectForKey:@"id"] forKey:kSchMainID];
                
                
                //Over All Schedule
                NSDictionary *dictSchedule=[[arrScheduleList objectAtIndex:0] objectForKey:@"schedule"];
                
                //Sch ID
                [dictGetSch_Content setObject:[dictSchedule valueForKey:@"id"] forKey:kScheduleID];
                //Sch Name
                [dictGetSch_Content setObject:[dictSchedule valueForKey:@"scheduleName"] forKey:kscheduleName];
                
                //Get Over All Schedule Setting inside the Schedule
                NSDictionary *dictScheduleSettings=[dictSchedule valueForKey:@"scheduleSetting"];
                
                //Sch Settings ID
                [dictGetSch_Content setObject:[dictScheduleSettings valueForKey:@"id"] forKey:kScheduleSettingID];
                
                //Get Over All Schedule Day inside the schedule Settings
                NSDictionary *dictScheduleDay=[dictScheduleSettings valueForKey:@"scheduleDay"];  //not need
                //Sch Day ID
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"id"] forKey:kScheduleDayID];
                //Sch Odd Day
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"oddDay"] forKey:kOddDay];
                //Sch Even Day
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"evenDay"] forKey:kEvenDay];
                //Sch SunDay
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"sunday"] forKey:kSun];
                //Sch Monday
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"monday"] forKey:kMon];
                //Sch Tuesday
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"tuesday"] forKey:kTue];
                //Sch Wednesday
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"wednesday"] forKey:kWed];
                //Sch Thursday
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"thursday"] forKey:kThr];
                //Sch Friday
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"friday"] forKey:kFri];
                //Sch Satuday
                [dictGetSch_Content setObject:[dictScheduleDay valueForKey:@"saturday"] forKey:kSat];
                
                
                //Get Over All Schedule Month inside the schedule Settings
                NSDictionary *dictScheduleMonth=[dictScheduleSettings valueForKey:@"scheduleMonth"];  //not need
                //Sch Month ID
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"id"] forKey:kScheduleMonthID];
                //Sch Jan
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"january"] forKey:kJan];
                //Sch Feb
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"february"] forKey:kFeb];
                //Sch Mar
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"march"] forKey:kMar];
                //Sch Apr
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"april"] forKey:kApr];
                //Sch May
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"may"] forKey:kMay];
                //Sch Jun
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"june"] forKey:kJun];
                //Sch Jly
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"july"] forKey:kJly];
                //Sch Aug
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"august"] forKey:kAug];
                //Sch Sep
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"september"] forKey:kSep];
                //Sch Oct
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"october"] forKey:kOct];
                //Sch Nov
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"november"] forKey:kNov];
                //Sch Dec
                [dictGetSch_Content setObject:[dictScheduleMonth valueForKey:@"december"] forKey:kDec];
                
                //Get Over All Schedule Time inside the schedule Settings
                NSDictionary *dictScheduleTime=[dictScheduleSettings valueForKey:@"scheduleTime"];
                //Sch Time ID
                [dictGetSch_Content setObject:[dictScheduleTime valueForKey:@"id"] forKey:kScheduleTimeID];
                //Sch Start Time
                [dictGetSch_Content setObject:[dictScheduleTime valueForKey:@"startTime"] forKey:kStartTime];
                //Sch End Time
                [dictGetSch_Content setObject:[dictScheduleTime valueForKey:@"endTime"] forKey:kEndTime];
                //Get Sch Category inside the Schedule Time
                NSDictionary *dictScheduleCat=[dictScheduleTime valueForKey:@"scheduleCategory"];
                //Sch Category ID
                [dictGetSch_Content setObject:[[dictScheduleCat valueForKey:@"id"] stringValue] forKey:kScheduleCategoryID];
                //Sch Category Code
                [dictGetSch_Content setObject:[dictScheduleCat valueForKey:@"scheduleCategoryCode"] forKey:kScheduleCategoryCode];
                NSLog(@"dict filter Conter spc  Schedule==%@",dictGetSch_Content);
                [self parseBodyScheduleWidget];
            }
        }else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)schedule_Add_DeviceDetailsUpdate
{
    NSLog(@"Sch Selected Content==%@",dictGetSch_Content);
    NSDictionary *parameters;
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/deviceSchedules?isAllowDuplicateSchedule=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID,strAllowDuplicate];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    
    NSMutableDictionary *dictSchedule_Details=[[NSMutableDictionary alloc] init];
    [dictSchedule_Details setObject:self.strDeviceID forKey:kDeviceID];
    NSLog(@"latest Name ==%@",[[arr_Schedule objectAtIndex:tag_Pos] valueForKey:kscheduleName]);
    //[dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kscheduleName] forKey:kscheduleName];
    [dictSchedule_Details setObject:[[arr_Schedule objectAtIndex:tag_Pos] valueForKey:kscheduleName] forKey:kscheduleName];
    [dictSchedule_Details setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID] forKey:kControllerID];
    if([strDeviceType isEqualToString:@"lights"]){
        [dictSchedule_Details setObject:@"1" forKey:kDeviceType];
    }else{
        [dictSchedule_Details setObject:@"3" forKey:kDeviceType];
    }
    
    
    [dictSchedule_Details setObject:strJan forKey:kJan];
    [dictSchedule_Details setObject:strFeb forKey:kFeb];
    [dictSchedule_Details setObject:strMar forKey:kMar];
    [dictSchedule_Details setObject:strApr forKey:kApr];
    [dictSchedule_Details setObject:strMay forKey:kMay];
    [dictSchedule_Details setObject:strJun forKey:kJun];
    [dictSchedule_Details setObject:strJly forKey:kJly];
    [dictSchedule_Details setObject:strAug forKey:kAug];
    [dictSchedule_Details setObject:strSep forKey:kSep];
    [dictSchedule_Details setObject:strOct forKey:kOct];
    [dictSchedule_Details setObject:strNov forKey:kNov];
    [dictSchedule_Details setObject:strDec forKey:kDec];
    [dictSchedule_Details setObject:strSun forKey:kSun];
    [dictSchedule_Details setObject:strMon forKey:kMon];
    [dictSchedule_Details setObject:strTue forKey:kTue];
    [dictSchedule_Details setObject:strWed forKey:kWed];
    [dictSchedule_Details setObject:strThr forKey:kThr];
    [dictSchedule_Details setObject:strFri forKey:kFri];
    [dictSchedule_Details setObject:strSat forKey:kSat];
    [dictSchedule_Details setObject:strOddDay forKey:kOddDay];
    [dictSchedule_Details setObject:strEvenDay forKey:kEvenDay]; //str_ScheduleCat_ID
    //[dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleCategoryID] forKey:kScheduleCategoryID];
    NSLog(@"strSelec id ==%@",strSelecteCategoryID);
    [dictSchedule_Details setObject:strSelecteCategoryID forKey:kScheduleCategoryID];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleMonthID] forKey:kScheduleMonthID];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleDayID] forKey:kScheduleDayID];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleTimeID] forKey:kScheduleTimeID];
    //
    [dictSchedule_Details setObject:startTime forKey:kStartTime];
    [dictSchedule_Details setObject:endTime forKey:kEndTime];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleSettingID] forKey:kScheduleSettingID];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleID] forKey:kScheduleID];
    // [dictSchedule_Details setObject:@"1" forKey:kScheduleMode];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kSchMainID] forKey:kSchMainID];
    
    NSLog(@"dict values going to update ==%@",dictSchedule_Details);
    parameters=[SCM scheduleUpdateDevice:dictSchedule_Details];
    NSLog(@"%@",parameters);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Schedule==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseupdate_Device_Schedule) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Schedule==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseupdate_Device_Schedule
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *newDatas=[responseDict valueForKey:@"data"];
            newDatas=[newDatas valueForKey:@"schedule"];
            // NSString *schName=[newDatas valueForKey:@"scheduleName"];
            newDatas=[newDatas valueForKey:@"scheduleSetting"];
            newDatas=[newDatas valueForKey:@"scheduleTime"];
            newDatas=[newDatas valueForKey:@"scheduleCategory"];
            NSString *strCatNewCode=[newDatas valueForKey:@"scheduleCategoryCode"];
            NSLog(@"new code ==%@",strCatNewCode);
            NSMutableArray *arrScheduleList = [[NSMutableArray alloc] init];
            NSMutableDictionary *dictSchedule_Details=[[NSMutableDictionary alloc] init];
            [dictSchedule_Details setObject:[[arr_Schedule objectAtIndex:tag_Pos] valueForKey:kscheduleName] forKey:kscheduleName];
            [dictSchedule_Details setObject:strCatNewCode forKey:kScheduleCategoryCode];
            [dictSchedule_Details setObject:strSelecteCategoryID forKey:kScheduleCategoryID];
            [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleTimeID] forKey:kScheduleTimeID];
            [dictSchedule_Details setObject:startTime forKey:kStartTime];
            [dictSchedule_Details setObject:endTime forKey:kEndTime];
            [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleSettingID] forKey:kScheduleSettingID];
            [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kScheduleID] forKey:kScheduleID];
            [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kSchMainID] forKey:kSchMainID];
            [arrScheduleList addObject:dictSchedule_Details];
            
            NSLog(@"arra filter Conter Over all Schedule==%@",arrScheduleList);
            
            NSLog(@"arr before replace ==%@",arr_Schedule);
            if([arrScheduleList count]>0)
            {
                [arr_Schedule replaceObjectAtIndex:tag_Pos withObject:[arrScheduleList objectAtIndex:0]];
                NSLog(@"arr after replace ==%@",arr_Schedule);
            }
            
            
            NSString *strTime=@"";
            if([strSelecteCategoryID isEqualToString:@"5"]){
                strTime=[NSString stringWithFormat:@"%@ To %@",startTime,endTime];
                lblSchedule_Time[tag_Pos].text=strTime;
            }else
            {
                lblSchedule_Time[tag_Pos].text=strCatNewCode;
            }
            
            if([strStatus_Schedule isEqualToString:@"YES"]){
                [lblSchedule[tag_Pos] setHidden:NO];
                [txt_Schedule[tag_Pos] setHidden:YES];
                [txt_Schedule[tag_Pos] resignFirstResponder];
                [btn_Close_Schedule[tag_Pos] setHidden:YES];
                [btn_Edit_Schedule[tag_Pos] setHidden:NO];
                strStatus_Schedule=@"NO";
                [btn_Save_Schedule[tag_Pos] setHidden:YES];
            }
            if([strAllowDuplicate isEqualToString:@"true"])
            {
                strAllowDuplicate=@"false";
            }
            [self collapseSchedule];
            [self stop_PinWheel_DeviceDetails];
            // [Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
        }else{
            [self stop_PinWheel_DeviceDetails];
            if([responseMessage isEqualToString:@"SCHEDULE_DUPLICATE"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NOID"
                                                                message:@"This schedule conflicts with an existing schedule, do you want to save anyway?"
                                                               delegate:self
                                                      cancelButtonTitle:@"YES"
                                                      otherButtonTitles:@"CANCEL",nil];
                alert.tag=1;
                [alert show];
                
            }
            else if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Schedule Name Already Exists"];
                return;
            }
            else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    
    [self stop_PinWheel_DeviceDetails];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag==1)
    {
        // the user clicked OK
        if (buttonIndex == 0) {
            // do something here...
            if([Common reachabilityChanged]==YES){
                strAllowDuplicate=@"true";
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(schedule_Add_DeviceDetailsUpdate) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

-(void)collapseSchedule
{
    if (viewTagValue==viewCurrent.tag) {
        self.view.userInteractionEnabled=NO;
        [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 43);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 55);
            }else{
                view_ScheduleCell[viewCurrent.tag].frame = CGRectMake(0, view_ScheduleCell[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 50);
            }
            yOffSet_Content=view_ScheduleCell[viewCurrent.tag].frame.origin.y+view_ScheduleCell[viewCurrent.tag].frame.size.height+5;
            for (int index=0;index<[arr_Schedule count];index++){
                if (index>[viewCurrent tag]) {
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 43);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 55);
                    }else{
                        view_ScheduleCell[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 50);
                    }
                    yOffSet_Content=view_ScheduleCell[index].frame.origin.y+view_ScheduleCell[index].frame.size.height+5;
                }
            }
            [self scroll_Footer_Setup:yOffSet_Content];
            [view_Schedule_ContentView[viewCurrent.tag] setHidden:YES];
            [view_Schedule_ContentView[viewCurrent.tag] removeFromSuperview];
            [self show_Schedule_Header:(int)viewTagValue];
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled=YES;
            cellExpandStatus=YES;
        }];
    }
}

-(void)deletScheduleService
{
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/deviceSchedules?deviceScheduleId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID,[dictGetSch_Content valueForKey:kSchMainID]];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for delete Schedule==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDelete_Device_Schedule) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for delete Schedule==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}
-(void)responseDelete_Device_Schedule
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self popUp_OLD_Configuration];
            NSLog(@"view tag value==%ld",(long)viewTagValue);
            for (int index=0;index<[arr_Schedule count];index++){
                [view_ScheduleCell[index] removeFromSuperview];
            }
            [arr_Schedule removeObjectAtIndex:viewTagValue];
            NSLog(@"%@",arr_Schedule);
            cellExpandStatus=YES;
            [self drawBodyContent_Schedule];
            if([arr_Schedule count]==0 && [self.str_HasSchedule isEqualToString:@"YES"])
            {
                strStatus=@"NO";
                appDelegate.strScheduleAddedStatus=@"YES";
            }
            else if([arr_Schedule count]==0)
            {
                strStatus=@"NO";
                if([appDelegate.strScheduleAddedStatus isEqualToString:@"YES"])
                {
                    appDelegate.strScheduleAddedStatus=@"";
                }
            }
//            if([arr_Schedule count]==0){
//                strStatus=@"NO";
//                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//                appDelegate.strDeviceUpdated_Status=@"YES";
//            }
            [self stop_PinWheel_DeviceDetails];
        }else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)schedule_ScheduleNameUpdate
{
    NSLog(@"Sch Selected Content==%@",dictGetSch_Content);
    NSDictionary *parameters;
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/deviceSchedules/profile",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID];
    NSLog(@"method name==%@",strMethodNameWith_Value);
    
    NSMutableDictionary *dictSchedule_Details=[[NSMutableDictionary alloc] init];
    [dictSchedule_Details setObject:[dictGetSch_Content valueForKey:kSchMainID] forKey:kSchMainID];
    [dictSchedule_Details setObject:txt_Schedule[tag_Pos].text forKey:kscheduleName];
    
    NSLog(@"dict values going to update sch name ==%@",dictSchedule_Details);
    parameters=[SCM updateScheduleName:dictSchedule_Details];
    NSLog(@"%@",parameters);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Schedule Name==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseScheduleNameUpdate) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Schedule Name==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseScheduleNameUpdate
{
    NSString *strName=txt_Schedule[tag_Pos].text;
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSLog(@"dict ==%@",[arr_Schedule objectAtIndex:tag_Pos]);
            [lblSchedule[tag_Pos] setHidden:NO];
            lblSchedule[tag_Pos].text=txt_Schedule[tag_Pos].text;
            [txt_Schedule[tag_Pos] setHidden:YES];
            [txt_Schedule[tag_Pos] resignFirstResponder];
            [btn_Close_Schedule[tag_Pos] setHidden:YES];
            [btn_Edit_Schedule[tag_Pos] setHidden:NO];
            strStatus_Schedule=@"NO";
            [btn_Save_Schedule[tag_Pos] setHidden:YES];
            [[arr_Schedule objectAtIndex:tag_Pos] setObject:strName forKey:kscheduleName];
            NSLog(@"dict ==%@",[arr_Schedule objectAtIndex:tag_Pos]);
            [self stop_PinWheel_DeviceDetails];
        }else{
            [self stop_PinWheel_DeviceDetails];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Schedule Name Already Exists"];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    [self stop_PinWheel_DeviceDetails];
}

-(void)update_Noid_DeviceCategory
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/profileType",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    NSDictionary *parameters;
    NSMutableDictionary *dictDeviceStatus=[[NSMutableDictionary alloc] init];
    [dictDeviceStatus setObject:self.strDeviceID forKey:kDeviceID];
    [dictDeviceStatus setObject:strDeviceCatType forKey:kDeviceStatus];
    
    parameters=[SCM device_Category_Update:dictDeviceStatus];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Device Category==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDeviceCategory) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Device Category==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
        //self.view.userInteractionEnabled=YES;
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseDeviceCategory
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            deviceCategoryView.hidden=YES;
            btn_close_categoryDevice.hidden=YES;
            btn_edit_category.hidden=NO;
            btn_save_categoryDevice.hidden=YES;
            strDeviceOldName=btn_DeviceCategory.currentTitle;
            [self changeCategotySetupDevice];
            if([strDeviceCategoryChangedStatus isEqualToString: @"NO"]){
                strDeviceCategoryChangedStatus = @"YES";
            }else{
                strDeviceCategoryChangedStatus = @"NO";
            }
            [self stop_PinWheel_DeviceDetails];
        }
        else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)update_DeviceMode
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/profileMode",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    NSDictionary *parameters;
    NSMutableDictionary *dictDeviceMode=[[NSMutableDictionary alloc] init];
    [dictDeviceMode setObject:self.strDeviceID forKey:kDeviceID];
    [dictDeviceMode setObject:strVactionStatusFlag forKey:kDeviceMode];
    
    
    parameters=[SCM device_Mode_Update:dictDeviceMode];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDeviceMode) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
    
}

-(void)responseDeviceMode
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            if (vacationModeStatus==YES) {
                strVacStatus=@"YES";
                if(cellExpandStatus==NO){
                    if([arr_Schedule count]>0){
                        [self resetSchedule];
                    }
                }
                [self changeVacationNewState];
            }else if (vacationModeStatus==NO){
                [self changeVacation_Mode_OldState];
                self.strDeviceMode=@"";
                strVacStatus=@"NO";
            }
            [self stop_PinWheel_DeviceDetails];
            NSLog(@"%@",self.strDeviceMode);
            appDelegate.strDeviceUpdated_Status=@"YES";  //need to change
        }
        else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)quoteForDowngradeDevice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/planQuote?quoteTypeId=2&deviceTypeId=2&controllerId=%@&deviceId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID];

    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Quote details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseForQuotePlanDowngradeDevice) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Quote details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseForQuotePlanDowngradeDevice
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSArray *arrPlanQuote;
            arrPlanQuote = [[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"lineItems"];
            NSLog(@"%@",arrPlanQuote);
            if([arrPlanQuote count]>=2)
            {
                NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"]);
                NSLog(@"Amount == %@",[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"]);
                float remAmt=[[[arrPlanQuote objectAtIndex:0] objectForKey:@"amount"] floatValue]+[[[arrPlanQuote objectAtIndex:1] objectForKey:@"amount"] floatValue];
                NSLog(@"remAmount =%f",remAmt);
                float Amount = fabs(remAmt/100);
                NSLog(@"remAmount =%f",Amount);
                self.lbl_PlanDowngrade_Charge.text=[NSString stringWithFormat:@"PLEASE NOTE THAT YOUR AMOUNT $%.2f WILL BE REFUNDED AND YOUR PLAN WILL BE DOWNGRADED.",Amount];
                [self.viewAlert_PlanDowngrade setHidden:YES];
                [self.viewAlert_PlanDowngrade_Confirm setHidden:NO];
            }else{
                [self.viewAlert_PlanDowngrade setHidden:YES];
                [self.viewAlert_PlanDowngrade_Confirm setHidden:NO];
            }
            NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
            strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
            [self stop_PinWheel_DeviceDetails];
            [self popUp_New_Configuration];
        }else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)quoteForDowngradeDeviceConfirmation
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing/planChange",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]];
    
    NSMutableDictionary *dict_Plan=[[NSMutableDictionary alloc] init];
    [dict_Plan setObject:@"2" forKey:kquoteTypeId];
    [dict_Plan setObject:@"2" forKey:kdeviceTypeId];
    [dict_Plan setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID] forKey:kControllerID];
    [dict_Plan setObject:self.strDeviceID forKey:kDeviceID];
    [dict_Plan setObject:strprorationTime forKey:kprorationDateTime];
    
    parameters=[SCM downgrade_Device_Plan:dict_Plan];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for downgrade plan device ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseDowngradePlanDevice) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for downgrade plan device ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}
-(void)responseDowngradePlanDevice
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self.viewAlert_PlanDowngrade_Confirm setHidden:YES];
            [self popUp_OLD_Configuration];
            [self stop_PinWheel_DeviceDetails];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strDevieDeleted_Status=@"YES";
            appDelegate.strAddNewSchedule=@"";
            appDelegate.strDeleteScheduleCount=@"";
            if(![strDeviceCategoryChangedStatus isEqualToString:@"NO"])
            {
                NSLog(@"pop up change lights to others and others to lights");
                appDelegate.strDevice_Added_Status=@"CATEGORY";
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)getZoneDetails_NOID
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/zones?zoneId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],strDeviceID,strZoneID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for view zone details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Zone_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for view zone details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)parse_Zone_Details
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrZoneDetails=[[NSMutableArray alloc] init];
            arrZoneDetails=[[responseDict valueForKey:@"data"]valueForKey:@"zoneDetails"];
            NSLog(@"%@",arrZoneDetails);
            strScheduleStatus=[[[responseDict valueForKey:@"data"]valueForKey:@"deviceMode"] objectForKey:@"deviceModeCode"];
            if([arrZoneDetails count]>0){
                NSMutableArray *arrZoneList = [[NSMutableArray alloc] init];
                arrZoneList = [[arrZoneDetails objectAtIndex:0] valueForKey:@"zoneList"];
                NSLog(@"%@",arrZoneList);
                lbl_HeaderName_lights.text=[[arrZoneList objectAtIndex:0] objectForKey:@"name"];
                lbl_deviceName_lights.text=[[arrZoneList objectAtIndex:0] objectForKey:@"name"];
                txtfld_DeviceName_Lights.text = lbl_deviceName_lights.text;
                if(![[[arrZoneList objectAtIndex:0] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
                    [self uiconfiguration_Profiles:[[arrZoneList objectAtIndex:0] objectForKey:@"thumbnailImage"]];
                    [deleteProfilebtn setHidden:NO];
                }else{
                    imgProfile.image = [UIImage imageNamed:@"dbigSprinkler"];
                    [deleteProfilebtn setHidden:YES];
                }
                latitude=[[arrZoneList objectAtIndex:0] objectForKey:@"latitude"];
                longitude=[[arrZoneList objectAtIndex:0] objectForKey:@"longitude"];
                self.lightsprofileView.hidden=NO;
                strHubActiveStatus=[[[arrZoneList objectAtIndex:0] objectForKey:@"zoneStatus"] objectForKey:@"code"];
                NSLog(@"hub current status ==%@",strHubActiveStatus);
                [self stop_PinWheel_DeviceDetails];
            }else{
                [self stop_PinWheel_DeviceDetails];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            [self stop_PinWheel_DeviceDetails];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
        //neeed to cahnge place
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)update_Zone_Details
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/zones",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],strDeviceID];
    NSDictionary *parameters;
    NSMutableDictionary *dictDeviceDetails=[[NSMutableDictionary alloc] init];
    [dictDeviceDetails setObject:self.strZoneID forKey:kZoneID];
    [dictDeviceDetails setObject:txtfld_DeviceName_Lights.text forKey:kZoneName];
    [dictDeviceDetails setObject:strEncoded_ControllerImage forKey:kZoneThumbnailImage];
    [dictDeviceDetails setObject:self.strZoneStatusID forKey:kZoneStatusID];
    [dictDeviceDetails setObject:self.strZoneLevel forKey:kZoneLevel];
    [dictDeviceDetails setObject:self.strZoneStatus forKey:kZoneStatus];

    parameters=[SCM update_Noid_Zone_Details:dictDeviceDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update zone Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUpdate_Zone_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update zone Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
        if ([strDeviceEditMode isEqualToString:@"deviceImage"]){
            strEncoded_ControllerImage = strDeviceImage;
        }
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseUpdate_Zone_Details
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            
            if ([strDeviceEditMode isEqualToString:@"name"]) {
                lbl_deviceName_lights.text = txtfld_DeviceName_Lights.text;
                lbl_HeaderName_lights.text = txtfld_DeviceName_Lights.text;
                [self fields_Enable_Disable];
            }else if ([strDeviceEditMode isEqualToString:@"deviceImage"]){
                if ([strEncoded_ControllerImage isEqualToString:@""]) {
                    imgProfile.image = [UIImage imageNamed:@"dbigSprinkler"];
                    [deleteProfilebtn setHidden:YES];
                }else{
                    imgProfile.image=[UIImage imageWithData:[Base64 decode:strEncoded_ControllerImage]];
                    [deleteProfilebtn setHidden:NO];
                }
                strDeviceImage = strEncoded_ControllerImage;
            }
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strDeviceUpdated_Status=@"YES"; //suppose navigate setting to noid logo need to reset this val
            [self stop_PinWheel_DeviceDetails];
        }else{
            [self stop_PinWheel_DeviceDetails];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Zone Name Already Exists"];
                return;
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            if ([strDeviceEditMode isEqualToString:@"deviceImage"]){
                strEncoded_ControllerImage = strDeviceImage;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteZoneDetails_NOID
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices/%@/zones?zoneId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strDeviceID,self.strZoneID];
    NSLog(@"path==%@",strMethodNameWith_Value);
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for zone Delete==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Delete_Zone_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for zone Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

-(void)parse_Delete_Zone_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strDevieDeleted_Status=@"YES";
            appDelegate.strAddNewSchedule=@"";
            appDelegate.strDeleteScheduleCount=@"";
            [self stop_PinWheel_DeviceDetails];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self stop_PinWheel_DeviceDetails];
            if([responseMessage isEqualToString:@"ACCT_DEVICE_MIN_LIMIT_REACHED"])
            {
                self.lbl_PlanDowngrade_Quote.text=@"WHEN DELETING THIS ZONE, YOUR PLAN WILL BE AUTOMATICALLY DOWNGRADED TO THE PREVIOUS TIER.";
                [self.viewAlert_PlanDowngrade setHidden:NO];
                [self popUp_New_Configuration];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
///accounts/1001/networks/1001/controllers/1001/zoneSchedules?zonId=1
-(void)getDevice_ZoneScheduleList
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice_Details=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/zoneSchedules?zoneId=%@",[defaultsDevice_Details objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID],self.strZoneID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for sprinkler zone schedule list==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseSpinklerZoneScheduleList) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for sprinkler zone schedule list ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceDetails) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorDeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseSpinklerZoneScheduleList
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arr_Schedule = [[NSMutableArray alloc] init];
            arr_Schedule = [[responseDict valueForKey:@"data"] valueForKey:@"zoneScheduleDetails"];
            NSLog(@"%@",arr_Schedule);
            NSLog(@"%lu",(unsigned long)[arr_Schedule count]);
            if ([arr_Schedule count]>0) {
                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                if([arr_Schedule count]>0 && [self.str_HasSchedule isEqualToString:@"NO"])
                {
                    appDelegate.strScheduleAddedStatus=@"YES";
                }
                appDelegate.strTimeZoneChanged_Status=@"";
                [self drawBodyContent_Schedule];
            }else{
                self.view_AddSchedule.hidden=NO;
                self.btn_Info.hidden=NO;
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btn_Info.frame = CGRectMake(204, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btn_Info.frame = CGRectMake(270, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    btn_Info.frame = CGRectMake(243, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
                }
                [self stop_PinWheel_DeviceDetails];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            if([self.strDeviceMode isEqualToString:@"VACATION"])
            {
                view_AddSchedule.backgroundColor=lblRGBA(88,89,91,1);
                view_AddSchedule.userInteractionEnabled=NO;
                view_AddSchedule.alpha=0.4;
            }
            self.view_AddSchedule.hidden=NO;
            self.btn_Info.hidden=NO;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btn_Info.frame = CGRectMake(204, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btn_Info.frame = CGRectMake(270, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btn_Info.frame = CGRectMake(243, btn_Info.frame.origin.y, btn_Info.frame.size.width, btn_Info.frame.size.height);
            }
            [self stop_PinWheel_DeviceDetails];
            if(![responseMessage isEqualToString:@"Zone schedule information unavailable"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceDetails];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}


#pragma mark - PinWheel Setup
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_DeviceDetails{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to stop the Progress HUD
 Method Name : stop_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)stop_PinWheel_DeviceDetails{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}


@end
