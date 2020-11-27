//
//  Common.m
//  CardShare
//
//  Created by iExemplar on 11/09/14.
//  Copyright (c) 2014 iExemplar. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@import SystemConfiguration.CaptiveNetwork;
@implementation Common
 CGSize screenSize;

#pragma mark - Common Factory Methods
/* **********************************************************************************
 Date : 22/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Title : Common Alert
 Description : The purpose of this method is show alert box dynamically
 Method Name : showAlert
 ************************************************************************************* */
+ (void)showAlert:(NSString *)header withMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:header message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : The purpose of this method is to make the view slide from the left to right.
 Method Name : viewSlide_FromLeft_ToRight
 ************************************************************************************* */
+(void)viewSlide_FromLeft_ToRight:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:nil];
}
+(void)viewSlide_FromLeft_ToRightLights:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:nil];
}

/* **********************************************************************************
 Date : 29/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : The purpose of this method is to make the view slide from the right to left.
 Method Name : viewSlide_FromRight_ToLeft
 ************************************************************************************* */
+(void)viewSlide_FromRight_ToLeft:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:kCATransition];
}

+(void)viewSlide_FromBottom_ToTop:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromTop;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:kCATransition];
}

+(void)viewSlide_FromTop_ToBottom:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromBottom;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:kCATransition];
}

+(void)viewFadeIn:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionReveal;
    transition.subtype =kCATransitionFade;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:nil];
}
+(void)viewFadeInSettings:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionReveal;
    transition.subtype =kCATransitionPush;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:nil];
}

+(void)viewFadeInTimeLine:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionReveal;
    transition.subtype =kCATransitionPush;
    transition.delegate = self;
    [view.layer addAnimation:transition forKey:nil];
}

/* **********************************************************************************
 Date : 22/06/2015
 Author : iExemplar Software India Pvt Ltd.
 Description : The purpose of this method is identify the device used to launch the application.
 Method Name : deviceType
 ************************************************************************************* */
+(NSString *)deviceType
{
    NSString *vStatus=@"";
    screenSize = [[UIScreen mainScreen] bounds].size;
    NSLog(@"screenSize.height===%f",screenSize.height);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f && screenSize.height <=568) {
            vStatus=@"iPhone5";
        }else if(screenSize.height >568 && screenSize.height <=667){
            vStatus=@"iPhone6";
        }else if(screenSize.height>667){
            vStatus=@"iPhone6plus";
        }
        else if(screenSize.height==320){
            vStatus=@"iPhone5landscape";
        }else if(screenSize.height==375 ){
            vStatus=@"iPhone6landscape";
        }else{
            vStatus=@"iPhone4";
        }
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (screenSize.height > 667 && screenSize.height <=1024) {
            vStatus=@"iPad";
        }else if (screenSize.height > 1024 && screenSize.height <=2048)
            vStatus=@"iPadRetina";
    }
    return vStatus;
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : Check the reachability status.
 Method Name : reachabilityChanged
 ************************************************************************************* */
+(BOOL)reachabilityChanged
{
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    //reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"Notification Says Reachable");
        return YES;
    }
    else
    {
        
        NSLog(@"Notification Says Unreachable");
        return NO;
    }
}

/* **********************************************************************************
 Date :
 Author : iExemplar Software India Pvt Ltd.
 Description : Convert data to MD5.
 Method Name : md5
 ************************************************************************************* */
+(NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
/* **********************************************************************************
 Date :13/10/15
 Author : iExemplar Software India Pvt Ltd.
 Description : Check Wifi is connected to Device or not.
 Method Name : wifiConnectionStatus
 ************************************************************************************* */
+(NSString *) wifiConnectionStatus{
    NSString *strConnection_Status;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        strConnection_Status=@"NO";
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        strConnection_Status=@"YES";
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        strConnection_Status=@"NO";
    }
    return strConnection_Status;
}
/* **********************************************************************************
 Date :13/10/15
 Author : iExemplar Software India Pvt Ltd.
 Description : Get Device Conntectd wifi network.
 Method Name : wifiConnectionStatus
 ************************************************************************************* */
