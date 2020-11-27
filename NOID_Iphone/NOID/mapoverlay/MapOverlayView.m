//
//  MapOverlayView.m
//  MapOverlay
//
//  Created by Raphael Petegrosso on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapOverlayView.h"
#import "MapOverlay.h"
#import "ViewController.h"
#import "AppDelegate.h"
@implementation MapOverlayView
//-(void)boundingCoordinates:(NSMutableDictionary *)dict
//{
//    NSLog(@"%@",dict);
//    dict_overlayCoordinates = [[NSMutableDictionary alloc] init];
//    dict_overlayCoordinates = dict;
//    NSLog(@"%@",dict_overlayCoordinates);
//}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx{
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
 //  UIImage *image =[UIImage imageNamed:@"PropertyMapbg_image"];
   // CGImageRef imageReference = image.CGImage;
     CGImageRef imageReference = appDelegate.imageNameOverLay.CGImage;
    
    //Loading and setting the image
//    MapOverlay *overlay = [[MapOverlay alloc] init];
    MKMapRect theMapRect    = [self.overlay boundingMapRect];
    CGRect theRect           = [self rectForMapRect:theMapRect];

    
    // We need to flip and reposition the image here
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -theRect.size.height);
    
    //drawing the image to the context
    CGContextDrawImage(ctx, theRect, imageReference);
    
}


@end
