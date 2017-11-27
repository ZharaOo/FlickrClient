//
//  TagsService.m
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "TagsService.h"
#import "FlickrNetwork.h"

@interface TagsService () <FlickrNetworkTagsDelegate>
@end

@implementation TagsService

- (void)loadTags {
    [FlickrNetwork loadTenHotTagsWithDelegate:self];
}

- (void)setReceivedTags:(NSArray *)tags {
    [self.delegate setReceivedTags:tags];
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    [self.delegate errorLoadingDataWithTitle:title description:errorDescription];
}

@end
