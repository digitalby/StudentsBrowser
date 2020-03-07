//
//  ViewControllerHelper.h
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ViewControllerHelper <NSObject>

@required
@property (weak, nonatomic) UIViewController* _Nullable viewController;

@required
- (instancetype _Nonnull) initWithViewController:(UIViewController * _Nonnull)viewController;

@end
