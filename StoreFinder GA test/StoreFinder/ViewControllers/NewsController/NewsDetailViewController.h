//
//  NewsDetailViewController.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonBack;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonForward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonRefresh;
@property (nonatomic, retain) IBOutlet UIWebView* webViewMain;
@property (nonatomic, retain) NSString* strUrl;

-(IBAction)didClickBarButtonBack:(id)sender;
-(IBAction)didClickBarButtonForward:(id)sender;
-(IBAction)didClickBarButtonRefresh:(id)sender;

@end
