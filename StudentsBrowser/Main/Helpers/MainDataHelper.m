//
//  MainDataHelper.m
//  StudentsBrowser
//
//  Created by Digital on 11/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainDataHelper.h"
#import "MainViewController.h"

@implementation MainDataHelper

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    
    self.arrayOfPeople = [[NSArray alloc]init];

    self.sectionedData = [[NSArray alloc]init];
    self.uniqueFirstLetters = [[NSArray alloc]init];

    return self;
}

#pragma mark - Data helpers

- (void)updateSectionedData {
    NSArray *uniqueFirstLetters = self.uniqueFirstLetters;

    NSArray<Person *> * data = self.currentArrayOfPeople;

    NSMutableArray<NSArray<Person *> *> * sectionedData = [[NSMutableArray alloc]init];
    for (NSString * lhs in uniqueFirstLetters) {
        NSMutableArray<Person *> * dataInSection = [[NSMutableArray alloc] init];

        for (Person * person in data) {
            NSString *rhs;
            if (!person.fullName || !person.fullName.lastName)
                continue;
            rhs = [person.fullName.lastName substringToIndex:1];
            if (!rhs)
                continue;
            rhs = [rhs stringByApplyingTransform:NSStringTransformStripCombiningMarks reverse:NO];
            rhs = [rhs uppercaseString];
            if ([rhs rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound)
                rhs = @"#";

            if ([lhs isEqualToString:rhs])
                [dataInSection addObject:person];
        }
        [dataInSection sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Person *lhs = (Person *)obj1;
            Person *rhs = (Person *)obj2;
            return [lhs.fullName.lastName compare:rhs.fullName.lastName];
        }];
        [sectionedData addObject:dataInSection];
    }
    self.sectionedData = sectionedData;
}

- (void)updateUniqueFirstLetters {
    NSMutableArray<NSString *> * firstLetters = [[NSMutableArray alloc]init];

    NSArray<Person *> * data = self.currentArrayOfPeople;

    for (Person* person in data) {
        NSString *letter;
        if (!person.fullName || !person.fullName.lastName)
            continue;
        letter = [person.fullName.lastName substringToIndex:1];
        if (!letter)
            continue;
        letter = [letter stringByApplyingTransform:NSStringTransformStripCombiningMarks reverse:NO];
        letter = [letter uppercaseString];
        if ([letter rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound)
            letter = @"#";

        [firstLetters addObject:letter];
    }

    NSSet<NSString *> *setOfLetters = [NSSet setWithArray:firstLetters];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:nil ascending:YES];
    NSArray<NSString *> *sortedArrayOfUniqueLetters = [setOfLetters sortedArrayUsingDescriptors:@[descriptor]];

    self.uniqueFirstLetters = sortedArrayOfUniqueLetters;
}

- (NSArray<Person *> *)currentArrayOfPeople {
    NSArray<Person *> * data = [[NSArray alloc]init];
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return data;

    if ([viewController.searchHelper filteringIsInProgress]) {
        data = viewController.searchHelper.arrayOfPeopleFromSearch;
    } else {
        data = self.arrayOfPeople;
    }

    return data;
}

#pragma mark - Data downloading

- (void) downloadPeople {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;

    [viewController.throbber startAnimating];
    [viewController.peopleDownloader cancelOperations];
    [viewController.peopleDownloader downloadDataWithAmount:50 completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController.throbber stopAnimating];
            [viewController.tableView.refreshControl endRefreshing];
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
                [viewController presentViewController:alertController animated:YES completion:nil];
                return;
            }
            if (json) {
                [self clearPersistentThumbnails];
                [self clearPersistentLargePictures];
                [self parsePeopleFromJSONArray:json];
            }
        });
    }];
}

- (void) downloadThumbnails {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;
    
    [viewController.thumbnailDownloader cancelOperations];
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
        [viewController.thumbnailDownloader downloadImageAtURL:thumbnailURL completion:^(NSData * _Nullable imageData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@", error.description);
                    return;
                }
                if (imageData) {
                    NSString *persistentKey = [NSString stringWithFormat:@"thumbnail%tu", i];
                    [NSUserDefaults.standardUserDefaults setObject:imageData forKey:persistentKey];
                    person.picture.thumbnailPicture = imageData;
                    [viewController.tableView reloadData];
                }
            });
        }];
    }
}

#pragma mark - Data parsing

- (void) parsePeopleFromJSONArray:(NSArray*)array {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;

    NSArray *people = [viewController.peopleParser getPeopleFromJSONArray:array];
    self.arrayOfPeople = people;
    self.arrayOfPeople = [self.arrayOfPeople sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        Person *lhs = (Person *)obj1;
        Person *rhs = (Person *)obj2;
        return [lhs.fullName.lastName compare:rhs.fullName.lastName];
    }];
    [self updateUniqueFirstLetters];
    [self updateSectionedData];
    [viewController.tableView reloadData];
    NSUInteger numberOfPeople = self.arrayOfPeople.count;
    [NSUserDefaults.standardUserDefaults setInteger:numberOfPeople forKey:@"thumbnails"];
    [self retrievePersistentLargePictures];
    [self retrievePersistentThumbnails];
    [self downloadThumbnails];
}

#pragma mark - Data persistence

- (void) retrievePersistentThumbnails {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;

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
    [viewController.tableView reloadData];
}

- (void) clearPersistentThumbnails {
    NSUInteger numberOfPersistentPeople = [NSUserDefaults.standardUserDefaults integerForKey:@"thumbnails"];
    for (NSUInteger i = 0; i < numberOfPersistentPeople; i++) {
        NSString *persistentKey = [NSString stringWithFormat:@"thumbnail%tu", i];
        [NSUserDefaults.standardUserDefaults setObject:nil forKey:persistentKey];
    }
}

- (void) retrievePersistentLargePictures {
    NSUInteger numberOfPeople = [NSUserDefaults.standardUserDefaults integerForKey:@"thumbnails"];
    for (NSUInteger i = 0; i < numberOfPeople; i++) {
        Person* person = [self.arrayOfPeople objectAtIndex:i];
        if (!person || person.picture.largePicture)
            continue;
        NSString *persistentKey = [NSString stringWithFormat:@"large%tu", i];
        NSData *persistentData = [NSUserDefaults.standardUserDefaults dataForKey:persistentKey];
        if (persistentData)
            person.picture.largePicture = persistentData;
    }
}

- (void) clearPersistentLargePictures {
    NSUInteger numberOfPersistentPeople = [NSUserDefaults.standardUserDefaults integerForKey:@"thumbnails"];
    for (NSUInteger i = 0; i < numberOfPersistentPeople; i++) {
        NSString *persistentKey = [NSString stringWithFormat:@"large%tu", i];
        [NSUserDefaults.standardUserDefaults setObject:nil forKey:persistentKey];
    }
}

@end
