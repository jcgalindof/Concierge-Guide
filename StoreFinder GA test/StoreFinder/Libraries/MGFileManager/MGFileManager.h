

#import <Foundation/Foundation.h>

@interface MGFileManager : NSObject

+(BOOL)deleteImageAtFilePath:(NSString*)filePath;

+(void)deleteAllFilesAtDocumentsFolderWithExt:(NSString*)extension;

@end
