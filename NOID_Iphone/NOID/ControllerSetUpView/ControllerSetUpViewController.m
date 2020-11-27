//
//  ControllerSetUpViewController.m
//  NOID
//
//  Created by iExemplar on 20/08/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "ControllerSetUpViewController.h"
#import "MultipleNetworkViewController.h"
#import "WifiViewController.h"
#import "Common.h"
#import "SettingsViewController.h"
#import "NetworkHomeViewController.h"
#import "CellularViewController.h"
#import "TimeLineViewController.h"
#import "Utils.h"
#import "ServiceConnectorModel.h"
#import "MBProgressHUD.h"

@interface ControllerSetUpViewController ()

@end

@implementation ControllerSetUpViewController
@synthesize txtfld_deviceId_SetUp,strBackStatus,str_Cellular_FirstStatus,str_EditCellularStatus,lbl_header1_ControllerSetup,lbl_header2_ControllerSetup,str_MultipleNetwork_Mode,captureSession,videoPreviewLayer,audioPlayer,view_QRScanCode,Bodyview_QRScanCode;

#pragma mark - ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp_ControllerSetUp];
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

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",appDelegate.strHubId);
    if (![appDelegate.strHubId isEqualToString:@""]) {
        if ([appDelegate.strHubId isEqualToString:@"QRSCAN"]) {
            appDelegate.strHubId=@"";
            lbl_header2_ControllerSetup.text=appDelegate.strControllerSetUp_Header;
            if (!_isReading) {
                if ([self startReading]) {
                    NSLog(@"finished");
                }
            }
            else{
                [self stopReading];
                NSLog(@"stopped");
            }
            _isReading = !_isReading;
        }else{
            txtfld_deviceId_SetUp.text=appDelegate.strHubId;
            lbl_header2_ControllerSetup.text=appDelegate.strControllerSetUp_Header;
            appDelegate.strHubId=@"";
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_ControllerSetup) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(checkControllerAvailability) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Defined Methods
-(void)initialSetUp_ControllerSetUp
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    appDelegate.strHubId=@"";
    if ([str_EditCellularStatus isEqualToString:@"EditCellular"]){
        lbl_header1_ControllerSetup.hidden=YES;
        lbl_header2_ControllerSetup.text = @"EDIT NOID HUB";
    }
    txtfld_deviceId_SetUp.delegate=self;
    txtfld_deviceId_SetUp.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txtfld_deviceId_SetUp.leftView = paddingView;
    txtfld_deviceId_SetUp.leftViewMode = UITextFieldViewModeAlways;
    Bodyview_QRScanCode.hidden=YES;
    captureSession = nil;
    _isReading = NO;
}

-(void)check_Controller_WidgetDismissORNot{
    if ([txtfld_deviceId_SetUp resignFirstResponder]) {
        [txtfld_deviceId_SetUp resignFirstResponder];
    }
}

#pragma mark - IBActions
-(IBAction)wifi_multipleNetwork_Action:(id)sender
{
    [self check_Controller_WidgetDismissORNot];
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0:
      {
          if ([txtfld_deviceId_SetUp resignFirstResponder]) {
              [txtfld_deviceId_SetUp resignFirstResponder];
          }
          txtfld_deviceId_SetUp.text=[Common Trimming_Right_End_WhiteSpaces:txtfld_deviceId_SetUp.text];
          if(txtfld_deviceId_SetUp.text.length==0){
              [Common showAlert:@"Warning" withMessage:@"Please enter hub id"];
              return;
          }
          if([Common reachabilityChanged]==YES){
              [self performSelectorOnMainThread:@selector(start_PinWheel_ControllerSetup) withObject:self waitUntilDone:YES];
              [self performSelectorInBackground:@selector(checkControllerAvailability) withObject:self];
          }else{
              [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
          }
        }
            break;
        case 1:
        {
            defaultsController=[NSUserDefaults standardUserDefaults];
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSLog(@"%@",appDelegate.strController_Setup_Mode);
            if([appDelegate.strController_Setup_Mode isEqualToString:@"AppLaunch"]||[appDelegate.strController_Setup_Mode isEqualToString:@"NetworkHomeDrawer"]){
                [defaultsController setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
                [defaultsController synchronize];
                //Need to Push Multiple Network
                MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
                MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
                NSArray *newStack = @[MNVC];
                [Common viewSlide_FromLeft_ToRight:self.navigationController.view];
                [self.navigationController setViewControllers:newStack animated:NO];
                // [self.navigationController pushViewController:MNVC animated:YES];
            }
            else if([appDelegate.strController_Setup_Mode isEqualToString:@"MultipleNetwork"]){
                [defaultsController setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
                [defaultsController synchronize];
                //Need to Pop Multiple Network
                for (UIViewController *controller in [self.navigationController viewControllers])
                {
                    if ([controller isKindOfClass:[MultipleNetworkViewController class]])
                    {
                        [Common viewSlide_FromLeft_ToRight:self.navigationController.view];
                        [self.navigationController popToViewController:controller animated:NO];
                        break;
                    }
                }
                
            }
        }
            break;
    }
}

-(IBAction)settings_Welcome_Action:(id)sender
{
    [self check_Controller_WidgetDismissORNot];
    SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    SVC.strPreviousView=@"ControlllerSetup";
    SVC.str_Cellular_FirstStatus=self.str_Cellular_FirstStatus;
    [Common viewFadeInSettings:self.navigationController.view];
    [self.navigationController pushViewController:SVC animated:NO];
}

-(IBAction)networkhome_Welcome_Action:(id)sender
{
    [self check_Controller_WidgetDismissORNot];
    defaultsController=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strController_Setup_Mode isEqualToString:@"AppLaunch"]||[appDelegate.strController_Setup_Mode isEqualToString:@"NetworkHomeDrawer"]){
        [defaultsController setObject:@"" forKey:@"MPNETWORKLOADSTATUS"];
        [defaultsController synchronize];
        //Need to Push Multiple Network
        MultipleNetworkViewController *MNVC = [[MultipleNetworkViewController alloc] initWithNibName:@"MultipleNetworkViewController" bundle:nil];
        MNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MultipleNetworkViewController"];
        NSArray *newStack = @[MNVC];
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController setViewControllers:newStack animated:NO];
        // [self.navigationController pushViewController:MNVC animated:YES];
    }
    else if([appDelegate.strController_Setup_Mode isEqualToString:@"MultipleNetwork"]){
        [defaultsController setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
        [defaultsController synchronize];
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

-(IBAction)scanQRcode_Action:(id)sender
{
    [self check_Controller_WidgetDismissORNot];
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            NSLog(@"finished");
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        NSLog(@"stopped");
        // The bar button item's title should change again.
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;

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
    captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:view_QRScanCode.layer.bounds];
    [view_QRScanCode.layer addSublayer:videoPreviewLayer];
    Bodyview_QRScanCode.hidden=NO;
    // Start video capture.
    [captureSession startRunning];
    return YES;
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
            _isReading = NO;
            if (audioPlayer) {
                [audioPlayer play];
            }
        }
    }
}

