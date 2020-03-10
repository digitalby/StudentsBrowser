//
//  PersonSetupHelper.m
//  StudentsBrowser
//
//  Created by Digital on 10/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "PersonSetupHelper.h"
#import "PersonViewController.h"

@implementation PersonSetupHelper

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self.viewController = viewController;
    return self;
}

- (void)setupPictureForCurrentPerson {
    PersonViewController* viewController = (PersonViewController*)self.viewController;
    if(!viewController)
        return;

    Person* person = viewController.person;
    if (!person)
        return;

    if (person.picture && person.picture.largePicture) {
        UIImage *image = [UIImage imageWithData:person.picture.largePicture];
        if (image)
            [viewController.pictureImageView setImage:image];
    }
}

- (void)setupViewControllerForCurrentPerson {
    PersonViewController* viewController = (PersonViewController*)self.viewController;
    if(!viewController)
        return;

    Person* person = viewController.person;
    if (!person)
        return;

#pragma mark Title
    if (person.fullName && person.fullName.firstName && person.fullName.lastName)
        viewController.title = [person.fullName makeFirstAndLastName];

#pragma mark Picture
    [self setupPictureForCurrentPerson];

#pragma mark General
    if (person.fullName && person.fullName.title)
        [viewController.titleButton setTitle: person.fullName.title forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.titleButton];

    NSString *genderString = [NSString string];
    switch (person.gender) {
        case GenderUndefined:
            genderString = @"Undefined";
            [self setButtonToNotAvailable:viewController.genderButton];
            break;
        case GenderMale:
            genderString = @"Male";
            break;
        case GenderFemale:
            genderString = @"Female";
            break;
    }
    [viewController.genderButton setTitle: genderString forState: UIControlStateNormal];

    if (person.nationality)
        [viewController.nationalityButton setTitle: person.nationality forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.nationalityButton];

#pragma mark Credentials
    if (person.email)
        [viewController.emailButton setTitle: person.email forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.emailButton];

    if (person.login && person.login.username)
        [viewController.usernameButton setTitle: person.login.username forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.usernameButton];

    if (person.login && person.login.password)
        [viewController.passwordButton setTitle: person.login.password forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.passwordButton];

#pragma mark Date

    if (person.dateOfBirth) {
        NSString* dateString = [NSDateFormatter localizedStringFromDate:person.dateOfBirth dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        NSString* ageString = [NSString stringWithFormat:@"%@", @(person.age)];
        [viewController.dateOfBirthButton setTitle: dateString forState: UIControlStateNormal];
        [viewController.ageButton setTitle: ageString forState: UIControlStateNormal];
    } else {
        [self setButtonToNotAvailable:viewController.dateOfBirthButton];
        [self setButtonToNotAvailable:viewController.ageButton];
    }

#pragma mark Phone

    if (person.cellPhoneNumber)
        [viewController.cellPhoneButton setTitle: person.cellPhoneNumber forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.cellPhoneButton];

    if (person.phoneNumber)
        [viewController.phoneButton setTitle: person.phoneNumber forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.phoneButton];

#pragma mark Location
    if (person.location && person.location.city)
        [viewController.cityButton setTitle: person.location.city forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.cityButton];

    if (person.location && person.location.state)
        [viewController.stateButton setTitle: person.location.state forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.stateButton];

    if (person.location && person.location.country)
        [viewController.countryButton setTitle: person.location.country forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.countryButton];

    if (person.location && person.location.addressLine.length > 0)
        [viewController.streetButton setTitle: person.location.addressLine forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.streetButton];

    if (person.location && person.location.timezoneDescription)
        [viewController.timeZoneButton setTitle: person.location.timezoneDescription forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:viewController.timeZoneButton];


    if (person.location && CLLocationCoordinate2DIsValid(person.location.coordinates)) {
        CLLocationCoordinate2D coordinate = person.location.coordinates;
        [viewController.mapView setCenterCoordinate:coordinate];
        MKCoordinateRegion region;
        region.center = coordinate;
        region.span = MKCoordinateSpanMake(60, 60);
        [viewController.mapView setRegion:region];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        NSString *coordinateString = [NSString stringWithFormat:@"%f %f", coordinate.latitude, coordinate.longitude];
        [annotation setTitle:coordinateString];
        [viewController.mapView addAnnotation:annotation];
    }
    else
        [viewController.mapView setCenterCoordinate:CLLocationCoordinate2DMake(0, 0)];
}

- (void)setButtonToNotAvailable:(UIButton*)button {
    button.enabled = false;
    [button setTitle: @"N/A" forState: UIControlStateNormal];
}

@end
