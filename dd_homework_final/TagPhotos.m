//
//  TagPhotos.m
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "TagPhotos.h"
#import "FlickrService.h"

@interface TagPhotos () <FlickrServicePhotosDelegate>

@property (nonatomic, copy) NSString *tag;
//@property (nonatomic, copy) NSArray *photoIDs;
//@property (nonatomic, strong) NSMutableArray *photosSizeWithURL;
//@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation TagPhotos

- (id)initWithTag:(NSString *)tag {
    self = [super init];
    if (self) {
        //_photos = [[NSMutableArray alloc] init];
        //_photoIDs = [[NSArray alloc] init];
        //_photosSizeWithURL = [[NSMutableArray alloc] init];
        _tag = tag;
    }
    return self;
}

- (void)loadTagPhotos:(NSString *)tag {
    [FlickrService loadPhotoIDsWithTag:self.tag delegate:self];
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    
}

- (void)setReceivedPhotosIDs:(NSArray *)photosID {
    //self.photoIDs = photosID;
    [FlickrService loadSizeOfPhotosWithID:photosID delegate:self];
}

- (void)addLoadedPhotosSize:(NSDictionary *)photosSize {
    //[self.photosSizeWithURL addObject:photosSize];
}

- (void)addLoadedPhoto:(PhotoImage *)image {
    //[self.photos addObject:image];
    [self.delegate addPhotoImage:image];
}

@end
