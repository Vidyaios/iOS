//
//  TimeZoneViewController.m
//  NOID
//
//  Created by iExemplar on 16/07/15.
//  Copyright (c) 2015 iexemplar. All rights reserved.
//

#import "TimeZoneViewController.h"
#import "TimeLineViewController.h"
#import "Common.h"
@interface TimeZoneViewController ()<UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@end

@implementation TimeZoneViewController
@synthesize callbackValue=_callbackValue;
@synthesize tableview_timeZone,strUserDetail;

#pragma mark - View LifeCycle
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the view
 Method Name : viewDidLoad(View Delegate Methods)
 ************************************************************************************* */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSetup_TimeZone];
    [self fetchTimeZone];
    
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

#pragma mark - User Defined Methods
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Initial setup for the tableview
 Method Name : tableViewSetup_TimeZone
 ************************************************************************************* */
-(void)tableViewSetup_TimeZone
{
    tableview_timeZone.delegate=self;
    tableview_timeZone.dataSource=self;
    self.tableview_timeZone.layer.masksToBounds=YES;
    self.tableview_timeZone.layer.borderWidth = 1;
    self.tableview_timeZone.layer.cornerRadius=5.0;
    self.tableview_timeZone.layer.borderColor=[UIColor grayColor].CGColor;
    [self.tableview_timeZone setBackgroundView:nil];
    [self.tableview_timeZone setBackgroundColor:[UIColor clearColor]];
}

/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Fetch timezone list from the locale
 Method Name : fetchTimeZone
 ************************************************************************************* */
-(void)fetchTimeZone
{
    self.searchResults = [NSMutableArray arrayWithCapacity:[arr_search_TimeZone count]];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableview_timeZone.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.backgroundImage=[UIImage imageNamed:@"top_bar_bg.png"];
//    arr_TimeZone = [[NSMutableArray alloc] initWithArray:[NSTimeZone knownTimeZoneNames]];
    if ([strUserDetail isEqualToString:@"timezone"]) {
        arr_TimeZone = [[NSMutableArray alloc] initWithObjects:@"Atlantic Time Zone",@"Eastern Time Zone",@"Central Time Zone",@"Mountain Time Zone",@"Mountain Time Zone - Arizona",@"Pacific Time Zone",@"Alaska Time Zone",@"Hawaii–Aleutian Time Zone",@"India Standard Time", nil];
//        arr_TimeZone = [[NSMutableArray alloc] initWithArray:[NSTimeZone knownTimeZoneNames]];
//        NSLog(@"count==%lu",(unsigned long)[arr_TimeZone count]);
    }else{
        arr_TimeZone = [[NSMutableArray alloc] initWithObjects:@"English",@"Spanish",@"French",@"German",@"Chinese", nil];
    }
    NSLog(@"%@",arr_TimeZone);
    arr_search_TimeZone = [[NSMutableArray alloc] initWithArray:arr_TimeZone];
}

#pragma mark - TableView Delegates and DataSource
/* **********************************************************************************
 Date :
 Description :Method used to return the number of rows in the tableview
 Method Name :numberOfRowsInSection (Pre Defined Method)
 ************************************************************************************* */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // return [arr_search_CounrtyZone count];
    if (self.searchController.active) {
        return [self.searchResults count];
    } else {
        return [arr_search_TimeZone count];
    }
}

/* **********************************************************************************
 Date :
 Description : Method used to set values in each row automatically based on the index path
 Method Name :cellForRowAtIndexPath (Pre Defined Method)
 ************************************************************************************* */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.searchController.active) {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[self.searchResults objectAtIndex:indexPath.row]];
    }else{
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[arr_search_TimeZone objectAtIndex:indexPath.row]];
    }
    
    cell.textLabel.textColor=lblRGBA(255, 206, 52, 1);
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : Returns the number of sections in the tableview.
 Method Name : numberOfSectionsInTableView (TableView Delegate Method Name)
 ************************************************************************************* */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : when user taps a particular cell or row in the tableview,this method is called
 Method Name : didSelectRowAtIndexPath (TableView Delegate Method Name)
 ************************************************************************************* */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isSelected=YES;
    NSArray *sourceArray = self.searchController.active ? self.searchResults : arr_search_TimeZone;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([strUserDetail isEqualToString:@"timezone"]) {
        [dict setObject:[NSString stringWithFormat:@"%@",[sourceArray objectAtIndex:indexPath.row]] forKey:KTimeZone];
    }else{
        [dict setObject:[NSString stringWithFormat:@"%@",[sourceArray objectAtIndex:indexPath.row]] forKey:kLanguage];
    }
    NSLog(@"%@",dict);
    [self responseMSG:dict];
