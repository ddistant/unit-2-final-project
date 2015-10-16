//
//  CourseResult.m
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import "CourseResult.h"

@implementation CourseResult

-(instancetype)initWithJSON: (NSDictionary *)json{
    
       if (self = [super init]){
        
        self.courseName = json[@"name"];
        self.courseDescription = json[@"shortDescription"];
        
        self.iconURL = json[@"smallIcon"];
        
        return self;
        
    }
    return nil;
    
}


@end
