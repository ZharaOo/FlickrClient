//
//  FlickrService.h
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoImage;

@protocol FlickrServiceErrorDelegate <NSObject>
- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription;
@end

@protocol FlickrServiceTagsDelegate <FlickrServiceErrorDelegate>
- (void)setReceivedTags:(NSArray *)tags;
@end

@protocol FlickrServicePhotosDelegate <FlickrServiceErrorDelegate>
- (void)setReceivedPhotosIDs:(NSArray *)photosID;
- (void)addLoadedPhotosSize:(NSDictionary *)photosSize;
- (void)addLoadedPhoto:(PhotoImage *)image;
@end

@interface FlickrService : NSObject <NSURLSessionDataDelegate>

+ (void)loadTenHotTagsWithDelegate:(id <FlickrServiceTagsDelegate>)delegate;
+ (void)loadPhotoIDsWithTag:(NSString *)tag delegate:(id <FlickrServicePhotosDelegate>)delegate;
+ (void)loadPhotoWithURL:(NSURL *)url photoID:(NSString *)photoID delegate:(id <FlickrServicePhotosDelegate>)delegate;
+ (void)loadSizeOfPhotosWithID:(NSArray *)photoIDs delegate:(id <FlickrServicePhotosDelegate>)delegate;
@end
