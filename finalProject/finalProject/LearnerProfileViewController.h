//
//  LearnerProfileViewController.h
//  finalProject
//
//  Created by Justine Gartner on 10/10/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Learner.h"
#import "JournalEntry.h"
#import "ComposePostViewController.h"

@interface LearnerProfileViewController : UIViewController

@property (nonatomic)Learner *learner;

@end
