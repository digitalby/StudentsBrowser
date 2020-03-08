//
//  MainTableViewHelper.m
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainTableViewHelper.h"

@interface MainTableViewHelper ()

@property(nonatomic) NSArray* arrayOfPeopleFromSearch;
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
    filteredArray = [viewController.arrayOfPeople filteredArrayUsingPredicate:genderPredicate];
    if (![self searchBarIsEmpty]) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(fullName.firstName CONTAINS[cd] %@) OR (fullName.lastName CONTAINS[cd] %@)", text, text];
        filteredArray = [viewController.arrayOfPeople filteredArrayUsingPredicate:namePredicate];
    }

    self.arrayOfPeopleFromSearch = filteredArray;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return 0;
    NSInteger count;
    if ([self filteringIsInProgress]) {
        count = self.arrayOfPeopleFromSearch.count;
    } else {
        count = viewController.arrayOfPeople.count;
    }
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
    Person* person;
    if ([self filteringIsInProgress]) {
        person = [self.arrayOfPeopleFromSearch objectAtIndex:indexPath.row];
    } else {
        person = [viewController.arrayOfPeople objectAtIndex:indexPath.row];
    }
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

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;
    Person* person;
    if ([self filteringIsInProgress]) {
        person = [self.arrayOfPeopleFromSearch objectAtIndex:indexPath.row];
    } else {
        person = [viewController.arrayOfPeople objectAtIndex:indexPath.row];
    }
    if (!person) {
        return;
    }
    NSString* message = [NSString stringWithFormat:@"You selected %@", [person.fullName makeFullName]];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Delegate" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
