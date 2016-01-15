//
//  CPHHelpCustomSegue.m
//  Watcher
//
//  Created by Oleg Bolshakov on 4/2/15.
//  Copyright (c) 2015 CPHCloud. All rights reserved.
//

#import "BMExpandDescriptionSegue.h"
#import "BMDescriptionViewController.h"

@implementation BMExpandDescriptionSegue

-(void)perform {
    
    UIViewController *sourceViewController = self.sourceViewController;
    BMDescriptionViewController *destinationViewController = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window insertSubview:destinationViewController.view aboveSubview:sourceViewController.view];
    window.opaque = YES;
    
    // Transformation start scale
    destinationViewController.view.transform = CGAffineTransformMakeScale(1.0f, 0.01f);//0.1979f);
    ((BMDescriptionViewController*)destinationViewController).topLiftSpace.constant = self.destinationCenter.y - 19;
    [destinationViewController.view layoutIfNeeded];
    
    // Store original centre point of the destination view
    CGPoint originalCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    // Set center to start point of the button
    destinationViewController.view.layer.opacity = 0.0f;
    destinationViewController.view.center = self.destinationCenter;
    ((BMDescriptionViewController*)destinationViewController).dismissDestinationCenter = self.destinationCenter;
    destinationViewController.htmlData = self.selectedDescription;
    destinationViewController.descriptionTitle = self.selectedTitle;
    
    ((BMDescriptionViewController*)destinationViewController).liftBtn.layer.opacity = 1.0f;
    [destinationViewController.view layoutIfNeeded];
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         destinationViewController.view.center = originalCenter;
                         destinationViewController.view.layer.opacity = 1;
                         ((BMDescriptionViewController*)destinationViewController).liftBtn.layer.opacity = 1.0f;
                     }
                     completion:^(BOOL finished){
                       
                         
                             [sourceViewController addChildViewController:destinationViewController]; // present VC

                         
                     }];
}



@end
