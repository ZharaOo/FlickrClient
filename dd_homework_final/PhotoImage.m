//
//  PhotoImage.m
//  dd_homework_final
//
//  Created by babi4_97 on 23.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "PhotoImage.h"

@implementation PhotoImage

- (id)initWithImage:(UIImage *)image photoSizes:(NSDictionary *)sizes {
    self = [super init];
    if (self) {
        _image = image;
        _sizes = sizes;
    }
    return self;
}

@end
