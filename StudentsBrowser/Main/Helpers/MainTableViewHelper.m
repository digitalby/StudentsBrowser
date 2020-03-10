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

@property(nonatomic) UISearchController* searchController;

@end

@implementation MainTableViewHelper

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self.viewController = viewController;

    self.arrayOfPeopleFromSearch = [[NSArray alloc]init];
    [self setupSearchController];

    return self;
}

#pragma mark - Search Helpers

- (BOOL) searchBarIsEmpty {
    NSString* text = self.searchController.searchBar.text;
    if (!text)
        return YES;
    return [text length] == 0;
}

- (BOOL) filteringIsInProgress {
    BOOL isFilteringScope = self.searchController.searchBar.selectedScopeButtonIndex != 0;
    return self.searchController.isActive && (![self searchBarIsEmpty] || isFilteringScope);
}

- (void) setupSearchController {
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search People";
    self.searchController.searchBar.scopeButtonTitles = @[@"Any", @"Male", @"Female"];
    self.searchController.searchBar.delegate = self;
    self.viewController.navigationItem.searchController = self.searchController;
    self.viewController.definesPresentationContext = YES;
}

- (void) filterForSearchText:(NSString* _Nonnull)text andGender:(Gender)gender {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;
    NSArray* filteredArray = [[NSArray alloc]init];
    NSPredicate* genderPredicate;
    if (gender != GenderUndefined)
        genderPredicate = [NSPredicate predicateWithFormat:@"gender == %d", gender];
    else
        genderPredicate = [NSPredicate predicateWithValue:YES];
    filteredArray = [viewController.dataHelper.arrayOfPeople filteredArrayUsingPredicate:genderPredicate];
    if (![self searchBarIsEmpty]) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(fullName.firstName CONTAINS[cd] %@) OR (fullName.lastName CONTAINS[cd] %@)", text, text];
        filteredArray = [filteredArray filteredArrayUsingPredicate:namePredicate];
    }

    self.arrayOfPeopleFromSearch = filteredArray;
    [viewController.dataHelper updateUniqueFirstLetters];
    [viewController.dataHelper updateSectionedData];
    [viewController.tableView reloadData];
}

- (void) filterForSearchText:(NSString* _Nonnull)text {
    [self filterForSearchText:text andGender:GenderUndefined];
}

#pragma mark - Search Bar Delegate

- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    Gender gender;
    switch (selectedScope) {
        case 1:
            gender = GenderMale;
            break;
        case 2:
            gender = GenderFemale;
            break;
        default:
            gender = GenderUndefined;
            break;
    }
    NSString* text = self.searchController.searchBar.text;
    [self filterForSearchText:text andGender:gender];
}

#pragma mark - Search Results Updating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    UISearchBar* searchBar = searchController.searchBar;
    Gender selectedGender = searchBar.selectedScopeButtonIndex;
    NSString* searchText = searchBar.text;
    if (searchText) {
        [self filterForSearchText:searchText andGender:selectedGender];
    }
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
