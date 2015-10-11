//
//  JournalEntry.m
//  finalProject
//
//  Created by Justine Gartner on 10/11/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "JournalEntry.h"

@implementation JournalEntry

@dynamic entryTimestamp;
@dynamic entryTitle;
@dynamic entryText;
@dynamic entryPhoto;
@dynamic entryLink;

+ (NSString *)parseClassName{
    
    return @"JournalEntry";
}

+ (void)fetchAll:(void (^)(NSArray *results, NSError *error))completion {
    
    //create query
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    
    //find all objects and return them in an array
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];
}

@end
