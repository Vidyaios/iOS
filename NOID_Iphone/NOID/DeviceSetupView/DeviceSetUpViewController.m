//
//  DeviceSetUpViewController.m
//  NOID
//
//  Created by iExemplar on 10/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "DeviceSetUpViewController.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "NetworkHomeViewController.h"
#import "SWRevealViewController.h"
#import "TimeLineViewController.h"
#import "MBProgressHUD.h"
#import "ServiceConnectorModel.h"
#import "Base64.h"
#import "Utils.h"
#import "LightScheduleViewController.h"
#import "MultipleNetworkViewController.h"

@interface DeviceSetUpViewController ()

@end

@implementation DeviceSetUpViewController
@synthesize viewDeviceInfo,viewDeviceInfo_Container,viewDeviceInfo_HeaderContent,viewDeviceInfo_ImageEdit,viewDeviceInfo_ImageGallery,viewDeviceInfo_SetUpSchedule,viewDeviceInfo_SkipSchedule,viewLightSetUp_Body,viewLightSetUp_Header,viewLightSetUp_QR,viewLightSetUp_QR_BodyContent,viewLightSetUp_QR_HeaderContent;
@synthesize scrollView_LightSetUp,lblDeviceEdit_Info_Wifi,lblEdit_QR_LightSetUp,txtfld_DeviceId_LightSetUp,txtfld_DeviceName_LightSetUp,imgView_Info,view_otherCategory,delegate,strDeviceType;
@synthesize btnHeader_LightOtherSetUp,backarrow_LightOtherSetUp,lblHeader_LightOtherSetUp,cameraSnap_LightOtherSetUp,album_LightOtherSetUp,lblDeviceId_LightOtherSetUp,lblScan_LightOtherSetUp,view_Proceed_LightOtherSetUp,lbl_DeviceInfoTabNo_LightOtherSetUp,lbl_ScanTabNo_LightOtherSetUp,view_DeviceInfo_Alert,viewDeviceInfo_BodyContent,btn_DeviceInfo_chargeMyCard,strBackStatus_LightSetUp,strPreviousView;
@synthesize strControllerStatus,strController_Added_ID,network_Data_Dict,viewDeviceInfo_SetupSkip_View;
@synthesize lbl_deviceImgName,captureSession_lightSetUp,viewLightSetUp_QRScanCode,videoPreviewLayer_lightSetUp,audioPlayer_lightSetUp,bodyView_QRScan_LightSetUp,viewAlert_PlanUpgrade_Confirm_device,viewAlert_PlanUpgrade_device,lbl_PlanUpgrade_Charge_device,strDeviceID,btn_Charge_device;

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"network data ==%@",network_Data_Dict);
    NSLog(@"controller id ==%@",strController_Added_ID);
    [self flagSetup_Lights_Device];
    [self initialSetUp_LightDeviceSetUp];
    [self scrollView_Configuration_LightSetUp];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(IBAction)lightSetUp_TapMenu_Action:(id)sender
{
    self.view.userInteractionEnabled=NO;
    [self check_LightSetUp_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if (lightSetUp_QR_ExpandedStatus==YES) {
                [self check_LightSetUp_TapAlreadyOpenedOrNot];
                [self expand_QR_View_lightSetUp];
            }else{
                [self collapse_QR_View_lightSetUp];
            }
            //[self scroll_LightSetUp_ReSet_And_Changes];
        }
            break;
        case 1:
        {
            if(lightSetUp_info_ExpandedStatus==YES){
                [self check_LightSetUp_TapAlreadyOpenedOrNot];
                [self expand_DeviceInfo_View_lightSetUp];
            }else{
                [self collapse_DeviceInfo_View_lightSetUp];
            }
            //[self scroll_LightSetUp_ReSet_And_Changes];
        }
            break;
    }
}

