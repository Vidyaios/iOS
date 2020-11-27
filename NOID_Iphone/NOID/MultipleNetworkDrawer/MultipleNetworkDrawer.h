//
//  MultipleNetworkDrawer.h
//  NOID
//
//  Created by Karthik on 10/12/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MultipleNetworkDrawer : UIViewController<UIScrollViewDelegate>
{
    AppDelegate *appDelegate;
    NSDictionary *responseDict,*networkData_Dict;
    NSUserDefaults *defaultsMultiple_Networks;
    NSString *strResponseError,*strNetworkAction,*strNetworkID,*strNetworkOwner,*strTimeZoneIDFor_User;
    int selectedIndex;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll_MultiNetwork_Drawer;
@property (strong, nonatomic) NSMutableArray *arrNetworkList_drawer;
@property (strong, nonatomic) UIView *view_AddNetwork_drawer;
@property (strong, nonatomic) IBOutlet UIView *view_pushAlert_drawer;

@end
