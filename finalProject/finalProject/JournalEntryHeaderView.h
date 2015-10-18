//
//  JournalEntryHeaderView.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/18/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalEntryHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end
