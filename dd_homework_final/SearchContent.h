//
//  SearchContent.h
//  dd_homework_final
//
//  Created by babi4_97 on 27.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ContentTypeTag,
    ContentTypeText
} ContentType;

@interface SearchContent : NSObject

- (id)initWithContent:(NSString *)content type:(ContentType)type;

@property (nonatomic, assign) ContentType type;
@property (nonatomic, copy) NSString *content;

@end
