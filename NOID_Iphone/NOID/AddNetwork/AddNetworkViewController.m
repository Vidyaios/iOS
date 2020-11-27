//
//  AddNetworkViewController.m
//  NOID
//
//  Created by iExemplar on 24/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "AddNetworkViewController.h"
#import "SettingsViewController.h"
#import "Common.h"
#import "NetworkHomeViewController.h"
#import "TimeLineViewController.h"

@interface AddNetworkViewController ()

@end

@implementation AddNetworkViewController

#pragma mark - View LifeCycle
/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *viewStackArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSLog(@"Stack count %lu",(unsigned long)[viewStackArr count]);
    NSLog(@"stack List == %@",viewStackArr);

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        NSLog(@"portrait");
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    [super viewWillAppear:animated];
}

#pragma mark - IBActions
/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates back to the Multiple Network screen.
 Method Name : back_AddNetwork_Action(User Defined Methods)
 ************************************************************************************* */
-(IBAction)back_AddNetwork_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/* **********************************************************************************
 Date : 24/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event navigates to the setting screen
 Method Name : setting_AddNetwork_Action(user Defined Methods)
 ************************************************************************************* */
-(IBAction)setting_AddNetwork_Action:(id)sender
{
    SettingsViewController *SVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    SVC.str_gear_Type=@"addnetwork";
    [Common viewFadeInSettings:self.navigationController.view];
    [self.navigationController pushViewController:SVC animated:NO];
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
    return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
    //return here which orientation you are going to support
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

@end
