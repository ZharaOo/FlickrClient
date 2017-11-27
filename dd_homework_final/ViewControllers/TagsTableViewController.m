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

@interface TagsTableViewController () <TagsServiceDelegate, UITextFieldDelegate> {
    NSString *selectedTag;
    TagsService *service;
}

@property (nonatomic, copy) NSArray *tags;
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation TagsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"10 Popular tags";
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 30.0)];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = self;
    
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

- (IBAction)showSearchPhotoByTextField:(id)sender {
    if (self.tableView.tableHeaderView) {
        [self showHeaderWithTextField:nil];
        [self.searchTextField endEditing:YES];
    } else {
        [self showHeaderWithTextField:self.searchTextField];
        [self.searchTextField becomeFirstResponder];
        self.searchTextField.text = @"Search text";
        [self.searchTextField selectAll:nil];
    }
}

- (void)showHeaderWithTextField:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.tableHeaderView = textField;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        if ([textField hasText]) {
            
        }
        return NO;
    }
    return YES;
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
