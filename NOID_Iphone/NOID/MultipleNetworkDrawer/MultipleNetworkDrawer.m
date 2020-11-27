//
//  MultipleNetworkDrawer.m
//  NOID
//
//  Created by Karthik on 10/12/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "MultipleNetworkDrawer.h"
#import "SWRevealViewController.h"
#import "ControllerSetUpViewController.h"
#import "Utils.h"
#import "Common.h"
#import "ServiceConnectorModel.h"
#import "Base64.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "WifiViewController.h"
#import "CellularViewController.h"

#define kButtonIndex 1000
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MultipleNetworkDrawer ()
{
    UIView *view_NetworkDrawer[kButtonIndex];
    UIImageView *img_NetworkProfile_drawer[kButtonIndex];
    AsyncImageView *postimageView[kButtonIndex];
    AsyncImageView *aPostimageView[kButtonIndex];
    UIButton *btn_EditNetwork_drawer[kButtonIndex];
    UIImageView *imgPayment_Inactive[kButtonIndex];
}

@end

@implementation MultipleNetworkDrawer
@synthesize view_AddNetwork_drawer,scroll_MultiNetwork_Drawer,arrNetworkList_drawer;

- (void)viewDidLoad {
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"DICT Network Data ==%@",appDelegate.dict_NetworkControllerDatas);
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [super viewDidLoad];
    scroll_MultiNetwork_Drawer.delegate=self;
    scroll_MultiNetwork_Drawer.scrollsToTop=NO;
    self.view_pushAlert_drawer.hidden=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        NSLog(@"landscape");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }

    //[self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.frontViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController.frontViewController.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate.strNetworkDrawer_Status isEqualToString:@"YES"])
    {
        appDelegate.strNetworkDrawer_Status=@"";
        if([Common reachabilityChanged]==YES){
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getAllControllerNetworks_Drawer_NOID) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }else if([appDelegate.strNetworkDrawer_Status isEqualToString:@"ReSet"]){
        appDelegate.strNetworkDrawer_Status=@"";
        [self resetNOIDNWDrawer];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"view dis appear");
    // [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    [self.revealViewController.frontViewController.view removeGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController.frontViewController.view removeGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNOIDNetowrksDrawer:) name:@"PushMessageReceivedNotification" object:nil];
}