-(IBAction)lightSetUp_QR_ButtonAction:(id)sender
{
    
    [self check_LightSetUp_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Prceed QR Button
        {
            txtfld_DeviceId_LightSetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceId_LightSetUp.text];
            if(txtfld_DeviceId_LightSetUp.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter device id"];
                return;
            }
            if([Common reachabilityChanged]==YES){
                if([strDevice_Edit_Status isEqualToString:@"YES"]||imageStatus==YES){
                    [self reset_All_Widgets_Devices];
                }
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(checkLights_Others_Device_Availability) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //Cancel OR Button
        {
            [self collapse_QR_View_lightSetUp];
        }
            break;
        case 2:
        {
            if (!_isReading_lightSetUp) {
                if ([self startReading]) {
                    NSLog(@"scanning");
                }
            }
            else{
                [self stopReading];
                NSLog(@"stopped");
            }
            
            _isReading_lightSetUp = !_isReading_lightSetUp;
        }
            break;
    }
}

-(IBAction)lightSetUp_DeviceInfo_ButtonAction:(id)sender
{
    [self check_LightSetUp_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Prceed Connection Button
        {
            //self.view.userInteractionEnabled=NO;
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
        case 1: //Cancel Connection Button
        {
            //self.view.userInteractionEnabled=NO;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;[self presentViewController:picker animated:YES completion:^{}];
            
        }
            break;
        case 2:  //Edit action gallary
        {
            self.view.userInteractionEnabled=NO;
            [self reset_lightSetup_Gallary];
            imageStatus=NO;
            strEncoded_ControllerImag=@"";
        }
            break;
        case 4: //Cancel Connection Button
        {
            [self collapse_DeviceInfo_View_lightSetUp];
        }
            break;
        case 5:
            view_otherCategory.backgroundColor = lblRGBA(147, 149, 152, 1);
            break;
            //        case 6:
            //        {
            //            [self expand_AlertView_LightSetUp];
            //        }
            //            break;
        case 7:
        {
            strSave_Skip_Schedule=@"SaveSchedule";
            [self processSaveSchedule_SkipSchedule];

//            LightScheduleViewController *LSVC = [[LightScheduleViewController alloc] initWithNibName:@"LightScheduleViewController" bundle:nil];
//            LSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LightScheduleViewController"];
//            LSVC.strDeviceType_Schedule=strDeviceType;
//            if(![self.strBackStatus_LightSetUp isEqualToString:@"wifi"]){
//                LSVC.strPreviousView=@"DeviceSetup";
//            }else{
//                LSVC.strPreviousView=@"Wifi";
//                LSVC.strControllerStatus=self.strControllerStatus;
//            }
//            LSVC.strStatus_Schedule = strBackStatus_LightSetUp;
//            [Common viewFadeInSettings:self.navigationController.view];
//            [self.navigationController pushViewController:LSVC animated:NO];
        }
            break;
        case  8: //Proceed  Device Details
        {
//            txtfld_DeviceName_LightSetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_LightSetUp.text];
//            if(txtfld_DeviceName_LightSetUp.text.length==0){
//                [Common showAlert:@"Warning" withMessage:@"Please enter device name"];
//                return;
//            }
//            if([Common reachabilityChanged]==YES){
//                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
//                [self performSelectorInBackground:@selector(create_Lights_Others_Noid_Service) withObject:self];
//            }else{
//                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
//            }
            strSave_Skip_Schedule=@"SkipSchedule";
            [self processSaveSchedule_SkipSchedule];
        }
            break;
            //        case 9: //Cancel Device Details
            //        {
            //            [self collapse_DeviceInfo_View_lightSetUp];
            //        }
            //            break;
    }
}

-(void)processSaveSchedule_SkipSchedule
{
    txtfld_DeviceName_LightSetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_LightSetUp.text];
    if(txtfld_DeviceName_LightSetUp.text.length==0){
        [Common showAlert:@"Warning" withMessage:@"Please enter device name"];
        return;
    }
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
        if(![str_Device_Added isEqualToString:@"YES"]){
            [self performSelectorInBackground:@selector(create_Lights_Others_Noid_Service) withObject:self];
        }else{
            [self performSelectorInBackground:@selector(update_Noid_DeviceCards) withObject:self];
        }
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
    
}

-(IBAction)networkHome_Setting_LightOtherSetUp_Action:(id)sender
{
    [self check_LightSetUp_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (btnTag.tag) {
        case 0: //Back
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1: //Noid Logo
        {
            if ([appDelegate.strNoidLogo isEqualToString:@"NetworkHome"]) {
                [self processComplete_LightOther_DeviceSetUp];
            }else{
                [Common resetNetworkFlags];
                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                NSArray *newStack = @[NHVC];
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
            }
        }
            break;
        case 2: //settings
        {
            SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            // SVC.str_gear_Type=@"networkhome";
            if(![self.strBackStatus_LightSetUp isEqualToString:@"wifi"]){
                SVC.strPreviousView=@"DeviceSetup";
            }else{
                if([strControllerStatus isEqualToString:@"ControllerFirstTime"])
                {
                    SVC.strPreviousView=@"Cellular";
                    SVC.str_Cellular_FirstStatus=strControllerStatus;
                    
                }else{
                    SVC.strPreviousView=@"Wifi";
                }
            }
            [Common viewFadeInSettings:self.navigationController.view];
            [self.navigationController pushViewController:SVC animated:NO];
        }
    }
}

-(IBAction)planUpgrade_Confirmation_Device_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Plan Upgrade Okay
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForAdditionalDevice) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 1: //Plan Upgrade Cancel
        {
            self.viewAlert_PlanUpgrade_device.hidden=YES;
            [self popUp_DeviceSetUp_Alpha_Enabled];
            
        }
            break;
        case 2: //Charge My card
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(quoteForAdditionalDeviceConfirmation) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 3: // Confirmation Alert Cancel
        {
            self.viewAlert_PlanUpgrade_Confirm_device.hidden=YES;
            [self popUp_DeviceSetUp_Alpha_Enabled];
        }
            break;
    }
}

