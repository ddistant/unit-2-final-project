//
//  CourseResult.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseResult : NSObject

@property (nonatomic) NSString *courseName;
@property (nonatomic) NSString *courseDescription;
@property (nonatomic) NSString *iconURL;

-(instancetype)initWithJSON: (NSDictionary *)json;

@end
