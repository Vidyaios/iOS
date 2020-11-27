//
//  MultipleNetworkViewController.m
//  NOID
//
//  Created by iExemplar on 24/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "MultipleNetworkViewController.h"
#import "AddNetworkViewController.h"
#import "NetworkHomeViewController.h"
#import "Common.h"
#import "ControllerSetUpViewController.h"
#import "TimeLineViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "ServiceConnectorModel.h"
#import "Base64.h"
#import "CellularViewController.h"
#import "WifiViewController.h"

#define kButtonIndex 1000
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MultipleNetworkViewController ()
{
    NSMutableArray *arrDeivce_Images;
    UIView *view_Network[kButtonIndex];
    UIImageView *img_NetworkProfile[kButtonIndex];
    UILabel *lblNetworkName[kButtonIndex];
    UIButton *btn_EditNetwork[kButtonIndex];
    UIImageView *imgPayment_Inactive[kButtonIndex];
}
@end

@implementation MultipleNetworkViewController
@synthesize strPreviousView,scrollView_MultipleNetWork,arr_NetworkList,view_AddNetwork,view_pushAlert,headerView_MultipleNw,bodyView_MultipleNw;

#pragma mark - View LifeCycle
/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flagSetupMultiple_Network];
    [self scrollView_Configuration_MultipleNetwork];

//    [self scrollView_Configuration_MultipleNetwork];
//    [self load_MultipleNetwork_Contents];
    // Do any additional setup after loading the view.
}


-(void)flagSetupMultiple_Network
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
    strNetworkAction=@"";
    self.view_pushAlert.hidden=YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNOIDNetowrks:) name:@"PushMessageReceivedNotification" object:nil];
}
- (void) incomingNOIDNetowrks:(NSNotification *)notification{
    if([[notification object] isEqualToString:@"YES"])
    {
        [self popUpOldConfiguration_MultipleNw];
        [self resetNOIDNW];
    }
}
-(void)resetNOIDNW
{
    self.scrollView_MultipleNetWork.hidden=YES;
    
    [[self.scrollView_MultipleNetWork subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scrollView_MultipleNetWork.hidden=NO;
    if([Common reachabilityChanged]==YES){
        [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(getAllControllerNetworks_NOID) withObject:self];
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count  %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);
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
    appDelegate.strNoidLogo=@"MultipleNW";
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    if(![[defaultsMultiple_Networks objectForKey:@"MPNETWORKLOADSTATUS"] isEqualToString:@"YES"])
    {
        appDelegate.strNetworkAddedStatus=@"";
        appDelegate.strSettingAction=@"";
        appDelegate.strNew_NotiReceived=@"";
        appDelegate.strPaymentActive=@"";
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getAllControllerNetworks_NOID) withObject:self];
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
        //[self loadMultipleNetworkDatas];
    }
    else{
        NSLog(@"strNetwork status==%@",appDelegate.strNetworkAddedStatus);
        appDelegate.strSettingAction=@"";
        if([appDelegate.strNetworkAddedStatus isEqualToString:@"YES"]){
            appDelegate.strNetworkAddedStatus=@"";
            [self.scrollView_MultipleNetWork setContentOffset:CGPointZero animated:YES];
            if([appDelegate.strEdit_Controller_DeviceStatus isEqualToString:@"YES"]){
                lblNetworkName[selectedIndex].text =[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkName];
                if([appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] == [NSNull null]){
                    img_NetworkProfile[selectedIndex].image = [UIImage imageNamed:@"noNetworkImage"];
                }
                else if([[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage] isEqualToString:@""]){
                    img_NetworkProfile[selectedIndex].image = [UIImage imageNamed:@"noNetworkImage"];
                }
                else{
                    img_NetworkProfile[selectedIndex].image = [UIImage imageWithData:[Base64 decode:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetWrokImage]]];
                }
                appDelegate.strEdit_Controller_DeviceStatus=@"";
                if([appDelegate.strPaymentActive isEqualToString:@"YES"])
                {
                    imgPayment_Inactive[selectedIndex].image=nil;
                    appDelegate.strPaymentActive=@"";
                }
                return;
            }
            else if([appDelegate.strPaymentActive isEqualToString:@"YES"]){
                imgPayment_Inactive[selectedIndex].image=nil;
                appDelegate.strPaymentActive=@"";
                return;
            }

            self.scrollView_MultipleNetWork.hidden=YES;
            
            [[self.scrollView_MultipleNetWork subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            self.scrollView_MultipleNetWork.hidden=NO;
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getAllControllerNetworks_NOID) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }else if ([appDelegate.strNew_NotiReceived isEqualToString:@"YES"]){
            appDelegate.strNew_NotiReceived = @"";
            [self resetNOIDNW];
        }
    }
    [Common resetNetworkFlags];
    [appDelegate.dict_NetworkControllerDatas removeAllObjects];
    appDelegate.strInviteeID=@"";
    appDelegate.dict_NetworkControllerDatas=nil;
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"view dis appear");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the Add Network screen.
 Method Name : addNetwork_Action(View Delegate Methods)
 ************************************************************************************* */
