//
//  VideoTableViewCell.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
