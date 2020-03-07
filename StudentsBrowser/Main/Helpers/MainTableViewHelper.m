//
//  MainTableViewHelper.m
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainTableViewHelper.h"

@implementation MainTableViewHelper

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    return self;
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return 0;
    NSInteger count = viewController.arrayOfPeople.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentCell* cell = (StudentCell *)[tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    if (!cell) {
        abort();
    }
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return cell;
    Person* person = [viewController.arrayOfPeople objectAtIndex:indexPath.row];
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
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

@end
