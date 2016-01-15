//
//  BMContactsTableViewCell.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/20/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMContactsTableViewCell.h"
#import "BMContact.h"
#import "NSData+Base64.h"
#import "BMContactInfo.h"
@interface BMContactsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
- (IBAction)call:(id)sender;
- (IBAction)message:(id)sender;
- (IBAction)import:(id)sender;


@end

@implementation BMContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 29.f;
    self.avatarImageView.clipsToBounds = YES;
    
    MGSwipeButton *callButton = [MGSwipeButton buttonWithTitle:@"Call"
                                                      backgroundColor:[UIColor colorWithRed:157.0/225.0 green:163.0/225.0 blue:43.0/225.0 alpha:1.0]
                                                              padding:20
                                                             callback:^BOOL(MGSwipeTableCell *sender) {
                                                                 [self call:nil];
                                                                 return YES;
                                                             }];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    MGSwipeButton *messageButton = [MGSwipeButton buttonWithTitle:@"Mail"
                                               backgroundColor:[UIColor colorWithRed:222.0/225.0 green:170.0/225.0 blue:18.0/225.0 alpha:1.0]
                                                       padding:20
                                                      callback:^BOOL(MGSwipeTableCell *sender) {
                                                          [self message:nil];
                                                          return YES;
                                                      }];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    MGSwipeButton *importButton = [MGSwipeButton buttonWithTitle:@"Add"
                                                  backgroundColor:[UIColor colorWithRed:135.0/225.0 green:135.0/225.0 blue:135.0/225.0 alpha:1.0]
                                                          padding:20
                                                         callback:^BOOL(MGSwipeTableCell *sender) {
                                                             [self import:nil];
                                                             return YES;
                                                         }];
    [importButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [importButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    self.rightButtons =  @[importButton, messageButton, callButton];
    self.rightSwipeSettings.transition = MGSwipeTransitionBorder;
}

- (IBAction)call:(id)sender {
    if (self.actionDelegate) {
        [self.actionDelegate call:self.contactInfo];
    }
}

- (IBAction)message:(id)sender {
    if (self.actionDelegate) {
        [self.actionDelegate sendMail:self.contactInfo];
    }
}

- (IBAction)import:(id)sender {
    if (self.actionDelegate) {
        [self.actionDelegate addToContacts:self.contactInfo];
    }
}

- (void)setContactInfo:(BMContactInfo *)contactInfo {
    _contactInfo = contactInfo;
    NSData *data = [[NSData alloc] initWithData:[NSData
                                                 dataFromBase64String:contactInfo.contact.avatar]];
    
    UIImage *image = [UIImage imageWithData:data];
    self.avatarImageView.image = image;
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", contactInfo.contact.lastName, contactInfo.contact.firstName];
    self.countryLabel.text = contactInfo.country;
    
    
}

@end
