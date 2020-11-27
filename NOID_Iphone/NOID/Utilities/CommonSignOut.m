//
//  CommonSignOut.m
//  NOID
//
//  Created by iExemplar on 11/01/16.
//  Copyright © 2016 iexemplar. All rights reserved.
//

#import "CommonSignOut.h"

@implementation CommonSignOut


+(void)showSignOutAlert:(NSString *)header withMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:header message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