//    }
//    else{
//        [self resError];
//    }
    [self.searchController setActive:NO];
    [Common viewSlide_FromTop_ToBottom:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:YES completion:Nil];
}



/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This method is used to perform action when the tableview finish loading
 Method Name : willDisplayCell (TableView Delegate Method Name)
 ************************************************************************************* */
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [tableview_timeZone setAlpha:1.0];
        [tableview_timeZone setUserInteractionEnabled:YES];
    }
}


#pragma mark - CallBackDicitionary
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : used to send the value to the previous view.
 Method Name : Call Back Methods
 ************************************************************************************* */
-(void)responseMSG :(NSMutableDictionary *)response{
    
    _callbackValue(response);
}
-(void)resError
{
    _callbackVoid();
}

#pragma mark - UISearchResultsUpdating
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Relaod tableview with the search results
 Method Name : updateSearchResultsForSearchController
 ************************************************************************************* */
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if(isSelected==YES){
        return;
    }
    NSString *searchString = [self.searchController.searchBar text];
    
    NSString *scope = nil;
    
    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0) {
        scope = [[arr_TimeZone valueForKey:KTimeZone] objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    //if (self.searchController.searchResultsController) {
    [self.tableview_timeZone reloadData];
    //}
}

#pragma mark - UISearchBarDelegate
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Method called to Relaod tableview with the search results
 Method Name : selectedScopeButtonIndexDidChange
 ************************************************************************************* */
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}
/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : This button action dismiss from the present view
 Method Name : back_Action_country(User Defined Method)
 ************************************************************************************* */

#pragma mark - Content Filtering
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : Load the tableview with the search results
 Method Name : updateFilteredContentForProductName
 ************************************************************************************* */
- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
    
    // Update the filtered array based on the search text and scope.
    if ((productName == nil) || [productName length] == 0) {
        // If there is no search string and the scope is "All".
        if (typeName == nil) {
            self.searchResults = [arr_TimeZone mutableCopy];
        } else {
            // If there is no search string and the scope is chosen.
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
                for(int i=0;i<arr_TimeZone.count;i++)
                {
                    if ([[arr_TimeZone objectAtIndex:i]  isEqualToString:typeName]) {
                        [searchResults addObject:[arr_TimeZone objectAtIndex:i]];
                    }
                }
            self.searchResults = _searchResults;
            }
        return;
    }
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    
        for (int i=0;i<arr_TimeZone.count;i++) {
            if ((typeName == nil) || [[arr_TimeZone objectAtIndex:i]  isEqualToString:typeName]) {
                NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
                NSRange productNameRange = NSMakeRange(0, [[arr_TimeZone objectAtIndex:i] length]);
                NSRange foundRange = [[arr_TimeZone objectAtIndex:i] rangeOfString:productName options:searchOptions range:productNameRange];
                if (foundRange.length > 0) {
                    [self.searchResults addObject:[arr_TimeZone objectAtIndex:i]];
                }
            }
        }
}

#pragma mark - IBActions
/* **********************************************************************************
 Date : 16/07/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : On click event dismiss from the present view 
 Method Name : back_TimeZone_Action
 ************************************************************************************* */
-(IBAction)back_TimeZone_Action:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:Nil];
    [Common viewSlide_FromTop_ToBottom:self.navigationController.view];
    [self.navigationController popViewControllerAnimated:NO];
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

@end