#pragma mark - User Defined Methods
-(void)flagSetup_Lights_Device
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    imageStatus=NO;
    categoryStatus=NO;
    strDevice_Edit_Status=@"";
    self.viewDeviceInfo.userInteractionEnabled=NO;
    str_Device_Added=@"";
    strEncoded_ControllerImag=@"";
    strprorationTime=@"";
}
-(void)initialSetUp_LightDeviceSetUp
{
    txtfld_DeviceId_LightSetUp.delegate=self;
    txtfld_DeviceId_LightSetUp.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtfld_DeviceId_LightSetUp.leftView = paddingView;
    txtfld_DeviceId_LightSetUp.leftViewMode = UITextFieldViewModeAlways;

    txtfld_DeviceName_LightSetUp.delegate=self;
    [txtfld_DeviceName_LightSetUp setValue:lblRGBA(0, 0, 0, 1) forKeyPath:@"_placeholderLabel.textColor"];
    txtfld_DeviceName_LightSetUp.clearButtonMode = UITextFieldViewModeWhileEditing;

    //QRView SetUp
    lblEdit_QR_LightSetUp.hidden=YES;
    lightSetUp_QR_ExpandedStatus=NO;
    
    //Device Info Setup
    lblDeviceEdit_Info_Wifi.hidden=YES;
    lightSetUp_info_ExpandedStatus=YES;
    self.viewDeviceInfo_Container.hidden=YES;
    self.viewDeviceInfo_ImageEdit.hidden=YES;
    self.view_DeviceInfo_Alert.hidden=YES;
    
    [imgView_Info.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [imgView_Info.layer setBorderWidth:1.0];
    
    strDeviceInfo_ExpandStatus=@"";
    
    if ([strDeviceType isEqualToString:@"others"]) {
        [backarrow_LightOtherSetUp setImage:[UIImage imageNamed:@"blueBackBtni6plus"] forState:UIControlStateNormal];
        [btnHeader_LightOtherSetUp setTitle:@"OTHER" forState:UIControlStateNormal];
        [btnHeader_LightOtherSetUp setTitleColor:lblRGBA(49, 165, 222, 1) forState:UIControlStateNormal];
        [cameraSnap_LightOtherSetUp setBackgroundColor:lblRGBA(49, 165, 222, 1)];
        [album_LightOtherSetUp setBackgroundColor:lblRGBA(49, 165, 222, 1)];
        lblHeader_LightOtherSetUp.text = @"OTHER DEVICE SET-UP";
        [viewDeviceInfo_SetUpSchedule setBackgroundColor:lblRGBA(49, 165, 222, 1)];
        view_Proceed_LightOtherSetUp.backgroundColor = lblRGBA(49, 165, 222, 1);
        lbl_ScanTabNo_LightOtherSetUp.backgroundColor = lblRGBA(49, 165, 222, 1);
        lbl_DeviceInfoTabNo_LightOtherSetUp.backgroundColor = lblRGBA(49, 165, 222, 1);
        lblScan_LightOtherSetUp.textColor = lblRGBA(49, 165, 222, 1);
        lblDeviceId_LightOtherSetUp.textColor = lblRGBA(49, 165, 222, 1);
        btn_DeviceInfo_chargeMyCard.backgroundColor = lblRGBA(49, 165, 222, 1);
    }
    bodyView_QRScan_LightSetUp.hidden=YES;
    captureSession_lightSetUp = nil;
    _isReading_lightSetUp = NO;
    self.viewAlert_PlanUpgrade_device.hidden=YES;
    self.viewAlert_PlanUpgrade_Confirm_device.hidden=YES;
}

-(void)scrollView_Configuration_LightSetUp
{
    scrollView_LightSetUp.showsHorizontalScrollIndicator=NO;
    scrollView_LightSetUp.scrollEnabled=YES;
    scrollView_LightSetUp.userInteractionEnabled=YES;
    scrollView_LightSetUp.delegate=self;
}

-(void)check_LightSetUp_WidgetDismissORNot
{
    if([txtfld_DeviceId_LightSetUp resignFirstResponder]){
        [txtfld_DeviceId_LightSetUp resignFirstResponder];
    }else if([txtfld_DeviceName_LightSetUp resignFirstResponder]){
        [txtfld_DeviceName_LightSetUp resignFirstResponder];
    }
}

-(void)scroll_LightSetUp_ReSet_And_Changes{
    self.scrollView_LightSetUp.contentSize=CGSizeMake(self.scrollView_LightSetUp.frame.size.width, self.viewDeviceInfo.frame.origin.y+self.viewDeviceInfo.frame.size.height+20);
}

-(void)check_LightSetUp_TapAlreadyOpenedOrNot{
    if (lightSetUp_QR_ExpandedStatus==NO) {
        [self collapse_QR_View_lightSetUp];
    }else if(lightSetUp_info_ExpandedStatus==NO){
        [self collapse_DeviceInfo_View_lightSetUp];
    }
}

-(void)expand_QR_View_lightSetUp
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewLightSetUp_QR.frame=CGRectMake(self.viewLightSetUp_QR.frame.origin.x, self.viewLightSetUp_QR.frame.origin.y, self.viewLightSetUp_QR.frame.size.width, self.viewLightSetUp_QR_BodyContent.frame.origin.y+self.viewLightSetUp_QR_BodyContent.frame.size.height);
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewLightSetUp_QR.frame.origin.y+self.viewLightSetUp_QR.frame.size.height+5, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo.frame.size.height);
        lblEdit_QR_LightSetUp.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewLightSetUp_QR_BodyContent.hidden=NO;
        lightSetUp_QR_ExpandedStatus=NO;
        [self scroll_LightSetUp_ReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
        
    }];
}

