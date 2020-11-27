//
//  WifiViewController.m
//  NOID
//
//  Created by iExemplar on 18/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "WifiViewController.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "MultipleNetworkViewController.h"
#import "SprinklerDeviceSetupViewController.h"
#import "DeviceSetUpViewController.h"
#import "TimeLineViewController.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "ServiceConnectorModel.h"
#import "Base64.h"
#import "ControllerSetUpViewController.h"

#define kButtonIndex 1000
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface WifiViewController ()
{
    UIView *menuViewWifi[kButtonIndex];
    UIView *view_wifi_ContentView[kButtonIndex];
    UILabel *lblWifiAlert[kButtonIndex];
    UIImageView *imgWifi[kButtonIndex];
    UIImageView *imgSecureLock[kButtonIndex];
    UITextField *txtfld_Password[kButtonIndex];
}

@end

@implementation WifiViewController
@synthesize viewWifi_Body,viewWifi_Header,viewWifi_QR,viewWifi_QR_HeaderContent,lblEdit_QR_Wifi,scrollViewWifi,viewSetUp,viewSetUp_BodyContent,viewSetUp_HeaderContent,viewInfo,viewInfo_BodyContent,viewInfo_HeaderContent,lblWifi_Header,lblWifi_Welcome,viewSetupDevice,viewSkipDevice;
@synthesize viewInfo_CancelView,viewInfo_ImageEdit,viewInfo_ImageGallery,viewInfo_ProceedView,imgView_Info,txtfld_DeviceName_Wifi,lblEdit_Info_Wifi,lblEdit_SetUp_Wifi,viewSetup_AvailableNetwork,viewSetUp_defaultWifi,scrollView_AvailableNetwork,arrAvailableNetworks,view_Confirm_popUp,viewSetUp_ConnectToInternet,view_success_popUp,view_deviceSetUp_Alert,str_MultipleNetwork_Mode;
@synthesize lblControllerIndex,lblViewIndex,strPreviousView,strControllerStatus,lbl_deviceImgName_WifiController,strController_TraceID,deleteNetworkView_Wifi,popUpDeleteView_Wifi,strWifiAccessType,lbl_DefaultWifi,viewWifi_QR_BodyContent,txtfld_DeviceId_Wifi;

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"controller id ==%@",strController_TraceID);
    [self flag_Setup_Wifi];
    [self wifi_Setup_UIConfiguration];
    [self textfield_WidgetConfiguration_Wifi];
    [self scrollView_Configuration_Wifi];
    
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
-(IBAction)wifi_QR_ButtonAction:(id)sender
{
    [self check_wifi_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Prceed QR Button
        {
            if ([txtfld_DeviceId_Wifi resignFirstResponder]) {
                [txtfld_DeviceId_Wifi resignFirstResponder];
            }
            txtfld_DeviceId_Wifi.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceId_Wifi.text];
            if(txtfld_DeviceId_Wifi.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter hub id"];
                return;
            }
            
//            ControllerSetUpViewController *CSVC = [[ControllerSetUpViewController alloc] initWithNibName:@"ControllerSetUpViewController" bundle:nil];
//            CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strHubId=txtfld_DeviceId_Wifi.text;
            appDelegate.strControllerSetUp_Header=lblWifi_Header.text;
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
        case 1: //Cancel OR Button
        {
            [self collapse_QR_View_Wifi];
        }
            break;
        case 2:
        {
//            ControllerSetUpViewController *CSVC = [[ControllerSetUpViewController alloc] initWithNibName:@"ControllerSetUpViewController" bundle:nil];
//            CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strHubId=@"QRSCAN";
            appDelegate.strControllerSetUp_Header=lblWifi_Header.text;
            [Common viewFadeIn:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
    }
}

-(IBAction)wifi_setUp_ButtonAction:(id)sender
{
    self.view.userInteractionEnabled=NO;
    [self check_wifi_WidgetDismissORNot];
    //[self checkWifi_SetUpTap_AlreadyOpenedOrNot]; // need to change temp hide
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //DefaultWifi Button
        {
            str_Selected_Tap=@"Default_Wifi";
            if([str_Selected_Tap isEqualToString:@"Default_Wifi"] && ![str_Previous_Tap isEqualToString:@"Default_Wifi"]){
                str_Previous_Tap=str_Selected_Tap;
                viewSetUp_defaultWifi.backgroundColor = lblRGBA(255, 206, 52, 1);
                viewSetup_AvailableNetwork.backgroundColor = lblRGBA(128, 130, 132, 1);
                //float yAxis = viewSetUp_defaultWifi.frame.origin.y+viewSetUp_defaultWifi.frame.size.height+20;
                [self expand_default_wifi_CompleteAction];  //not need i think
                //defaultWifi_ExpandStatus=NO;
            }else{
                self.view.userInteractionEnabled=YES;
            }
        }
            break;
        case 1: //Available Network Button
        {
            self.view.userInteractionEnabled=YES;
            //            if (availableNetwork_ExpandStatus==YES) {
            //                viewSetUp_defaultWifi.backgroundColor = lblRGBA(128, 130, 132, 1);
            //                viewSetup_AvailableNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
            //                [self load_AvailableWifi_Datas];
            //                availableNetwork_ExpandStatus=NO;
            //            }else{
            //                [self collapse_AvailableNetwork_Wifi_View];
            //            }
        }
            break;
            
        case 2: //Continue SetUp Button
        {
            [self expand_SuccessAlert_View_Wifi];
        }
            break;
        case 3:
        {
            [self collapse_SetUp_View_Wifi];
            [self expand_Info_View_Wifi];
        }
            break;
        case 4: //Cancel Setup Button
        {
            [self collapse_SetUp_View_Wifi];
        }
            break;
        case 5: //setupsch
        {
            self.view.userInteractionEnabled=YES;
            view_deviceSetUp_Alert.hidden=NO;
            [viewWifi_Body setAlpha:0.6];
            [viewWifi_Header setAlpha:0.6];
        }
            break;
        case 6: //skip
        {
            
//            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            appDelegate.dicit_NetworkDatas=networkData_Dict;
            [Common resetNetworkFlags];
            SWRevealViewController *SWR = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
            SWR = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            NSArray *newStack = @[SWR];
            [self.navigationController setViewControllers:newStack animated:YES];
            self.view.userInteractionEnabled=YES;
        }
            break;
    }
}

-(IBAction)wifi_TapMenu_Action:(id)sender
{
    self.view.userInteractionEnabled=NO;
    [self check_wifi_WidgetDismissORNot];
    [self.scrollViewWifi setContentOffset:CGPointMake(0, 0)];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            if(wifi_QR_ExpandedStatus==YES){
                [self check_Wifi_TapAlreadyOpenedOrNot];
                [self expand_QR_View_Wifi];
            }else{
                [self collapse_QR_View_Wifi];
            }
        }
            break;
        case 1:
        {
            if(wifi_setUp_ExpandedStatus==YES){
                [self check_Wifi_TapAlreadyOpenedOrNot];
                [self expand_SetUp_View_Wifi];
            }else{
                [self collapse_SetUp_View_Wifi];
            }
            // [self scrollWifiReSet_And_Changes];
        }
            break;
        case 2:  //Wifi Into Tap
        {
            if(wifi_info_ExpandedStatus==YES){
                [self check_Wifi_TapAlreadyOpenedOrNot];
                [self expand_Info_View_Wifi];
            }else{
                [self collapse_Info_View_Wifi];
            }
            //[self scrollWifiReSet_And_Changes];
        }
            break;
    }
}

-(IBAction)InfoSetup_Button_Action:(id)sender
{
    if([txtfld_DeviceName_Wifi resignFirstResponder]){
        [txtfld_DeviceName_Wifi resignFirstResponder];
    }
    //    if (view_deviceSetUp_Alert.hidden==NO) {
    //        view_deviceSetUp_Alert.hidden=YES;
    //        [viewWifi_Body setAlpha:1.0];
    //        [viewWifi_Header setAlpha:1.0];
    //    }
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //device camera
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
        case 1: //device gallery
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
            [self resetInfoGallary];
            imageStatus=NO;
            strEncoded_ControllerImage=@"";
            
        }
            break;
        case 3: //Proceed
        {
            txtfld_DeviceName_Wifi.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Wifi.text];
            if(txtfld_DeviceName_Wifi.text.length==0){
                [Common showAlert:@"Warning" withMessage:@"Please enter hub name"];
                return;
            }
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Wifi) withObject:self waitUntilDone:YES];
                if(![strNetwork_Added_Status isEqualToString:@"YES"]){
                    [self performSelectorInBackground:@selector(create_Modify_Wifi_Controller_Noid_Service) withObject:self];
                }else{
                    [self performSelectorInBackground:@selector(update_Modify_Wifi_Controller_Noid_Service) withObject:self];
                }
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
            break;
        case 4: //Cancel
        {
            [self collapse_Info_View_Wifi];
        }
            break;
        case 5: //close device alert popup
        {
//            view_deviceSetUp_Alert.hidden=YES;
//            [viewWifi_Body setAlpha:1.0];
//            [viewWifi_Header setAlpha:1.0];
            [self hide_DeviceSetUp_PopUp];
        }
            break;
        case 6: //device sprinkler alert popup
        {
            SprinklerDeviceSetupViewController *SDSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SprinklerDeviceSetupViewController"];
            SDSVC.strDeviceType = @"sprinklers";
            [self hide_DeviceSetUp_PopUp];
            [self.navigationController pushViewController:SDSVC animated:YES];
        }
            break;
        case 7: //device lights alert popup
        {
            DeviceSetUpViewController *DSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
//            if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
//                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//                DSVC.strController_Added_ID=appDelegate.strController_IDApp;
//            }else{
//                DSVC.strController_Added_ID=str_Added_ControllerID;
//            }
//            DSVC.network_Data_Dict=networkData_Dict;
            DSVC.strDeviceType = @"lights";
            [self hide_DeviceSetUp_PopUp];
            // LDSVC.strBackStatus_LightSetUp = @"wifi";
            // LDSVC.strPreviousView=@"WIFI";
            // LDSVC.strControllerStatus=self.strControllerStatus;
            [self.navigationController pushViewController:DSVC animated:YES];
        }
            break;
        case 8: //device others alert popup
        {
            DeviceSetUpViewController *DSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceSetUpViewController"];
            //  LDSVC.strController_Added_ID=str_Added_ControllerID;
//            if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
//                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//                DSVC.strController_Added_ID=appDelegate.strController_IDApp;
//            }else{
//                DSVC.strController_Added_ID=str_Added_ControllerID;
//            }
//            DSVC.network_Data_Dict=networkData_Dict;
            DSVC.strDeviceType = @"others";
            [self hide_DeviceSetUp_PopUp];
            // LDSVC.strBackStatus_LightSetUp = @"wifi";
            // LDSVC.strPreviousView=@"WIFI";
            // LDSVC.strControllerStatus=self.strControllerStatus;
            [self.navigationController pushViewController:DSVC animated:YES];
        }
    }
}

