//
//  PhotosCollectionViewController.h
//  dd_homework_final
//
//  Created by babi4_97 on 23.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchContent;

@interface PhotosCollectionViewController : UICollectionViewController

@property (nonatomic, strong) SearchContent *selectedContent;

@end
