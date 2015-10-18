//
//  JournalEntryTableViewCell.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/18/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalEntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *journalEntryImageView;
@property (weak, nonatomic) IBOutlet UILabel *journalEntryLabel;

@end
