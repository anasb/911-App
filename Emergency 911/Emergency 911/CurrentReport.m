//
//  CurrentReport.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "CurrentReport.h"

@implementation CurrentReport

+ (instancetype)sharedReport {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CurrentReport alloc] init];
        
        // Default values
        [_sharedInstance setInjuredIndividual:unknownIndividual];
        [_sharedInstance setConsciousness:unknownConsciousness];
        [_sharedInstance setBreathing:unknownBreathing];
        [_sharedInstance setInjurySeverity:unknownCritical];
        [_sharedInstance setTraumaType:@""];
        [_sharedInstance setBodyPartHurt:@""];
        [_sharedInstance setTweetsRelatedTo:[[NSMutableDictionary alloc] init]];
    });
    return _sharedInstance;
}

@end