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

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfPeople = [[NSArray alloc]init];
    self.tableViewHelper = [[MainTableViewHelper alloc]initWithViewController:self];
    self.tableView.dataSource = self.tableViewHelper;
    self.tableView.delegate = self.tableViewHelper;

    JSONDownloader* downloader = [[JSONDownloader alloc] init];
    JSONParser* parser = [[JSONParser alloc]init];
    [downloader downloadDataWithAmount:50 completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@", error.description);
            }
            if (json) {
                NSArray *people = [parser getPeopleFromJSONArray:json];
                self.arrayOfPeople = people;
                self.arrayOfPeople = [self.arrayOfPeople sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    Person *lhs = (Person *)obj1;
                    Person *rhs = (Person *)obj2;
                    return [lhs.fullName.lastName compare:rhs.fullName.lastName];
                }];
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - Actions

- (IBAction)didTapLeftBarButtonItem:(id)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Action" message:@"You tapped left bar button item" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)didTapRightBarButtonItem:(id)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Action" message:@"You tapped right bar button item" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
