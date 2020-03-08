//
//  MainViewController.m
//  StudentsBrowser
//
//  Created by Digital on 29/02/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property(nonatomic) MainTableViewHelper* tableViewHelper;
@property(nonatomic) JSONDownloader* peopleDownloader;
@property(nonatomic) JSONParser* peopleParser;
@property(nonatomic) ThumbnailDownloader* thumbnailDownloader;

@property(nonatomic) UIActivityIndicatorView* throbber;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.throbber = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.throbber.hidesWhenStopped = YES;
    UIBarButtonItem *throbberBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.throbber];
    [self.mainNavigationItem setLeftBarButtonItems:@[self.leftBarButtonItem, throbberBarButtonItem]];

    self.arrayOfPeople = [[NSArray alloc]init];
    self.tableViewHelper = [[MainTableViewHelper alloc]initWithViewController:self];
    self.tableView.dataSource = self.tableViewHelper;
    self.tableView.delegate = self.tableViewHelper;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView.refreshControl addTarget:self action:@selector(downloadPeople) forControlEvents:UIControlEventValueChanged];

    self.peopleDownloader = [[JSONDownloader alloc]init];
    self.peopleParser = [[JSONParser alloc]init];
    self.thumbnailDownloader = [[ThumbnailDownloader alloc]init];
    [self downloadPeople];
}

- (void) downloadPeople {
    [self.throbber startAnimating];
    [self.peopleDownloader cancelOperations];
    [self.peopleDownloader downloadDataWithAmount:50 completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@", error.description);
                return;
            }
            if (json) {
                NSArray *people = [self.peopleParser getPeopleFromJSONArray:json];
                self.arrayOfPeople = people;
                self.arrayOfPeople = [self.arrayOfPeople sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    Person *lhs = (Person *)obj1;
                    Person *rhs = (Person *)obj2;
                    return [lhs.fullName.lastName compare:rhs.fullName.lastName];
                }];
                [self.throbber stopAnimating];
                [self.tableView.refreshControl endRefreshing];
                [self.tableView reloadData];
                [self downloadThumbnails];
            }
        });
    }];
}

- (void) downloadThumbnails {
    [self.thumbnailDownloader cancelOperations];
    for (Person* person in self.arrayOfPeople) {
        if (person.picture.thumbnailPicture)
            continue;
        NSString* thumbnailURLString = person.picture.thumbnailPictureURLString;
        if (!thumbnailURLString)
            continue;
        NSURL* thumbnailURL = [[NSURL alloc]initWithString:thumbnailURLString];
        if (!thumbnailURL)
            continue;
        [self.thumbnailDownloader downloadImageAtURL:thumbnailURL completion:^(NSData * _Nullable imageData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@", error.description);
                    return;
                }
                if (imageData) {
                    person.picture.thumbnailPicture = imageData;
                    [self.tableView reloadData];
                }
            });
        }];
    }
}

#pragma mark - Actions

- (IBAction)didTapLeftBarButtonItem:(id)sender {
    [self downloadPeople];
}

- (IBAction)didTapRightBarButtonItem:(id)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Action" message:@"You tapped right bar button item" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