-(IBAction)networkHome_Setting_Wifi_Action:(id)sender
{
    [self check_wifi_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Noid Logo
        {
            defaults_Wifi=[NSUserDefaults standardUserDefaults];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([appDelegate.strController_Setup_Mode isEqualToString:@"AppLaunch"]||[appDelegate.strController_Setup_Mode isEqualToString:@"NetworkHomeDrawer"]){
                [defaults_Wifi setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                [defaults_Wifi synchronize];
                //Need to Push Multiple Network
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [Common viewFadeIn:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
                // [self.navigationController pushViewController:MNVC animated:YES];
            }
            else if([appDelegate.strController_Setup_Mode isEqualToString:@"MultipleNetwork"]){
                [defaults_Wifi setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
                [defaults_Wifi synchronize];
                //Need to Pop Multiple Network
                for (UIViewController *controller in [self.navigationController viewControllers])
                {
                    if ([controller isKindOfClass:[MultipleNetworkViewController class]])
                    {
                        [Common viewFadeIn:self.navigationController.view];
                        [self.navigationController popToViewController:controller animated:NO];
                        break;
                    }
                }
                
            }
        }
            break;
        case 1: //Add NetWork Edit
        {
            if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
                appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                if([appDelegate.strInitialView isEqualToString:@"SignIn"]){
                    for (UIViewController *controller in [self.navigationController viewControllers])
                    {
                        if ([controller isKindOfClass:[MultipleNetworkViewController class]])
                        {
                            [Common viewFadeIn:self.navigationController.view];
                            [self.navigationController popToViewController:controller animated:NO];
                            break;
                        }
                    }
                }
            }else{
                SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                appDelegate.strInitialView=@"ControllerFirstTime";
                NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                [self.navigationController pushViewController:NHVC animated:YES];
                
            }
            
        }
            break;
        case 2: //Stngs
        {
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strSettingAction = @"networkHome";
            SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            SVC.str_Cellular_FirstStatus=self.strControllerStatus;
            [Common viewFadeInSettings:self.navigationController.view];
            [self.navigationController pushViewController:SVC animated:NO];
        }
    }
}

-(IBAction)deleteNetwork_Wifi_Action:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
        {
            popUpDeleteView_Wifi.hidden=YES;
            [viewWifi_Body setAlpha:1.0];
            [viewWifi_Header setAlpha:1.0];
        }
            break;
        case 1:
        {
            popUpDeleteView_Wifi.hidden=YES;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_Wifi) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(deleteNetwork_NOID) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
            [viewWifi_Body setAlpha:1.0];
            [viewWifi_Header setAlpha:1.0];
        }
            break;
        case 2:
        {
            popUpDeleteView_Wifi.hidden=NO;
            [viewWifi_Body setAlpha:0.6];
            [viewWifi_Header setAlpha:0.6];
        }
            break;
    }
}

#pragma mark - User Defined Methods
-(void)textfield_WidgetConfiguration_Wifi
{
    txtfld_DeviceName_Wifi.delegate=self;
    txtfld_DeviceName_Wifi.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtfld_DeviceName_Wifi setValue:lblRGBA(0, 0, 0, 1) forKeyPath:@"_placeholderLabel.textColor"];
    txtfld_DeviceId_Wifi.delegate=self;
    txtfld_DeviceId_Wifi.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtfld_DeviceId_Wifi.leftView = paddingView;
    txtfld_DeviceId_Wifi.leftViewMode = UITextFieldViewModeAlways;
}

-(void)flag_Setup_Wifi
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    imageStatus=NO;
    self.viewSetUp.userInteractionEnabled=NO;
    str_Selected_Tap=@"Default_Wifi";
    str_Previous_Tap=@"";
    strNetwork_Added_Status=@"";
    strEncoded_ControllerImage=@"";
    deleteNetworkView_Wifi.hidden=YES;
    popUpDeleteView_Wifi.hidden=YES;
    lbl_DefaultWifi.hidden=YES;
    // self.viewInfo.userInteractionEnabled=NO;
}
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : uiconfiguration setup with flag
 Method Name : controllet_Setup_UIConfiguration(User Defined Method)
 ************************************************************************************* */
-(void)wifi_Setup_UIConfiguration{
    
    defaults_Wifi=[NSUserDefaults standardUserDefaults];
    if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
        [self start_PinWheel_Wifi];
        lblWifi_Welcome.hidden=YES;
        lblWifi_Header.text=@"EDIT WIFI NOID HUB";
        lblViewIndex.text=@"1";
        lblControllerIndex.text=@"2";
    }
    
    if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            self.lblWifi_Header.frame=CGRectMake(self.lblWifi_Header.frame.origin.x, self.lblWifi_Header.frame.origin.y-47, self.lblWifi_Header.frame.size.width,self.lblWifi_Header.frame.size.height);
            self.viewWifi_Body.frame=CGRectMake(self.viewWifi_Body.frame.origin.x, self.viewWifi_Body.frame.origin.y-38, self.viewWifi_Body.frame.size.width,self.viewWifi_Body.frame.size.height+38);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            self.lblWifi_Header.frame=CGRectMake(self.lblWifi_Header.frame.origin.x, self.lblWifi_Header.frame.origin.y-63, self.lblWifi_Header.frame.size.width,self.lblWifi_Header.frame.size.height);
            self.viewWifi_Body.frame=CGRectMake(self.viewWifi_Body.frame.origin.x, self.viewWifi_Body.frame.origin.y-51, self.viewWifi_Body.frame.size.width,self.viewWifi_Body.frame.size.height+51);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            self.lblWifi_Header.frame=CGRectMake(self.lblWifi_Header.frame.origin.x, self.lblWifi_Header.frame.origin.y-60, self.lblWifi_Header.frame.size.width,self.lblWifi_Header.frame.size.height);
            self.viewWifi_Body.frame=CGRectMake(self.viewWifi_Body.frame.origin.x, self.viewWifi_Body.frame.origin.y-53, self.viewWifi_Body.frame.size.width,self.viewWifi_Body.frame.size.height+53);
        }
        
        //QRView SetUp
        self.viewWifi_QR.hidden=YES;
        viewInfo.userInteractionEnabled=YES;
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, 0, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
        
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5,self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);

        self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);

        self.deleteNetworkView_Wifi.hidden=NO;

        lblEdit_Info_Wifi.hidden=YES;
        wifi_info_ExpandedStatus=YES;
        self.viewInfo_BodyContent.hidden=YES;
        self.viewInfo_ImageEdit.hidden=YES;
        
        [imgView_Info.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [imgView_Info.layer setBorderWidth:1.0];
        lblEdit_SetUp_Wifi.hidden=NO;
        [self expand_Info_EditView_Wifi];
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        str_Added_ControllerID=[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerID];
        NSLog(@"str_Added_ControllerID=%@",str_Added_ControllerID);

    }else{
        if (![[defaults_Wifi objectForKey:@"NETWORKCOUNT"] isEqualToString:@"0"]){
            lblWifi_Header.text=@"SET-UP WIFI NOID HUB";
        }

        //ControllerInfo Setup
        lblEdit_Info_Wifi.hidden=YES;
        wifi_info_ExpandedStatus=YES;
        wifi_QR_ExpandedStatus=YES;
        self.viewWifi_QR_BodyContent.hidden=YES;
        self.viewInfo_BodyContent.hidden=YES;
        self.viewInfo_ImageEdit.hidden=YES;
        
        [imgView_Info.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [imgView_Info.layer setBorderWidth:1.0];
        lblEdit_SetUp_Wifi.hidden=YES;
        [self expand_Info_View_Wifi];
    }
        //Controller Setup
        wifi_setUp_ExpandedStatus=YES;
        self.viewSetUp_BodyContent.hidden=YES;
        self.view_Confirm_popUp.hidden=YES;
        self.view_success_popUp.hidden=YES;
        self.viewSetupDevice.hidden=YES;
        self.viewSkipDevice.hidden=YES;
        defaultWifi_ExpandStatus=YES;
        availableNetwork_ExpandStatus=YES;
        cellExpandStatus=YES;
        self.view_deviceSetUp_Alert.hidden=YES;
}

