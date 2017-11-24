//
//  TagsService.h
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TagsServiceDelegate <NSObject>
- (void)setReceivedTags:(NSArray *)tags;
@end

@interface TagsService : NSObject

@property (nonatomic, weak) id <TagsServiceDelegate> delegate;

- (void)loadTags;

@end
