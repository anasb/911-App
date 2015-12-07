//
//  CurrentReport.h
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentReport : NSObject

// Types
typedef NS_ENUM(NSUInteger, i) {
    myself,
    someoneElse,
    unknownIndividual,
};

typedef NS_ENUM(NSUInteger, c) {
    conscious,
    unconscious,
    unknownConsciousness,
};

typedef NS_ENUM(NSUInteger, b) {
    breathing,
    notBreathing,
    unknownBreathing,
};

typedef NS_ENUM(NSUInteger, ic) {
    critical,
    nonCritical,
    unknownCritical,
};

// Properties
@property (nonatomic, assign) NSUInteger injuredIndividual;
@property (nonatomic, assign) NSUInteger consciousness;
@property (nonatomic, assign) NSUInteger breathing;
@property (nonatomic, assign) NSUInteger injurySeverity;
@property (nonatomic, strong) NSString *traumaType;
@property (nonatomic, strong) NSString *bodyPartHurt;
@property (nonatomic, strong) NSMutableDictionary *tweetsRelatedTo;

// Methods
+ (instancetype)sharedReport;

@end
