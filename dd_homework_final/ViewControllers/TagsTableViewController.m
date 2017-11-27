//
//  TagsTableViewController.m
//  dd_homework_final
//
//  Created by babi4_97 on 22.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "TagsTableViewController.h"
#import "PhotosCollectionViewController.h"
#import "TagsService.h"
#import "FlickrNetwork.h"

#define SHOW_PHOTOS_SEGUE_ID @"photosCollectionSegue"

@interface TagsTableViewController () <TagsServiceDelegate> {
    NSString *selectedTag;
    TagsService *service;
}

@property (nonatomic, copy) NSArray *tags;

@end

@implementation TagsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"10 Popular tags";
    
    service = [[TagsService alloc] init];
    service.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateTags)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self updateTags];
}

- (void)updateTags {
    [service loadTags];
}

- (void)setReceivedTags:(NSArray *)tags {
    self.tags = tags;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)errorLoadingDataWithTitle:(NSString *)title description:(NSString *)errorDescription {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:errorDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.tags[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectedTag = cell.textLabel.text;
    [self performSegueWithIdentifier:SHOW_PHOTOS_SEGUE_ID sender:self];
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqual:SHOW_PHOTOS_SEGUE_ID]) {
         PhotosCollectionViewController *dvc = (PhotosCollectionViewController *)segue.destinationViewController;
         dvc.selectedTag = selectedTag;
     }
 }

@end