-(IBAction)addNetwork_Action:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strController_Setup_Mode=@"MultipleNetwork";
    appDelegate.strDevice_Added_Mode=@"";
    appDelegate.strOwnerNetwork_Status=@"YES";
    ControllerSetUpViewController *CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
    CSVC.str_MultipleNetwork_Mode=@"";
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController pushViewController:CSVC animated:NO];
}

/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the Network Home screen.
 Method Name : NetworkHome_Action(user Defined Methods)
 ************************************************************************************* */
-(IBAction)NetworkHome_Action:(id)sender
{    
//    SWRevealViewController *NHVC = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
//    NHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//    [self.navigationController pushViewController:NHVC animated:YES];

}


/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the Setting screen.
 Method Name : settingsView_Action(user Defined Methods)
 ************************************************************************************* */
-(IBAction)settingsView_Action:(id)sender
{
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    [defaultsMultiple_Networks setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
    [defaultsMultiple_Networks synchronize];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strNetworkAddedStatus=@"";
    appDelegate.strSettingAction = @"multipleNw";
    SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    SVC.strPreviousView=@"MutlipleNetWork";
    [Common viewFadeInSettings:self.navigationController.view];
    [self.navigationController pushViewController:SVC animated:NO];
}

-(IBAction)accept_decline_AlertAction:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Accept
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(acceptNetworks_NOID) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                return;
            }
            [self popUpOldConfiguration_MultipleNw];
        }
            break;
        case 1:  //Decline
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(declineNetworks_NOID) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                return;
            }
            [self popUpOldConfiguration_MultipleNw];
        }
            break;
        case 2: //close
        {
            [self popUpOldConfiguration_MultipleNw];
        }
            break;
    }
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
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        NSLog(@"Landscape left");
        defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
        [defaultsMultiple_Networks setObject:@"YES" forKey:@"MPNETWORKLOADSTATUS"];
        [defaultsMultiple_Networks synchronize];
        TimeLineViewController *TLVC = [[TimeLineViewController alloc] initWithNibName:@"TimeLineViewController" bundle:nil];
        TLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeLineViewController"];
        TLVC.strNoidLogo_Status=@"";
        [Common viewFadeIn:self.navigationController.view];
        [self.navigationController pushViewController:TLVC animated:NO];
    }
}

#pragma mark - User Defined Methods
-(void)addNetWorkOnly
{
    view_AddNetwork = [[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        view_AddNetwork.frame = CGRectMake(21, 0, 88, 77);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        view_AddNetwork.frame = CGRectMake(28, 0, 113, 99);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        view_AddNetwork.frame = CGRectMake(25, 0, 103, 90);
    }
    view_AddNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
    [scrollView_MultipleNetWork addSubview:view_AddNetwork];
    
    UIImageView *imgAddNetwork = [[UIImageView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        imgAddNetwork.frame = CGRectMake(32, 17, 25, 24);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        imgAddNetwork.frame = CGRectMake(41, 26, 31, 31);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        imgAddNetwork.frame = CGRectMake(37, 23, 29, 29);
    }
    imgAddNetwork.image = [UIImage imageNamed:@"add_iconi6plus"];
    [view_AddNetwork addSubview:imgAddNetwork];
    
    UILabel *lblAddNetwork = [[UILabel alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        lblAddNetwork.frame = CGRectMake(0, 50, 88, 21);
        lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:9.0];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        lblAddNetwork.frame = CGRectMake(0, 72, 113, 21);
        lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:11.0];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        lblAddNetwork.frame = CGRectMake(0, 63, 103, 21);
        lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:10.0];
    }
    lblAddNetwork.textColor = lblRGBA(255, 255, 255, 1);
    lblAddNetwork.text = @"ADD PROPERTY";
    lblAddNetwork.textAlignment = NSTextAlignmentCenter;
    [view_AddNetwork addSubview:lblAddNetwork];
    
    UIButton *btnAddNetwork = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        btnAddNetwork.frame = CGRectMake(0, 0, 88, 77);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        btnAddNetwork.frame = CGRectMake(0, 0, 113, 99);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        btnAddNetwork.frame = CGRectMake(0, 0, 103, 90);
    }
    [btnAddNetwork addTarget:self action:@selector(addNetwork_Action:) forControlEvents:UIControlEventTouchUpInside];
    [view_AddNetwork addSubview:btnAddNetwork];
    
    scrollView_MultipleNetWork.contentSize = CGSizeMake(scrollView_MultipleNetWork.contentSize.width, view_AddNetwork.frame.origin.y+(view_AddNetwork.frame.size.height*2)+40);
}

-(void)scrollView_Configuration_MultipleNetwork
{
    scrollView_MultipleNetWork .showsHorizontalScrollIndicator=NO;
    scrollView_MultipleNetWork.showsVerticalScrollIndicator=NO;
    scrollView_MultipleNetWork.scrollEnabled=YES;
    scrollView_MultipleNetWork.userInteractionEnabled=YES;
    scrollView_MultipleNetWork.delegate=self;
    scrollView_MultipleNetWork.scrollsToTop=NO;
}

