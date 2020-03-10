//
//  MainViewController.h
//  StudentsBrowser
//
//  Created by Digital on 29/02/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONDownloader.h"
#import "JSONParser.h"
#import "ThumbnailDownloader.h"
#import "StudentCell.h"
#import "MainTableViewHelper.h"
#import "PersonViewController.h"
#import "NSIndexPath+Flatten.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *mainNavigationItem;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshBarButtonItem;

@property(nonatomic) NSArray* arrayOfPeople;

@end

