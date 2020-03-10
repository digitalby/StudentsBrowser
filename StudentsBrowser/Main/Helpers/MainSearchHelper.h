//
//  MainSearchHelper.h
//  StudentsBrowser
//
//  Created by Digital on 11/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerHelper.h"
#import "Gender.h"

@interface MainSearchHelper : NSObject<ViewControllerHelper, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) UIViewController* _Nullable viewController;

@property(nonatomic) NSArray* _Nonnull arrayOfPeopleFromSearch;
- (BOOL) filteringIsInProgress;

@end
