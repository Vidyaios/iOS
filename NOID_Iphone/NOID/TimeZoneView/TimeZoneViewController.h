//
//  TimeZoneViewController.h
//  NOID
//
//  Created by iExemplar on 16/07/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface TimeZoneViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arr_TimeZone;
    NSMutableArray *arr_search_TimeZone;
    BOOL isSelected;
}
@property (strong, nonatomic) NSString *strUserDetail;
@property (strong, nonatomic) IBOutlet UITableView *tableview_timeZone;

@property (nonatomic, copy) formCallbackDictionary callbackValue;
@property (nonatomic, copy) formCallbackVoid callbackVoid;

-(IBAction)back_TimeZone_Action:(id)sender;
@end
