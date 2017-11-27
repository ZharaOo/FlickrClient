//
//  TagPhotos.h
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoImage;

@protocol ParamPhotosDelegate <NSObject>
- (void)addPhotoImage:(PhotoImage *)photoImage;
- (void)updateNumberOfPhotos;
@end

@interface ParamPhotosService : NSObject

- (id)initWithTag:(NSString *)tag;

@property (nonatomic, assign) NSInteger nubmerOfPhotos;
@property (nonatomic, weak) id <ParamPhotosDelegate> delegate;
- (void)loadTagPhotos:(NSString *)tag;

@end
