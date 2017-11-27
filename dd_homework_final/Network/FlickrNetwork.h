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

@protocol FlickrNetworkParamPhotosDelegate <FlickrNetworkErrorDelegate>
- (void)addLoadedPhoto:(PhotoImage *)image;
@optional
- (void)setReceivedPhotosIDs:(NSArray *)photosID;
@end

@interface FlickrNetwork : NSObject

+ (void)loadTenHotTagsWithDelegate:(id <FlickrNetworkTagsDelegate>)delegate;

+ (void)loadPhotoIDsWithTag:(NSString *)tag delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate;
+ (void)loadPhotoIDsWithText:(NSString *)text delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate;
+ (void)loadSizeOfPhotosWithID:(NSArray *)photoIDs delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate;

+ (void)loadPhotoWithSize:(NSString *)size photoSizes:(NSDictionary *)photoSizesURL session:(NSURLSession *)session delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate;

@end
