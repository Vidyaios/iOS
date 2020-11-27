//
//  Common.h
//  CardShare
//
//  Created by iExemplar on 11/09/14.
//  Copyright (c) 2014 iExemplar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import "AppDelegate.h"

#define lblRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface Common : NSObject

+(void)showAlert:(NSString *)header withMessage:(NSString *)message;
+(void)viewSlide_FromLeft_ToRight:(UIView *)view;
+(void)viewSlide_FromRight_ToLeft:(UIView *)view;
+(void)viewFadeIn:(UIView *)view;
+(void)viewFadeInSettings:(UIView *)view;
+(void)viewSlide_FromLeft_ToRightLights:(UIView *)view;
+(void)viewSlide_FromBottom_ToTop:(UIView *)view;
+(void)viewSlide_FromTop_ToBottom:(UIView *)view;
+(NSString *)deviceType;
+(BOOL)reachabilityChanged;
+(NSString *) md5:(NSString *) input;
+(NSDictionary *)fetchSSIDInfo;
+(NSString *) wifiConnectionStatus;
+(int)getCurrentYear;
+(int)getCurrentMonth;
+(BOOL)checCardYearRegx:(NSString *)validateString;
+(BOOL)checCardMonthRegx:(NSString *)validateString;
+(BOOL)checCardCSCRegx:(NSString *)validateString;
+(BOOL)checkMASTROCardRegx:(NSString *)validateString;
+(BOOL)checkAMERICANCardRegx:(NSString *)validateString;
+(BOOL)checkDISCOVERCardRegx:(NSString *)validateString;
+(BOOL)checkVISACardRegx:(NSString *)validateString;
+(BOOL)checkZIPCODEregx:(NSString *)validateString;
+(CGSize)imageScalling:(UIImage *)image withScalingDetails:(float )targetImgWidth and:(float)targetImgHeight;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(NSString *)Trimming_Right_End_WhiteSpaces :(NSString *) trimmedString;
+(NSString *) secureCreditCardNumber:(NSString *)strCardNumber;
+(void)resetNetworkFlags;
+ (NSString *)GetDeviceID;
+(void) setObject:(NSString*) object forKey:(NSString*) key;
+(NSString*) objectForKey:(NSString*) key;
+(NSString *)GetCurrentDateFormat;
+(void)viewFadeInTimeLine:(UIView *)view;

//+(UIImage *)resizeImage:(UIImage *)image;

@end