-(void)getAllControllerNetworks_NOID
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Controller Availability==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(load_MultipleNetwork_Contents) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Controller Availability ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorMultipleNetworkSetup) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}


-(void)responseErrorMultipleNetworkSetup
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
//    self.view_AddNetwork.hidden=NO;
}
-(void)load_MultipleNetwork_Contents
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arr_NetworkList = [[NSMutableArray alloc] init];
            arr_NetworkList=[responseDict objectForKey:@"data"];
            NSLog(@"arr_Network_Data count==%lu",(unsigned long)arr_NetworkList.count);
            [self parseNetworksDatas];
            if(arr_NetworkList.count==1)
            {
                defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
                NSLog(@"network count is ==%@",[defaultsMultiple_Networks objectForKey:@"NETWORKCOUNT"]);
                if([[[arr_NetworkList objectAtIndex:0] objectForKey:@"accessTypeId"] intValue]==0)
                {
                    [defaultsMultiple_Networks setObject:[[[arr_NetworkList objectAtIndex:0] objectForKey:@"id"] stringValue] forKey:@"NETWORKID"];
                    [defaultsMultiple_Networks synchronize];
                }
//                else{
//                    int nwCount=[[defaultsMultiple_Networks objectForKey:@"NETWORKCOUNT"] intValue];
//                    nwCount=nwCount-1;
//                    [defaultsMultiple_Networks setObject:[NSString stringWithFormat:@"%d",nwCount] forKey:@"NETWORKCOUNT"];
//                    [defaultsMultiple_Networks synchronize];
//                }
            }
        }else{
            [self stop_PinWheel_MultipleNetwork];
            if(![responseMessage isEqualToString:@"No properties to view"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            //[Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            [self addNetWorkOnly];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetwork];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self addNetWorkOnly];
        //self.view_AddNetwork.hidden=NO;
    }
}

-(void)parseNetworksDatas
{
    float yCoord=0,xCoord = 0.0;

    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        xCoord = 21;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        xCoord = 28;
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        xCoord = 25;
    }
    for(int i=0;i<[arr_NetworkList count];i++){
        NSLog(@"array value is ==%@",arr_NetworkList);
        NSLog(@"array value is indi ==%@",[arr_NetworkList objectAtIndex:i]);
        NSLog(@"network id ==%@",[[arr_NetworkList objectAtIndex:i] objectForKey:@"id"]);
        if(i==0){
            view_Network[i]=[[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_Network[i].frame=CGRectMake(xCoord,yCoord, 88, 163);
                xCoord = view_Network[i].frame.origin.x+view_Network[i].frame.size.width+7;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_Network[i].frame=CGRectMake(xCoord,yCoord, 113, 209);
                xCoord = view_Network[i].frame.origin.x+view_Network[i].frame.size.width+10;
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_Network[i].frame=CGRectMake(xCoord,yCoord, 103, 190);
                xCoord = view_Network[i].frame.origin.x+view_Network[i].frame.size.width+8;
            }
            yCoord = view_Network[i].frame.origin.y;
        }else{
            view_Network[i]=[[UIView alloc] init];
            NSLog(@"i val is ==%d",i%3);
            if(i%3!=0){
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_Network[i].frame=CGRectMake(xCoord,yCoord, 88, 163);
                    xCoord = xCoord+view_Network[i-1].frame.size.width+7;
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_Network[i].frame=CGRectMake(xCoord,yCoord, 113, 209);
                    xCoord = xCoord+view_Network[i-1].frame.size.width+10;
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    view_Network[i].frame=CGRectMake(xCoord,yCoord, 103, 190);
                    xCoord = xCoord+view_Network[i-1].frame.size.width+8;
                }
                yCoord = view_Network[i-1].frame.origin.y;
            }else{
                NSLog(@"%f",yCoord+view_Network[i-1].frame.size.height);
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_Network[i].frame=CGRectMake(21,yCoord+view_Network[i-1].frame.size.height+7,88,163);
                    xCoord = view_Network[i].frame.origin.x+view_Network[i].frame.size.width+7;
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_Network[i].frame=CGRectMake(28,yCoord+view_Network[i-1].frame.size.height+10,113,209);
                    xCoord = view_Network[i].frame.origin.x+view_Network[i].frame.size.width+10;
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    view_Network[i].frame=CGRectMake(25,yCoord+view_Network[i-1].frame.size.height+8,103,190);
                    xCoord = view_Network[i].frame.origin.x+view_Network[i].frame.size.width+8;
                }
                NSLog(@"%f",view_Network[i].frame.origin.y);
                yCoord = view_Network[i].frame.origin.y;
            }
        }
        view_Network[i].backgroundColor=[UIColor clearColor];
        [scrollView_MultipleNetWork addSubview:view_Network[i]];
        
        img_NetworkProfile[i] = [[UIImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            img_NetworkProfile[i].frame = CGRectMake(0, 0, 88, 77);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            img_NetworkProfile[i].frame = CGRectMake(0, 0, 113, 99);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            img_NetworkProfile[i].frame = CGRectMake(0, 0, 103, 90);
        }
        if([[[arr_NetworkList objectAtIndex:i] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    img_NetworkProfile[i].image = [UIImage imageNamed:@"noNetworkImage"];
                });
            });
        }else{
            dispatch_async(kBgQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    img_NetworkProfile[i].image = [UIImage imageWithData:[Base64 decode:[[arr_NetworkList objectAtIndex:i] objectForKey:@"thumbnailImage"]]];
                });
            });
        }
        [view_Network[i] addSubview:img_NetworkProfile[i]];
        
        if([[[[[arr_NetworkList objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arr_NetworkList objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
        {
            imgPayment_Inactive[i]=[[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgPayment_Inactive[i].frame = CGRectMake(0, 0, 88, 77);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgPayment_Inactive[i].frame = CGRectMake(0, 0, 113, 99);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgPayment_Inactive[i].frame = CGRectMake(0, 0, 103, 90);
            }
            imgPayment_Inactive[i].image=[UIImage imageNamed:@"deviceVaction1"];
            [view_Network[i] addSubview:imgPayment_Inactive[i]];
        }
        else if([[[[[arr_NetworkList objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arr_NetworkList objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue])
        {
            imgPayment_Inactive[i]=[[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgPayment_Inactive[i].frame = CGRectMake(0, 0, 88, 77);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgPayment_Inactive[i].frame = CGRectMake(0, 0, 113, 99);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgPayment_Inactive[i].frame = CGRectMake(0, 0, 103, 90);
            }
            imgPayment_Inactive[i].image=[UIImage imageNamed:@"deviceVaction1"];
            [view_Network[i] addSubview:imgPayment_Inactive[i]];
        }

        if([[[arr_NetworkList objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]>0)
        {
            if([[[arr_NetworkList objectAtIndex:i] objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arr_NetworkList objectAtIndex:i] objectForKey:@"inviteeNetStatus"] intValue]==3)
            {
                view_Network[i].alpha=0.4;
            }
        }

        UIButton *btn_NetworkImage = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_NetworkImage.frame = CGRectMake(0, 0, 88, 77);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_NetworkImage.frame = CGRectMake(0, 0, 113, 99);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_NetworkImage.frame = CGRectMake(0, 0, 103, 90);
        }
        [btn_NetworkImage setTag:i];
        [btn_NetworkImage addTarget:self action:@selector(networkImageTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn_NetworkImage setExclusiveTouch:YES];
        [view_Network[i] addSubview:btn_NetworkImage];
        
        UIView *view_NetworkDetail = [[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_NetworkDetail.frame  = CGRectMake( 0, 77, 88, 86);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_NetworkDetail.frame  = CGRectMake( 0, 99, 113, 110);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_NetworkDetail.frame  = CGRectMake( 0, 90, 103, 100);
        }
        view_NetworkDetail.backgroundColor = lblRGBA(77, 77, 79, 1);
        [view_Network[i] addSubview:view_NetworkDetail];
        
        UIButton *btn_placeMarker = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_placeMarker.frame = CGRectMake(36, 7, 16, 25);
//            [btn_placeMarker setImage:[UIImage imageNamed:@"Placemarker_icon"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_placeMarker.frame = CGRectMake(46, 12, 21, 32);
//            [btn_placeMarker setImage:[UIImage imageNamed:@"Placemarker_iconi6plus"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_placeMarker.frame = CGRectMake(43, 11, 19, 29);
//            [btn_placeMarker setImage:[UIImage imageNamed:@"Placemarker_iconi6"] forState:UIControlStateNormal];
        }
        [btn_placeMarker setImage:[UIImage imageNamed:@"Placemarker_iconi6"] forState:UIControlStateNormal];
        [btn_placeMarker setTag:i];
        [btn_placeMarker addTarget:self action:@selector(networkNameTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn_placeMarker setExclusiveTouch:YES];
        [view_NetworkDetail addSubview:btn_placeMarker];
        
        UIView *view_NetworkName = [[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_NetworkName.frame = CGRectMake(0, 33, 88, 33);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_NetworkName.frame = CGRectMake(0, 46, 113, 33);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_NetworkName.frame = CGRectMake(0, 44, 103, 33);
        }
        view_NetworkName.backgroundColor = [UIColor clearColor];
        [view_NetworkDetail addSubview:view_NetworkName];
        
//        UILabel *lbl_NetworkDirection = [[UILabel alloc] init];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            lbl_NetworkDirection.frame = CGRectMake(0, 0, 88, 21);
//            lbl_NetworkDirection.font = [UIFont fontWithName:@"NexaBold" size:11];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            lbl_NetworkDirection.frame = CGRectMake(0, 0, 113, 21);
//            lbl_NetworkDirection.font = [UIFont fontWithName:@"NexaBold" size:13];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            lbl_NetworkDirection.frame = CGRectMake(0, 0, 103, 21);
//            lbl_NetworkDirection.font = [UIFont fontWithName:@"NexaBold" size:12];
//        }
//        lbl_NetworkDirection.textColor = [UIColor whiteColor];
//        lbl_NetworkDirection.textAlignment = NSTextAlignmentCenter;
//        lbl_NetworkDirection.text = @"9234 NORTH";
//        [view_NetworkName addSubview:lbl_NetworkDirection];
        
//        lblNetworkName[i] = [[UILabel alloc] init];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            lblNetworkName[i].frame = CGRectMake(0, 18, 88, 11);
//            lblNetworkName[i].font = [UIFont fontWithName:@"NexaBold" size:8];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            lblNetworkName[i].frame = CGRectMake(0, 19, 113, 11);
//            lblNetworkName[i].font = [UIFont fontWithName:@"NexaBold" size:10];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            lblNetworkName[i].frame = CGRectMake(0, 18, 103, 11);
//            lblNetworkName[i].font = [UIFont fontWithName:@"NexaBold" size:9];
//        }
//        lblNetworkName[i].textColor = lblRGBA(40, 165, 222, 1);
//        lblNetworkName[i].text = [[arr_NetworkList objectAtIndex:i] objectForKey:@"name"];
//        lblNetworkName[i].textAlignment = NSTextAlignmentCenter;
//        [view_NetworkName addSubview:lblNetworkName[i]];
        
        
        lblNetworkName[i] = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lblNetworkName[i].frame = CGRectMake(0, 0, 88, 42);
            lblNetworkName[i].font = [UIFont fontWithName:@"NexaBold" size:11];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lblNetworkName[i].frame = CGRectMake(0, 0, 113, 42);
            lblNetworkName[i].font = [UIFont fontWithName:@"NexaBold" size:13];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lblNetworkName[i].frame = CGRectMake(0, 0, 103, 42);
            lblNetworkName[i].font = [UIFont fontWithName:@"NexaBold" size:12];
        }
        lblNetworkName[i].textColor = [UIColor whiteColor];
        lblNetworkName[i].text = [[arr_NetworkList objectAtIndex:i] objectForKey:@"name"];
        lblNetworkName[i].textAlignment = NSTextAlignmentCenter;
        lblNetworkName[i].numberOfLines = 2;
        [view_NetworkName addSubview:lblNetworkName[i]];

        UIButton *btn_NetworkName = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_NetworkName.frame = CGRectMake(0, 33, 88, 33);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_NetworkName.frame = CGRectMake(0, 46, 113, 33);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_NetworkName.frame = CGRectMake(0, 44, 103, 33);
        }
        [btn_NetworkName setBackgroundColor:[UIColor clearColor]];
        btn_NetworkName.tag = i;
        [btn_NetworkName addTarget:self action:@selector(networkNameTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn_NetworkName setExclusiveTouch:YES];
        [view_NetworkDetail addSubview:btn_NetworkName];
        
        NSLog(@"view access Type == %d",[[[arr_NetworkList objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]);
        btn_EditNetwork[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_EditNetwork[i].frame = CGRectMake(6, 64, 20, 25);
//            [btn_EditNetwork[i] setImage:[UIImage imageNamed:@"view_icon"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_EditNetwork[i].frame = CGRectMake(6, 80, 30, 35);
//            [btn_EditNetwork[i] setImage:[UIImage imageNamed:@"view_iconi6plus"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_EditNetwork[i].frame = CGRectMake(8, 75, 25, 30);
//            [btn_EditNetwork[i] setImage:[UIImage imageNamed:@"view_iconi6"] forState:UIControlStateNormal];
        }
        [btn_EditNetwork[i] setImage:[UIImage imageNamed:@"WhiteEditImagei6plus"] forState:UIControlStateNormal];
        [btn_EditNetwork[i] setTag:i];
        [btn_EditNetwork[i] addTarget:self action:@selector(editNetworkTapped:) forControlEvents:UIControlEventTouchUpInside];
        [btn_EditNetwork[i] setExclusiveTouch:YES];
        [view_NetworkDetail addSubview:btn_EditNetwork[i]];
        
        if([[[arr_NetworkList objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==2||[[[arr_NetworkList objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==3)
        {
            [btn_EditNetwork[i] setHidden:YES];
        }

        if([arr_NetworkList count]-1==i)
        {
            if ([arr_NetworkList count]%3==0) {
                view_AddNetwork = [[UIView alloc] init];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_AddNetwork.frame = CGRectMake(21, view_Network[i].frame.origin.y+view_Network[i].frame.size.height+7, 88, 77);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_AddNetwork.frame = CGRectMake(28, view_Network[i].frame.origin.y+view_Network[i].frame.size.height+10, 113, 99);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    view_AddNetwork.frame = CGRectMake(25, view_Network[i].frame.origin.y+view_Network[i].frame.size.height+8, 103, 90);
                }
                view_AddNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
                [scrollView_MultipleNetWork addSubview:view_AddNetwork];
            }else{
                view_AddNetwork = [[UIView alloc] init];
                if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                    view_AddNetwork.frame = CGRectMake(xCoord, yCoord, 88, 77);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                    view_AddNetwork.frame = CGRectMake(xCoord, yCoord, 113, 99);
                }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                    view_AddNetwork.frame = CGRectMake(xCoord, yCoord, 103, 90);
                }
                view_AddNetwork.backgroundColor = lblRGBA(255, 206, 52, 1);
                [scrollView_MultipleNetWork addSubview:view_AddNetwork];
            }
            UIImageView *imgAddNetwork = [[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgAddNetwork.frame = CGRectMake(32, 17, 25, 24);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgAddNetwork.frame = CGRectMake(41, 26, 31, 31);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgAddNetwork.frame = CGRectMake(37, 23, 29, 29);
            }
            imgAddNetwork.image = [UIImage imageNamed:@"add_iconi6plus"];
            [view_AddNetwork addSubview:imgAddNetwork];
            
            UILabel *lblAddNetwork = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblAddNetwork.frame = CGRectMake(0, 50, 88, 21);
                lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:9.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblAddNetwork.frame = CGRectMake(0, 72, 113, 21);
                lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblAddNetwork.frame = CGRectMake(0, 63, 103, 21);
                lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:10.0];
            }
            lblAddNetwork.textColor = lblRGBA(255, 255, 255, 1);
            lblAddNetwork.text = @"ADD PROPERTY";
            lblAddNetwork.textAlignment = NSTextAlignmentCenter;
            [view_AddNetwork addSubview:lblAddNetwork];
            
            UIButton *btnAddNetwork = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnAddNetwork.frame = CGRectMake(0, 0, 88, 77);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnAddNetwork.frame = CGRectMake(0, 0, 113, 99);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btnAddNetwork.frame = CGRectMake(0, 0, 103, 90);
            }
            [btnAddNetwork addTarget:self action:@selector(addNetwork_Action:) forControlEvents:UIControlEventTouchUpInside];
            [view_AddNetwork addSubview:btnAddNetwork];
            
            scrollView_MultipleNetWork.contentSize = CGSizeMake(scrollView_MultipleNetWork.contentSize.width, view_AddNetwork.frame.origin.y+(view_AddNetwork.frame.size.height*2)+40);
        }
        
        defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
        if([[defaultsMultiple_Networks objectForKey:@"ACTIVENETWORKID"] isEqualToString:[[[arr_NetworkList objectAtIndex:i] objectForKey:@"id"] stringValue]])
        {
            view_Network[i].layer.borderColor=[UIColor colorWithRed:133 green:133 blue:133 alpha:1].CGColor;
            //view_Network[i].layer.borderColor=[UIColor redColor].CGColor;
            view_Network[i].layer.borderWidth=1.0;
        }
    }
    [self stop_PinWheel_MultipleNetwork];
}

-(void)popUpNewConfiguration_MultipleNw
{
    self.view_pushAlert.hidden=NO;
    [self.headerView_MultipleNw setAlpha:0.6];
    [self.bodyView_MultipleNw setAlpha:0.6];
}

-(void)popUpOldConfiguration_MultipleNw
{
    self.view_pushAlert.hidden=YES;
    [self.headerView_MultipleNw setAlpha:1.0];
    [self.bodyView_MultipleNw setAlpha:1.0];
}

- (void)networkNameTapped:(id)sender{
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"name tag==%ld",(long)btnTag.tag);
    [Common resetNetworkFlags];
    strNetworkAction=@"Home";
    selectedIndex=(int)btnTag.tag;
    //
    if([[[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue] && [[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Subscription Expired! Please check you card credentials and amount."];
        return;
    }
    //
    NSLog(@"selected network id ==%@",[[arr_NetworkList objectAtIndex:btnTag.tag] objectForKey:@"id"]);
    strNetworkID=[[[arr_NetworkList objectAtIndex:btnTag.tag] objectForKey:@"id"] stringValue];
    if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"accessTypeId"] intValue]==0)
    {
        strNetworkOwner=@"OwnNW";
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
    else
    {
        strNetworkOwner=@"OtherNW";
        if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==3)
        {
            [self popUpNewConfiguration_MultipleNw];
        }else if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==2)
        {
            
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

- (void)editNetworkTapped:(id)sender{
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"edit tag==%ld",(long)btnTag.tag);
    strNetworkAction=@"Edit";
    selectedIndex=(int)btnTag.tag;
    //
    if([[[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue] && [[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Subscription Expired! Please check you card credentials and amount."];
        return;
    }
    //
    NSLog(@"selected network id ==%@",[[arr_NetworkList objectAtIndex:btnTag.tag] objectForKey:@"id"]);
    strNetworkID=[[[arr_NetworkList objectAtIndex:btnTag.tag] objectForKey:@"id"] stringValue];
    if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"accessTypeId"] intValue]==0)
    {
        strNetworkOwner=@"OwnNW";
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
    else
    {
        strNetworkOwner=@"OtherNW";
        if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==3)
        {
            [self popUpNewConfiguration_MultipleNw];
        }else if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==2)
        {
            if([Common reachabilityChanged]==YES){
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
        
    }
}

- (void)networkImageTapped:(id)sender{
    [Common resetNetworkFlags];
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"image tag==%ld",(long)btnTag.tag);
    strNetworkAction=@"Home";
    selectedIndex=(int)btnTag.tag;
    //
    if([[[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue] && [[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Subscription Expired! Please check you card credentials and amount."];
        return;
    }
    //
    NSLog(@"selected network id ==%@",[[arr_NetworkList objectAtIndex:btnTag.tag] objectForKey:@"id"]);
    strNetworkID=[[[arr_NetworkList objectAtIndex:btnTag.tag] objectForKey:@"id"] stringValue];
    if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"accessTypeId"] intValue]==0)
    {
        strNetworkOwner=@"OwnNW";
        if([Common reachabilityChanged]==YES){
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
    else
    {
        strNetworkOwner=@"OtherNW";
        if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==3)
        {
            [self popUpNewConfiguration_MultipleNw];
        }
        else if([[[arr_NetworkList objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==2)
        {
            if([Common reachabilityChanged]==YES){
                
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

-(void)getSelected_Networks_ControllerDetails
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    //   NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks/%@/controllers",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"],strNetworkID];
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"],strNetworkID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Controller Details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(get_Controller_Details) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Controller Details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorMultipleNetworkSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)get_Controller_Details
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            NSMutableArray *arrController_Data=[[NSMutableArray alloc] init];
//            arrController_Data=[responseDict objectForKey:@"data"];
            arrController_Data=[[responseDict objectForKey:@"data"] objectForKey:@"networkDetails"];
            strTimeZoneIDFor_User=[[responseDict valueForKey:@"data"] objectForKey:@"timeZoneId"];
            NSLog(@"array count ==%lu",(unsigned long)arrController_Data.count);
            if([arrController_Data count]>0)
            {
                [self navigate_Network_HomeVia_MultiPleNetwork:[arrController_Data objectAtIndex:0]];
            }else{
                [self stop_PinWheel_MultipleNetwork];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
        }else{
            [self stop_PinWheel_MultipleNetwork];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetwork];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)navigate_Network_HomeVia_MultiPleNetwork:(NSDictionary *)dictNetworkDetails
{
    NSLog(@"whole dict ==%@",dictNetworkDetails);
    @try {
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.dict_NetworkControllerDatas = [[NSMutableDictionary alloc] init];
        [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"alert"] forKey:kAlertCount];
        [appDelegate.dict_NetworkControllerDatas setObject:[[dictNetworkDetails valueForKey:@"id"] stringValue] forKey:kNetworkID];
        [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"message"] forKey:kMessageCount];
        [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"latitude"] forKey:kLat];
        [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"longitude"] forKey:kLong];
        [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"name"] forKey:kNetworkName];
        [appDelegate.dict_NetworkControllerDatas setObject:[dictNetworkDetails valueForKey:@"thumbnailImage"] forKey:kNetWrokImage];
        NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
        
        
        NSLog(@"invitee id is == %@",[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"inviteeId"] stringValue]);
        appDelegate.strInviteeID=[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"inviteeId"] stringValue];
        
        NSDictionary *dictNetworkStatus=[dictNetworkDetails valueForKey:@"networkStatus"];
        NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
        if(arrController.count>0)
        {
            if([strNetworkOwner isEqualToString:@"OtherNW"])
            {
                appDelegate.strOwnerNetwork_Status=@"NO";
                NSLog(@"Permission =%@",[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue]);
                appDelegate.strNetworkPermission=[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue];
            }else{
                appDelegate.strOwnerNetwork_Status=@"YES";
            }
            NSDictionary *dictController=[arrController objectAtIndex:0];
            NSLog(@"controller id ==%@",[dictController valueForKey:@"id"]);
            NSDictionary *dictControllerTrace = [[dictController valueForKey:@"controllerTrace"] valueForKey:@"controllerConnectivityType"];
            NSLog(@"controllerConnectivityType is ==%@",dictControllerTrace);
            [appDelegate.dict_NetworkControllerDatas setObject:[dictControllerTrace valueForKey:@"typeCode"] forKey:kControllerType];
            [appDelegate.dict_NetworkControllerDatas setObject:[[dictController valueForKey:@"id"] stringValue] forKey:kControllerID];
            NSLog(@"controller type%@",[dictControllerTrace valueForKey:@"typeCode"]);
            NSLog(@"network details==%@",appDelegate.dict_NetworkControllerDatas);
            NSLog(@"controller Trace ID ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"]);
            if ([[dictControllerTrace valueForKey:@"typeCode"] isEqualToString:@"WIFI"]) {
                [self stop_PinWheel_MultipleNetwork];
                if([strNetworkAction isEqualToString:@"Home"]){
                    SWRevealViewController *SWR = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                    SWR = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                    NSArray *newStack = @[SWR];
                    [self.navigationController setViewControllers:newStack animated:YES];
                    
                }else{
                    appDelegate.strController_Setup_Mode=@"MultipleNetwork";
                    WifiViewController *WVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiViewController"];
                    WVC.str_MultipleNetwork_Mode=@"edit";
                    WVC.strWifiAccessType = [[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue];
                    WVC.strController_TraceID=[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue];
                    [self.navigationController pushViewController:WVC animated:YES];
                }
            }else{
                if([strNetworkAction isEqualToString:@"Home"]){
                    if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue])
                    {
                        [self stop_PinWheel_MultipleNetwork];
                        SWRevealViewController *SWR = [[SWRevealViewController alloc] initWithNibName:@"SWRevealViewController" bundle:nil];
                        SWR = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                        NSArray *newStack = @[SWR];
                        [self.navigationController setViewControllers:newStack animated:YES];
                    }else{
                        NSLog(@"billing plan ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"]);
                        appDelegate.strController_Setup_Mode=@"MultipleNetwork";
                        CellularViewController *CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CellularViewController"];
                        CVC.str_MultipleNetwork_Mode=@"edit";
                        
                        if([[dictNetworkStatus valueForKey:@"hasControllerConnected"] boolValue])
                        {
                            CVC.strController_ConnectedSTS=@"YES";
                        }
                        else{
                            CVC.strController_ConnectedSTS=@"NO";
                        }
                        if([[dictNetworkStatus valueForKey:@"hasPaymentCard"] boolValue])
                        {
                            CVC.strController_PaymentCardSTS=@"YES";
                        }
                        else{
                            CVC.strController_PaymentCardSTS=@"NO";
                        }
                        if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue])
                        {
                            CVC.strController_PaymentCompletedSTS=@"YES";
                        }
                        else{
                            CVC.strController_PaymentCompletedSTS=@"NO";
                        }
                        CVC.dictController_BasicPlan=[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"];
                        CVC.strController_TraceID=[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue];
                        CVC.strCellularAccessType =[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue];
                        CVC.strTimeZoneIDFor_User=strTimeZoneIDFor_User;
                        [self stop_PinWheel_MultipleNetwork];
                        [self.navigationController pushViewController:CVC animated:YES];
                    }
                }else{
                    NSLog(@"billing plan ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"]);
                    appDelegate.strController_Setup_Mode=@"MultipleNetwork";
                    CellularViewController *CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CellularViewController"];
                    CVC.str_MultipleNetwork_Mode=@"edit";
                    
                    if([[dictNetworkStatus valueForKey:@"hasControllerConnected"] boolValue])
                    {
                        CVC.strController_ConnectedSTS=@"YES";
                    }
                    else{
                        CVC.strController_ConnectedSTS=@"NO";
                    }
                    if([[dictNetworkStatus valueForKey:@"hasPaymentCard"] boolValue])
                    {
                        CVC.strController_PaymentCardSTS=@"YES";
                    }
                    else{
                        CVC.strController_PaymentCardSTS=@"NO";
                    }
                    if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue])
                    {
                        CVC.strController_PaymentCompletedSTS=@"YES";
                    }
                    else{
                        CVC.strController_PaymentCompletedSTS=@"NO";
                    }
                    CVC.dictController_BasicPlan=[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"];
                    CVC.strController_TraceID=[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue];
                    CVC.strCellularAccessType =[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue];
                    CVC.strTimeZoneIDFor_User=strTimeZoneIDFor_User;
                    [self stop_PinWheel_MultipleNetwork];
                    [self.navigationController pushViewController:CVC animated:YES];
                }
            }
        }
        else{
            [self stop_PinWheel_MultipleNetwork];
            [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetwork];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

#pragma mark - Webservice Integration

-(void)acceptNetworks_NOID
{
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/receivedNetworks",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]];
    NSLog(@"invitee id ==%@",[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictDetails=[[NSMutableDictionary alloc] init];
    [dictDetails setObject:[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue] forKey:kNetworkID];
    [dictDetails setObject:@"2" forKey:kaccesstype];
    
    parameters=[SCM accpetNetworksShared:dictDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for accpet shared networks==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAcceptedNetworks) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Controller cellular Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorMultipleNetworkSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseAcceptedNetworks
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            view_Network[selectedIndex].alpha=1.0;
            [self stop_PinWheel_MultipleNetwork];
            //[Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
            [self resetNOIDNW];
        }else{
            [self stop_PinWheel_MultipleNetwork];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetwork];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
    }
}

-(void)declineNetworks_NOID
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSLog(@"invitee id ==%@",[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/receivedNetworks?type=%@&inviteeNetworkId=%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"],@"3",[[[arr_NetworkList objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Decline Shared Network==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAcceptedNetworks) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for  Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetwork) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseErrorMultipleNetworkSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is called to start the Progress HUD
 Method Name : start_PinWheel_Registeration(User Defined Method)
 ************************************************************************************* */
-(void)start_PinWheel_MultipleNetwork{
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
-(void)stop_PinWheel_MultipleNetwork{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strLaunchOrientation=@"";
}

@end
