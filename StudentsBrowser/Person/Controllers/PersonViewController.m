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
    self.personSetupHelper = [[PersonSetupHelper alloc]initWithViewController:self];
    self.person = person;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.personSetupHelper setupViewControllerForCurrentPerson];
    self.pictureImageView.layer.cornerRadius = 64.0;
    self.pictureImageView.layer.masksToBounds = YES;
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
