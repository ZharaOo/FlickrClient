//
//  SearchContent.m
//  dd_homework_final
//
//  Created by babi4_97 on 27.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "SearchContent.h"

@implementation SearchContent

- (id)initWithContent:(NSString *)content type:(ContentType)type {
    self = [super init];
    if (self) {
        _content = content;
        _type = type;
    }
    return self;
}

@end
