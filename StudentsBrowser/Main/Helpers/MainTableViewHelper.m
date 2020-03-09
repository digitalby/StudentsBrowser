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

    self.sectionedData = [[NSArray alloc]init];
    self.uniqueFirstLetters = [[NSArray alloc]init];

    self.arrayOfPeopleFromSearch = [[NSArray alloc]init];
    [self setupSearchController];

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

    if ([self filteringIsInProgress]) {
        data = self.arrayOfPeopleFromSearch;
    } else {
        data = viewController.arrayOfPeople;
    }

    return data;
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
        filteredArray = [filteredArray filteredArrayUsingPredicate:namePredicate];
    }

    self.arrayOfPeopleFromSearch = filteredArray;
    [self updateUniqueFirstLetters];
    [self updateSectionedData];
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
    return self.sectionedData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * dataInSection = [self.sectionedData objectAtIndex:section];
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
    NSArray * section = [self.sectionedData objectAtIndex:indexPath.section];
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
    return [self.uniqueFirstLetters objectAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.uniqueFirstLetters;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainViewController* viewController = (MainViewController*)self.viewController;
    if(!viewController)
        return;
    NSArray * section = [self.sectionedData objectAtIndex:indexPath.section];
    if (!section)
        return;
    Person* person = [section objectAtIndex:indexPath.row];
    if (!person) {
        return;
    }
    [viewController performSegueWithIdentifier:@"ShowPerson" sender:self.viewController];
}

@end