+(NSDictionary *)fetchSSIDInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *SSIDInfo;
    
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"networks %@ => %@", interfaceName, [SSIDInfo valueForKey:@"SSID"]);
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return [SSIDInfo valueForKey:@"SSID"];
}

+(int)getCurrentYear
{
    //Get current year
    NSDate *currentYear=[[NSDate alloc]init];
    currentYear=[NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy"];
    NSString *currentYearString = [formatter1 stringFromDate:currentYear];
    
    int yearINT=[currentYearString intValue];
    
    return yearINT;
}

+(int)getCurrentMonth
{
    //Get current month
    NSDate *currentMonth=[[NSDate alloc]init];
    currentMonth=[NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM"];
    NSString *currentMonthString = [formatter1 stringFromDate:currentMonth];
    
    int yearINT=[currentMonthString intValue];
    
    return yearINT;
}

+(BOOL)checkVISACardRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"^4[0-9]{12}(?:[0-9]{3})?$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }
    
}

+(BOOL)checkDISCOVERCardRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"^6(?:011|5[0-9]{2})[0-9]{12}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }
    
}

+(BOOL)checkAMERICANCardRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"^3[47][0-9]{13}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }
    
}

+(BOOL)checkMASTROCardRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"^5[1-5][0-9]{14}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }
    
}

+(BOOL)checCardCSCRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"[0-9]{3,4}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }    
}

+(BOOL)checCardMonthRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"(?:0[1-9]|1[0-2])$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }
    
}

+(BOOL)checCardYearRegx:(NSString *)validateString
{
    NSString * const regularExpression = @"^2[0-9]{3}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"succes regex test ");
        return YES;
    }
}

+(BOOL)checkZIPCODEregx:(NSString *)validateString
{
    
    // NSString * const regularExpression = @"^[0-9]{5}(?:-[0-9]{4})?$";
    NSString * const regularExpression = @"^\\d{5}(-\\d{4})?$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:validateString
                                                        options:0
                                                          range:NSMakeRange(0, [validateString length])];
    
    if(numberOfMatches==0){
        NSLog(@"Failed regex test ");
        return NO;
    }else{
        NSLog(@"success regex test ");
        return YES;
    }
    
}

+(CGSize)imageScalling:(UIImage *)image withScalingDetails:(float )targetImgWidth and:(float)targetImgHeight
{
    CGSize sizeScalling;
    NSLog(@"Org image width ==%f and height==%f",image.size.width,image.size.height);
    float sourceAspect = image.size.width/image.size.height;
    NSLog(@"Target image width ==%f and height==%f",targetImgWidth,targetImgHeight);
    float targetAspect = targetImgWidth/targetImgHeight;
    NSLog(@"source aspect==%f",sourceAspect);
    NSLog(@"targetAspect aspect==%f",targetAspect);
    float heightIMG,widthIMG;
    
    if(sourceAspect <  targetAspect){
        //keep target image  height
        //img width cal = org img width / org img heig * Targ img height
        heightIMG = targetImgHeight;
        widthIMG = image.size.width/image.size.height*targetImgHeight;
        
    }else if(sourceAspect > targetAspect){
        //keep target image width
        //img height cal = target img width * org img heig / org img width
        heightIMG = targetImgWidth*image.size.height/image.size.width;
        widthIMG = targetImgWidth;
    }else{
        // keeep same
        heightIMG = targetImgHeight;
        widthIMG = targetImgWidth;
    }
    //  image = [Common imageWithImage:image scaledToSize:CGSizeMake(52, 52)];
    sizeScalling.width=widthIMG;
    sizeScalling.height=heightIMG;
    NSLog(@"final image width ==%f and height==%f",widthIMG,heightIMG);
    NSLog(@"final image width ==%f and height==%f",sizeScalling.width,sizeScalling.height);
    return sizeScalling;
}


+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(NSString *)Trimming_Right_End_WhiteSpaces :(NSString *) trimmedString
{
    trimmedString = [trimmedString stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"names==%@ and length ==%lu",trimmedString,(unsigned long)[trimmedString length]);
    return trimmedString;
}