-(void)stopReading{
    [captureSession stopRunning];
    captureSession = nil;
    [videoPreviewLayer removeFromSuperlayer];
    txtfld_deviceId_SetUp.text = strScanCode;
    Bodyview_QRScanCode.hidden=YES;
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
    return YES;
}

/* **********************************************************************************
 Date : 23/06/2015
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Characters Entered");
    NSLog(@"%lu",txtfld_deviceId_SetUp.text.length);
    NSUInteger newLength = [txtfld_deviceId_SetUp.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_DEVICEID] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= UnitfieldIDLimit));
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text=@"";
    return NO;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    }];
    return [super canPerformAction:action withSender:sender];
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

    //return here which orientation you are going to support
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"Landscape left");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
        
    }
    
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape right");
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        
    }
}

#pragma mark - WebService Implementation
-(void)checkControllerAvailability
{
    defaultsController=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsController objectForKey:@"ACCOUNTID"]);
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/controllerTrace?traceCode=%@",[defaultsController objectForKey:@"ACCOUNTID"],[txtfld_deviceId_SetUp.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Controller Availability==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseController_Availability) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Controller Availability ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_ControllerSetup) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorControllerSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)responseController_Availability
{
    NSLog(@"%@",responseDict);
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
           // NSDictionary *dicitData=[responseDict objectForKey:@"data"];
            NSDictionary *dicitData=[[responseDict objectForKey:@"data"] objectForKey:@"traceDetails"];
            NSLog(@"controllerTrace Code ==%@",[dicitData valueForKey:@"controllerTraceCode"]);
            if([dicitData count]>0)
            {
                NSString *strControllerTrace_ID=[[dicitData valueForKey:@"id"] stringValue];
                [self stop_PinWheel_ControllerSetup];
                if([[[dicitData valueForKey:@"controllerConnectivityType"] valueForKey:@"typeCode"] isEqualToString:@"WIFI"])
                {
                    WifiViewController *WVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiViewController"];
                    [Common viewFadeIn:self.navigationController.view];
                    WVC.str_MultipleNetwork_Mode=self.str_MultipleNetwork_Mode;
                    WVC.strController_TraceID=strControllerTrace_ID;
                    // WVC.strControllerStatus=str_Cellular_FirstStatus;
                    [self.navigationController pushViewController:WVC animated:NO];
                }else{
                    CellularViewController *CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CellularViewController"];
                    [Common viewFadeIn:self.navigationController.view];
                    CVC.str_MultipleNetwork_Mode=self.str_MultipleNetwork_Mode;
                    CVC.strController_TraceID=strControllerTrace_ID;
                    CVC.dictController_BasicPlan=[dicitData valueForKey:@"defaultBillingPlan"];
                    CVC.strController_ConnectedSTS=@"NO";
                    CVC.strController_PaymentCardSTS=@"NO";
                    CVC.strController_PaymentCompletedSTS=@"NO";
                    CVC.strTimeZoneIDFor_User=[[responseDict objectForKey:@"data"] objectForKey:@"timeZoneId"];
                    [self.navigationController pushViewController:CVC animated:NO];
                }
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self stop_PinWheel_ControllerSetup];
            }
        }else{
            [self stop_PinWheel_ControllerSetup];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_ControllerSetup];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
    
}
-(void)responseErrorControllerSetup
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
}


#pragma mark - pin wheel
-(void)start_PinWheel_ControllerSetup{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"YES";
}
-(void)stop_PinWheel_ControllerSetup{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

@end
