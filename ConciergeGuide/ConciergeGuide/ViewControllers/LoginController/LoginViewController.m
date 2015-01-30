

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize scrollViewLogin;
@synthesize barButtonCancel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    
    self.title = LOCALIZED(@"LOGIN");
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    _loginView = [[MGLoginView alloc] initWithFrame:scrollViewLogin.frame nibName:@"LoginView"];
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen) {
        CGRect frame = _loginView.frame;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = self.view.frame.size.height;
        _loginView.frame = frame;
    }
    
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _loginView.textFieldUsername.frame.size.height)];
    leftView.backgroundColor = _loginView.textFieldUsername.backgroundColor;
    _loginView.textFieldUsername.leftView = leftView;
    _loginView.textFieldUsername.leftViewMode = UITextFieldViewModeAlways;
    _loginView.textFieldUsername.placeholder = LOCALIZED(@"USER_NAME");
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, _loginView.textFieldPassword.frame.size.height)];
    leftView.backgroundColor = _loginView.textFieldPassword.backgroundColor;
    _loginView.textFieldPassword.leftView = leftView;
    _loginView.textFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    _loginView.textFieldPassword.placeholder = LOCALIZED(@"PASSWORD");
    
    _loginView.textFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    _loginView.textFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    [scrollViewLogin addSubview:_loginView];
    scrollViewLogin.contentSize = _loginView.frame.size;
    
    [_loginView.buttonLogin setTitleColor:WHITE_TEXT_COLOR
                                    forState:UIControlStateNormal];
    
    [_loginView.buttonLogin setTitleColor:WHITE_TEXT_COLOR
                                    forState:UIControlStateSelected];
    
    [_loginView.buttonLogin setTitle:LOCALIZED(@"LOGIN")
                               forState:UIControlStateNormal];
    
    [_loginView.buttonLogin setTitle:LOCALIZED(@"LOGIN")
                               forState:UIControlStateSelected];
    
    [_loginView.buttonLogin addTarget:self
                               action:@selector(didClickLoginButton:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.buttonFb addTarget:self
                                     action:@selector(didClickLoginToFacebook:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.buttonFb setTitleColor:WHITE_TEXT_COLOR
                                 forState:UIControlStateNormal];
    
    [_loginView.buttonFb setTitleColor:WHITE_TEXT_COLOR
                                 forState:UIControlStateSelected];
    
    [_loginView.buttonFb setTitle:LOCALIZED(@"LOGIN_TO_FACEBOOK")
                            forState:UIControlStateNormal];
    
    [_loginView.buttonFb setTitle:LOCALIZED(@"LOGIN_TO_FACEBOOK")
                            forState:UIControlStateSelected];
    
    [_loginView.buttonTwitter addTarget:self
                            action:@selector(didClickLoginToTwitter:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.buttonTwitter setTitleColor:WHITE_TEXT_COLOR
                              forState:UIControlStateNormal];
    
    [_loginView.buttonTwitter setTitleColor:WHITE_TEXT_COLOR
                              forState:UIControlStateSelected];
    
    [_loginView.buttonTwitter setTitle:LOCALIZED(@"LOGIN_TO_TWITTER")
                         forState:UIControlStateNormal];
    
    [_loginView.buttonTwitter setTitle:LOCALIZED(@"LOGIN_TO_TWITTER")
                         forState:UIControlStateSelected];
    
    
    _loginView.textFieldPassword.delegate = self;
    _loginView.textFieldUsername.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    UIEdgeInsets inset = scrollViewLogin.contentInset;
    inset.bottom = NAV_BAR_OFFSET;
    scrollViewLogin.contentInset = inset;
}

-(void)keyboardDidShow:(id)sender {
    
    UIEdgeInsets inset = scrollViewLogin.contentInset;
    inset.bottom = 216;
    scrollViewLogin.contentInset = inset;
    
    inset = scrollViewLogin.scrollIndicatorInsets;
    inset.bottom = 216;
    scrollViewLogin.scrollIndicatorInsets = inset;
}

-(void)keyboardDidHide:(id)sender {
    
    UIEdgeInsets inset = scrollViewLogin.contentInset;
    inset.bottom = NAV_BAR_NO_OFFSET;
    scrollViewLogin.contentInset = inset;
    
    inset = scrollViewLogin.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_NO_OFFSET;
    scrollViewLogin.scrollIndicatorInsets = inset;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _loginView.textFieldUsername) {
		[_loginView.textFieldUsername resignFirstResponder];
		[_loginView.textFieldPassword becomeFirstResponder];
	}
	else if (textField == _loginView.textFieldPassword) {
		[_loginView.textFieldPassword resignFirstResponder];
        [self didClickLoginButton:textField];
	}
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    BOOL isFound = YES;
    
    if(textField == _loginView.textFieldPassword) {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                isFound = NO;
            }
        }
        
    }
    
    if(textField == _loginView.textFieldUsername) {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyz_"];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                isFound = NO;
            }
        }
    }
    
    return ((newLength < MAX_CHARS_INPUT) && isFound) ? YES : NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didClickLoginButton:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    NSString* username = [_loginView.textFieldUsername text];
    NSString* password = [_loginView.textFieldPassword text];
    
    if(username.length == 0 || password.length == 0) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                            message:LOCALIZED(@"LOGIN_ERROR_DETAILS")];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOGGING_IN");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    barButtonCancel.enabled = NO;
    
    NSURL *url = [NSURL URLWithString:LOGIN_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            nil];
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"LOGIN_SYNC = %@", responseStr);
        
        NSDictionary* dictUser = [json objectForKey:@"user_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(dictUser != nil) {
                
                UserSession* session = [UserSession new];
                session.facebookId = [dictUser valueForKey:@"facebook_id"];
                session.fullName = [dictUser valueForKey:@"full_name"];
                session.loginHash = [dictUser valueForKey:@"login_hash"];
                session.twitterId = [dictUser valueForKey:@"twitter_id"];
                session.userId = [dictUser valueForKey:@"user_id"];
                session.userName = [dictUser valueForKey:@"username"];
                session.email = [dictUser valueForKey:@"email"];
                session.coverPhotoUrl = [dictUser valueForKey:@"photo_url"];
                session.thumbPhotoUrl = [dictUser valueForKey:@"thumb_url"];
                
                [UserAccessSession storeUserSession:session];
            }
            
            if( ![dictUser isEqual:[NSNull null]]) {
                
                [hud removeFromSuperview];
                [self.view setUserInteractionEnabled:YES];
                barButtonCancel.enabled = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
                
                
            }
            
        }
        else {
            
            [hud removeFromSuperview];
            [self.view setUserInteractionEnabled:YES];
            barButtonCancel.enabled = YES;
            
            [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        barButtonCancel.enabled = YES;
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"LOGIN_CONNECTING_ERROR")];
        
    }];
}