-(void)incomingNOIDNetowrksDrawer:(NSNotification *)notification{
    
    if([[notification object] isEqualToString:@"YES"])
    {
        [self popUpOldConfiguration_MultipleNwDrawer];
        [self resetNOIDNWDrawer];
        
    }
}
-(void)resetNOIDNWDrawer
{
    self.scroll_MultiNetwork_Drawer.hidden=YES;
    
    [[self.scroll_MultiNetwork_Drawer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scroll_MultiNetwork_Drawer.hidden=NO;
    if([Common reachabilityChanged]==YES){
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
        [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
        [self performSelectorInBackground:@selector(getAllControllerNetworks_Drawer_NOID) withObject:self];
        
    }else{
        [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    }
}

#pragma mark - IBActions

-(IBAction)selectNetwork_Action:(id)sender
{
    SWRevealViewController *revealController = self.revealViewController;
    [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}

-(IBAction)accept_decline_DrawerAlertAction:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    switch (btnTag.tag) {
        case 0: //Accept
        {
            if([Common reachabilityChanged]==YES){
                [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(acceptNetworks_NOIDDrawer) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                return;
            }
            [self popUpOldConfiguration_MultipleNwDrawer];
        }
            break;
        case 1:  //Decline
        {
            if([Common reachabilityChanged]==YES){
                [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(declineNetworks_NOIDDrawer) withObject:self];
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
                return;
            }
            [self popUpOldConfiguration_MultipleNwDrawer];
        }
            break;
        case 2: //close
        {
            [self popUpOldConfiguration_MultipleNwDrawer];
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        }
            break;
    }
}

#pragma mark - User Defined Method
-(void)popUpOldConfiguration_MultipleNwDrawer
{
    self.view_pushAlert_drawer.hidden=YES;
    [self.scroll_MultiNetwork_Drawer setAlpha:1.0];
}

-(void)popUpNewConfiguration_MultipleNwDrawer
{
    self.view_pushAlert_drawer.hidden=NO;
    [self.scroll_MultiNetwork_Drawer setAlpha:0.6];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
}

-(void)parse_DrawerNetworksDatas
{
    float y=0;
    #define REC_POSTUSER_IMG_TAG 999

    NSLog(@"arr_Network_Data count==%lu",(unsigned long)arrNetworkList_drawer.count);
    for(int i=0;i<[arrNetworkList_drawer count];i++){
        
        view_NetworkDrawer[i] = [[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_NetworkDrawer[i].frame = CGRectMake(0, y, 270, 65);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_NetworkDrawer[i].frame = CGRectMake(0, y, 355, 85);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_NetworkDrawer[i].frame = CGRectMake(0, y, 310, 75);
        }

        view_NetworkDrawer[i].backgroundColor=[UIColor clearColor];
        [scroll_MultiNetwork_Drawer addSubview:view_NetworkDrawer[i]];
        
        
        [AsyncImageLoader sharedLoader].cache = nil;
        postimageView[i] = [[AsyncImageView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            postimageView[i].frame = CGRectMake(0.0f, 0.0f, 80.0f, 65.0f);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            postimageView[i].frame = CGRectMake(0.0f, 0.0f, 85.0f, 85.0f);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            postimageView[i].frame = CGRectMake(0.0f, 0.0f, 80.0f, 75.0f);
        }
        postimageView[i].tag =REC_POSTUSER_IMG_TAG;
        postimageView[i].activityIndicatorStyle= UIActivityIndicatorViewStyleWhite;
        [view_NetworkDrawer[i] addSubview:postimageView[i]];
        
        //get image view
        aPostimageView[i] = (AsyncImageView *)[view_NetworkDrawer[i] viewWithTag:REC_POSTUSER_IMG_TAG];
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:aPostimageView[i]];
        
        if([[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"thumbnailImage"] isEqualToString:@""]){
            aPostimageView[i].image=[UIImage imageNamed:@"noNetworkImage"];
        }else
        {
            aPostimageView[i].image=[UIImage imageWithData:[Base64 decode:[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"thumbnailImage"]]];
        }

        if([[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]>0)
        {
            if([[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"inviteeNetStatus"] intValue]==3)
            {
                view_NetworkDrawer[i].alpha=0.4;
            }
        }

        if([[[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
        {
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgPayment_Inactive[i]=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 65.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgPayment_Inactive[i]=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 85.0f, 85.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgPayment_Inactive[i]=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 75.0f)];
            }
            
            imgPayment_Inactive[i].image=[UIImage imageNamed:@"deviceVaction1"];
            [view_NetworkDrawer[i] addSubview:imgPayment_Inactive[i]];
        }
        else if([[[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue])
        {
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgPayment_Inactive[i]=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 65.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgPayment_Inactive[i]=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 85.0f, 85.0f)];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgPayment_Inactive[i]=[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 75.0f)];
            }
            
            imgPayment_Inactive[i].image=[UIImage imageNamed:@"deviceVaction1"];
            [view_NetworkDrawer[i] addSubview:imgPayment_Inactive[i]];
        }
        UIButton *btn_NetworkImage_Drawer = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_NetworkImage_Drawer.frame = CGRectMake(0, 0, 80, 65);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_NetworkImage_Drawer.frame = CGRectMake(0, 0, 85, 85);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_NetworkImage_Drawer.frame = CGRectMake(0, 0, 80, 75);
        }
        [btn_NetworkImage_Drawer setTag:i];
        [btn_NetworkImage_Drawer addTarget:self action:@selector(networkImageTapped_Drawer:) forControlEvents:UIControlEventTouchUpInside];
        [btn_NetworkImage_Drawer setExclusiveTouch:YES];
        [view_NetworkDrawer[i] addSubview:btn_NetworkImage_Drawer];
        
        UIView *view_NetworkDetail_Drawer = [[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_NetworkDetail_Drawer.frame = CGRectMake(80, 0, 188, 65);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_NetworkDetail_Drawer.frame = CGRectMake(85, 0, 270, 85);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_NetworkDetail_Drawer.frame = CGRectMake(80, 0, 229, 75);
        }
        view_NetworkDetail_Drawer.backgroundColor = lblRGBA(77, 77, 79, 1);
        [view_NetworkDrawer[i] addSubview:view_NetworkDetail_Drawer];
        
        UIButton *btn_placeMarker_Drawer = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_placeMarker_Drawer.frame = CGRectMake(159, 20, 16, 25);
//            [btn_placeMarker_Drawer setImage:[UIImage imageNamed:@"Placemarker_icon"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_placeMarker_Drawer.frame = CGRectMake(230, 22, 21, 32);
//            [btn_placeMarker_Drawer setImage:[UIImage imageNamed:@"Placemarker_iconi6plus"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_placeMarker_Drawer.frame = CGRectMake(199, 23, 19, 29);
//            [btn_placeMarker_Drawer setImage:[UIImage imageNamed:@"Placemarker_iconi6"] forState:UIControlStateNormal];
        }
        [btn_placeMarker_Drawer setImage:[UIImage imageNamed:@"Placemarker_iconi6"] forState:UIControlStateNormal];
        [btn_placeMarker_Drawer setTag:i];
        [btn_placeMarker_Drawer addTarget:self action:@selector(networkNameTapped_Drawer:) forControlEvents:UIControlEventTouchUpInside];
        [btn_placeMarker_Drawer setExclusiveTouch:YES];
        [view_NetworkDetail_Drawer addSubview:btn_placeMarker_Drawer];
        
        UIView *view_NetworkName_Drawer = [[UIView alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            view_NetworkName_Drawer.frame = CGRectMake(0, 0, 146, 41);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            view_NetworkName_Drawer.frame = CGRectMake(0, 0, 205, 54);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            view_NetworkName_Drawer.frame = CGRectMake(0, 0, 161, 60);
        }
        view_NetworkName_Drawer.backgroundColor = [UIColor clearColor];
        [view_NetworkDetail_Drawer addSubview:view_NetworkName_Drawer];
        
//        UILabel *lbl_NetworkDirection_drawer = [[UILabel alloc] init];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            lbl_NetworkDirection_drawer.frame = CGRectMake(10, 7, 119, 21);
//            lbl_NetworkDirection_drawer.font = [UIFont fontWithName:@"NexaBold" size:11.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            lbl_NetworkDirection_drawer.frame = CGRectMake(10, 12, 205, 21);
//            lbl_NetworkDirection_drawer.font = [UIFont fontWithName:@"NexaBold" size:13.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            lbl_NetworkDirection_drawer.frame = CGRectMake(10, 12, 161, 21);
//            lbl_NetworkDirection_drawer.font = [UIFont fontWithName:@"NexaBold" size:12.0];
//        }
//        lbl_NetworkDirection_drawer.textColor = [UIColor whiteColor];
//        lbl_NetworkDirection_drawer.text = @"9234 NORTH";
//        [view_NetworkName_Drawer addSubview:lbl_NetworkDirection_drawer];
        
//        UILabel *lbl_NetworkName_drawer = [[UILabel alloc] init];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            lbl_NetworkName_drawer.frame = CGRectMake(10, 22, 124, 21);
//            lbl_NetworkName_drawer.font = [UIFont fontWithName:@"NexaBold" size:8.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            lbl_NetworkName_drawer.frame = CGRectMake(10, 27, 205, 21);
//            lbl_NetworkName_drawer.font = [UIFont fontWithName:@"NexaBold" size:10.0];
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            lbl_NetworkName_drawer.frame = CGRectMake(10, 27, 161, 21);
//            lbl_NetworkName_drawer.font = [UIFont fontWithName:@"NexaBold" size:9.0];
//        }
//        lbl_NetworkName_drawer.textColor = lblRGBA(40, 165, 222, 1);
//        lbl_NetworkName_drawer.text = [[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"name"];
//        [view_NetworkName_Drawer addSubview:lbl_NetworkName_drawer];
        
        UILabel *lbl_NetworkName_drawer = [[UILabel alloc] init];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            lbl_NetworkName_drawer.frame = CGRectMake(10, 7, 119, 42);
            lbl_NetworkName_drawer.font = [UIFont fontWithName:@"NexaBold" size:11.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            lbl_NetworkName_drawer.frame = CGRectMake(10, 12, 205, 42);
            lbl_NetworkName_drawer.font = [UIFont fontWithName:@"NexaBold" size:13.0];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            lbl_NetworkName_drawer.frame = CGRectMake(10, 12, 161, 42);
            lbl_NetworkName_drawer.font = [UIFont fontWithName:@"NexaBold" size:12.0];
        }
        lbl_NetworkName_drawer.textColor = [UIColor whiteColor];
        lbl_NetworkName_drawer.numberOfLines = 2;
        lbl_NetworkName_drawer.text = [[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"name"];
        [view_NetworkName_Drawer addSubview:lbl_NetworkName_drawer];

        UIButton *btn_NetworkName_drawer = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_NetworkName_drawer.frame = CGRectMake(0, 0, 146, 41);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_NetworkName_drawer.frame = CGRectMake(0, 0, 205, 54);
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_NetworkName_drawer.frame = CGRectMake(0, 0, 161, 60);
        }
        [btn_NetworkName_drawer setBackgroundColor:[UIColor clearColor]];
        btn_NetworkName_drawer.tag = i;
        [btn_NetworkName_drawer addTarget:self action:@selector(networkNameTapped_Drawer:) forControlEvents:UIControlEventTouchUpInside];
        [btn_NetworkName_drawer setExclusiveTouch:YES];
        [view_NetworkName_Drawer addSubview:btn_NetworkName_drawer];
        
        btn_EditNetwork_drawer[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
            btn_EditNetwork_drawer[i].frame = CGRectMake(8, 42, 20, 25);
//            [btn_EditNetwork_drawer[i] setImage:[UIImage imageNamed:@"view_icon"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
            btn_EditNetwork_drawer[i].frame = CGRectMake(12, 50, 35, 40);
//            [btn_EditNetwork_drawer[i] setImage:[UIImage imageNamed:@"view_iconi6plus"] forState:UIControlStateNormal];
        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
            btn_EditNetwork_drawer[i].frame = CGRectMake(8, 43, 25, 30);
//            [btn_EditNetwork_drawer[i] setImage:[UIImage imageNamed:@"view_iconi6"] forState:UIControlStateNormal];
        }
        [btn_EditNetwork_drawer[i] setImage:[UIImage imageNamed:@"WhiteEditImagei6plus"] forState:UIControlStateNormal];
        [btn_EditNetwork_drawer[i] setTag:i];
        [btn_EditNetwork_drawer[i] addTarget:self action:@selector(editNetworkTapped_Drawer:) forControlEvents:UIControlEventTouchUpInside];
        [btn_EditNetwork_drawer[i] setExclusiveTouch:YES];
        [view_NetworkDetail_Drawer addSubview:btn_EditNetwork_drawer[i]];
        
        if([[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==2||[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"accessTypeId"] intValue]==3)
        {
            [btn_EditNetwork_drawer[i] setHidden:YES];
        }

//        UIButton *btn_PreviewNetwork_drawer = [UIButton buttonWithType:UIButtonTypeCustom];
//        if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
//            btn_PreviewNetwork_drawer.frame = CGRectMake(36, 47, 18, 10);
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
//            btn_PreviewNetwork_drawer.frame = CGRectMake(43, 60, 18, 10);
//        }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
//            btn_PreviewNetwork_drawer.frame = CGRectMake(36, 53, 18, 10);
//        }
//        [btn_PreviewNetwork_drawer setImage:[UIImage imageNamed:@"AlertEye"] forState:UIControlStateNormal];
//        [btn_PreviewNetwork_drawer setTag:i];
//        [view_NetworkDetail_Drawer addSubview:btn_PreviewNetwork_drawer];
        
        y=y+view_NetworkDrawer[i].frame.size.height+6;
        
        if([arrNetworkList_drawer count]-1==i)
        {
            view_AddNetwork_drawer = [[UIView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                view_AddNetwork_drawer.frame = CGRectMake(72, y+10, 120, 77);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                view_AddNetwork_drawer.frame = CGRectMake(84, y+10, 175, 103);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                view_AddNetwork_drawer.frame = CGRectMake(76, y+10, 149, 91);
            }
            view_AddNetwork_drawer.backgroundColor = lblRGBA(255, 206, 52, 1);
            [scroll_MultiNetwork_Drawer addSubview:view_AddNetwork_drawer];
            
            UIImageView *imgAddNetwork = [[UIImageView alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                imgAddNetwork.frame = CGRectMake(48, 17, 25, 24);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                imgAddNetwork.frame = CGRectMake(75, 18, 25, 24);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                imgAddNetwork.frame = CGRectMake(62, 18, 25, 24);
            }
            imgAddNetwork.image = [UIImage imageNamed:@"add_iconi6plus"];
            [view_AddNetwork_drawer addSubview:imgAddNetwork];
            
            UILabel *lblAddNetwork = [[UILabel alloc] init];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                lblAddNetwork.frame = CGRectMake(16, 50, 88, 21);
                lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:10.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                lblAddNetwork.frame = CGRectMake(36, 62, 103, 21);
                lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:12.0];
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                lblAddNetwork.frame = CGRectMake(30, 57, 88, 21);
                lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:11.0];
            }
            lblAddNetwork.textColor = lblRGBA(255, 255, 255, 1);
            lblAddNetwork.text = @"ADD PROPERTY";
            lblAddNetwork.textAlignment = NSTextAlignmentCenter;
            [view_AddNetwork_drawer addSubview:lblAddNetwork];
            
            UIButton *btnAddNetwork = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
                btnAddNetwork.frame = CGRectMake(0, 0, 120, 77);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
                btnAddNetwork.frame = CGRectMake(0, 0, 175, 103);
            }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
                btnAddNetwork.frame = CGRectMake(0, 0, 149, 91);
            }
            [btnAddNetwork addTarget:self action:@selector(addNetwork_Action_Drawer:) forControlEvents:UIControlEventTouchUpInside];
            [view_AddNetwork_drawer addSubview:btnAddNetwork];
            
            self.scroll_MultiNetwork_Drawer.contentSize = CGSizeMake(self.scroll_MultiNetwork_Drawer.contentSize.width, view_AddNetwork_drawer.frame.origin.y+view_AddNetwork_drawer.frame.size.height+20);
        }
        
        defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
        if([[defaultsMultiple_Networks objectForKey:@"ACTIVENETWORKID"] isEqualToString:[[[arrNetworkList_drawer objectAtIndex:i] objectForKey:@"id"] stringValue]])
        {
            view_NetworkDrawer[i].layer.borderColor=[UIColor colorWithRed:133 green:133 blue:133 alpha:1].CGColor;
            //view_Network[i].layer.borderColor=[UIColor redColor].CGColor;
            view_NetworkDrawer[i].layer.borderWidth=2.0;
        }
    }
    [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

-(void)addNetwork_Action_Drawer:(id)sender
{
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"name tag==%ld",(long)btnTag.tag);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.strController_Setup_Mode=@"NetworkHomeDrawer";
    appDelegate.strNoidLogo=@"Add/Edit";
    appDelegate.strDevice_Added_Mode=@"";
    appDelegate.strOwnerNetwork_Status=@"YES";
    ControllerSetUpViewController *CSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ControllerSetUpViewController"];
    CSVC.str_MultipleNetwork_Mode=@"";
    [Common viewFadeIn:self.navigationController.view];
    [self.navigationController pushViewController:CSVC animated:NO];
}

- (void)networkNameTapped_Drawer:(id)sender{
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"name tag==%ld",(long)btnTag.tag);
    strNetworkAction=@"Home";
    selectedIndex=(int)btnTag.tag;
    //
    if([[[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue] && [[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Subscription Expired! Please check you card credentials and amount."];
        return;
    }
    //
    NSLog(@"selected network id ==%@",[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"id"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"already displayed network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    strNetworkID=[[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"id"] stringValue];
    if([strNetworkID isEqualToString:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]]){
        appDelegate.strChangeDrawerData=@"";
        SWRevealViewController *revealController = self.revealViewController;
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"accessTypeId"] intValue]==0)
    {
        strNetworkOwner=@"OwnNW";
        if([Common reachabilityChanged]==YES){
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails_Drawer) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }else
    {
        strNetworkOwner=@"OtherNW";
        if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==3)
        {
            [self popUpNewConfiguration_MultipleNwDrawer];
        }else if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==2)
        {
            
            if([Common reachabilityChanged]==YES){
                [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails_Drawer) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

- (void)editNetworkTapped_Drawer:(id)sender{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.strNoidLogo=@"Add/Edit";
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"edit tag==%ld",(long)btnTag.tag);
    strNetworkAction=@"Edit";
    selectedIndex=(int)btnTag.tag;
    ///
    //
    if([[[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue] && [[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Subscription Expired! Please check you card credentials and amount."];
        return;
    }
    //
    
    //
    NSLog(@"selected network id ==%@",[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"id"]);
    strNetworkID=[[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"id"] stringValue];
    if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"accessTypeId"] intValue]==0)
    {
        strNetworkOwner=@"OwnNW";
        if([Common reachabilityChanged]==YES){
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails_Drawer) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
    else
    {
        strNetworkOwner=@"OtherNW";
        if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==3)
        {
            [self popUpNewConfiguration_MultipleNwDrawer];
        }else if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==2)
        {
            
            if([Common reachabilityChanged]==YES){
                [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails_Drawer) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

- (void)networkImageTapped_Drawer:(id)sender{
    NSLog(@"DICT Network Data ==%@",appDelegate.dict_NetworkControllerDatas);
    UIButton *btnTag = (UIButton *)sender;
    NSLog(@"image tag==%ld",(long)btnTag.tag);
    strNetworkAction=@"Home";
    selectedIndex=(int)btnTag.tag;
    //
    if([[[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"controllerTypeId"] stringValue] isEqualToString:@"2"] && ![[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentRenewed"] boolValue] && [[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"networkStatus"] objectForKey:@"hasPaymentCompleted"] boolValue])
    {
        [Common showAlert:kAlertTitleWarning withMessage:@"Subscription Expired! Please check you card credentials and amount."];
        return;
    }
    //
    
    NSLog(@"selected network id ==%@",[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"id"]);
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"already displayed network id ==%@",[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]);
    strNetworkID=[[[arrNetworkList_drawer objectAtIndex:btnTag.tag] objectForKey:@"id"] stringValue];
    if([strNetworkID isEqualToString:[appDelegate.dict_NetworkControllerDatas valueForKey:kNetworkID]]){
        appDelegate.strChangeDrawerData=@"";
        SWRevealViewController *revealController = self.revealViewController;
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"accessTypeId"] intValue]==0)
    {
        strNetworkOwner=@"OwnNW";
        if([Common reachabilityChanged]==YES){
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
            [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
            [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails_Drawer) withObject:self];
            
        }else{
            [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
        }
    }
    else
    {
        strNetworkOwner=@"OtherNW";
        if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==1||[[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==3)
        {
            [self popUpNewConfiguration_MultipleNwDrawer];
        }else if([[[arrNetworkList_drawer objectAtIndex:btnTag.tag]objectForKey:@"inviteeNetStatus"] intValue]==2)
        {
            
            if([Common reachabilityChanged]==YES){
                [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
                [self performSelectorOnMainThread:@selector(start_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
                [self performSelectorInBackground:@selector(getSelected_Networks_ControllerDetails_Drawer) withObject:self];
                
            }else{
                [Common showAlert:kAlertTitleWarning withMessage:@"Please Check Your Network Connection"];
            }
        }
    }
}

-(void)addNetWorkOnly_MultipleNetworkDrawer
{
    view_AddNetwork_drawer = [[UIView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        view_AddNetwork_drawer.frame = CGRectMake(72,0, 120, 77);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        view_AddNetwork_drawer.frame = CGRectMake(84, 0, 175, 103);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        view_AddNetwork_drawer.frame = CGRectMake(76, 0, 149, 91);
    }
    view_AddNetwork_drawer.backgroundColor = lblRGBA(255, 206, 52, 1);
    [scroll_MultiNetwork_Drawer addSubview:view_AddNetwork_drawer];
    
    UIImageView *imgAddNetwork = [[UIImageView alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        imgAddNetwork.frame = CGRectMake(48, 17, 25, 24);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        imgAddNetwork.frame = CGRectMake(75, 18, 25, 24);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        imgAddNetwork.frame = CGRectMake(62, 18, 25, 24);
    }
    imgAddNetwork.image = [UIImage imageNamed:@"add_iconi6plus"];
    [view_AddNetwork_drawer addSubview:imgAddNetwork];
    
    UILabel *lblAddNetwork = [[UILabel alloc] init];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        lblAddNetwork.frame = CGRectMake(16, 50, 88, 21);
        lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:10.0];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        lblAddNetwork.frame = CGRectMake(36, 62, 103, 21);
        lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:12.0];
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        lblAddNetwork.frame = CGRectMake(30, 57, 88, 21);
        lblAddNetwork.font = [UIFont fontWithName:@"NexaBold" size:11.0];
    }
    lblAddNetwork.textColor = lblRGBA(255, 255, 255, 1);
    lblAddNetwork.text = @"ADD NETWORK";
    lblAddNetwork.textAlignment = NSTextAlignmentCenter;
    [view_AddNetwork_drawer addSubview:lblAddNetwork];
    
    UIButton *btnAddNetwork = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[Common deviceType] isEqualToString:@"iPhone5"]) {
        btnAddNetwork.frame = CGRectMake(0, 0, 120, 77);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6plus"]){
        btnAddNetwork.frame = CGRectMake(0, 0, 175, 103);
    }else if ([[Common deviceType] isEqualToString:@"iPhone6"]){
        btnAddNetwork.frame = CGRectMake(0, 0, 149, 91);
    }
    [btnAddNetwork addTarget:self action:@selector(addNetwork_Action_Drawer:) forControlEvents:UIControlEventTouchUpInside];
    [view_AddNetwork_drawer addSubview:btnAddNetwork];
    
    scroll_MultiNetwork_Drawer.contentSize = CGSizeMake(scroll_MultiNetwork_Drawer.contentSize.width, view_AddNetwork_drawer.frame.origin.y+view_AddNetwork_drawer.frame.size.height+20);
}
#pragma mark - Webservice Methods
-(void)getAllControllerNetworks_Drawer_NOID
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]];
    //  SCM.callbackValue=^(NSMutableDictionary *dict){
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Controller Availability==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(load_MultipleNetworkDrawer_Contents) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Controller Availability ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseError_MultipleNetworkDrawerSetup) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}

-(void)responseError_MultipleNetworkDrawerSetup
{
    [Common showAlert:@"Warning" withMessage:strResponseError];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    // self.view_AddNetwork.hidden=NO;
}
-(void)load_MultipleNetworkDrawer_Contents
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            arrNetworkList_drawer = [[NSMutableArray alloc] init];
            arrNetworkList_drawer=[responseDict objectForKey:@"data"];
            NSLog(@"arr_Network_Data count==%lu",(unsigned long)arrNetworkList_drawer.count);
            [self parse_DrawerNetworksDatas];
        }else{
            [self stop_PinWheel_MultipleNetworkDrawer];
            //[Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            if(![responseMessage isEqualToString:@"No properties to view"])
            {
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            }
            [self addNetWorkOnly_MultipleNetworkDrawer];
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetworkDrawer];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self addNetWorkOnly_MultipleNetworkDrawer];
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        //self.view_AddNetwork.hidden=NO;
    }
    
}

-(void)getSelected_Networks_ControllerDetails_Drawer
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/networks?networkId=%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"],strNetworkID];
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Controller Details ==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(get_Controller_DetailsDrawer) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for Controller Details ==%@",resErrorString);
        strResponseError=resErrorString;
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseError_MultipleNetworkDrawerSetup) withObject:self waitUntilDone:YES];
        
    };
    [SCM serviceConnectorGET:strMethodNameWith_Value];
}
-(void)get_Controller_DetailsDrawer
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
                [self navigate_Network_HomeVia_Drawer:[arrController_Data objectAtIndex:0]];
            }else{
                [self stop_PinWheel_MultipleNetworkDrawer];
                [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
                [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
            }
        }else{
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
            [self stop_PinWheel_MultipleNetworkDrawer];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        [self stop_PinWheel_MultipleNetworkDrawer];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    }
}
-(void)navigate_Network_HomeVia_Drawer:(NSDictionary *)dictNetworkDetails
{
    NSLog(@"whole dict ==%@",dictNetworkDetails);
    
    @try {
        for(int index=0;index<[arrNetworkList_drawer count];index++)
        {
            view_NetworkDrawer[index].layer.borderWidth=0.0;
            view_NetworkDrawer[index].layer.borderColor=[UIColor clearColor].CGColor;
        }
        view_NetworkDrawer[selectedIndex].layer.borderWidth=1.0;
        view_NetworkDrawer[selectedIndex].layer.borderColor=[UIColor colorWithRed:133 green:133 blue:133 alpha:1].CGColor;

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
        
        NSLog(@"invitee id is == %@",[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"inviteeId"] stringValue]);
        appDelegate.strInviteeID=[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"inviteeId"] stringValue];
        
        NSDictionary *dictNetworkStatus=[dictNetworkDetails valueForKey:@"networkStatus"];
        NSArray *arrController=[dictNetworkStatus valueForKey:@"controller"];
        if(arrController.count>0)
        {
            
            if([strNetworkOwner isEqualToString:@"OtherNW"])
            {
                appDelegate.strOwnerNetwork_Status=@"NO";
                NSLog(@"Permission =%@",[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue]);
                appDelegate.strNetworkPermission=[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"accessTypeId"] stringValue];
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
                [self stop_PinWheel_MultipleNetworkDrawer];
                if([strNetworkAction isEqualToString:@"Home"]){
                    appDelegate.strChangeDrawerData=@"YES";
                    SWRevealViewController *revealController = self.revealViewController;
                    [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
                    
                }else{
                    appDelegate.strController_Setup_Mode=@"NetworkHomeDrawer";
                    appDelegate.strNoidLogo=@"Add/Edit";
                    WifiViewController *WVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiViewController"];
                    WVC.str_MultipleNetwork_Mode=@"edit";
                    WVC.strController_TraceID=[[[dictController valueForKey:@"controllerTrace"] valueForKey:@"id"] stringValue];
                    [self.navigationController pushViewController:WVC animated:YES];
                }
            }else{
                
                if([strNetworkAction isEqualToString:@"Home"]){
                    
                    if([[dictNetworkStatus valueForKey:@"hasPaymentCompleted"] boolValue])
                    {
                        [self stop_PinWheel_MultipleNetworkDrawer];
                        appDelegate.strChangeDrawerData=@"YES";
                        SWRevealViewController *revealController = self.revealViewController;
                        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
                    }else{
                        NSLog(@"billing plan ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"]);
                        appDelegate.strController_Setup_Mode=@"NetworkHomeDrawer";
                        appDelegate.strNoidLogo=@"Add/Edit";
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
                        CVC.strTimeZoneIDFor_User=strTimeZoneIDFor_User;
                        [self stop_PinWheel_MultipleNetworkDrawer];
                        [self.navigationController pushViewController:CVC animated:YES];
                    }
                }else{
                    NSLog(@"billing plan ==%@",[[dictController valueForKey:@"controllerTrace"] valueForKey:@"defaultBillingPlan"]);
                    appDelegate.strController_Setup_Mode=@"NetworkHomeDrawer";
                    appDelegate.strNoidLogo=@"Add/Edit";
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
                    CVC.strTimeZoneIDFor_User=strTimeZoneIDFor_User;
                    [self stop_PinWheel_MultipleNetworkDrawer];
                    [self.navigationController pushViewController:CVC animated:YES];
                }
            }
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        }
        else{
            [self stop_PinWheel_MultipleNetworkDrawer];
            [Common showAlert:kAlertTitleWarning withMessage:@"Parser Error"];
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetworkDrawer];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    }
}

