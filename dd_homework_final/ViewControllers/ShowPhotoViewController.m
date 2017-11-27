//
//  ShowPhotoViewController.m
//  dd_homework_final
//
//  Created by babi4_97 on 24.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "PhotoService.h"
#import "PhotoImage.h"
#import "Sizes.h"

@interface ShowPhotoViewController () <PhotoServiceDelegate, UIScrollViewDelegate> {
    PhotoService *service;
}

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation ShowPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    service = [[PhotoService alloc] init];
    service.delegate = self;
    [service loadPhotoWithSize:[self chooseSize] photoSizes:self.sizes delegate:self];
    
    [self.indicator startAnimating];
}

- (NSString *)chooseSize {
    if ([self.sizes objectForKey:LARGE_SIZE]) {
        return LARGE_SIZE;
    } else {
        return MEDIUM_SIZE;
    }
}

- (void)setLoadedPhoto:(PhotoImage *)photoImage {
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    
    self.photoImageView.image = photoImage.image;
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    if (self.view.window) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:errorDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
