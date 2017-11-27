//
//  PhotoService.m
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "PhotoService.h"
#import "FlickrNetwork.h"

@interface PhotoService () <FlickrNetworkParamPhotosDelegate>

@end

@implementation PhotoService

- (void)loadPhotoWithSize:(NSString *)size photoSizes:(NSDictionary *)photoSizes delegate:(id)delegate {
    [FlickrNetwork loadPhotoWithSize:size photoSizes:photoSizes session:nil delegate:self];
}

- (void)addLoadedPhoto:(PhotoImage *)image {
    [self.delegate setLoadedPhoto:image];
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    [self.delegate errorLoadingDataWithTitle:title description:errorDescription];
}

@end
