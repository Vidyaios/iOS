//
//  MapOverlay.m
//  MapOverlay
//
//  Created by Raphael Petegrosso on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapOverlay.h"
#import "ViewController.h"


@implementation MapOverlay

-(CLLocationCoordinate2D)coordinate:(CLLocationCoordinate2D) coordinate {
    //Image center point
//    return CLLocationCoordinate2DMake(48.85883, 2.2945);
    return CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
}


- (MKMapRect)boundingMapRect
{
    //Latitue and longitude for each corner point
//    MKMapPoint upperLeft   = MKMapPointForCoordinate(CLLocationCoordinate2DMake(48.85995, 2.2933));
//    MKMapPoint upperRight  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(48.85995, 2.2957));
//    MKMapPoint bottomLeft  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(48.85758, 2.2933));
//    NSLog(@"%@",dict);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",appDelegate.dict_OverlayCoord);
    
    MKMapPoint upperLeft   = MKMapPointForCoordinate(CLLocationCoordinate2DMake([[appDelegate.dict_OverlayCoord valueForKey:@"UpperLeftLat"] doubleValue], [[appDelegate.dict_OverlayCoord valueForKey:@"UpperLeftLong"] doubleValue]));
    MKMapPoint upperRight  = MKMapPointForCoordinate(CLLocationCoordinate2DMake([[appDelegate.dict_OverlayCoord valueForKey:@"UpperRightLat"] doubleValue], [[appDelegate.dict_OverlayCoord valueForKey:@"UpperRightLong"] doubleValue]));
    MKMapPoint bottomLeft  = MKMapPointForCoordinate(CLLocationCoordinate2DMake([[appDelegate.dict_OverlayCoord valueForKey:@"BottomLeftLat"] doubleValue], [[appDelegate.dict_OverlayCoord valueForKey:@"BottomLeftLong"] doubleValue]));

    //Building a map rect that represents the image projection on the map
//    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, fabs(upperLeft.x - upperRight.x), fabs(upperLeft.y - bottomLeft.y));
    NSLog(@"%f",upperLeft.y);
    NSLog(@"%f",bottomLeft.y);
    NSLog(@"%f",fabs(upperLeft.y - bottomLeft.y));
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, fabs(upperLeft.x - upperRight.x), fabs(upperLeft.y - bottomLeft.y));

    return bounds;
}



@end
