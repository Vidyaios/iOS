//
//  MultipleNetworkViewController.h
//  NOID
//
//  Created by iExemplar on 24/06/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MultipleNetworkViewController : UIViewController<UIScrollViewDelegate>
{
    AppDelegate *appDelegate;
    NSString *strResponseError,*strNetworkID,*strNetworkAction,*strNetworkOwner,*strTimeZoneIDFor_User;
    NSDictionary *responseDict;
    NSUserDefaults *defaultsMultiple_Networks;
    int selectedIndex;
}
@property (strong, nonatomic) NSString *strPreviousView;

@property (strong, nonatomic) IBOutlet UIView *headerView_MultipleNw;
@property (strong, nonatomic) IBOutlet UIView *bodyView_MultipleNw;

@property (strong, nonatomic) UIView *view_AddNetwork;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView_MultipleNetWork;
@property (strong, nonatomic) NSMutableArray *arr_NetworkList;
@property (strong, nonatomic) IBOutlet UIView *view_pushAlert;

-(IBAction)addNetwork_Action:(id)sender;
-(IBAction)NetworkHome_Action:(id)sender;
-(IBAction)settingsView_Action:(id)sender;
-(IBAction)accept_decline_AlertAction:(id)sender;

@end
