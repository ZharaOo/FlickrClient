//
//  TagPhotos.m
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "TagPhotosService.h"
#import "FlickrNetwork.h"

@interface TagPhotosService () <FlickrNetworkTagPhotosDelegate>

@property (nonatomic, copy) NSString *tag;
//@property (nonatomic, copy) NSArray *photoIDs;
//@property (nonatomic, strong) NSMutableArray *photosSizeWithURL;
//@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation TagPhotosService

- (id)initWithTag:(NSString *)tag {
    self = [super init];
    if (self) {
        _tag = tag;
        _nubmerOfPhotos = 0;
    }
    return self;
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
