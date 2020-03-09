//
//  MainTableViewHelper.h
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ViewControllerHelper.h"

@interface MainTableViewHelper : NSObject<ViewControllerHelper, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) UIViewController* _Nullable viewController;
@property (nonatomic) NSArray<NSArray<Person *> *> * _Nonnull sectionedData;
@property (nonatomic) NSArray<NSString *> * _Nonnull uniqueFirstLetters;
@property (nonatomic, readonly) NSArray<Person *> * _Nonnull currentArrayOfPeople;

- (instancetype _Nonnull) initWithViewController:(UIViewController * _Nonnull)viewController;
- (BOOL) filteringIsInProgress;
- (void) updateSectionedData;
- (void) updateUniqueFirstLetters;

@end
