//
//  FlickrService.h
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FlickrServiceDelegate <NSObject>
- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription;
@optional
- (void)getReceivedData:(NSArray *)data;
@end

@interface FlickrService : NSObject

+ (void)getTenHotTagsWithDelegate:(id <FlickrServiceDelegate>)delegate;

@end
