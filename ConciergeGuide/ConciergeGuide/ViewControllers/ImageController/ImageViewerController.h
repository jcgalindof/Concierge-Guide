//
//  ImageViewerController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerController : UIViewController <MGImageViewerDelegate>

@property (nonatomic, retain) IBOutlet MGImageViewer* imageViewer;
@property (nonatomic, retain) NSArray* imageArray;
@property (nonatomic, assign) int selectedIndex;

-(IBAction)didClickBarButtonDone:(id)sender;

@end
