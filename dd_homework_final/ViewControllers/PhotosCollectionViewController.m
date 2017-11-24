//
//  PhotosCollectionViewController.m
//  dd_homework_final
//
//  Created by babi4_97 on 23.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "TagPhotosService.h"
#import "PhotoImage.h"

@interface PhotosCollectionViewController () <TagPhotosDelegate> {
    TagPhotosService *service;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation PhotosCollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.title = self.selectedTag;
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.center = CGPointMake(self.collectionView.frame.size.width / 2, self.collectionView.frame.size.height / 2);
    [self.indicator startAnimating];
    [self.collectionView addSubview:self.indicator];
    
    self.photos = [[NSMutableArray alloc] init];
    
    service = [[TagPhotosService alloc] initWithTag:self.selectedTag];
    service.delegate = self;
    [service loadTagPhotos:self.selectedTag];
}

- (void)addPhotoImage:(PhotoImage *)photoImage {
    [self.photos addObject:photoImage];
    [self.collectionView reloadData];
}

- (void)updateNumberOfPhotos {
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    [self.collectionView reloadData];
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:errorDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return service.nubmerOfPhotos;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.photos.count) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        PhotoImage *photoImage = self.photos[indexPath.row];
        imgView.image = photoImage.image;
        [cell addSubview:imgView];
    } else {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator startAnimating];
        indicator.center = CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2);
        [cell addSubview:indicator];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.photos.count) {
        return YES;
    } else {
        return NO;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //UICollectionViewCell *datasetCell = [collectionView cellForItemAtIndexPath:indexPath];
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
 }

@end
