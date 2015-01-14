

#import <UIKit/UIKit.h>

@interface MGTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

-(CGRect)textRectForBounds:(CGRect)bounds;
-(CGRect)editingRectForBounds:(CGRect)bounds;

@end
