//
//  PersonViewController.m
//  StudentsBrowser
//
//  Created by Digital on 09/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

- (instancetype)initWithCoder:(NSCoder *)coder andPerson:(Person *)person {
    self = [super initWithCoder:coder];
    self.person = person;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupForCurrentPerson];
    self.pictureImageView.layer.cornerRadius = 64.0;
    self.pictureImageView.layer.masksToBounds = YES;
}

- (void)setupForCurrentPerson {
    Person* person = self.person;
    if (!person)
        return;

#pragma mark Title
    if (person.fullName && person.fullName.firstName && person.fullName.lastName)
        self.title = [self.person.fullName makeFirstAndLastName];

#pragma mark Picture
#warning Picture

#pragma mark General
    if (person.fullName && person.fullName.title)
        [self.titleButton setTitle: person.fullName.title forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.titleButton];

    NSString *genderString = [NSString string];
    switch (person.gender) {
        case GenderUndefined:
            genderString = @"Undefined";
            [self setButtonToNotAvailable:self.genderButton];
            break;
        case GenderMale:
            genderString = @"Male";
            break;
        case GenderFemale:
            genderString = @"Female";
            break;
    }
    [self.genderButton setTitle: genderString forState: UIControlStateNormal];

    if (person.nationality)
        [self.nationalityButton setTitle: person.nationality forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.nationalityButton];

#pragma mark Credentials
    if (person.email)
        [self.emailButton setTitle: person.email forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.emailButton];

    if (person.login && person.login.username)
        [self.usernameButton setTitle: person.login.username forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.usernameButton];

    if (person.login && person.login.password)
        [self.passwordButton setTitle: person.login.password forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.passwordButton];

#pragma mark Date

    if (person.dateOfBirth) {
        NSString* dateString = [NSDateFormatter localizedStringFromDate:person.dateOfBirth dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        NSString* ageString = [NSString stringWithFormat:@"%@", @(person.age)];
        [self.dateOfBirthButton setTitle: dateString forState: UIControlStateNormal];
        [self.ageButton setTitle: ageString forState: UIControlStateNormal];
    } else {
        [self setButtonToNotAvailable:self.dateOfBirthButton];
        [self setButtonToNotAvailable:self.ageButton];
    }

#pragma mark Phone

    if (person.cellPhoneNumber)
        [self.cellPhoneButton setTitle: person.cellPhoneNumber forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.cellPhoneButton];

    if (person.phoneNumber)
        [self.phoneButton setTitle: person.phoneNumber forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.phoneButton];

#pragma mark Location
    if (person.location && person.location.city)
        [self.cityButton setTitle: person.location.city forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.cityButton];

    if (person.location && person.location.state)
        [self.stateButton setTitle: person.location.state forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.stateButton];

    if (person.location && person.location.country)
        [self.countryButton setTitle: person.location.country forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.countryButton];

    if (person.location && person.location.addressLine.length > 0)
        [self.streetButton setTitle: person.location.addressLine forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.streetButton];

    if (person.location && person.location.timezoneDescription)
        [self.timeZoneButton setTitle: person.location.timezoneDescription forState: UIControlStateNormal];
    else
        [self setButtonToNotAvailable:self.timeZoneButton];


    if (person.location && CLLocationCoordinate2DIsValid(person.location.coordinates)) {
        CLLocationCoordinate2D coordinate = person.location.coordinates;
        [self.mapView setCenterCoordinate:coordinate];
        MKCoordinateRegion region;
        region.center = coordinate;
        region.span = MKCoordinateSpanMake(60, 60);
        [self.mapView setRegion:region];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        NSString *coordinateString = [NSString stringWithFormat:@"%f %f", coordinate.latitude, coordinate.longitude];
        [annotation setTitle:coordinateString];
        [self.mapView addAnnotation:annotation];
    }
    else
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(0, 0)];
}

- (void)setButtonToNotAvailable:(UIButton*)button {
    button.enabled = false;
    [button setTitle: @"N/A" forState: UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)sharedTapAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (!button)
        return;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:button.titleLabel.text];
    }];
    [controller addAction:cancelAction];
    [controller addAction:copyAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)didTapTitle:(id)sender {
}
- (IBAction)didTapGender:(id)sender {
}
- (IBAction)didTapNationality:(id)sender {
}
- (IBAction)didTapEmail:(id)sender {
}
- (IBAction)didTapUsername:(id)sender {
}
- (IBAction)didTapPassword:(id)sender {
}
- (IBAction)didTapDateOfBirth:(id)sender {
}
- (IBAction)didTapAge:(id)sender {
}
- (IBAction)didTapCellPhone:(id)sender {
}
- (IBAction)didTapPhone:(id)sender {
}
- (IBAction)didTapCountry:(id)sender {
}
- (IBAction)didTapState:(id)sender {
}
- (IBAction)didTapCity:(id)sender {
}
- (IBAction)didTapStreet:(id)sender {
}
- (IBAction)didTapTimeZone:(id)sender {
}

@end