-(void)collapse_QR_View_lightSetUp
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewLightSetUp_QR_BodyContent.hidden=YES;
        self.viewLightSetUp_QR.frame=CGRectMake(self.viewLightSetUp_QR.frame.origin.x, self.viewLightSetUp_QR.frame.origin.y, self.viewLightSetUp_QR.frame.size.width, self.viewLightSetUp_QR_HeaderContent.frame.size.height);
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewLightSetUp_QR.frame.origin.y+self.viewLightSetUp_QR.frame.size.height+5, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo.frame.size.height);
    } completion:^(BOOL finished) {
        lightSetUp_QR_ExpandedStatus=YES;
        lblEdit_QR_LightSetUp.hidden=NO;
        [self scroll_LightSetUp_ReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)expand_DeviceInfo_View_lightSetUp
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
        lblDeviceEdit_Info_Wifi.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewDeviceInfo_Container.hidden=NO;
        self.viewDeviceInfo_BodyContent.hidden=NO;
        lightSetUp_info_ExpandedStatus=NO;
        [self scroll_LightSetUp_ReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}



-(void)collapse_DeviceInfo_View_lightSetUp
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(imageStatus==YES)
        {
            self.viewDeviceInfo_SetupSkip_View.frame=CGRectMake(self.viewDeviceInfo_SetupSkip_View.frame.origin.x, self.viewDeviceInfo_ImageEdit.frame.origin.y+self.viewDeviceInfo_ImageEdit.frame.size.height+5,self.viewDeviceInfo_SetupSkip_View.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.size.height);
            self.viewDeviceInfo_BodyContent.frame=CGRectMake(self.viewDeviceInfo_BodyContent.frame.origin.x,self.viewDeviceInfo_BodyContent.frame.origin.y,self.viewDeviceInfo_BodyContent.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.origin.y+self.viewDeviceInfo_SetupSkip_View.frame.size.height+5);
            self.viewDeviceInfo_Container.frame=CGRectMake(self.viewDeviceInfo_Container.frame.origin.x, self.viewDeviceInfo_Container.frame.origin.y, self.viewDeviceInfo_Container.frame.size.width,self.viewDeviceInfo_BodyContent.frame.origin.y+self.viewDeviceInfo_BodyContent.frame.size.height);
            self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
        }
        else{
            self.viewDeviceInfo_SetupSkip_View.frame=CGRectMake(self.viewDeviceInfo_SetupSkip_View.frame.origin.x, self.viewDeviceInfo_ImageGallery.frame.origin.y+self.viewDeviceInfo_ImageGallery.frame.size.height+5,self.viewDeviceInfo_SetupSkip_View.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.size.height);
            self.viewDeviceInfo_BodyContent.frame=CGRectMake(self.viewDeviceInfo_BodyContent.frame.origin.x,self.viewDeviceInfo_BodyContent.frame.origin.y,self.viewDeviceInfo_BodyContent.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.origin.y+self.viewDeviceInfo_SetupSkip_View.frame.size.height+5);
            self.viewDeviceInfo_Container.frame=CGRectMake(self.viewDeviceInfo_Container.frame.origin.x, self.viewDeviceInfo_Container.frame.origin.y, self.viewDeviceInfo_Container.frame.size.width,self.viewDeviceInfo_BodyContent.frame.origin.y+self.viewDeviceInfo_BodyContent.frame.size.height);
            self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
        }
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width,self.viewDeviceInfo_HeaderContent.frame.size.height);
        self.viewDeviceInfo_Container.hidden=YES;
    } completion:^(BOOL finished) {
        lightSetUp_info_ExpandedStatus=YES;
        lblDeviceEdit_Info_Wifi.hidden=NO;
        [self resetset_DeviceInfo_Widgets];
        [self scroll_LightSetUp_ReSet_And_Changes];
        //strDeviceInfo_ExpandStatus=@"YES";
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)resetset_DeviceInfo_Widgets{
    if(imageStatus==YES){
        self.viewDeviceInfo_ImageGallery.hidden=YES;
        self.viewDeviceInfo_ImageEdit.hidden=NO;
    }else{
        self.viewDeviceInfo_ImageGallery.hidden=NO;
        self.viewDeviceInfo_ImageEdit.hidden=YES;
    }
}

