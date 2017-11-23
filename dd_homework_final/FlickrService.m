//
//  FlickrService.m
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "FlickrService.h"

#define API_KEY @"0cd525f2f8f87b299852210dd47a3939"
#define SECRET @"af3fe2ecf2e04ba7"
#define HOST @"https://api.flickr.com/services/rest?nojsoncallback=1&format=json&"

@implementation FlickrService

+ (void)getTenHotTagsWithDelegate:(id <FlickrServiceDelegate>)delegate {
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.tags.getHotList&count=10", HOST, API_KEY]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:requestUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"%@", jsonError.description);
                } else {
                    NSArray *tags = [[jsonResponse objectForKey:@"hottags"] objectForKey:@"tag"];
                    NSMutableArray *tagsContent = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in tags) {
                        [tagsContent addObject:[dic objectForKey:@"_content"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate getReceivedData:tagsContent];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *errorDescription = [NSString stringWithFormat:@"Server error code %lu", httpResponse.statusCode];
                    [delegate errorLoadingDataWithTitle:@"Error loading data" description:errorDescription];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate errorLoadingDataWithTitle:@"Connection error" description:error.description];
            });
        }
    }] resume];
}

- (void)lol {
    
}


@end