-(void)acceptNetworks_NOIDDrawer
{
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/receivedNetworks",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]];
    NSLog(@"invitee id ==%@",[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue]);
    NSDictionary *parameters;
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    NSMutableDictionary *dictDetails=[[NSMutableDictionary alloc] init];
    [dictDetails setObject:[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue] forKey:kNetworkID];
    [dictDetails setObject:@"2" forKey:kaccesstype];
    
    parameters=[SCM accpetNetworksShared:dictDetails];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for accpet shared networks==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAcceptedNetworksDrawer) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for update Controller cellular Device Details==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseError_MultipleNetworkDrawerSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorPUT:parameters andMethodName:strMethodNameWith_Value];
}
-(void)responseAcceptedNetworksDrawer
{
    @try {
        NSString *responseCode = [[responseDict valueForKey:@"code"] stringValue];
        NSString *responseMessage = [responseDict valueForKey:@"message"];
        NSLog(@"response Code ==%@",responseCode);
        NSLog(@"response Message ==%@",responseMessage);
        if([responseCode isEqualToString:@"200"]){
            
            view_NetworkDrawer[selectedIndex].alpha=1.0;
            [self stop_PinWheel_MultipleNetworkDrawer];
            //[Common showAlert:kAlertTitleSuccess withMessage:responseMessage];
            [self resetNOIDNWDrawer];
        }else{
            [self stop_PinWheel_MultipleNetworkDrawer];
            [Common showAlert:kAlertTitleWarning withMessage:responseMessage];
            [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==%@",[exception description]);
        [self stop_PinWheel_MultipleNetworkDrawer];
        [Common showAlert:kAlertTitleWarning withMessage:[exception description]];
        [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    }
}

-(void)declineNetworks_NOIDDrawer
{
    ServiceConnectorModel *SCM=[[ServiceConnectorModel alloc] init];
    defaultsMultiple_Networks=[NSUserDefaults standardUserDefaults];
    NSLog(@"User Account id ==%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"]);
    NSLog(@"invitee id ==%@",[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue]);
    NSString *strMethodNameWith_Value=[NSString stringWithFormat:@"/accounts/%@/receivedNetworks?type=%@&inviteeNetworkId=%@",[defaultsMultiple_Networks objectForKey:@"ACCOUNTID"],@"3",[[[arrNetworkList_drawer objectAtIndex:selectedIndex] objectForKey:@"inviteeNetId"] stringValue]];
    
    SCM.callbackValue=^(NSMutableDictionary *dict){
        NSLog(@"Dicitionary Call Back Response for Decline Shared Network==%@",dict);
        responseDict=dict;
        [self performSelectorOnMainThread:@selector(responseAcceptedNetworksDrawer) withObject:self waitUntilDone:YES];
    };
    SCM.callbackString=^(NSString *resErrorString){
        NSLog(@"Error Call Back Response for  Delete ==%@",resErrorString);
        strResponseError=resErrorString;
        [self performSelectorOnMainThread:@selector(stop_PinWheel_MultipleNetworkDrawer) withObject:self waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(responseError_MultipleNetworkDrawerSetup) withObject:self waitUntilDone:YES];
    };
    [SCM serviceConnectorDELETE:strMethodNameWith_Value];
}


#pragma mark - PinWheel Delgate Method
-(void)start_PinWheel_MultipleNetworkDrawer{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"";
}

-(void)stop_PinWheel_MultipleNetworkDrawer{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