-(IBAction)didClickCancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickLoginToFacebook:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    AppDelegate* appDelegate = [AppDelegate instance];
    //    [appDelegate.session closeAndClearTokenInformation];
    
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen: {
            
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 
                 if (!error) {
                     //error
                     NSString* facebookId = [user valueForKey:@"id"];
                     NSString* name = [user valueForKey:@"name"];
                     NSString* email = [user valueForKey:@"email"];
                     
                     NSString *imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", facebookId];
                     [self registerViaSocial:facebookId isFacebook:YES name:name email:email profilePic:imageURL];
                 }
                 
             }];
        }
            
        case FBSessionStateClosed: { }
            
        case FBSessionStateClosedLoginFailed: { }
            
        case FBSessionStateCreatedOpening: { }
            
        case FBSessionStateCreatedTokenLoaded: { }
            
        case FBSessionStateOpenTokenExtended: { }
            
        case FBSessionStateCreated: { }
    }
}


-(void)registerViaSocial:(NSString*)anyId
              isFacebook:(BOOL)isFacebook
                    name:(NSString*)name
                   email:(NSString*)email
              profilePic:(NSString*)profilePic{
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOGGING_IN");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    barButtonCancel.enabled = NO;
    
    NSURL *url = [NSURL URLWithString:REGISTER_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = nil;
    
    if(isFacebook) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  anyId, @"facebook_id",
                  name, @"full_name",
                  email, @"email",
                  profilePic, @"thumb_url",
                  nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  anyId, @"twitter_id",
                  name, @"full_name",
                  email, @"email",
                  profilePic, @"thumb_url",
                  nil];
    }
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseStr = %@", responseStr);
        
        NSDictionary* dictUser = [json objectForKey:@"user_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(dictUser != nil) {
                
                UserSession* session = [UserSession new];
                session.facebookId = [dictUser valueForKey:@"facebook_id"];
                session.fullName = [dictUser valueForKey:@"full_name"];
                session.loginHash = [dictUser valueForKey:@"login_hash"];
                session.twitterId = [dictUser valueForKey:@"twitter_id"];
                session.userId = [dictUser valueForKey:@"user_id"];
                session.userName = [dictUser valueForKey:@"username"];
                session.email = [dictUser valueForKey:@"email"];
                session.thumbPhotoUrl = [dictUser valueForKey:@"thumb_url"];
                
                [UserAccessSession storeUserSession:session];
                
                [hud removeFromSuperview];
                [self.view setUserInteractionEnabled:YES];
                barButtonCancel.enabled = YES;
                
                [self performSelector:@selector(delaySocial:)
                           withObject:nil
                           afterDelay:0.5];
            }
        }
        else {
            
            [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
            
            [hud removeFromSuperview];
            [self.view setUserInteractionEnabled:YES];
            barButtonCancel.enabled = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        barButtonCancel.enabled = YES;
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"SIGNUP_CONNECTING_ERROR")];
    }];
}

-(void)delaySocial:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickLoginToTwitter:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        
        NSString* twitterId = [[FHSTwitterEngine sharedEngine] authenticatedID];
        NSDictionary *data = [[FHSTwitterEngine sharedEngine] getUserSettings];
        NSString* name = [data valueForKey:@"screen_name"];
        NSString* full_name = [NSString stringWithFormat:@"@%@", name];
        
        NSString* imageURL =[[FHSTwitterEngine sharedEngine] getProfileImageURLStringForUsername:name
                                                                                         andSize:FHSTwitterEngineImageSizeOriginal];
        
        [self registerViaSocial:twitterId isFacebook:NO name:full_name email:@"" profilePic:imageURL];
    }];
    
    [self presentViewController:loginController animated:YES completion:nil];
}


@end