-(void)scrollView_Configuration_Wifi
{
    scrollViewWifi.showsHorizontalScrollIndicator=NO;
    scrollViewWifi.scrollEnabled=YES;
    scrollViewWifi.userInteractionEnabled=YES;
    scrollViewWifi.delegate=self;
}

-(void)check_wifi_WidgetDismissORNot{
    if ([txtfld_DeviceName_Wifi resignFirstResponder]) {
        [txtfld_DeviceName_Wifi resignFirstResponder];
    }
    else if ([txtfld_Password[viewTagValue] resignFirstResponder]) {
        [txtfld_Password[viewTagValue] resignFirstResponder];
    }else if ([txtfld_DeviceId_Wifi resignFirstResponder]){
        [txtfld_DeviceId_Wifi resignFirstResponder];
    }
}

-(void)check_Wifi_TapAlreadyOpenedOrNot{
    
    if([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]){
        if(wifi_setUp_ExpandedStatus==NO){
            [self collapse_SetUp_View_Wifi];
        }else if(wifi_info_ExpandedStatus==NO){
            [self collapse_Info_View_Wifi];
        }
    }else{
        if(wifi_setUp_ExpandedStatus==NO){
            [self collapse_SetUp_View_Wifi];
        }else if(wifi_info_ExpandedStatus==NO){
            [self collapse_Info_View_Wifi];
        }else if (wifi_QR_ExpandedStatus==NO){
            [self collapse_QR_View_Wifi];
        }
    }
    
}

-(void)checkWifi_SetUpTap_AlreadyOpenedOrNot
{
    if (defaultWifi_ExpandStatus==NO) {
        [self collapseDefault_Wifi_View];
    }else if (availableNetwork_ExpandStatus==NO){
        [self collapse_AvailableNetwork_Wifi_View];
    }
}

//-(void)collapse_QR_View_Wifi{
//    self.view.userInteractionEnabled=NO;
//    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.viewWifi_QR_BodyContent.hidden=YES;
//        self.viewWifi_QR.frame=CGRectMake(self.viewWifi_QR.frame.origin.x, self.viewWifi_QR.frame.origin.y, self.viewWifi_QR.frame.size.width, self.viewWifi_QR_HeaderContent.frame.size.height);
//        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x, self.viewWifi_QR.frame.origin.y+self.viewWifi_QR.frame.size.height+5, self.viewSetUp.frame.size.width, self.viewSetUp.frame.size.height);
//        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
//    } completion:^(BOOL finished) {
//        wifi_QR_ExpandedStatus=YES;
//        lblEdit_QR_Wifi.hidden=NO;
//        self.view.userInteractionEnabled=YES;
//    }];
//}
//-(void)expand_QR_View_Wifi{
//    self.view.userInteractionEnabled=NO;
//    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.viewWifi_QR.frame=CGRectMake(self.viewWifi_QR.frame.origin.x, self.viewWifi_QR.frame.origin.y, self.viewWifi_QR.frame.size.width, self.viewWifi_QR_BodyContent.frame.origin.y+self.viewWifi_QR_BodyContent.frame.size.height);
//        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x, self.viewWifi_QR.frame.origin.y+self.viewWifi_QR.frame.size.height+5, self.viewSetUp.frame.size.width, self.viewSetUp.frame.size.height);
//        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+14, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
//        lblEdit_QR_Wifi.hidden=YES;
//    } completion:^(BOOL finished) {
//        self.viewWifi_QR_BodyContent.hidden=NO;
//        wifi_QR_ExpandedStatus=NO;
//        self.view.userInteractionEnabled=YES;
//    }];
//}

-(void)expand_QR_View_Wifi
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewWifi_QR.frame=CGRectMake(self.viewWifi_QR.frame.origin.x, self.viewWifi_QR.frame.origin.y, self.viewWifi_QR.frame.size.width, self.viewWifi_QR_BodyContent.frame.origin.y+self.viewWifi_QR_BodyContent.frame.size.height);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x,self.viewWifi_QR.frame.origin.y+self.viewWifi_QR.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
        lblEdit_QR_Wifi.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewWifi_QR_BodyContent.hidden=NO;
        wifi_QR_ExpandedStatus=NO;
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)collapse_QR_View_Wifi
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewWifi_QR_BodyContent.hidden=YES;
        self.viewWifi_QR.frame=CGRectMake(self.viewWifi_QR.frame.origin.x, self.viewWifi_QR.frame.origin.y, self.viewWifi_QR.frame.size.width, self.viewWifi_QR_HeaderContent.frame.size.height);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x,self.viewWifi_QR.frame.origin.y+self.viewWifi_QR.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
    } completion:^(BOOL finished) {
        wifi_QR_ExpandedStatus=YES;
        lblEdit_QR_Wifi.hidden=NO;
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)expand_SetUp_View_Wifi
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view_Confirm_popUp.hidden=YES;
        view_success_popUp.hidden=YES;
        viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, viewSetUp_ConnectToInternet.frame.origin.y+viewSetUp_ConnectToInternet.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x, self.viewSetUp.frame.origin.y,self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
        lblEdit_SetUp_Wifi.hidden=YES;
        lbl_DefaultWifi.hidden=NO;
    } completion:^(BOOL finished) {
        self.viewSetUp_BodyContent.hidden=NO;
        self.viewSetUp_ConnectToInternet.hidden=NO;
        wifi_setUp_ExpandedStatus=NO;
        self.view.userInteractionEnabled=YES;
        [self scrollWifiReSet_And_Changes];
    }];
}

-(void)collapse_SetUp_View_Wifi
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewSetUp_BodyContent.hidden=YES;
        self.viewSetUp_ConnectToInternet.hidden=YES;
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y, self.viewSetUp.frame.size.width,self.viewSetUp_HeaderContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
    } completion:^(BOOL finished) {
        wifi_setUp_ExpandedStatus=YES;
        lblEdit_SetUp_Wifi.hidden=NO;
        lbl_DefaultWifi.hidden=YES;
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)resetSetUpWidgets
{
    viewSetUp_defaultWifi.backgroundColor = lblRGBA(255, 206, 52, 1);
    viewSetup_AvailableNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
}

-(void)expand_Info_EditView_Wifi
{
    @try {
        strNetwork_Added_Status=@"YES";
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"Network Data == %@",appDelegate.dict_NetworkControllerDatas);
        txtfld_DeviceName_Wifi.text=[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkName]; //[appDelegate.dicit_NetworkDatas valueForKey:@"name"];
        NSLog(@"network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
        if([appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] == [NSNull null]){
            [self expand_Info_View_Wifi];
            strEncoded_ControllerImage=@"";
        }
        else if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] isEqualToString:@""]){
            [self expand_Info_View_Wifi];
            strEncoded_ControllerImage=@"";
        }
        else{
            [self editImageGallerySetup];
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView_Info.image = [UIImage imageWithData:[Base64 decode:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage]]];
                    strEncoded_ControllerImage = [appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage];
                });
            });
        }
        self.viewSetUp.userInteractionEnabled=YES;
        [self stop_PinWheel_Wifi];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Wifi];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)expand_Info_View_Wifi{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewInfo_BodyContent.frame.origin.y+self.viewInfo_BodyContent.frame.size.height+5);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
        lblEdit_Info_Wifi.hidden=YES;
    } completion:^(BOOL finished) {
        self.viewInfo_BodyContent.hidden=NO;
        wifi_info_ExpandedStatus=NO;
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)collapse_Info_View_Wifi{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(imageStatus==YES){
            self.viewInfo_ProceedView.frame=CGRectMake(self.viewInfo_ProceedView.frame.origin.x, self.viewInfo_ImageEdit.frame.origin.y+self.viewInfo_ImageEdit.frame.size.height+5,self.viewInfo_ProceedView.frame.size.width, self.viewInfo_ProceedView.frame.size.height);
            self.viewInfo_CancelView.frame=CGRectMake(self.viewInfo_CancelView.frame.origin.x, self.viewInfo_ImageEdit.frame.origin.y+self.viewInfo_ImageEdit.frame.size.height+5,self.viewInfo_CancelView.frame.size.width, self.viewInfo_CancelView.frame.size.height);
        }else{
            self.viewInfo_ProceedView.frame=CGRectMake(self.viewInfo_ProceedView.frame.origin.x, self.viewInfo_ImageGallery.frame.origin.y+self.viewInfo_ImageGallery.frame.size.height+5,self.viewInfo_ProceedView.frame.size.width, self.viewInfo_ProceedView.frame.size.height);
            self.viewInfo_CancelView.frame=CGRectMake(self.viewInfo_CancelView.frame.origin.x, self.viewInfo_ImageGallery.frame.origin.y+self.viewInfo_ImageGallery.frame.size.height+5,self.viewInfo_CancelView.frame.size.width, self.viewInfo_CancelView.frame.size.height);
        }
        
        self.viewInfo_BodyContent.frame=CGRectMake(self.viewInfo_BodyContent.frame.origin.x, self.viewInfo_BodyContent.frame.origin.y, self.viewInfo_BodyContent.frame.size.width,self.viewInfo_ProceedView.frame.origin.y+self.viewInfo_ProceedView.frame.size.height);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewInfo_BodyContent.frame.origin.y+self.viewInfo_BodyContent.frame.size.height);
        self.viewInfo_BodyContent.hidden=YES;
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x,self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewInfo_HeaderContent.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
        // self.viewSetUp_defaultWifi
    } completion:^(BOOL finished) {
        wifi_info_ExpandedStatus=YES;
        lblEdit_Info_Wifi.hidden=NO;
        [self resetInfoWidgets];
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
        
    }];
}

