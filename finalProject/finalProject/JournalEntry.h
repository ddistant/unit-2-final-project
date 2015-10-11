//
//  JournalEntry.h
//  finalProject
//
//  Created by Justine Gartner on 10/11/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface JournalEntry : PFObject<PFSubclassing>

@property (nonatomic) NSDate *entryTimestamp;
@property (nonatomic) NSString *entryTitle;
@property (nonatomic) NSString *entryText;
@property (nonatomic) UIImage *entryPhoto;
@property (nonatomic) NSURL *entryLink;

+(NSString *)parseClassName;

+ (void)fetchAll:(void (^)(NSArray *results, NSError *error))completion;

@end
