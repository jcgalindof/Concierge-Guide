

#import "NSStringExtras.h"

@implementation NSString (ContainsCategory)

- (BOOL) containsString: (NSString*) substring {
    
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch];
    BOOL found = (range.location != NSNotFound);
    return found;
}

- (NSString*) decodeFromPercentEscapeString:(NSString *) string {
    return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                         (__bridge CFStringRef) string,
                                                                                         CFSTR(""),
                                                                                         kCFStringEncodingUTF8);
}

@end
