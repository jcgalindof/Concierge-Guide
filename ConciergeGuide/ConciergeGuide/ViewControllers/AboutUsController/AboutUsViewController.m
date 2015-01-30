//
//  AboutUsViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize scrollViewMain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    
    [_aboutView removeFromSuperview];
    [scrollViewMain addSubview:_aboutView];
    scrollViewMain.contentSize = _aboutView.frame.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    _aboutView = [[MGRawView alloc] initWithFrame:scrollViewMain.frame nibName:@"AboutUsView"];
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen) {
        CGRect frame = _aboutView.frame;
        frame.size.width = self.view.frame.size.width;
        _aboutView.frame = frame;
    }
    
    scrollViewMain.frame = self.view.frame;
    
    [_aboutView.label1 setText:LOCALIZED(@"ABOUT_US")];
    [_aboutView.label2 setText:LOCALIZED(@"ABOUT_US_DETAIL_1")];
    [_aboutView.label3 setText:LOCALIZED(@"ABOUT_US_DETAIL_2")];
    
    [_aboutView.buttonEmail setTitle:LOCALIZED(@"CONTACT_US")
                            forState:UIControlStateNormal];
    
    [_aboutView.buttonEmail setTitle:LOCALIZED(@"CONTACT_US")
                            forState:UIControlStateSelected];
    
    [_aboutView.buttonEmail addTarget:self
                              action:@selector(didClickEmailButton:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    inset.top = 0;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    inset.top = 0;
    scrollViewMain.scrollIndicatorInsets = inset;

    UIBarButtonItem* itemMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_MENU]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didClickBarButtonMenu:)];
    self.navigationItem.leftBarButtonItem = itemMenu;
}

-(void)didClickBarButtonMenu:(id)sender {
    
    AppDelegate* delegate = [AppDelegate instance];
    [delegate.sideViewController updateUI];
    
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)didClickEmailButton:(id)sender {
 
    if ([MFMailComposeViewController canSendMail]) {
        
        // set the sendTo address
        NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:1];
        [recipients addObject:ABOUT_US_EMAIL];
        
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:LOCALIZED(@"EMAIL_SUBJECT_ABOUT_US")];
        
        [mailController setMessageBody:LOCALIZED(@"EMAIL_SUBJECT_ABOUT_US_MSG") isHTML:NO];
        [mailController setToRecipients:recipients];
        
        if(DOES_SUPPORT_IOS7) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
            
            [[mailController navigationBar] setTitleTextAttributes:attributes];
            [[mailController navigationBar ] setTintColor:[UIColor whiteColor]];
            
        }
        
        [self.view.window.rootViewController presentViewController:mailController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"EMAIL_SERVICE_ERROR")
                            message:LOCALIZED(@"EMAIL_SERVICE_ERROR_MSG")];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
	[self becomeFirstResponder];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
