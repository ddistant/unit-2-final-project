//
//  VideoResult.h
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoResult : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *videoDescription;

@property (nonatomic) NSString *thumbnailURL;

@property (nonatomic) NSString *videoID;

-(instancetype)initWithJSON: (NSDictionary *)json;

@end
