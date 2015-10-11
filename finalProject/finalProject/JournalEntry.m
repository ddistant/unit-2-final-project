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

+(NSString *)parseClassName{
    
    return @"JournalEntry";
}

@end
