//
//  AnimationViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationViewController : UIViewController {
    
    MGRawView* _animationView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewMain;

@end
