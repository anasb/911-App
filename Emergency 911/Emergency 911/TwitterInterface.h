//
//  TwitterInterface.h
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 06/12/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TwitterInterface : NSObject

+ (BOOL)canAccessTwitterAPI;

+ (void)queryTwitterAPIWithKeyword:(NSString*)keyword
                        atLatitude:(CLLocationDegrees)lat
                      andLongitude:(CLLocationDegrees)lon
                      successBlock:(void(^)(NSArray *statuses))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock;

@end
