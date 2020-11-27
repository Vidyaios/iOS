//
//  TimeLineViewController.h
//  NOID
//
//  Created by Karthik on 9/1/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol ProcessDataDelegateTimeLine <NSObject>
@required
-(void)processSuccessful_Back_To_TimeLine:(BOOL)success;
@end

@interface TimeLineViewController : UIViewController<UIScrollViewDelegate>
{
    id <ProcessDataDelegateTimeLine> delegate;
    BOOL lightsPopUpViewStatus,sprinklerPopUpViewStatus,otherPopUpViewStatus;
    UITapGestureRecognizer *tapHeader_TimeLine,*tapBodyView_TimeLine,*tapTitleView_TimeLine;
    NSMutableArray *arrTimeLineHeaders;
    UIButton *view_LightStart,*view_LightEnd,*view_LightMiddle;
    UIButton *view_OtherStart,*view_OtherEnd,*view_OtherMiddle;
    UIButton *view_SprinklerStart,*view_SprinklerEnd,*view_SprinklerMiddle;
    int preTag,CurrentTag,currentTagOther,preTagOther,currentTagSprinkler,preTagSprinkler;
    UIView *viewOuterShade,*viewInnerShade;
    NSString *strStatusCheck;
    UIView *viewPopUpAlerts;
    UIScrollView *scrollViewPopupAlerts;
    NSString *strHeader_Status,*deviceTypes;
    int selectedTag;
    NSMutableArray *arrSelectedDevice,*arrLights,*arrSprinkler,*arrOthers;
    AppDelegate *appDelegate;
    NSTimer *timerTL;
}

@property (retain) id <ProcessDataDelegateTimeLine> delegate;
@property (strong, nonatomic) NSString *strNoidLogo_Status;
@property (strong, nonatomic) IBOutlet UILabel *lblTimes;

@property (weak, nonatomic) IBOutlet UIView *TimelineAlert;
@property(nonatomic,strong)IBOutlet UIView *view_HeaderViewTimeLine;
@property(nonatomic,strong)IBOutlet UIView *view_BodyViewTimeLine;


@property(nonatomic,strong)IBOutlet UIView *view_SprinklerTimeLineBar;
@property(nonatomic,strong)IBOutlet UIView *view_LightsTimeLineBar;
@property(nonatomic,strong)IBOutlet UIView *view_OthersTimeLineBar;
@property(nonatomic,strong)IBOutlet UIView *view_DetailViewTimeLine;
@property(nonatomic,strong)IBOutlet UIView *view_TitleViewTimeLine;

@property(nonatomic,strong)IBOutlet UIView *view_Profile_Header;

@property(nonatomic,strong)IBOutlet UIButton *btn_PreviousInTimeLine;
@property(nonatomic,strong)IBOutlet UIButton *btn_NextInTimeLine;
@property(nonatomic,strong)IBOutlet UIButton *btn_PreviousInDetailTimeLine;
@property(nonatomic,strong)IBOutlet UIButton *btn_NextInDetailTimeLine;

@property(nonatomic,strong)IBOutlet UISwitch *swtchLight;

@property (strong, nonatomic) IBOutlet UIButton *btnLogo_TimeLine;
@property (strong, nonatomic) IBOutlet UIButton *btnBackarrow_TImeline;
@property (strong, nonatomic) IBOutlet UIButton *btnBack_TimeLine;
@property (strong, nonatomic) IBOutlet UIImageView *img_detailView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_deviceName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ScheduleName;

@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar1;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar2;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar3;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar4;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar5;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar6;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar7;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar8;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar9;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar10;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar11;
@property (strong, nonatomic) IBOutlet UIImageView *imgView_MatrixBar12;

-(IBAction)Close:(id)sender;
-(IBAction)switch_Actions_TimeLine:(id)sender;
-(IBAction)clickToView_DeviceDetailView:(id)sender;
-(IBAction)networkhome_Welcome_ActionInTimeLine:(id)sender;
-(IBAction)back_Action_InTimeLine:(id)sender;
-(IBAction)changeDeviceProfile_onClick_Action:(id)sender;

@end
