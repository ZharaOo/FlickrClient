//
//  PhotoImage.h
//  dd_homework_final
//
//  Created by babi4_97 on 23.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImage : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSDictionary *sizes;

- (id)initWithImage:(UIImage *)image photoSizes:(NSDictionary *)sizes;

@end
