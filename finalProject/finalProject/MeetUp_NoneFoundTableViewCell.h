//
//  MeetUp_NoneFoundTableViewCell.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/21/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetUp_NoneFoundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noMeetupsFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *startOneLabel;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@end
