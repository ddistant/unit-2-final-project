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


- (id)init {
    
    //This overrides [[Learner alloc] init] and
    //whenever a Learner is initialized,
    //it will now be initialized with a Skill!
    
    self = [super init];
    
     if (self != nil) {
         
         self.skill = [[Skill alloc]init];
         
         return self;
     }
     else {
         return nil;
     }
}

+(void)fetchAll:(void (^)(NSArray *, NSError *))completion{
    
    //create query
    PFQuery *query = [PFQuery queryWithClassName:[self parseClassName]];
    
    //find all objects and return them in an array
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects, error);
    }];

}

-(void)setSkillWith: (NSString *)skillName{
        
        self.skill.skillName = skillName;
}

-(void)saveLearnerSkill{
    
    //create a string with the Learner's skill.skillName
    NSString *skill = self.skill.skillName;
    
    //store the string in NSUserDefaults with the key: self.learnerName
    [[NSUserDefaults standardUserDefaults] setObject:skill forKey:LearnerSkillKey];
    
    
}

-(void)loadLearnerSkill{
    
    NSString *skill = [[NSUserDefaults standardUserDefaults] objectForKey:LearnerSkillKey];
    
    
    if (skill != nil) {
        self.skill.skillName = skill;
    }
}

@end
