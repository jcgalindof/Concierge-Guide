

#import <Foundation/Foundation.h>

@interface MGMapRoute : NSObject

+(NSArray*)getRouteFrom:(CLLocationCoordinate2D)coordFrom to:(CLLocationCoordinate2D)coordTo;

@end
