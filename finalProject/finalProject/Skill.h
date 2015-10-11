//
//  Skill.h
//  finalProject
//
//  Created by Justine Gartner on 10/11/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>

@interface Skill : PFObject<PFSubclassing>

@property (nonatomic) NSString *skillName;

+(NSString *)parseClassName;

+ (void)fetchAll:(void (^)(NSArray *results, NSError *error))completion;

@end
