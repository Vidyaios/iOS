//
//  CustomAnnotationView.m
//  CustomAnnotation
//
//  Created by akshay on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "MyAnnotation.h"

@implementation CustomAnnotationView


/*
 
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated
 {
 if(selected){

self.frame = CGRectMake(0, 0, max_width, max_height);
UIView *view = [[UIView alloc]initWithFrame:CGRectMake(6, 0, max_width-10, max_height)];
view.backgroundColor = [UIColor blackColor];

UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
UIImage *img = [UIImage imageNamed:@"image.png"];
but = CGRectMake(x , y, img.size.width + 20,  img.size.height + 15);
[but setImage:img forState:UIControlStateNormal];
[but addTarget:targetController action:@selector(methodName) forControlEvents:UIControlEventTouchDown];
[view addSubview:but];

[self addSubview:view];
}
else {
 
    self.frame = CGRectMake(0, 0, Initial_width, Initial_height);
    [view removeFromSuperview];
    
}
}
 */
/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    
    Annotation *ann = self.annotation;
    if(selected)
    {
        //Add your custom view to self...
        if ([ann.type isEqualToString:@"1"]) {
           // calloutView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"airport.png"]];
            calloutViewTest=[[UIView alloc] init];
            calloutViewTest.backgroundColor=[UIColor redColor];
        }
        if ([ann.type isEqualToString:@"2"]) {
            //calloutView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"restaurant.png"]];
            calloutViewTest=[[UIView alloc] init];
            calloutViewTest.backgroundColor=[UIColor greenColor];
        }
        if ([ann.type isEqualToString:@"3"]) {
            //calloutView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shopping.png"]];
            calloutViewTest=[[UIView alloc] init];
            calloutViewTest.backgroundColor=[UIColor blueColor];
        }

        [calloutViewTest setFrame:CGRectMake(-24, 65, 100, 100)];
        [calloutViewTest sizeToFit];
        [self animateCalloutAppearance];
        [self addSubview:calloutViewTest];
    }
    else
    {
        //Remove your custom view...
        NSLog(@"remove call put view");
        [calloutViewTest removeFromSuperview];
    }
}
*/

/*
 UITapGestureRecognizer *singleFingerTap =
 [[UITapGestureRecognizer alloc] initWithTarget:self
 action:@selector(handleSingleTap:)];
 [self.view addGestureRecognizer:singleFingerTap];
 [singleFingerTap release];
 
 //The event handling method
 - (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
 CGPoint location = [recognizer locationInView:[recognizer.view superview]];
 
 //Do stuff here...
 }
 */

//- (void)didAddSubview:(UIView *)subview{
//    Annotation *ann = self.annotation;
//    if (![ann.locationType isEqualToString:@"dropped"]) {
//        if ([[[subview class] description] isEqualToString:@"UICalloutView"]) {
//            for (UIView *subsubView in subview.subviews) {
//                if ([subsubView class] == [UIImageView class]) {
//                    UIImageView *imageView = ((UIImageView *)subsubView);
//                    [imageView removeFromSuperview];
//                }else if ([subsubView class] == [UILabel class]) {
//                    UILabel *labelView = ((UILabel *)subsubView);
//                    [labelView removeFromSuperview];
//                }
//            }
//        }
//    }
//}

//- (void)animateCalloutAppearance {
//    CGFloat scale = 0.001f;
//    calloutViewTest.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);
//    
//    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
//        CGFloat scale = 1.1f;
//        calloutViewTest.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
//            CGFloat scale = 0.95;
//            calloutViewTest.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
//                CGFloat scale = 1.0;
//                calloutViewTest.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
//            } completion:nil];
//        }];
//    }];
//}

@end