-(void)resetInfoWidgets{
    if(imageStatus==YES){
        self.viewInfo_ImageGallery.hidden=YES;
        self.viewInfo_ImageEdit.hidden=NO;
    }else{
        self.viewInfo_ImageGallery.hidden=NO;
        self.viewInfo_ImageEdit.hidden=YES;
    }
    
}

-(void)resetInfoGallary{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewInfo_ImageEdit.hidden=YES;
        self.viewInfo_ImageGallery.hidden=NO;
        self.imgView_Info.image=nil;
        self.viewInfo_ProceedView.frame=CGRectMake(self.viewInfo_ProceedView.frame.origin.x, self.viewInfo_ImageGallery.frame.origin.y+self.viewInfo_ImageGallery.frame.size.height+5,self.viewInfo_ProceedView.frame.size.width, self.viewInfo_ProceedView.frame.size.height);
        self.viewInfo_CancelView.frame=CGRectMake(self.viewInfo_CancelView.frame.origin.x, self.viewInfo_ImageGallery.frame.origin.y+self.viewInfo_ImageGallery.frame.size.height+5,self.viewInfo_CancelView.frame.size.width, self.viewInfo_CancelView.frame.size.height);
        self.viewInfo_BodyContent.frame=CGRectMake(self.viewInfo_BodyContent.frame.origin.x,self.viewInfo_BodyContent.frame.origin.y,self.viewInfo_BodyContent.frame.size.width,self.viewInfo_ProceedView.frame.origin.y+self.viewInfo_ProceedView.frame.size.height+10);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewInfo_BodyContent.frame.origin.y+self.viewInfo_BodyContent.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)expand_default_wifi_CompleteAction
{
    NSLog(@"view height ==%f",viewSetUp_BodyContent.frame.size.height);
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        NSLog(@"viewSetUp_BodyContent height ==%f",viewSetUp_BodyContent.frame.size.height);
        
        viewSetUp_ConnectToInternet.frame = CGRectMake(viewSetUp_ConnectToInternet.frame.origin.x, viewSetUp_ConnectToInternet.frame.origin.y, viewSetUp_ConnectToInternet.frame.size.width, viewSetupDevice.frame.origin.y+viewSetupDevice.frame.size.height+10);
        viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, viewSetUp_ConnectToInternet.frame.origin.y+viewSetUp_ConnectToInternet.frame.size.height);
        NSLog(@"viewSetUp_BodyContent aft height ==%f",viewSetUp_BodyContent.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y,self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
        if ([[Common wifiConnectionStatus] isEqualToString:@"YES"]) {
            lbl_DefaultWifi.text = [NSString stringWithFormat:@"Currently connected to %@",[Common fetchSSIDInfo]];
        }else{
            lbl_DefaultWifi.text = @"Not Connected";
        }
    }completion:^(BOOL finished) {
        viewSetupDevice.hidden=NO;
        viewSkipDevice.hidden=NO;
        [self scrollWifiReSet_And_Changes];
        //viewProceed.hidden=NO;  not need
        //viewCancel.hidden=NO;  not need
        //  viewInfo.hidden=NO;
        self.view.userInteractionEnabled=YES;
    }];
}


-(void)proceed_Cancel_AddWidget:(float)yAxis
{
    viewProceed=[[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]){
        viewProceed.frame = CGRectMake(21,yAxis, 134, 64);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        viewProceed.frame = CGRectMake(26, yAxis, 174, 83);
    }else{
        viewProceed.frame = CGRectMake(21, yAxis, 157, 75);
    }
    viewProceed.backgroundColor=lblRGBA(255,206,52, 1);
    [viewSetUp_BodyContent addSubview:viewProceed];
    viewProceed.hidden=YES;
    
    UIImageView *imgViewAdd_Tick=[[UIImageView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        imgViewAdd_Tick.frame = CGRectMake(52, 9, 24, 24);
//        imgViewAdd_Tick.image=[UIImage imageNamed:@"proceedImage"];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        imgViewAdd_Tick.frame = CGRectMake(71, 12, 31, 31);
//        imgViewAdd_Tick.image=[UIImage imageNamed:@"proceedImagei6plus"];
    }else{
        imgViewAdd_Tick.frame = CGRectMake(63, 10, 30, 30);
//        imgViewAdd_Tick.image=[UIImage imageNamed:@"proceedImagei6"];
    }
    imgViewAdd_Tick.image=[UIImage imageNamed:@"proceedImagei6plus"];
    [viewProceed addSubview:imgViewAdd_Tick];
    
    UILabel *lblProceed=[[UILabel alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        lblProceed.frame = CGRectMake(0, 38, 134, 21);
        [lblProceed setFont:[UIFont fontWithName:@"NexaBold" size:10]];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        lblProceed.frame = CGRectMake(0, 54, 174, 21);
        [lblProceed setFont:[UIFont fontWithName:@"NexaBold" size:12]];
    }else{
        lblProceed.frame = CGRectMake(0, 47, 157, 21);
        [lblProceed setFont:[UIFont fontWithName:@"NexaBold" size:11]];
    }
    lblProceed.text=@"SET-UP DEVICE";
    lblProceed.textColor=lblRGBA(255, 255, 255, 1);
    lblProceed.textAlignment=NSTextAlignmentCenter;
    [viewProceed addSubview:lblProceed];
    
    UIButton *btnProceed=[UIButton buttonWithType:UIButtonTypeCustom];
    btnProceed.frame=CGRectMake(0.0f, 0.0f, viewProceed.frame.size.width, viewProceed.frame.size.height);
    [btnProceed setBackgroundColor:[UIColor clearColor]];
    [btnProceed addTarget:self action:@selector(setupSch_SkipSch_wifiController_Action:)
         forControlEvents:UIControlEventTouchUpInside];
    [viewProceed addSubview:btnProceed];
    
    viewCancel=[[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        viewCancel.frame = CGRectMake(166, yAxis, 134, 64);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        viewCancel.frame = CGRectMake(214, yAxis, 174, 83);
    }else{
        viewCancel.frame = CGRectMake(195, yAxis, 157, 75);
    }
    viewCancel.backgroundColor=lblRGBA(211,7,21, 1);
    [viewSetUp_BodyContent addSubview:viewCancel];
    viewCancel.hidden=YES;
    
    UIImageView *imgViewDelete=[[UIImageView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        imgViewDelete.frame = CGRectMake(52, 9, 24, 24);
//        imgViewDelete.image=[UIImage imageNamed:@"cancelImage"];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        imgViewDelete.frame = CGRectMake(71, 12, 31, 31);
//        imgViewDelete.image=[UIImage imageNamed:@"cancelImagei6plus"];
    }else{
        imgViewDelete.frame = CGRectMake(63, 10, 30, 30);
//        imgViewDelete.image=[UIImage imageNamed:@"cancelImagei6"];
    }
    imgViewDelete.image=[UIImage imageNamed:@"cancelImagei6plus"];
    [viewCancel addSubview:imgViewDelete];
    
    UILabel *lblCancel=[[UILabel alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        lblCancel.frame = CGRectMake(0, 38, 134, 21);
        [lblCancel setFont:[UIFont fontWithName:@"NexaBold" size:10]];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        lblCancel.frame = CGRectMake(0, 54, 174, 21);
        [lblCancel setFont:[UIFont fontWithName:@"NexaBold" size:10]];
    }else{
        lblCancel.frame = CGRectMake(0, 47, 157, 21);
        [lblCancel setFont:[UIFont fontWithName:@"NexaBold" size:11]];
    }
    lblCancel.text=@"SKIP DEVICE SET-UP & SAVE";
    lblCancel.textColor=lblRGBA(255, 255, 255, 1);
    lblCancel.textAlignment=NSTextAlignmentCenter;
    [viewCancel addSubview:lblCancel];
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame=CGRectMake(0.0f, 0.0f, viewCancel.frame.size.width, viewCancel.frame.size.height);
    [btnCancel setBackgroundColor:[UIColor clearColor]];
    [btnCancel addTarget:self action:@selector(setupSch_SkipSch_wifiController_Action:)
        forControlEvents:UIControlEventTouchUpInside];
    [viewCancel addSubview:btnCancel];

    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, viewProceed.frame.origin.y+viewProceed.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y,self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        //self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
    }completion:^(BOOL finished) {
        [self scrollWifiReSet_And_Changes];
        viewProceed.hidden=NO;
        viewCancel.hidden=NO;
        viewInfo.hidden=NO;
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)collapseDefault_Wifi_View
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.userInteractionEnabled=NO;
        viewProceed.hidden=YES;
        viewCancel.hidden=YES;
        viewSetUp_defaultWifi.backgroundColor = lblRGBA(255, 206, 52, 1);
        viewSetup_AvailableNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
        viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, viewSetUp_defaultWifi.frame.origin.y+viewSetUp_defaultWifi.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y, self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
        // self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
    }completion:^(BOOL finished) {
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
        defaultWifi_ExpandStatus=YES;
    }];
}

-(void)collapse_AvailableNetwork_Wifi_View
{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.userInteractionEnabled=NO;
        viewProceed.hidden=YES;
        viewCancel.hidden=YES;
        [scrollView_AvailableNetwork removeFromSuperview];
        [scrollView_AvailableNetwork setHidden:YES];
        viewSetUp_defaultWifi.backgroundColor = lblRGBA(255, 206, 52, 1);
        viewSetup_AvailableNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
        viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, viewSetup_AvailableNetwork.frame.origin.y+viewSetup_AvailableNetwork.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y, self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
    }completion:^(BOOL finished) {
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
        availableNetwork_ExpandStatus=YES;
        //        if (availableNetwork_ExpandStatus==YES) {
        //            wifi_setUp_ExpandedStatus=YES;
        //        }else{
        //            wifi_setUp_ExpandedStatus=NO;
        //        }
        cellExpandStatus=YES;
    }];
}