-(void)reset_lightSetup_Gallary{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewDeviceInfo_ImageEdit.hidden=YES;
        self.viewDeviceInfo_ImageGallery.hidden=NO;
        self.imgView_Info.image=nil;
        self.viewDeviceInfo_SetupSkip_View.frame=CGRectMake(self.viewDeviceInfo_SetupSkip_View.frame.origin.x, self.viewDeviceInfo_ImageGallery.frame.origin.y+self.viewDeviceInfo_ImageGallery.frame.size.height+5,self.viewDeviceInfo_SetupSkip_View.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.size.height);
        self.viewDeviceInfo_BodyContent.frame=CGRectMake(self.viewDeviceInfo_BodyContent.frame.origin.x,self.viewDeviceInfo_BodyContent.frame.origin.y,self.viewDeviceInfo_BodyContent.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.origin.y+self.viewDeviceInfo_SetupSkip_View.frame.size.height+5);
        self.viewDeviceInfo_Container.frame=CGRectMake(self.viewDeviceInfo_Container.frame.origin.x, self.viewDeviceInfo_Container.frame.origin.y, self.viewDeviceInfo_Container.frame.size.width,self.viewDeviceInfo_BodyContent.frame.origin.y+self.viewDeviceInfo_BodyContent.frame.size.height);
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
    } completion:^(BOOL finished) {
        [self scroll_LightSetUp_ReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}
-(void)reset_All_Widgets_Devices
{
    if([strDevice_Edit_Status isEqualToString:@"YES"]){
        txtfld_DeviceName_LightSetUp.text=@"";
        strDevice_Edit_Status=@"";
    }
    if(imageStatus==YES){
        self.viewDeviceInfo_ImageEdit.hidden=YES;
        self.viewDeviceInfo_ImageGallery.hidden=NO;
        self.imgView_Info.image=nil;
        imageStatus=NO;
        self.viewDeviceInfo_SetupSkip_View.frame=CGRectMake(self.viewDeviceInfo_SetupSkip_View.frame.origin.x, self.viewDeviceInfo_ImageGallery.frame.origin.y+self.viewDeviceInfo_ImageGallery.frame.size.height+5,self.viewDeviceInfo_SetupSkip_View.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.size.height);
        self.viewDeviceInfo_BodyContent.frame=CGRectMake(self.viewDeviceInfo_BodyContent.frame.origin.x,self.viewDeviceInfo_BodyContent.frame.origin.y,self.viewDeviceInfo_BodyContent.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.origin.y+self.viewDeviceInfo_SetupSkip_View.frame.size.height+5);
        self.viewDeviceInfo_Container.frame=CGRectMake(self.viewDeviceInfo_Container.frame.origin.x, self.viewDeviceInfo_Container.frame.origin.y, self.viewDeviceInfo_Container.frame.size.width,self.viewDeviceInfo_BodyContent.frame.origin.y+self.viewDeviceInfo_BodyContent.frame.size.height);
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
    }
}

-(void)expand_AlertView_LightSetUp
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewDeviceInfo_BodyContent.hidden=YES;
        self.viewDeviceInfo_Container.frame=CGRectMake(self.viewDeviceInfo_Container.frame.origin.x, self.viewDeviceInfo_Container.frame.origin.y, self.viewDeviceInfo_Container.frame.size.width,self.view_DeviceInfo_Alert.frame.origin.y+self.view_DeviceInfo_Alert.frame.size.height);
        self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
        lblDeviceEdit_Info_Wifi.hidden=YES;
    } completion:^(BOOL finished) {
        view_DeviceInfo_Alert.hidden=NO;
        self.viewDeviceInfo_Container.hidden=NO;
        lightSetUp_info_ExpandedStatus=NO;
        [self scroll_LightSetUp_ReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

/* **********************************************************************************
 Date : 22/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Protocal call
 Method Name : processCompleteLights(User Defined Methods)
 ************************************************************************************* */
- (void)processComplete_LightOther_DeviceSetUp
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strDevice_Added_Status isEqualToString:@"OLDPOPUPLOAD"])
    {
        appDelegate.strDevice_Added_Status=@"REMOVEPOPUPLOAD";
    }
    [[self delegate] processSuccessful_Back_To_NetworkHome_Via_DeviceSetUp:YES];
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    captureSession_lightSetUp = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [captureSession_lightSetUp addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession_lightSetUp addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    videoPreviewLayer_lightSetUp = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession_lightSetUp];
    [videoPreviewLayer_lightSetUp setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer_lightSetUp setFrame:viewLightSetUp_QRScanCode.layer.bounds];
    [viewLightSetUp_QRScanCode.layer addSublayer:videoPreviewLayer_lightSetUp];
    bodyView_QRScan_LightSetUp.hidden=NO;
    // Start video capture.
    [captureSession_lightSetUp startRunning];
    return YES;
}

-(void)stopReading{
    [captureSession_lightSetUp stopRunning];
    captureSession_lightSetUp = nil;
    [videoPreviewLayer_lightSetUp removeFromSuperlayer];
    txtfld_DeviceId_LightSetUp.text = strScanCode;
    bodyView_QRScan_LightSetUp.hidden=YES;
}

-(void)popUp_DeviceSetUp_Alpha_Enabled
{
    [self.viewLightSetUp_Header setAlpha:1.0];
    [self.viewLightSetUp_Body setAlpha:1.0];
}

-(void)popUp_DeviceSetUp_Alpha_Disabled
{
    [self.viewLightSetUp_Header setAlpha:0.6];
    [self.viewLightSetUp_Body setAlpha:0.6];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSLog(@"%@",[metadataObj stringValue]);
            strScanCode = [NSString stringWithFormat:@"%@",[metadataObj stringValue]];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading_lightSetUp = NO;
            if (audioPlayer_lightSetUp) {
                [audioPlayer_lightSetUp play];
            }
        }
    }
}

#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date : 22/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==txtfld_DeviceName_LightSetUp){
        strDevice_Edit_Status=@"YES";
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
    NSLog(@"string === %@",string);
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"whole string === %@",proposedNewString);
    if(textField==txtfld_DeviceName_LightSetUp)
    {
        NSUInteger newLength = [txtfld_DeviceName_LightSetUp.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }
    else if (textField==txtfld_DeviceId_LightSetUp){
        NSUInteger newLength = [txtfld_DeviceId_LightSetUp.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICEID] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldIDLimit));
    }
    return YES;
}

