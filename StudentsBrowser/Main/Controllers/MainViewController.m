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

    NSData* persistentPeople = [NSUserDefaults.standardUserDefaults dataForKey:@"people"];
    if (persistentPeople) {
        [self.peopleDownloader validateJSONData:persistentPeople completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
            if (!error && json)
                [self parsePeopleFromJSONArray:json];
        }];
    } else {
        [self downloadPeople];
    }
}

- (void) downloadPeople {
    [self.throbber startAnimating];
    [self.peopleDownloader cancelOperations];
    [self.peopleDownloader downloadDataWithAmount:50 completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.throbber stopAnimating];
            [self.tableView.refreshControl endRefreshing];
            if (error) {
                NSString *title = [[NSString alloc]init];
                NSString *message = [[NSString alloc]init];
                NetworkError* networkError = (NetworkError*)error;
                if (networkError) {
                    title = networkError.localizedDescription;
                    message = networkError.localizedFailureReason;
                } else {
                    title = @"Error";
                    message = error.localizedDescription;
                }
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            if (json) {
                [self clearPersistentThumbnails];
                [self parsePeopleFromJSONArray:json];
            }
        });
    }];
}

- (void) parsePeopleFromJSONArray:(NSArray*)array {
    NSArray *people = [self.peopleParser getPeopleFromJSONArray:array];
    self.arrayOfPeople = people;
    self.arrayOfPeople = [self.arrayOfPeople sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        Person *lhs = (Person *)obj1;
        Person *rhs = (Person *)obj2;
        return [lhs.fullName.lastName compare:rhs.fullName.lastName];
    }];
    [self.tableView reloadData];
    NSUInteger numberOfPeople = self.arrayOfPeople.count;
    [NSUserDefaults.standardUserDefaults setInteger:numberOfPeople forKey:@"thumbnails"];
    [self retrievePersistentThumbnails];
    [self downloadThumbnails];
}

- (void) clearPersistentThumbnails {
    NSUInteger numberOfPersistentPeople = [NSUserDefaults.standardUserDefaults integerForKey:@"thumbnails"];
    for (NSUInteger i = 0; i < numberOfPersistentPeople; i++) {
        NSString *persistentKey = [NSString stringWithFormat:@"thumbnail%tu", i];
        [NSUserDefaults.standardUserDefaults setObject:nil forKey:persistentKey];
    }
}

- (void) retrievePersistentThumbnails {
    NSUInteger numberOfPeople = [NSUserDefaults.standardUserDefaults integerForKey:@"thumbnails"];
    for (NSUInteger i = 0; i < numberOfPeople; i++) {
        Person* person = [self.arrayOfPeople objectAtIndex:i];
        if (!person || person.picture.thumbnailPicture)
            continue;
        NSString *persistentKey = [NSString stringWithFormat:@"thumbnail%tu", i];
        NSData *persistentThumbnail = [NSUserDefaults.standardUserDefaults dataForKey:persistentKey];
        if (persistentThumbnail)
            person.picture.thumbnailPicture = persistentThumbnail;
    }
    [self.tableView reloadData];
}

- (void) downloadThumbnails {
    [self.thumbnailDownloader cancelOperations];
    for (NSUInteger i = 0; i < self.arrayOfPeople.count; i++) {
        Person* person = [self.arrayOfPeople objectAtIndex:i];
        if (!person || person.picture.thumbnailPicture)
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
                    NSString *persistentKey = [NSString stringWithFormat:@"thumbnail%tu", i];
                    [NSUserDefaults.standardUserDefaults setObject:imageData forKey:persistentKey];
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
