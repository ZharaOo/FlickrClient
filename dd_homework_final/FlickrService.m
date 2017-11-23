//
//  FlickrService.m
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "FlickrService.h"
#import "PhotoImage.h"

#define API_KEY @"0cd525f2f8f87b299852210dd47a3939"
#define HOST @"https://api.flickr.com/services/rest?nojsoncallback=1&format=json&"

@implementation FlickrService

+ (void)loadTenHotTagsWithDelegate:(id <FlickrServiceTagsDelegate>)delegate {
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.tags.getHotList&count=10", HOST, API_KEY]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [FlickrService addTaskToSession:session url:requestUrl tag:nil photoID:nil delegate:delegate completionHandlerWithoutError:^(NSDictionary *loadedData, NSString *tag, NSString *photoID) {
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

+ (void)loadPhotoIDsWithTag:(NSString *)tag delegate:(id <FlickrServicePhotosDelegate>)delegate {
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.photos.search&tags=%@&per_page=10", HOST, API_KEY, tag]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [FlickrService addTaskToSession:session url:requestUrl tag:tag photoID:nil delegate:delegate completionHandlerWithoutError:^(NSDictionary *loadedData, NSString *tag, NSString *photoID) {
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

+ (void)loadSizeOfPhotosWithID:(NSArray *)photoIDs delegate:(id <FlickrServicePhotosDelegate>)delegate {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.HTTPMaximumConnectionsPerHost = 2;
    sessionConfig.timeoutIntervalForResource = 0;
    sessionConfig.timeoutIntervalForRequest = 0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    for (NSString *pID in photoIDs) {
        NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@api_key=%@&method=flickr.photos.getSizes&photo_id=%@", HOST, API_KEY, pID]];
        
        [FlickrService addTaskToSession:session url:requestUrl tag:nil photoID:pID delegate:delegate completionHandlerWithoutError:^(NSDictionary *loadedData, NSString *tag, NSString *photoID) {
            NSArray *loadedPhotoSizesURL = [[loadedData objectForKey:@"sizes"] objectForKey:@"size"];
            NSMutableDictionary *requredPhotoSizesURL = [[NSMutableDictionary alloc] init];
            for (NSDictionary *dic in loadedPhotoSizesURL) {
                NSString *photoSize = [dic objectForKey:@"label"];
                if ([photoSize isEqual:@"Large Square"] || [photoSize isEqual:@"Medium"] || [photoSize isEqual:@"Large"]) {
                    NSString *photoURLstring = [[dic objectForKey:@"source"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                    [requredPhotoSizesURL setValue:[NSURL URLWithString:photoURLstring] forKey:photoSize];
                }
            }
            NSMutableDictionary *photoSizesID = [[NSMutableDictionary alloc] init];
            [photoSizesID setValue:requredPhotoSizesURL forKey:pID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate addLoadedPhotosSize:[photoSizesID copy]];
            });
            [[session downloadTaskWithURL:[requredPhotoSizesURL objectForKey:@"Large Square"] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error) {
                    PhotoImage *img = [[PhotoImage alloc] initWithImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:location]] photoSizes:requredPhotoSizesURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate addLoadedPhoto:img];
                    });
                } else {
                    //[delegate errorLoadingDataWithTitle:@"Error loading data" description:error.description];
                }
            }] resume];
        }];
    }
}

+ (void)loadPhotoWithURL:(NSURL *)url photoID:(NSString *)photoID delegate:(id <FlickrServicePhotosDelegate>)delegate {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            PhotoImage *img = (PhotoImage *)[UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
            //img.photoID = photoID;
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate addLoadedPhoto:img];
            });
        } else {
            //[delegate errorLoadingDataWithTitle:@"Error loading data" description:error.description];
        }
     }] resume];
}

+ (NSDictionary *)getServerAnswer:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError *)error {
    if (!error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError) {
                return @{@"Error" : @"Serialization error",
                         @"Description" :  jsonError.description};
            } else {
                return jsonResponse;
            }
        } else {
            NSString *errorDescription = [NSString stringWithFormat:@"Server error code %lu", response.statusCode];
            return @{@"Error" : @"Error loading data",
                     @"Description" : errorDescription};
        }
    } else {
        return @{@"Error" : @"Connection error",
                 @"Description" : error.description};
    }
}

+ (void)addTaskToSession:(NSURLSession *)session url:(NSURL *)url tag:(NSString *)tag photoID:(NSString *)photoID delegate:(id)delegate completionHandlerWithoutError:(void (^)(NSDictionary *, NSString *, NSString *))processingOfReceivedData {
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *serverAnswer = [FlickrService getServerAnswer:data response:(NSHTTPURLResponse *)response error:error];
        
        if ([serverAnswer objectForKey:@"Error"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate errorLoadingDataWithTitle:serverAnswer[@"Error"] description:serverAnswer[@"Description"]];
            });
        } else {
            processingOfReceivedData(serverAnswer, tag, photoID);
        }
    }] resume];
}

@end
