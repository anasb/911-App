//
//  TwitterInterface.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 06/12/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "TwitterInterface.h"
#import <STTwitter/STTwitter.h>

@implementation TwitterInterface

+ (BOOL)canAccessTwitterAPI
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"J3UTNyiLwkNfII8GE1BVdsv3Q"
                                                            consumerSecret:@"4qrS4pjjCRIW0owVCtXMt0BMsBT53kuYSO4pPW9oNCuOvAcLOW"];
    __block BOOL canAccess = false;
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        canAccess = true;
    } errorBlock:^(NSError *error) {
        canAccess = false;
    }];
    
    [NSThread sleepForTimeInterval:3];
    return canAccess;
}

+ (void)queryTwitterAPIWithKeyword:(NSString*)keyword
                        atLatitude:(CLLocationDegrees)lat
                      andLongitude:(CLLocationDegrees)lon
                      successBlock:(void(^)(NSArray *statuses))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"J3UTNyiLwkNfII8GE1BVdsv3Q"
                                                            consumerSecret:@"4qrS4pjjCRIW0owVCtXMt0BMsBT53kuYSO4pPW9oNCuOvAcLOW"];

    // Verify access to API
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        // Query near me
        NSString *geocode = [NSString stringWithFormat:@"%f,%f,1mi", lat, lon];
        [twitter getSearchTweetsWithQuery:keyword geocode:geocode lang:@"en" locale:nil resultType:@"recent" count:@"100" until:nil sinceID:nil maxID:nil includeEntities:nil callback:nil successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
            
            successBlock(statuses);
            
            
        // Error in fetching tweets
        } errorBlock:^(NSError *error) { errorBlock(error); }];
    
    // Get access Twitter API
    } errorBlock:^(NSError *error) { errorBlock(error); }];
    
    
}

@end