-(void)scrollWifiReSet_And_Changes{
    NSLog(@"viewsetup height ==%f",self.viewSetUp.frame.size.height);
    if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
        self.scrollViewWifi.contentSize=CGSizeMake(self.scrollViewWifi.frame.size.width, self.deleteNetworkView_Wifi.frame.origin.y+self.deleteNetworkView_Wifi.frame.size.height);
    }else{
        if(wifi_setUp_ExpandedStatus==YES){
            self.scrollViewWifi.contentSize=CGSizeMake(self.scrollViewWifi.frame.size.width, self.viewSetUp.frame.origin.y+self.viewSetUp_HeaderContent.frame.size.height);
        }else{
            self.scrollViewWifi.contentSize=CGSizeMake(self.scrollViewWifi.frame.size.width, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height);
        }
    }
}

-(void)load_AvailableWifi_Datas
{
    NSLog(@"%f",viewSetup_AvailableNetwork.frame.origin.y+viewSetup_AvailableNetwork.frame.size.height);
    NSLog(@"scroll==%f",scrollView_AvailableNetwork.frame.origin.y+scrollView_AvailableNetwork.frame.size.height);
    scrollView_AvailableNetwork = [[UIScrollView alloc] init];
    scrollView_AvailableNetwork.userInteractionEnabled=YES;
    scrollView_AvailableNetwork.delegate=self;
    [viewSetUp_BodyContent addSubview:scrollView_AvailableNetwork];
    scrollView_AvailableNetwork.hidden=YES;
    
    arrAvailableNetworks = [[NSMutableArray alloc] initWithObjects:@"WIFI NETWORK ONE",@"WIFI NETWORK TWO",@"WIFI NETWORK THREE",@"WIFI NETWORK FOUR", nil];
    
    float x_OffsetAlerts=0,yOffsetAlerts=0,h_OffsetAlerts;
    if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        h_OffsetAlerts=30;
    }else{
        h_OffsetAlerts=28;
    }
    for(int alertIndex=0;alertIndex<[arrAvailableNetworks count];alertIndex++){
        NSLog(@"array value is ==%@",arrAvailableNetworks);
        NSLog(@"array value is indi ==%@",[arrAvailableNetworks objectAtIndex:alertIndex]);
        menuViewWifi[alertIndex]=[[UIView alloc] init];
        menuViewWifi[alertIndex].frame=CGRectMake(x_OffsetAlerts, yOffsetAlerts, self.viewSetUp_BodyContent.frame.size.width,h_OffsetAlerts);
        menuViewWifi[alertIndex].backgroundColor=[UIColor clearColor];//lblRGBA(99, 100, 102, 1);
        menuViewWifi[alertIndex].tag=alertIndex;
        [scrollView_AvailableNetwork addSubview:menuViewWifi[alertIndex]];
        
        [menuViewWifi[alertIndex] setExclusiveTouch:YES];
        UITapGestureRecognizer *tapGestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandWifi_View_onClick:)];
        [menuViewWifi[alertIndex] addGestureRecognizer:tapGestureView];
        [menuViewWifi[alertIndex] setExclusiveTouch:YES];
        
        lblWifiAlert[alertIndex] = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblWifiAlert[alertIndex].frame=CGRectMake(21, 0, 176, 28);
            [lblWifiAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:10]];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblWifiAlert[alertIndex].frame=CGRectMake(27, 0, 176, 30);
            [lblWifiAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:12]];
        }else{
            lblWifiAlert[alertIndex].frame=CGRectMake(21, 0, 176, 28);
            [lblWifiAlert[alertIndex] setFont:[UIFont fontWithName:@"NexaBold" size:11]];
        }
        [lblWifiAlert[alertIndex] setTextColor:lblRGBA(255,255,255, 1)];
        lblWifiAlert[alertIndex].text =[NSString stringWithFormat:@"%@",[arrAvailableNetworks objectAtIndex:alertIndex]];
        [menuViewWifi[alertIndex] addSubview:lblWifiAlert[alertIndex]];
        
        imgWifi[alertIndex] = [[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            imgWifi[alertIndex].frame = CGRectMake(258, 5, 17, 17);
//            imgWifi[alertIndex].image = [UIImage imageNamed:@"smallwifiImage"];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            imgWifi[alertIndex].frame = CGRectMake(349, 6, 18, 18);
//            imgWifi[alertIndex].image = [UIImage imageNamed:@"smallwifiImagei6plus"];
        }else{
            imgWifi[alertIndex].frame = CGRectMake(312, 5, 17, 17);
//            imgWifi[alertIndex].image = [UIImage imageNamed:@"smallwifiImagei6"];
        }
        imgWifi[alertIndex].image = [UIImage imageNamed:@"smallwifiImagei6plus"];
        imgWifi[alertIndex].backgroundColor = lblRGBA(98, 99, 102, 1);
        [menuViewWifi[alertIndex] addSubview:imgWifi[alertIndex]];
        
        imgSecureLock[alertIndex] = [[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            imgSecureLock[alertIndex].frame = CGRectMake(279, 5, 17, 17);
//            imgSecureLock[alertIndex].image = [UIImage imageNamed:@"smallLockImage"];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            imgSecureLock[alertIndex].frame = CGRectMake(370, 6, 18, 18);
//            imgSecureLock[alertIndex].image = [UIImage imageNamed:@"smallLockImagei6plus"];
        }else{
            imgSecureLock[alertIndex].frame = CGRectMake(333, 5, 17, 17);
//            imgSecureLock[alertIndex].image = [UIImage imageNamed:@"smallLockImagei6"];
        }
        imgSecureLock[alertIndex].image = [UIImage imageNamed:@"smallLockImagei6plus"];
        imgSecureLock[alertIndex].backgroundColor = lblRGBA(98, 99, 102, 1);
        [menuViewWifi[alertIndex] addSubview:imgSecureLock[alertIndex]];
        
        UIView *viewDivier=[[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            viewDivier.frame=CGRectMake(0, 29,menuViewWifi[alertIndex].frame.size.width, 1);
        }else{
            viewDivier.frame=CGRectMake(0, 27,menuViewWifi[alertIndex].frame.size.width, 1);
        }
        viewDivier.backgroundColor=lblRGBA(76, 76, 76, 1);
        [menuViewWifi[alertIndex] addSubview:viewDivier];
        
        yOffsetAlerts=menuViewWifi[alertIndex].frame.size.height+menuViewWifi[alertIndex].frame.origin.y;
        NSLog(@"after y offset==%f",yOffsetAlerts);
    }
    NSLog(@"%f",yOffsetAlerts);
    
    scrollView_AvailableNetwork.frame = CGRectMake(self.view.frame.origin.x, viewSetup_AvailableNetwork.frame.origin.y+viewSetup_AvailableNetwork.frame.size.height+20, self.view.frame.size.width,yOffsetAlerts);
    NSLog(@"scrollview height==%f",scrollView_AvailableNetwork.frame.size.height);
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, scrollView_AvailableNetwork.frame.origin.y+scrollView_AvailableNetwork.frame.size.height);
        viewSetUp.frame = CGRectMake(viewSetUp.frame.origin.x, viewSetUp.frame.origin.y, viewSetUp.frame.size.width, viewSetUp_BodyContent.frame.origin.y+viewSetUp_BodyContent.frame.size.height);
        frame_Org_Size_Controller_Wifi_List=viewSetUp.frame;
        viewInfo.frame = CGRectMake(viewInfo.frame.origin.x, viewSetUp.frame.origin.y+viewSetUp.frame.size.height+5, viewInfo.frame.size.width,viewInfo_HeaderContent.frame.size.height);
    }completion:^(BOOL finished) {
        scrollView_AvailableNetwork.hidden=NO;
        self.view.userInteractionEnabled=YES;
    }];
}

