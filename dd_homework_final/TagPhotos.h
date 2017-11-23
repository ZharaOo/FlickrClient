//
//  TagPhotos.h
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoImage;

@protocol TagPhotosDelegate <NSObject>
- (void)addPhotoImage:(PhotoImage *)photoImage;
@end

@interface TagPhotos : NSObject
@property (nonatomic, weak) id <TagPhotosDelegate> delegate;
- (void)loadTagPhotos:(NSString *)tag;
@end