+(NSString *) secureCreditCardNumber:(NSString *)strCardNumber
{
    NSString *newString=@"";
    NSString *myString = [NSString stringWithFormat:@"%4@",strCardNumber]; // if less than 4 then pad string
    NSLog(@"Old String is%@",myString);
    
    NSInteger obscureLength = myString.length;
    NSLog(@"string length %ld",(long)obscureLength);
    if (obscureLength ==16)
    {
        NSRange range = NSMakeRange(0,12);
        newString = [myString stringByReplacingCharactersInRange:range
                                                      withString:@"************"];
        //  lbldisplay.text=newString;
        NSLog(@"result for 16 %@",newString);
        
    }else if (obscureLength ==15){
        
        NSRange range = NSMakeRange(0,11);
        newString = [myString stringByReplacingCharactersInRange:range
                                                      withString:@"***********"];
        // lbldisplay.text=newString;
        NSLog(@"result for 15 %@",newString);
    }
    else if (obscureLength ==13){
        
        NSRange range = NSMakeRange(0,9);
        newString = [myString stringByReplacingCharactersInRange:range
                                                      withString:@"*********"];
        //lbldisplay.text=newString;
        NSLog(@"result for 13 %@",newString);
    }
    return newString;
}

+(void)resetNetworkFlags
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.strDevice_Added_Status=@"";
    appdelegate.strDevice_Added_Mode=@"";
    appdelegate.strAddedDevice_Type=@"";
    appdelegate.strDevieDeleted_Status=@"";
    appdelegate.strDeviceUpdated_Status=@"";
    appdelegate.strScheduleAddedStatus=@"";
    appdelegate.strTimeZoneChanged_Status=@"";
    appdelegate.strPaymentActive=@"";
}

//+(UIImage *)resizeImage:(UIImage *)image
//{
//    float actualHeight = image.size.height;
//    float actualWidth = image.size.width;
//    float maxHeight = 200.0;
//    float maxWidth = 172.0;
//    float imgRatio = actualWidth/actualHeight;
//    float maxRatio = maxWidth/maxHeight;
//    float compressionQuality = 0.5;//50 percent compression
//    
//    if (actualHeight > maxHeight || actualWidth > maxWidth)
//    {
//        if(imgRatio < maxRatio)
//        {
//            //adjust width according to maxHeight
//            imgRatio = maxHeight / actualHeight;
//            actualWidth = imgRatio * actualWidth;
//            actualHeight = maxHeight;
//        }
//        else if(imgRatio > maxRatio)
//        {
//            //adjust height according to maxWidth
//            imgRatio = maxWidth / actualWidth;
//            actualHeight = imgRatio * actualHeight;
//            actualWidth = maxWidth;
//        }
//        else
//        {
//            actualHeight = maxHeight;
//            actualWidth = maxWidth;
//        }
//    }
//    
//    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
//    UIGraphicsBeginImageContext(rect.size);
//    [image drawInRect:rect];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
//    UIGraphicsEndImageContext();
//    
//    return [UIImage imageWithData:imageData];
//}

+ (NSString *)GetDeviceID {
    NSString *udidString;
    udidString = [self objectForKey:@"deviceID"];
    if(!udidString)
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        udidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        CFRelease(cfuuid);
        [self setObject:udidString forKey:@"deviceID"];
    }
    return udidString;
}

+(NSString *)GetCurrentDateFormat{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *date=[defaults objectForKey:@"DATEFORMAT"];
    NSLog(@"%@",date);
    
    return date;
}

//+(void) setObject:(NSString*) object forKey:(NSString*) key
//{
//    NSString *objectString = object;
//    NSError *error = nil;
//    [SFHFKeychainUtils storeUsername:key
//                         andPassword:objectString
//                      forServiceName:@"LIB"
//                      updateExisting:YES
//                               error:&error];
//    
//    if(error)
//        NSLog(@"%@", [error localizedDescription]);
//}
//
//+(NSString*) objectForKey:(NSString*) key
//{
//    NSError *error = nil;
//    NSString *object = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSLog(@"%@",object);
//    if(error)
//        NSLog(@"%@", [error localizedDescription]);
//    
//    return object;
//}
@end