-(void) wifi_AddWidget:(int)tag
{
    view_wifi_ContentView[tag]=[[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        view_wifi_ContentView[tag].frame = CGRectMake(0, 27, self.view.frame.size.width, 50);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        view_wifi_ContentView[tag].frame = CGRectMake(0, 29, self.view.frame.size.width, 66);
    }else{
        view_wifi_ContentView[tag].frame = CGRectMake(0, 27, self.view.frame.size.width, 58);
    }
    view_wifi_ContentView[tag].backgroundColor=lblRGBA(128, 130, 132, 1);
    [menuViewWifi[tag] addSubview:view_wifi_ContentView[tag]];
    
    UILabel *lblPassword = [[UILabel alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        lblPassword.frame = CGRectMake(19, 3, 131, 16);
        lblPassword.font = [UIFont fontWithName:@"NexaBold" size:10.0];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        lblPassword.frame = CGRectMake(27, 7, 250, 16);
        lblPassword.font = [UIFont fontWithName:@"NexaBold" size:12.0];
    }else{
        lblPassword.frame = CGRectMake(21, 5, 131, 16);
        lblPassword.font = [UIFont fontWithName:@"NexaBold" size:10.0];
    }
    lblPassword.text = @"ENTER WIFI PASSWORD";
    lblPassword.textColor = lblRGBA(255, 255, 255, 1);
    [view_wifi_ContentView[tag] addSubview:lblPassword];
    
    txtfld_Password[tag] = [[UITextField alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        txtfld_Password[tag].frame = CGRectMake(19, 21, 278, 19);
        txtfld_Password[tag].font = [UIFont fontWithName:@"NexaBold" size:10.0];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        txtfld_Password[tag].frame = CGRectMake(27, 25, 363, 24);
        txtfld_Password[tag].font = [UIFont fontWithName:@"NexaBold" size:10.0];
    }else{
        txtfld_Password[tag].frame = CGRectMake(21, 22, 333, 21);
        txtfld_Password[tag].font = [UIFont fontWithName:@"NexaBold" size:11.0];
    }
    txtfld_Password[tag].backgroundColor = [UIColor whiteColor];
    txtfld_Password[tag].textColor = lblRGBA(0, 0, 0, 1);
    txtfld_Password[tag].userInteractionEnabled=YES;
    txtfld_Password[tag].delegate=self;
    [txtfld_Password[tag] setSecureTextEntry:YES];
    txtfld_Password[tag].tag = tag;
    [view_wifi_ContentView[tag] addSubview:txtfld_Password[tag]];
    
    yOffSet_Content = scrollView_AvailableNetwork.frame.origin.y+scrollView_AvailableNetwork.frame.size.height+20;
    [self proceed_Cancel_AddWidget:yOffSet_Content];
}

-(void)setupSch_SkipSch_wifiController_Action:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    self.view.userInteractionEnabled=NO;
    [self.scrollViewWifi setContentOffset:CGPointMake(0, 0)];
    [self check_wifi_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Prceed SetUp Button
        {
            if (defaultWifi_ExpandStatus==NO) {
                [self collapse_SetUp_View_Wifi];
                [self expand_Info_View_Wifi];
            }else{
                [self expand_SetUp_AlertView];
            }
        }
            break;
        case 1: //Cancel Setup Button
        {
            [self collapse_SetUp_View_Wifi];
        }
            break;
    }
}

-(void)expandWifi_View_onClick:(UITapGestureRecognizer*)sender
{
    UIView *viewCurrent = sender.view;
    int tag_Pos=(int)viewCurrent.tag;
    NSLog(@"tag==%ld",(long)viewCurrent.tag);
    @try {
        if (cellExpandStatus==YES) {
            self.view.userInteractionEnabled=NO;
            [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                viewInfo.hidden=YES;
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    menuViewWifi[viewCurrent.tag].frame = CGRectMake(0, menuViewWifi[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 77);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    menuViewWifi[viewCurrent.tag].frame = CGRectMake(0, menuViewWifi[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 96);
                }else{
                    menuViewWifi[viewCurrent.tag].frame = CGRectMake(0, menuViewWifi[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 86);
                }
                menuViewWifi[viewCurrent.tag].backgroundColor=lblRGBA(128, 130, 132, 1);
                yOffSet_Content=menuViewWifi[viewCurrent.tag].frame.origin.y+menuViewWifi[viewCurrent.tag].frame.size.height;
                for (int index=0;index<[arrAvailableNetworks count];index++){
                    if (index>[viewCurrent tag]) {
                        if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                            menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 30);
                        }else{
                            menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 28);
                        }
                        yOffSet_Content=menuViewWifi[index].frame.origin.y+menuViewWifi[index].frame.size.height;
                    }
                }
                viewTagValue=viewCurrent.tag;
                [self scroll_Controller_Setup_Wifi:yOffSet_Content];
                
            } completion:^(BOOL finished) {
                [self wifi_AddWidget:tag_Pos];
                //                viewInfo_AddController.hidden=NO;
                cellExpandStatus=NO;
                self.view.userInteractionEnabled=YES;
            }];
        }else{
            if (viewTagValue==viewCurrent.tag) {
                self.view.userInteractionEnabled=NO;
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuViewWifi[viewCurrent.tag].frame = CGRectMake(0,viewCurrent.frame.origin.y, self.view.frame.size.width, 30);
                    }else{
                        menuViewWifi[viewCurrent.tag].frame = CGRectMake(0,viewCurrent.frame.origin.y, self.view.frame.size.width, 28);
                    }
                    menuViewWifi[viewCurrent.tag].backgroundColor=[UIColor clearColor];
                    yOffSet_Content=menuViewWifi[viewCurrent.tag].frame.origin.y+menuViewWifi[viewCurrent.tag].frame.size.height;
                    for (int index=0;index<[arrAvailableNetworks count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 30);
                            }else{
                                menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 28);
                            }
                            yOffSet_Content=menuViewWifi[index].frame.origin.y+menuViewWifi[index].frame.size.height;
                        }
                    }
                    [self scroll_Controller_Setup_Wifi:yOffSet_Content];
                    [view_wifi_ContentView[viewCurrent.tag] setHidden:YES];
                    [view_wifi_ContentView[viewCurrent.tag] removeFromSuperview];
                    [viewProceed setHidden:YES];
                    [viewProceed removeFromSuperview];
                    [viewCancel setHidden:YES];
                    [viewCancel removeFromSuperview];
                } completion:^(BOOL finished) {
                    [self controllerSetup_Wifi_Position];
                    [self scrollWifiReSet_And_Changes];
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatus=YES;
                }];
            }else{
                cellExpandStatus=YES;
                self.view.userInteractionEnabled=NO;
                
                [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuViewWifi[viewTagValue].frame = CGRectMake(0,menuViewWifi[viewTagValue].frame.origin.y, self.view.frame.size.width, 30);
                    }else{
                        menuViewWifi[viewTagValue].frame = CGRectMake(0,menuViewWifi[viewTagValue].frame.origin.y, self.view.frame.size.width, 28);
                    }
                    menuViewWifi[viewTagValue].backgroundColor=[UIColor clearColor];
                    yOffSet_Content=menuViewWifi[viewTagValue].frame.origin.y+menuViewWifi[viewTagValue].frame.size.height;
                    [view_wifi_ContentView[viewTagValue] setHidden:YES];
                    [view_wifi_ContentView[viewTagValue] removeFromSuperview];
                    [viewProceed setHidden:YES];
                    [viewProceed removeFromSuperview];
                    [viewCancel setHidden:YES];
                    [viewCancel removeFromSuperview];
                    
                    for (int index=0;index<[arrAvailableNetworks count];index++){
                        if (index>viewTagValue) {
                            if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 30);
                            }else{
                                menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 28);
                            }
                            yOffSet_Content=menuViewWifi[index].frame.origin.y+menuViewWifi[index].frame.size.height;
                        }
                    }
                    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                        menuViewWifi[viewCurrent.tag].frame = CGRectMake(0, menuViewWifi[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 77);
                    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                        menuViewWifi[viewCurrent.tag].frame = CGRectMake(0, menuViewWifi[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 96);
                    }else{
                        menuViewWifi[viewCurrent.tag].frame = CGRectMake(0, menuViewWifi[viewCurrent.tag].frame.origin.y, self.view.frame.size.width, 86);
                    }
                    menuViewWifi[viewCurrent.tag].backgroundColor=lblRGBA(128, 130, 132, 1);
                    yOffSet_Content=menuViewWifi[viewCurrent.tag].frame.origin.y+menuViewWifi[viewCurrent.tag].frame.size.height;
                    for (int index=0;index<[arrAvailableNetworks count];index++){
                        if (index>[viewCurrent tag]) {
                            if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                                menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 30);
                            }else{
                                menuViewWifi[index].frame = CGRectMake(0,yOffSet_Content, self.view.frame.size.width, 28);
                            }
                            yOffSet_Content=menuViewWifi[index].frame.origin.y+menuViewWifi[index].frame.size.height;
                        }
                    }
                    viewTagValue=viewCurrent.tag;
                    [self scroll_Controller_Setup_Wifi:yOffSet_Content];
                    
                } completion:^(BOOL finished) {
                    [self wifi_AddWidget:tag_Pos];
                    self.view.userInteractionEnabled=YES;
                    cellExpandStatus=NO;
                }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"expandable exception==%@",exception.description);
    }
}

-(void)scroll_Controller_Setup_Wifi:(float)yAxis{
    self.scrollView_AvailableNetwork.frame=CGRectMake(self.scrollView_AvailableNetwork.frame.origin.x, self.scrollView_AvailableNetwork.frame.origin.y, self.scrollView_AvailableNetwork.frame.size.width, yAxis);
}

-(void)controllerSetup_Wifi_Position
{
    viewSetUp.frame=frame_Org_Size_Controller_Wifi_List;
    viewInfo.frame = CGRectMake(viewInfo.frame.origin.x, viewSetUp.frame.origin.y+viewSetUp.frame.size.height+5, viewInfo.frame.size.width,viewInfo_HeaderContent.frame.size.height+20);
}

-(void)expand_SetUp_AlertView
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewSetUp_BodyContent.hidden=NO;
        self.viewSetUp_ConnectToInternet.hidden=YES;
        viewProceed.hidden=YES;
        viewCancel.hidden=YES;
        [scrollView_AvailableNetwork removeFromSuperview];
        [scrollView_AvailableNetwork setHidden:YES];
        self.viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, view_Confirm_popUp.frame.origin.y+view_Confirm_popUp.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y, self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
    } completion:^(BOOL finished) {
        view_Confirm_popUp.hidden=NO;
        [self scrollWifiReSet_And_Changes];
        availableNetwork_ExpandStatus=YES;
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)expand_SuccessAlert_View_Wifi
{
    self.view.userInteractionEnabled=NO;
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.viewSetUp_BodyContent.frame = CGRectMake(viewSetUp_BodyContent.frame.origin.x, viewSetUp_BodyContent.frame.origin.y, viewSetUp_BodyContent.frame.size.width, view_success_popUp.frame.origin.y+view_success_popUp.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewSetUp.frame.origin.y, self.viewSetUp.frame.size.width,self.viewSetUp_BodyContent.frame.origin.y+self.viewSetUp_BodyContent.frame.size.height);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+5, self.viewInfo.frame.size.width, self.viewInfo.frame.size.height);
    } completion:^(BOOL finished) {
        view_success_popUp.hidden=NO;
        self.view.userInteractionEnabled=YES;
    }];
}

