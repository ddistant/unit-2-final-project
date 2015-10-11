//
//  Learner.m
//  finalProject
//
//  Created by Justine Gartner on 10/11/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "Learner.h"

@implementation Learner

@dynamic learnerName;
@dynamic learnerAvatar;
@dynamic learnerCoverPhoto;
@dynamic journalEntries;
@dynamic skill;

+(NSString *)parseClassName{
    
    return @"Learner";
}

+(void)fetchAll:(void (^)(NSArray *, NSError *))completion{
    
    //create query
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    
    //find all objects and return them in an array
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];

}

@end
