//
//  TagPhotos.m
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "ParamPhotosService.h"
#import "FlickrNetwork.h"

@interface ParamPhotosService () <FlickrNetworkParamPhotosDelegate>

@property (nonatomic, copy) NSString *tag;

@end

@implementation ParamPhotosService

- (id)initWithTag:(NSString *)tag {
    self = [super init];
    if (self) {
        _tag = tag;
        _nubmerOfPhotos = 0;
    }
    return self;
}

- (void)loadTextPhotos:(NSString *)text {
    [FlickrNetwork loadPhotoIDsWithText:text delegate:self];
}

- (void)loadTagPhotos:(NSString *)tag {
    [FlickrNetwork loadPhotoIDsWithTag:self.tag delegate:self];
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    
}

- (void)setReceivedPhotosIDs:(NSArray *)photosID {
    self.nubmerOfPhotos = photosID.count;
    [self.delegate updateNumberOfPhotos];
    [FlickrNetwork loadSizeOfPhotosWithID:photosID delegate:self];
}

- (void)addLoadedPhoto:(PhotoImage *)image {
    [self.delegate addPhotoImage:image];
}

@end
