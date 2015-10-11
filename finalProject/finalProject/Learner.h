//
//  Learner.h
//  finalProject
//
//  Created by Justine Gartner on 10/11/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "Skill.h"

@interface Learner : PFObject

@property (nonatomic) NSString *learnerName;
@property (nonatomic) UIImage *learnerAvatar;
@property (nonatomic) UIImage *learnerCoverPhoto;

@property (nonatomic) NSMutableArray *journalEntries;
@property (nonatomic) Skill *skill;

+ (NSString *)parseClassName;

@end
