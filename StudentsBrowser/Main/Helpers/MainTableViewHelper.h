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

@interface MainTableViewHelper : NSObject<ViewControllerHelper, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) UIViewController* _Nullable viewController;

- (instancetype _Nonnull)initWithViewController:(UIViewController * _Nonnull)viewController;
- (BOOL) filteringIsInProgress;

@end