-(void)hide_DeviceSetUp_PopUp
{
    view_deviceSetUp_Alert.hidden=YES;
    [viewWifi_Body setAlpha:1.0];
    [viewWifi_Header setAlpha:1.0];
}



#pragma mark - Image Picker Delegtes
/* **********************************************************************************
 Date : 14/09/2015
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
            // imgView_Info.image=img;
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
            //imgView_Info.image=img;
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
            //imgView_Info.image=img;
            imgView_Info.image=[[UIImage alloc]initWithData:imageData];
        }
        NSData* data = UIImageJPEGRepresentation(imgView_Info.image, 0.3f);
        strEncoded_ControllerImage = [Base64 encode:data];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        imageStatus=YES;
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [viewInfo_ImageGallery setHidden:YES];
            [viewInfo_ImageEdit setHidden:NO];
            self.viewInfo_ProceedView.frame=CGRectMake(self.viewInfo_ProceedView.frame.origin.x, self.viewInfo_ImageEdit.frame.origin.y+self.viewInfo_ImageEdit.frame.size.height+5,self.viewInfo_ProceedView.frame.size.width, self.viewInfo_ProceedView.frame.size.height);
            self.viewInfo_CancelView.frame=CGRectMake(self.viewInfo_CancelView.frame.origin.x, self.viewInfo_ImageEdit.frame.origin.y+self.viewInfo_ImageEdit.frame.size.height+5,self.viewInfo_CancelView.frame.size.width, self.viewInfo_CancelView.frame.size.height);
            self.viewInfo_BodyContent.frame=CGRectMake(self.viewInfo_BodyContent.frame.origin.x,self.viewInfo_BodyContent.frame.origin.y,self.viewInfo_BodyContent.frame.size.width,self.viewInfo_ProceedView.frame.origin.y+self.viewInfo_ProceedView.frame.size.height+10);
            self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewInfo_BodyContent.frame.origin.y+self.viewInfo_BodyContent.frame.size.height);
            self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
            if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
                self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
            }
        } completion:^(BOOL finished) {
            [self scrollWifiReSet_And_Changes];
            self.view.userInteractionEnabled=YES;
        }];
    }
}

-(void)editImageGallerySetup
{
    imageStatus=YES;
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [viewInfo_ImageGallery setHidden:YES];
        [viewInfo_ImageEdit setHidden:NO];
        self.viewInfo_ProceedView.frame=CGRectMake(self.viewInfo_ProceedView.frame.origin.x, self.viewInfo_ImageEdit.frame.origin.y+self.viewInfo_ImageEdit.frame.size.height+5,self.viewInfo_ProceedView.frame.size.width, self.viewInfo_ProceedView.frame.size.height);
        self.viewInfo_CancelView.frame=CGRectMake(self.viewInfo_CancelView.frame.origin.x, self.viewInfo_ImageEdit.frame.origin.y+self.viewInfo_ImageEdit.frame.size.height+5,self.viewInfo_CancelView.frame.size.width, self.viewInfo_CancelView.frame.size.height);
        self.viewInfo_BodyContent.frame=CGRectMake(self.viewInfo_BodyContent.frame.origin.x,self.viewInfo_BodyContent.frame.origin.y,self.viewInfo_BodyContent.frame.size.width,self.viewInfo_ProceedView.frame.origin.y+self.viewInfo_ProceedView.frame.size.height+10);
        self.viewInfo.frame=CGRectMake(self.viewInfo.frame.origin.x, self.viewInfo.frame.origin.y, self.viewInfo.frame.size.width, self.viewInfo_BodyContent.frame.origin.y+self.viewInfo_BodyContent.frame.size.height);
        self.viewSetUp.frame=CGRectMake(self.viewSetUp.frame.origin.x,self.viewInfo.frame.origin.y+self.viewInfo.frame.size.height+5, self.viewSetUp.frame.size.width,self.viewSetUp.frame.size.height);
        if ([self.str_MultipleNetwork_Mode isEqualToString:@"edit"]) {
            self.deleteNetworkView_Wifi.frame = CGRectMake(self.deleteNetworkView_Wifi.frame.origin.x, self.viewSetUp.frame.origin.y+self.viewSetUp.frame.size.height+20, self.deleteNetworkView_Wifi.frame.size.width, self.deleteNetworkView_Wifi.frame.size.height);
        }
    } completion:^(BOOL finished) {
        self.viewInfo_BodyContent.hidden=NO;
        wifi_info_ExpandedStatus=NO;
        [self scrollWifiReSet_And_Changes];
        self.view.userInteractionEnabled=YES;
    }];
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

/* **********************************************************************************
 Date : 19/08/2015
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
//        lbl_deviceImgName_WifiController.text = @"asset.JPG";
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
//        lbl_deviceImgName_WifiController.text = [assetURL lastPathComponent];
//    }];
}

#pragma mark - Textfield Delegates
/* **********************************************************************************
 Date : 14/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the textfield is selected.
 Method Name : textFieldShouldBeginEditing(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==txtfld_Password[viewTagValue]) {
        [self.scrollViewWifi setContentOffset:CGPointMake(0, viewSetUp.frame.origin.y+menuViewWifi[viewTagValue].frame.origin.y+view_wifi_ContentView[viewTagValue].frame.origin.y+txtfld_Password[viewTagValue].frame.origin.y)];
    }
    return YES;
}

/* **********************************************************************************
 Date : 14/09/2015
 Author : iExemplar Software India Pvt Ltd.
 Title: Textfield Delegate Methods
 Description : Method gets executed when the return button on the keyboard is clicked
 Method Name : textFieldShouldReturn(Pre Defined Method)
 ************************************************************************************* */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.scrollViewWifi setContentOffset:CGPointMake(0, 0)];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.scrollViewWifi setContentOffset:CGPointMake(0, 0)];
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
    if(textField==txtfld_DeviceName_Wifi)
    {
        NSUInteger newLength = [txtfld_DeviceName_Wifi.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICENAME] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= UnitfieldDigitsPWd));
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text=@"";
    return NO;
}

#pragma mark - Orientation
/* **********************************************************************************
 Date : 14/09/2015
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
    //return here which orientation you are going to support
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [self.navigationController pushViewController:TLVC animated:NO];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
}
#pragma mark - PinWheel Methods
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_Wifi{
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
-(void)stop_PinWheel_Wifi{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

#pragma mark - WebService Part
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Title: Registeration Webservice
 Description : Add Wifi Controller device detials to server
 Method Name : create_Modify_Wifi_Controller_Noid_Service(User Defined Method)
 ************************************************************************************* */
