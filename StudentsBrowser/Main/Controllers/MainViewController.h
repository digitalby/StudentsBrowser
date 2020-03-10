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
#import "MainDataHelper.h"
#import "StudentCell.h"
#import "MainTableViewHelper.h"
#import "PersonViewController.h"
#import "NSIndexPath+Flatten.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *mainNavigationItem;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshBarButtonItem;

@property(nonatomic) UIActivityIndicatorView* throbber;

@property(nonatomic) MainTableViewHelper* tableViewHelper;
@property(nonatomic) MainDataHelper* dataHelper;
@property(nonatomic) JSONDownloader* peopleDownloader;
@property(nonatomic) JSONParser* peopleParser;
@property(nonatomic) ThumbnailDownloader* thumbnailDownloader;

@end