/* **********************************************************************************
 Date : 22/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the return button on the keyboard is clicked
 Method Name : textFieldShouldReturn(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text=@"";
    return NO;
}
#pragma mark - Orientation
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
    //return here which orientation you are going to support
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [self.navigationController pushViewController:TLVC animated:NO];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
}

#pragma mark - Image Picker Delegtes
/* **********************************************************************************
 Date : 16/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Image Saved To Album
 Description : after capture Image/Video its saved to album
 Method Name : hasBeenSavedInPhotoAlbumWithError (Media Picker Delegate Method)
 ************************************************************************************* */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *img =  [info objectForKey:UIImagePickerControllerEditedImage];
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), nil);
            
            CGSize imgScalling;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgScalling = [Common imageScalling:img withScalingDetails:96 and:60];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgScalling = [Common imageScalling:img withScalingDetails:133 and:73];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgScalling = [Common imageScalling:img withScalingDetails:113 and:68];
            }
            img = [Common imageWithImage:img scaledToSize:imgScalling];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.05);
            NSLog(@"Size of big image = %lu KB",(imageData.length/1024));
            imgView_Info.image=[[UIImage alloc]initWithData:imageData];
        }else{
            UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            [imgView_Info.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [imgView_Info.layer setBorderWidth:1.0];
            
            CGSize imgScalling;
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgScalling = [Common imageScalling:image withScalingDetails:96 and:60];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgScalling = [Common imageScalling:image withScalingDetails:133 and:73];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgScalling = [Common imageScalling:image withScalingDetails:113 and:68];
            }
            image = [Common imageWithImage:image scaledToSize:imgScalling];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
            NSLog(@"Size of big image = %lu KB",(imageData.length/1024));
            imgView_Info.image=[[UIImage alloc]initWithData:imageData];
        }
        NSData* data = UIImageJPEGRepresentation(imgView_Info.image, 0.3f);
        strEncoded_ControllerImag = [Base64 encode:data];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        imageStatus=YES;
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [viewDeviceInfo_ImageGallery setHidden:YES];
            [viewDeviceInfo_ImageEdit setHidden:NO];
            self.viewDeviceInfo_SetupSkip_View.frame=CGRectMake(self.viewDeviceInfo_SetupSkip_View.frame.origin.x, self.viewDeviceInfo_ImageEdit.frame.origin.y+self.viewDeviceInfo_ImageEdit.frame.size.height+5,self.viewDeviceInfo_SetupSkip_View.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.size.height);
            self.viewDeviceInfo_BodyContent.frame=CGRectMake(self.viewDeviceInfo_BodyContent.frame.origin.x,self.viewDeviceInfo_BodyContent.frame.origin.y ,self.viewDeviceInfo_BodyContent.frame.size.width, self.viewDeviceInfo_SetupSkip_View.frame.origin.y+self.viewDeviceInfo_SetupSkip_View.frame.size.height+5);
            self.viewDeviceInfo_Container.frame=CGRectMake(self.viewDeviceInfo_Container.frame.origin.x, self.viewDeviceInfo_Container.frame.origin.y, self.viewDeviceInfo_Container.frame.size.width,self.viewDeviceInfo_BodyContent.frame.origin.y+self.viewDeviceInfo_BodyContent.frame.size.height);
            self.viewDeviceInfo.frame=CGRectMake(self.viewDeviceInfo.frame.origin.x, self.viewDeviceInfo.frame.origin.y, self.viewDeviceInfo.frame.size.width, self.viewDeviceInfo_Container.frame.origin.y+self.viewDeviceInfo_Container.frame.size.height);
            //[self checkDeviceIsAddedOrNot];
        } completion:^(BOOL finished) {
            [self scroll_LightSetUp_ReSet_And_Changes];
            self.view.userInteractionEnabled=YES;
        }];
    }
}

