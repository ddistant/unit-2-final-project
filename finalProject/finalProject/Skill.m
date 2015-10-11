//
//  Skill.m
//  finalProject
//
//  Created by Justine Gartner on 10/11/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "Skill.h"

@implementation Skill

@dynamic skillName;

+(NSString *)parseClassName{
    
    return @"Skill";
}

+ (void)fetchAll:(void (^)(NSArray *results, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

@end
