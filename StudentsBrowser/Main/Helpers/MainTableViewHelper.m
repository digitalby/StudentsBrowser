//
//  MainTableViewHelper.m
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainTableViewHelper.h"
#import "MainViewController.h"

@interface MainTableViewHelper ()

@end

@implementation MainTableViewHelper

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self.viewController = viewController;

    return self;
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return 0;
    return viewController.dataHelper.sectionedData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return 0;

    NSArray * dataInSection = [viewController.dataHelper.sectionedData objectAtIndex:section];
    if (!dataInSection)
        return 0;

    return dataInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentCell* cell = (StudentCell *)[tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    if (!cell) {
        abort();
    }
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return cell;
    NSArray * section = [viewController.dataHelper.sectionedData objectAtIndex:indexPath.section];
    if (!section)
        return cell;
    Person* person = [section objectAtIndex:indexPath.row];
    if (!person) {
        return cell;
    }
    if (person.fullName) {
        cell.textLabel.text = [person.fullName makeFirstAndLastName];
    }
    cell.imageView.image = [UIImage imageNamed:@"placeholder_person"];
    if (person.picture) {
        NSData* thumbnailData = person.picture.thumbnailPicture;
        if (thumbnailData) {
            UIImage *thumbnail = [[UIImage alloc]initWithData:thumbnailData];
            if (thumbnail) {
                cell.imageView.image = thumbnail;
            }
        }
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return nil;
    return [viewController.dataHelper.uniqueFirstLetters objectAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return nil;
    return viewController.dataHelper.uniqueFirstLetters;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
