//
//  MeetUpResult.m
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import "MeetUpResult.h"

@implementation MeetUpResult

-(instancetype)initWithJSON: (NSDictionary *)json{
    
    //call super init, return self
    
    if (self = [super init]){
        
        self.eventName = json[@"name"];
        self.groupName = json[@"group"][@"name"];
        
        self.eventDescription = json[@"description"];
        
        self.locationName = json[@"venue"][@"name"];
        self.locationAddress = json[@"venue"][@"address_1"];
        
        self.eventURLLabel = [NSURL URLWithString:json[@"event_url"]];
        
        return self;
        
    }
    return nil;
    
}

@end