/* **********************************************************************************
 Date : 16/09/2015
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
////        lbl_deviceImgName.text = @"asset.JPG";
//        [alert show];
//    }
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    // Request to save the image to camera roll
//    [library writeImageToSavedPhotosAlbum:[imgView_Info.image CGImage] orientation:(ALAssetOrientation)[imgView_Info.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//        if (error) {
//            NSLog(@"error");
//        } else {
//            NSLog(@"url %@", [assetURL lastPathComponent]);
//        }
//        lbl_deviceImgName.text = [assetURL lastPathComponent];
//    }];
}
#pragma mark - WebService Implementation
-(void)checkLights_Others_Device_Availability
{
    defaultsDevice=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/deviceTrace?traceCode=%@",[defaultsDevice objectForKey:@"ACCOUNTID"],[txtfld_DeviceId_LightSetUp.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Lights_Others Availability==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseLights_Others_Availability) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Lights_Others Availability ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorLights_Others_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseLights_Others_Availability
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT Device Data ==%@",dicitData);
            NSLog(@"DIC Device Data  count==%lu",(unsigned long)dicitData.count);
            NSLog(@"DeviceTraceCode ==%@",[dicitData valueForKey:@"deviceTraceCode"]);
            if([dicitData count]>0)
            {
                NSDictionary *dicit_Type=[dicitData valueForKey:@"deviceType"];
                NSLog(@"device type ==%@",dicit_Type);
                NSString *strTypeCode=[dicit_Type valueForKey:@"code"];
                strDevice_TraceID=[[dicitData valueForKey:@"id"] stringValue];
                [self stop_PinWheel_DeviceAdded];
                if([strTypeCode isEqualToString:@"LIGHT"]&&[strDeviceType isEqualToString:@"lights"])
                {
                    //go ahead
                    
                    [self collapse_QR_View_lightSetUp];
                    [self expand_DeviceInfo_View_lightSetUp];
                    self.viewDeviceInfo.userInteractionEnabled=YES;
                }
                else if([strTypeCode isEqualToString:@"OTHERS"]&&[strDeviceType isEqualToString:@"others"])
                {
                    //go ahead
                    
                    [self collapse_QR_View_lightSetUp];
                    [self expand_DeviceInfo_View_lightSetUp];
                    self.viewDeviceInfo.userInteractionEnabled=YES;
                }
                else{
                    [Common showAlert:kAlertTitleWarning withMessage:@"Invalid Device"];
                }
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self stop_PinWheel_DeviceAdded];
            }
        }else{
            [self stop_PinWheel_DeviceAdded];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceAdded];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    
}
-(void)responseErrorLights_Others_Device_Setup
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}

-(void)create_Lights_Others_Noid_Service
{
    NSString *strType=@"";
    if([strDeviceType isEqualToString:@"others"])
    {
        strType=@"3";
    }else{
        strType=@"1";
    }
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"device trace id ==%@",strDevice_TraceID);
    defaultsDevice=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices",[defaultsDevice objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    
    NSDictionary *parameters;
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:txtfld_DeviceName_LightSetUp.text forKey:kDeviceName];
    [dictController_Device_Details setObject:@"" forKey:kDeviceImage];
    [dictController_Device_Details setObject:strEncoded_ControllerImag forKey:KThumbnailImage];
    [dictController_Device_Details setObject:strDevice_TraceID forKey:kDeviceTraceID];
    [dictController_Device_Details setObject:@"1" forKey:kDeviceMode];  // 1 Means Active
    [dictController_Device_Details setObject:@"2" forKey:kDeviceStatus];  // 2 Indicate Manual Off
    [dictController_Device_Details setObject:strType forKey:kDeviceType];
    
    parameters=[SCM add_Lights_Others_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for add lights others device==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAdded_Device_LightsOthers) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for add lights others device ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorLights_Others_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
}

-(void)responseAdded_Device_LightsOthers
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSLog(@"DICT Device Data ==%@",dicitData);
            NSLog(@"DIC Device Data  count==%lu",(unsigned long)dicitData.count);
            if([dicitData count]>0)
            {
                str_Saved_DeviceID=[dicitData objectForKey:@"id"];
                str_Device_Added=@"YES";
                NSLog(@"Device ID ==%@",str_Saved_DeviceID);
                [self stop_PinWheel_DeviceAdded];
                if([strSave_Skip_Schedule isEqualToString:@"SaveSchedule"]){
                    [self navigateSchedule];
                }else{
                    [self navigateHome];
                }
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self stop_PinWheel_DeviceAdded];
            }
        }else{
            [self stop_PinWheel_DeviceAdded];
            if([responseMessage isEqualToString:@"ACCT_DEVICE_MAX_LIMIT_REACHED"])
            {
                [self.viewAlert_PlanUpgrade_device setHidden:NO];
                [self popUp_DeviceSetUp_Alpha_Disabled];
                return;
            }
            else if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Device Name Already Exists"];
                return;
            }else if ([responseMessage isEqualToString:@"APP_DEVICE_MAX_LIMIT_REACHED"]){
                [Common showAlert:kAlertTitleWarning withMessage:@"Sorry! You Have Already Reached Your Maximum Limit."];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceAdded];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)navigateSchedule
{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strDevice_Added_Mode isEqualToString:@"MultipleNetwork"])
    {
        appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
        appDelegate.strAddedDevice_Type=self.strDeviceType;
    }else if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
    { //network home
        appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
        appDelegate.strAddedDevice_Type=self.strDeviceType;
    }else{
        //Reg Or Signin
        appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
        appDelegate.strAddedDevice_Type=self.strDeviceType;
    }
    LightScheduleViewController *LSVC = [[LightScheduleViewController alloc] initWithNibName:@"LightScheduleViewController" bundle:nil];
    LSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LightScheduleViewController"];
    LSVC.strDeviceType_Schedule=strDeviceType;
    LSVC.strDeviceID=str_Saved_DeviceID;
    [Common viewFadeInSettings:self.navigationController.view];
    [self.navigationController pushViewController:LSVC animated:NO];
}

-(void)navigateHome
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Str Device Added Mode ==%@",appDelegate.strDevice_Added_Mode);
    if([appDelegate.strDevice_Added_Mode isEqualToString:@"NetworkHome"])
    { //network home
        appDelegate.strDevice_Added_Status=@"OLDPOPUPLOAD";
        appDelegate.strAddedDevice_Type=self.strDeviceType;
        [self.navigationController popViewControllerAnimated:YES];
        //[self processComplete_LightOther_DeviceSetUp];
    }else{
        //Reg Or Signin Or AnyOther Page
        appDelegate.strDevice_Added_Status=@"NEWPOPUPLOAD";
        appDelegate.strAddedDevice_Type=self.strDeviceType;
        SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
        NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        NSArray *newStack = @[NHVC];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController setViewControllers:newStack animated:NO];
    }
}

-(void)update_Noid_DeviceCards
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DIC Netowkr Data Count ==%lu",(unsigned long)appDelegate.dict_NetworkControllerDatas);
    NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers/%@/devices",[defaultsDevice objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];
    NSDictionary *parameters;
    NSMutableDictionary *dictDeviceDetails=[[NSMutableDictionary alloc] init];
    [dictDeviceDetails setObject:str_Saved_DeviceID forKey:kDeviceID];
    [dictDeviceDetails setObject:txtfld_DeviceName_LightSetUp.text forKey:kDeviceName];
    [dictDeviceDetails setObject:@"" forKey:kDeviceImage];
    [dictDeviceDetails setObject:strEncoded_ControllerImag forKey:KThumbnailImage];
    [dictDeviceDetails setObject:strDevice_TraceID forKey:kDeviceTraceID];
    
    parameters=[SCM update_Noid_Device_Details:dictDeviceDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseupdate_Device_DetailsCard) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorLights_Others_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseupdate_Device_DetailsCard
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self stop_PinWheel_DeviceAdded];
            if([strSave_Skip_Schedule isEqualToString:@"SaveSchedule"]){
                [self navigateSchedule];
            }else{
                [self navigateHome];
            }
        }else{
            [self stop_PinWheel_DeviceAdded];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Device Name Already Exists"];
                return;
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        // self.viewSetUp.userInteractionEnabled=YES;
        [self stop_PinWheel_DeviceAdded];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)quoteForAdditionalDevice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsDevice=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/billing/planQuote?quoteTypeId=1&deviceTypeId=2&controllerId=%@",[defaultsDevice objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]];

    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Device Quote details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseForDeviceQuotePlanUpgrade) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Device Quote details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorLights_Others_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseForDeviceQuotePlanUpgrade
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
                float Amount = remAmt/100;
                NSLog(@"remAmount =%f",Amount);
                self.lbl_PlanUpgrade_Charge_device.text=[NSString stringWithFormat:@"YOU WILL BE AUTOMATICALLY CHARGED $%.2f FOR THE PLAN %@.",Amount,[[[responseDict valueForKey:@"data"] objectForKey:@"billingPlan"] objectForKey:@"billingPlanName"]];
                [self.viewAlert_PlanUpgrade_device setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_device setHidden:NO];
            }else{
                [self.viewAlert_PlanUpgrade_device setHidden:YES];
                [self.viewAlert_PlanUpgrade_Confirm_device setHidden:NO];
            }
            
            NSLog(@"%@",[[responseDict valueForKey:@"data"] objectForKey:@"billingUserFirstName"]);
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if ([appDelegate.strOwnerNetwork_Status isEqualToString:@"NO"]) {
                [btn_Charge_device setTitle:[NSString stringWithFormat:@"CHARGE %@'s CARD",[[responseDict valueForKey:@"data"] objectForKey:@"billingUserFirstName"]] forState:UIControlStateNormal];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    btn_Charge_device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:11];
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    btn_Charge_device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:14];
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    btn_Charge_device.titleLabel.font = [UIFont fontWithName:@"NexaBold" size:13];
                }
            }
            
            [self popUp_DeviceSetUp_Alpha_Disabled];
            NSLog(@"Time == %@",[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"]);
            strprorationTime=[[[[responseDict valueForKey:@"data"] objectForKey:@"billingQuote"] objectForKey:@"prorationDateTime"] stringValue];
            [self stop_PinWheel_DeviceAdded];
        }else{
            [self stop_PinWheel_DeviceAdded];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceAdded];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}
-(void)quoteForAdditionalDeviceConfirmation
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"controller id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID]);
    defaultsDevice=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsDevice objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/billing/planChange",[defaultsDevice objectForKey:@"ACCOUNTID"]];
    NSMutableDictionary *dict_Plan=[[NSMutableDictionary alloc] init];
    [dict_Plan setObject:@"1" forKey:kquoteTypeId];
    [dict_Plan setObject:@"2" forKey:kdeviceTypeId];
    [dict_Plan setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID] forKey:kControllerID];
    [dict_Plan setObject:strprorationTime forKey:kprorationDateTime];
    
    parameters=[SCM upgrade_Device_Plan:dict_Plan];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for upgrade plan ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseUpgradePlanDevice) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for upgrade plan ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorLights_Others_Device_Setup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}
-(void)responseUpgradePlanDevice
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            [self.viewAlert_PlanUpgrade_Confirm_device setHidden:YES];
            [self popUp_DeviceSetUp_Alpha_Enabled];
            [self stop_PinWheel_DeviceAdded];
            [self performSelectorOnMainThread:@selector(start_PinWheel_DeviceAdded) withObject:self waitUntilDone:YES];
            if(![str_Device_Added isEqualToString:@"YES"]){
                [self performSelectorInBackground:@selector(create_Lights_Others_Noid_Service) withObject:self];
            }else{
                [self performSelectorInBackground:@selector(update_Noid_DeviceCards) withObject:self];
            }
        }else{
            [self stop_PinWheel_DeviceAdded];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_DeviceAdded];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

#pragma mark - pin wheel
-(void)start_PinWheel_DeviceAdded{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}
-(void)stop_PinWheel_DeviceAdded{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}
@end
