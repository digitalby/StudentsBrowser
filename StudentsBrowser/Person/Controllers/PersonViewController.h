//
//  PersonViewController.h
//  StudentsBrowser
//
//  Created by Digital on 09/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (strong, nonatomic) IBOutlet UIButton *titleButton;
@property (strong, nonatomic) IBOutlet UIButton *genderButton;
@property (strong, nonatomic) IBOutlet UIButton *nationalityButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *usernameButton;
@property (strong, nonatomic) IBOutlet UIButton *passwordButton;
@property (strong, nonatomic) IBOutlet UIButton *dateOfBirthButton;
@property (strong, nonatomic) IBOutlet UIButton *ageButton;
@property (strong, nonatomic) IBOutlet UIButton *cellPhoneButton;
@property (strong, nonatomic) IBOutlet UIButton *phoneButton;
@property (strong, nonatomic) IBOutlet UIButton *countryButton;
@property (strong, nonatomic) IBOutlet UIButton *stateButton;
@property (strong, nonatomic) IBOutlet UIButton *cityButton;
@property (strong, nonatomic) IBOutlet UIButton *streetButton;
@property (strong, nonatomic) IBOutlet UIButton *timeZoneButton;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

NS_ASSUME_NONNULL_END
