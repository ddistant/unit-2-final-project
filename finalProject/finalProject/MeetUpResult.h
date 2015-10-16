//
//  MeetUpResult.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetUpResult : NSObject

@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *groupName;
@property (nonatomic) NSString *eventDescription;
@property (nonatomic) NSString *locationName;
@property (nonatomic) NSString *locationAddress;
@property (nonatomic) NSURL *eventURLLabel;

-(instancetype)initWithJSON: (NSDictionary *)json;

@end
