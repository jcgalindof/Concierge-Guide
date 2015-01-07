

#import <UIKit/UIKit.h>
#import "MGLoginView.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    
    MGLoginView* _loginView;
}

@property (nonatomic, retain) IBOutlet MGRawScrollView* scrollViewLogin;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* barButtonCancel;

-(IBAction)didClickCancelLogin:(id)sender;

@end
