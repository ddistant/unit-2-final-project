//
//  VideoResult.m
//  LearningJournalCustomTableViewCells
//
//  Created by Justine Gartner on 10/16/15.
//  Copyright © 2015 Justine Gartner. All rights reserved.
//

#import "VideoResult.h"

@implementation VideoResult

-(instancetype)initWithJSON: (NSDictionary *)json{
    
    if (self = [super init]){
        
        self.title = json[@"snippet"][@"title"];
        self.videoDescription = json[@"snippet"][@"description"];
        
        self.thumbnailURL = json[@"snippet"][@"thumbnails"][@"high"][@"url"];
        
        self.videoID = json[@"id"][@"videoId"];
        
        return self;
        
    }
    return nil;
    
}


@end
