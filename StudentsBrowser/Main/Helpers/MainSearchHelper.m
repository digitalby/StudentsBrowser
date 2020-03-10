//
//  MainSearchHelper.m
//  StudentsBrowser
//
//  Created by Digital on 11/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "MainSearchHelper.h"
#import "MainViewController.h"

@interface MainSearchHelper ()

@property(nonatomic) UISearchController* searchController;

@end

@implementation MainSearchHelper

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


@end
