//
//  PhotoService.h
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoImage;

@protocol PhotoServiceDelegate <NSObject>
- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription;
- (void)setLoadedPhoto:(PhotoImage *)photoImage;
@end

@interface PhotoService : NSObject

@property (nonatomic, weak) id <PhotoServiceDelegate> delegate;

- (void)loadPhotoWithSize:(NSString *)size photoSizes:(NSDictionary *)photoSizes delegate:(id)delegate;

@end
