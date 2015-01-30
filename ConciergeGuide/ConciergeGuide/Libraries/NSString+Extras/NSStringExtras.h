

#import <Foundation/Foundation.h>

@interface NSString (ContainsCategory)

- (BOOL) containsString: (NSString*) substring;

- (NSString*) decodeFromPercentEscapeString:(NSString *) string;

@end

