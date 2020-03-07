//
//  ViewController.m
//  StudentsBrowser
//
//  Created by Digital on 29/02/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic) NSArray* arrayOfPeople;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrayOfPeople = [[NSArray alloc]init];
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
                NSLog(@"Ready");
            }
        });
    }];
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.arrayOfPeople.count;
    NSLog(@"%zd", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentCell* cell = (StudentCell *)[tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    if (!cell) {
        abort();
    }
    Person* person = [self.arrayOfPeople objectAtIndex:indexPath.row];
    if (!person) {
        return cell;
    }
    if (person.fullName) {
        cell.textLabel.text = [person.fullName makeFirstAndLastName];
    }
    cell.imageView.image = [UIImage imageNamed:@"placeholder_person"];
    if (person.picture) {
        //Download
        //cell.imageView.image = person.picture.thumbnailPictureURLString;
    }

    return cell;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* message = [NSString stringWithFormat:@"You selected %@", indexPath];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Delegate" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
