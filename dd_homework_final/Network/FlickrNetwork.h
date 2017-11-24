//
//  FlickrService.h
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoImage;

@protocol FlickrNetworkErrorDelegate <NSObject>
- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription;
@end

@protocol FlickrNetworkTagsDelegate <FlickrNetworkErrorDelegate>
- (void)setReceivedTags:(NSArray *)tags;
@end

@protocol FlickrNetworkPhotosDelegate <FlickrNetworkErrorDelegate>
- (void)setReceivedPhotosIDs:(NSArray *)photosID;
- (void)addLoadedPhoto:(PhotoImage *)image;
@end

@interface FlickrNetwork : NSObject

+ (void)loadTenHotTagsWithDelegate:(id <FlickrNetworkTagsDelegate>)delegate;

+ (void)loadPhotoIDsWithTag:(NSString *)tag delegate:(id <FlickrNetworkPhotosDelegate>)delegate;
+ (void)loadSizeOfPhotosWithID:(NSArray *)photoIDs delegate:(id <FlickrNetworkPhotosDelegate>)delegate;

+ (void)loadPhotoWithSize:(NSString *)size photoID:(NSDictionary *)photoSizesURL session:(NSURLSession *)session delegate:(id <FlickrNetworkPhotosDelegate>)delegate;

@end