-(void)create_Modify_Wifi_Controller_Noid_Service
{
    defaults_Wifi=[NSUserDefaults standardUserDefaults];
    txtfld_DeviceName_Wifi.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Wifi.text];
    NSLog(@"User Account id ==%@",[defaults_Wifi objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks",[defaults_Wifi objectForKey:@"ACCOUNTID"]];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:txtfld_DeviceName_Wifi.text forKey:kDeviceName];
//    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:kDeviceImage];
    [dictController_Device_Details setObject:@"" forKey:kDeviceImage];
    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:KThumbnailImage];
    [dictController_Device_Details setObject:self.strController_TraceID forKey:kControllerID];
    
    parameters=[SCM controller_WifiAdd_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Create/Edit New wifi Controller Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseWifiController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Create/Edit New Controller wifi Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Wifi) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedWifiController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    // [SCM serviceConnector:parameters andMethodName:Add_NewController_Device_Details];
    [SCM serviceConnector:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseWifiController_DeviceDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strNetwork_Added_Status=@"YES";
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            networkData_Dict=[responseDict objectForKey:@"data"];
            if([networkData_Dict count]>0){
                appDelegate.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
                //new code
                NSDictionary *dictNetworkStatus=[networkData_Dict valueForKey:@"networkStatus"];
                NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
                if(arrController.count>0)
                {
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"alert"] forKey:kAlertCount];
                    [appDelegate.dict_NetworkControllerDatas setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"message"] forKey:kMessageCount];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"latitude"] forKey:kLat];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"longitude"] forKey:kLong];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"name"] forKey:kNetworkName];
                    [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
                    NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
                    
                    NSDictionary *dictController=[arrController objectAtIndex:0];
                    NSDictionary *dictControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
                    
                    NSLog(@"controller id ==%@",[dictController valueForKey:@"id"]);
                    NSLog(@"controllerConnectivityType is ==%@",dictControllerTrace);
                    NSLog(@"controller type%@",[dictControllerTrace valueForKey:@"typeCode"]);
                    NSLog(@"controller Trace ID ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"]);
                    
                    [appDelegate.dict_NetworkControllerDatas setObject:[dictControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
                    [appDelegate.dict_NetworkControllerDatas setObject:[[dictController valueForKey:@"id"] stringValue] forKey:kControllerID];
                    str_Added_ControllerID=[[dictController objectForKey:@"id"] stringValue];
                    NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
                    
                    defaults_Wifi=[NSUserDefaults standardUserDefaults];
                    
                    NSLog(@"network count is ==%@",[defaults_Wifi objectForKey:@"NETWORKCOUNT"]);
                    int nwCount=[[defaults_Wifi objectForKey:@"NETWORKCOUNT"] intValue];
                    nwCount=nwCount+1;
                    
                    [defaults_Wifi setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                    [defaults_Wifi synchronize];
                    NSLog(@"network count is ==%@",[defaults_Wifi objectForKey:@"NETWORKCOUNT"]);
                    
                    if(nwCount==1){
                        [defaults_Wifi setObject:[networkData_Dict valueForKey:@"id"] forKey:@"NETWORKID"];
                        [defaults_Wifi setObject:appDelegate.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
                        [defaults_Wifi synchronize];
                    }
                    self.viewSetUp.userInteractionEnabled=YES;
                    [self stop_PinWheel_Wifi];
//                    [Common showAlert:kAlertSuccess withMessage:responseMessage];
                    [self collapse_Info_View_Wifi];
                    [self expand_SetUp_View_Wifi];
                    NSLog(@"dict network ==%@",appDelegate.dict_NetworkControllerDatas);
                    
                }else{
                    [self stop_PinWheel_Wifi];
                    [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
                }
                // [self add_Wifi_Controller_Noid_Service];
            }
            else{
                //  self.viewSetUp.userInteractionEnabled=YES;
                [self stop_PinWheel_Wifi];
                [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
            }
        }else{
            // self.viewSetUp.userInteractionEnabled=YES;
            [self stop_PinWheel_Wifi];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Hub Name Already Exists"];
                return;
                
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        // self.viewSetUp.userInteractionEnabled=YES;
        [self stop_PinWheel_Wifi];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)responseFailedWifiController_DeviceDetails
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
    // self.viewSetUp.userInteractionEnabled=YES;
}

//controller added service
/*-(void)add_Wifi_Controller_Noid_Service
{
    NSLog(@"Nwtwork id ==%@",[[networkData_Dict valueForKey:@"id"] stringValue]);
    NSLog(@"controller id ==%@",strController_ID);
    defaults_Wifi=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Wifi objectForKey:@"ACCOUNTID"]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictController=[[NSMutableDictionary alloc] init];
    [dictController setObject:self.strController_ID forKey:kControllerID];
    [dictController setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
    NSString *strMethodName=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers",[defaults_Wifi objectForKey:@"ACCOUNTID"],[[networkData_Dict valueForKey:@"id"] stringValue]];
    parameters=[SCM controller_Add_Wifi:dictController];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Add New Controller ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(response_AddWifi_Controller) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Add New Controller ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Wifi) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedWifiController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnector:parameters andMethodName:strMethodName];
}

-(void)response_AddWifi_Controller
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSDictionary *dictController=[responseDict objectForKey:@"data"];
            str_Added_ControllerID=[[dictController objectForKey:@"id"] stringValue];
            [appDelegate.dict_NetworkControllerDatas setObject:str_Added_ControllerID forKey:kControllerID];
            NSLog(@"controller Type ==%@",[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"] valueForKey:@"typeCode"]);
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strController_IDApp=str_Added_ControllerID;
            [appDelegate.dict_NetworkControllerDatas setObject:[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"] valueForKey:@"typeCode"] forKey:kControllerType];
            self.viewSetUp.userInteractionEnabled=YES;
            defaults_Wifi=[NSUserDefaults standardUserDefaults];
            NSLog(@"network count is ==%@",[defaults_Wifi objectForKey:@"NETWORKCOUNT"]);
            int nwCount=[[defaults_Wifi objectForKey:@"NETWORKCOUNT"] intValue];
            nwCount=nwCount+1;
            [defaults_Wifi setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
            [defaults_Wifi synchronize];
            if(nwCount==1){
                [defaults_Wifi setObject:appDelegate.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
                [defaults_Wifi synchronize];
            }
            [self stop_PinWheel_Wifi];
            [Common showAlert:kAlertSuccess withMessage:responseMessage];
            [self collapse_Info_View_Wifi];
            [self expand_SetUp_View_Wifi];
            NSLog(@"dict network ==%@",appDelegate.dict_NetworkControllerDatas);
        }else{
            [self stop_PinWheel_Wifi];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Wifi];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
} */

-(void)update_Modify_Wifi_Controller_Noid_Service
{
    defaults_Wifi=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    txtfld_DeviceName_Wifi.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_DeviceName_Wifi.text];
    NSLog(@"User Account id ==%@",[defaults_Wifi objectForKey:@"ACCOUNTID"]);
    NSLog(@"Nwtwork id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?controllerTraceId=%@",[defaults_Wifi objectForKey:@"ACCOUNTID"],self.strController_TraceID];
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    
    NSMutableDictionary *dictController_Device_Details=[[NSMutableDictionary alloc] init];
    [dictController_Device_Details setObject:txtfld_DeviceName_Wifi.text forKey:kDeviceName];
//    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:kDeviceImage];
    [dictController_Device_Details setObject:@"" forKey:kDeviceImage];
    [dictController_Device_Details setObject:strEncoded_ControllerImage forKey:KThumbnailImage];
    [dictController_Device_Details setObject:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID] forKey:kNetworkID];
    
    parameters=[SCM controller_Update_Device_Details:dictController_Device_Details];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for update wifi Controller Device Details==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseWifiController_Update_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Controller wifi Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Wifi) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedWifiController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseWifiController_Update_DeviceDetails
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            strNetwork_Added_Status=@"YES";
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            if([str_MultipleNetwork_Mode isEqualToString:@"edit"]){
                appDelegate.strEdit_Controller_DeviceStatus=@"YES";
            }else{
                appDelegate.strEdit_Controller_DeviceStatus=@"";
            }
            networkData_Dict=[responseDict objectForKey:@"data"];
            //appDelegate.dicit_NetworkDatas=networkData_Dict;
            NSString *strConType=[appDelegate.dict_NetworkControllerDatas valueForKey:kControllerType];
            appDelegate.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"alert"] forKey:kAlertCount];
            [appDelegate.dict_NetworkControllerDatas setObject:[[networkData_Dict valueForKey:@"id"] stringValue] forKey:kNetworkID];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"message"] forKey:kMessageCount];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"latitude"] forKey:kLat];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"longitude"] forKey:kLong];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"name"] forKey:kNetworkName];
            [appDelegate.dict_NetworkControllerDatas setObject:[networkData_Dict valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
            [appDelegate.dict_NetworkControllerDatas setObject:str_Added_ControllerID forKey:kControllerID];
            NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
            NSDictionary *dictNetworkStatus=[networkData_Dict valueForKey:@"networkStatus"];
            NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
            if(arrController.count>0)
            {
                NSDictionary *dictController=[arrController objectAtIndex:0];
                NSArray *arrControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
                NSLog(@"controllerConnectivityType is ==%@",arrControllerTrace);
                [appDelegate.dict_NetworkControllerDatas setObject:[arrControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
                
            }else{
                [appDelegate.dict_NetworkControllerDatas setObject:strConType forKey:kControllerType];
            }
            NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
            defaults_Wifi=[NSUserDefaults standardUserDefaults];
            NSLog(@"network count is ==%@",[defaults_Wifi objectForKey:@"NETWORKCOUNT"]);
            int nwCount=[[defaults_Wifi objectForKey:@"NETWORKCOUNT"] intValue];
            if(nwCount==1){
                [defaults_Wifi setObject:appDelegate.dict_NetworkControllerDatas forKey:@"NETWORKSINGLEDATAS"];
                [defaults_Wifi synchronize];
            }
            [self stop_PinWheel_Wifi];
//            [Common showAlert:kAlertSuccess withMessage:responseMessage];
            self.viewSetUp.userInteractionEnabled=YES;
            [self collapse_Info_View_Wifi];
            [self expand_SetUp_View_Wifi];
        }else{
            // self.viewSetUp.userInteractionEnabled=YES;
            [self stop_PinWheel_Wifi];
            if([responseMessage isEqualToString:@"NAME_ALREADY_USED"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:@"This Hub Name Already Exists"];
                return;
                
            }
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        // self.viewSetUp.userInteractionEnabled=YES;
        [self stop_PinWheel_Wifi];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)deleteNetwork_NOID
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"network id ==%@",[[appDelegate.dicit_NetworkDatas valueForKey:@"id"] stringValue]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaults_Wifi=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaults_Wifi objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaults_Wifi objectForKey:@"ACCOUNTID"],[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Network Delete==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(parse_Delete_Network_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Network Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_Wifi) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseFailedWifiController_DeviceDetails) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

-(void)parse_Delete_Network_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.strNetworkAddedStatus=@"YES";
            appDelegate.strEdit_Controller_DeviceStatus=@"";
            appDelegate.strOwnerNetwork_Status=@"";
            defaults_Wifi=[NSUserDefaults standardUserDefaults];
            [defaults_Wifi setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
            
//            if([self.strWifiAccessType isEqualToString:@"0"]){
                NSLog(@"network count is ==%@",[defaults_Wifi objectForKey:@"NETWORKCOUNT"]);
                int nwCount=[[defaults_Wifi objectForKey:@"NETWORKCOUNT"] intValue];
                nwCount=nwCount-1;
                [defaults_Wifi setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
                [defaults_Wifi synchronize];
//            }
            
            [self stop_PinWheel_Wifi];
            if([appDelegate.strController_Setup_Mode isEqualToString: @"MultipleNetwork"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([appDelegate.strController_Setup_Mode isEqualToString: @"NetworkHomeDrawer"])
            {
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [self.navigationController setViewControllers:newStack animated:YES];
            }
        }else{
            [self stop_PinWheel_Wifi];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_Wifi];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

@end
