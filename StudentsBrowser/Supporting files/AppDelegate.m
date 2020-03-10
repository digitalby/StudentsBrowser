//
//  AppDelegate.m
//  StudentsBrowser
//
//  Created by Digital on 29/02/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self clearCacheIfNeeded];
    return YES;
}

- (void) clearCacheIfNeeded {
    NSString* settingsKey = @"ClearCache";
    BOOL valueForKey = [NSUserDefaults.standardUserDefaults boolForKey:settingsKey];
    if (valueForKey) {
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:settingsKey];
        NSString *domain = NSBundle.mainBundle.bundleIdentifier;
        if (domain)
            [NSUserDefaults.standardUserDefaults removePersistentDomainForName:domain];
    }
}

@end
