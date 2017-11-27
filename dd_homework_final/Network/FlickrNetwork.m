//
//  FlickrService.m
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "FlickrNetwork.h"
#import "PhotoImage.h"
#import "Sizes.h"

#define API_KEY @"0cd525f2f8f87b299852210dd47a3939"
#define HOST @"https://api.flickr.com/services/rest?nojsoncallback=1&format=json&"

@implementation FlickrNetwork

+ (void)loadTenHotTagsWithDelegate:(id <FlickrNetworkTagsDelegate>)delegate {
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.tags.getHotList&count=10", HOST, API_KEY]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [FlickrNetwork addTaskToSession:session url:requestUrl delegate:delegate completionHandlerWithoutError:^(NSDictionary *loadedData) {
        NSArray *tags = [[loadedData objectForKey:@"hottags"] objectForKey:@"tag"];
        NSMutableArray *tagsContent = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in tags) {
            [tagsContent addObject:[dic objectForKey:@"_content"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate setReceivedTags:tagsContent];
        });
    }];
}

+ (void)loadPhotoIDsWithTag:(NSString *)tag delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate {
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.photos.search&tags=%@&per_page=10", HOST, API_KEY, tag]];
    [FlickrNetwork loadPhotoIDsWithURL:requestUrl delegate:delegate];
}

+ (void)loadPhotoIDsWithText:(NSString *)text delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate {
    NSString *urlString = [[NSString stringWithFormat:@"%@api_key=%@&method=flickr.photos.search&text=%@&per_page=10", HOST, API_KEY, text] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    [FlickrNetwork loadPhotoIDsWithURL:requestUrl delegate:delegate];
}

+ (void)loadPhotoIDsWithURL:(NSURL *)url delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [FlickrNetwork addTaskToSession:session url:url delegate:delegate completionHandlerWithoutError:^(NSDictionary *loadedData) {
        NSArray *loadedPhotoIDs = [[loadedData objectForKey:@"photos"] objectForKey:@"photo"];
        NSMutableArray *photoIDs = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in loadedPhotoIDs) {
            [photoIDs addObject:[dic objectForKey:@"id"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate setReceivedPhotosIDs:photoIDs];
        });
    }];
}

+ (void)loadSizeOfPhotosWithID:(NSArray *)photoIDs delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPMaximumConnectionsPerHost = 2;
    sessionConfig.timeoutIntervalForResource = 0;
    sessionConfig.timeoutIntervalForRequest = 0;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    for (NSString *pID in photoIDs) {
        NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.photos.getSizes&photo_id=%@", HOST, API_KEY, pID]];
        
        [FlickrNetwork addTaskToSession:session url:requestUrl delegate:delegate completionHandlerWithoutError:^(NSDictionary *loadedData) {
            NSArray *loadedPhotoSizesURL = [[loadedData objectForKey:@"sizes"] objectForKey:@"size"];
            NSMutableDictionary *requredPhotoSizesURL = [[NSMutableDictionary alloc] init];
            for (NSDictionary *dic in loadedPhotoSizesURL) {
                NSString *photoSize = [dic objectForKey:@"label"];
                if ([photoSize isEqual:LARGE_SQUARE_SIZE] || [photoSize isEqual:MEDIUM_SIZE] || [photoSize isEqual:LARGE_SIZE]) {
                    NSString *photoURLstring = [[dic objectForKey:@"source"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                    [requredPhotoSizesURL setValue:[NSURL URLWithString:photoURLstring] forKey:photoSize];
                }
            }
            
            [FlickrNetwork loadPhotoWithSize:LARGE_SQUARE_SIZE photoSizes:requredPhotoSizesURL session:session delegate:delegate];
        }];
    }
}

+ (void)loadPhotoWithSize:(NSString *)size photoSizes:(NSDictionary *)photoSizesURL session:(NSURLSession *)session delegate:(id <FlickrNetworkParamPhotosDelegate>)delegate {
    NSString *urlString = [NSString stringWithFormat:@"%@", [photoSizesURL objectForKey:size]];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    if (!session) {
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    [[session downloadTaskWithURL:requestURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            PhotoImage *img = [[PhotoImage alloc] initWithImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:location]] photoSizes:photoSizesURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate addLoadedPhoto:img];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate errorLoadingDataWithTitle:@"Error loading data" description:error.localizedDescription];
            });
        }
     }] resume];
}

+ (void)addTaskToSession:(NSURLSession *)session url:(NSURL *)url delegate:(id)delegate completionHandlerWithoutError:(void (^)(NSDictionary *))processingOfReceivedData {
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *serverAnswer = [FlickrNetwork getServerAnswer:data response:(NSHTTPURLResponse *)response error:error];
        
        if ([serverAnswer objectForKey:@"Error"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate errorLoadingDataWithTitle:serverAnswer[@"Error"] description:serverAnswer[@"Description"]];
            });
        } else {
            processingOfReceivedData(serverAnswer);
        }
    }] resume];
}

+ (NSDictionary *)getServerAnswer:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error {
    if (!error) {
        if (response.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError) {
                return @{@"Error" : @"Serialization error",
                         @"Description" :  jsonError.localizedDescription};
            } else {
                if ([[jsonResponse objectForKey:@"stat"] isEqual:@"fail"]) {
                    return @{@"Error" : [jsonResponse objectForKey:@"stat"],
                             @"Description" : [jsonResponse objectForKey:@"message"]};
                } else {
                    return jsonResponse;
                }
            }
        } else {
            NSString *errorDescription = [NSString stringWithFormat:@"Error code %lu", response.statusCode];
            return @{@"Error" : @"Error loading data",
                     @"Description" : errorDescription};
        }
    } else {
        return @{@"Error" : @"Connection error",
                 @"Description" : error.localizedDescription};
    }
}

@end
