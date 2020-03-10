//
//  MainViewController.m
//  StudentsBrowser
//
//  Created by Digital on 29/02/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.throbber = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.throbber.hidesWhenStopped = YES;
    UIBarButtonItem *throbberBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.throbber];
    [self.mainNavigationItem setLeftBarButtonItems:@[throbberBarButtonItem]];

    self.tableViewHelper = [[MainTableViewHelper alloc]initWithViewController:self];
    self.dataHelper = [[MainDataHelper alloc]initWithViewController:self];
    self.searchHelper = [[MainSearchHelper alloc]initWithViewController:self];

    self.tableView.dataSource = self.tableViewHelper;
    self.tableView.delegate = self.tableViewHelper;
    self.tableView.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView.refreshControl addTarget:self action:@selector(downloadPeople) forControlEvents:UIControlEventValueChanged];

    self.peopleDownloader = [[JSONDownloader alloc]init];
    self.peopleParser = [[JSONParser alloc]init];
    self.thumbnailDownloader = [[ThumbnailDownloader alloc]init];

    NSData* persistentPeople = [NSUserDefaults.standardUserDefaults dataForKey:@"people"];
    if (persistentPeople) {
        [self.peopleDownloader validateJSONData:persistentPeople completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
            if (!error && json)
                [self.dataHelper parsePeopleFromJSONArray:json];
        }];
    } else {
        [self downloadPeople];
    }
}

- (void) downloadPeople {
    [self.dataHelper downloadPeople];
}

#pragma mark - Actions

- (IBAction)didTapRefreshBarButtonItem:(id)sender {
    [self downloadPeople];
}

- (IBSegueAction UIViewController *)showPerson:(NSCoder *)coder sender:(id)sender {
    StudentCell *selectedCell = (StudentCell *)sender;
    if(!selectedCell)
        return nil;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    if (!indexPath)
        return nil;
    Person* person = self.dataHelper.sectionedData[indexPath.section][indexPath.row];
    if (!person)
        return nil;
    PersonViewController *destination = [[PersonViewController alloc]initWithCoder:coder andPerson:person];
    if (person.picture && !person.picture.largePicture) {
        NSString* urlString = person.picture.largePictureURLString;
        if (!urlString)
            return destination;
        NSURL* url = [[NSURL alloc]initWithString:urlString];
        if (!url)
            return destination;

        [self.thumbnailDownloader downloadImageAtURL:url completion:^(NSData * _Nullable imageData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@", error.description);
                    return;
                }
                if (imageData) {
                    NSInteger flatIndexPath = [indexPath flattenIndexPathForTableView:self.tableView];
                    NSString *persistentKey = [NSString stringWithFormat:@"large%tu", flatIndexPath];
                    [NSUserDefaults.standardUserDefaults setObject:imageData forKey:persistentKey];
                    person.picture.largePicture = imageData;
                    [destination.personSetupHelper setupPictureForCurrentPerson];
                }
            });
        }];
    }

    return destination;
}

@end
