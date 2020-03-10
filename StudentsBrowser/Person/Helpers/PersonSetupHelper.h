//
//  PersonSetupHelper.h
//  StudentsBrowser
//
//  Created by Digital on 10/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerHelper.h"

@interface PersonSetupHelper : NSObject<ViewControllerHelper>

@property (weak, nonatomic) UIViewController* _Nullable viewController;

- (instancetype _Nonnull) initWithViewController:(UIViewController * _Nonnull)viewController;
- (void)setupViewControllerForCurrentPerson;
- (void)setupPictureForCurrentPerson;

@end
