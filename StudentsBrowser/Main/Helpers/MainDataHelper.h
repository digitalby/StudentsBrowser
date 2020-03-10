//
//  MainDataHelper.h
//  StudentsBrowser
//
//  Created by Digital on 11/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerHelper.h"
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainDataHelper : NSObject<ViewControllerHelper>

@property (weak, nonatomic) UIViewController* _Nullable viewController;


- (instancetype _Nonnull) initWithViewController:(UIViewController * _Nonnull)viewController;

@property (nonatomic) NSArray* arrayOfPeople;
@property (nonatomic) NSArray<NSArray<Person *> *> * _Nonnull sectionedData;
@property (nonatomic) NSArray<NSString *> * _Nonnull uniqueFirstLetters;
@property (nonatomic, readonly) NSArray<Person *> * _Nonnull currentArrayOfPeople;

- (void) updateSectionedData;
- (void) updateUniqueFirstLetters;

- (void) downloadPeople;
- (void) parsePeopleFromJSONArray:(NSArray*)array;
- (void) downloadThumbnails;

- (void) clearPersistentThumbnails;
- (void) retrievePersistentThumbnails;
- (void) retrievePersistentLargePictures;
- (void) clearPersistentLargePictures;

@end

NS_ASSUME_NONNULL_END
