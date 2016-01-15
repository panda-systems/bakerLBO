//
//  BMContactsViewController.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/16/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMContactsViewController.h"
#import "BMContactsTableViewCell.h"
#import "BMInitData.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "BMCountry.h"
#import "BMContact.h"
#import "BMContactInfo.h"
#import "BMCountriesViewController.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NSData+Base64.h"
#import "Baker_LBO_iOS-Swift.h"

@interface BMContactsViewController() <BMCountriesViewControllerDelegate, BMContactsTableViewCellDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray* allContacts;
@property (nonatomic, strong) NSMutableArray* contacts;
@property (nonatomic, strong) BMInitData* allData;
@property (nonatomic, strong) UIVisualEffectView* visualEffectsView;
@property (nonatomic, strong) BMCountriesViewController* countriesViewController;
@end

@implementation BMContactsViewController

- (void)viewDidLoad {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"backArrow"];
    [button setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 33, 23);
    [button addTarget:self action:@selector(backButtonPushed:) forControlEvents:UIControlEventTouchDown];
    button.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UISplitViewController class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    self.navigationItem.title = @"Contacts";
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    self.allData = [fetchedObjects firstObject];
    self.contacts = [[NSMutableArray alloc] init];
    self.allContacts = [[NSMutableArray alloc] init];
    [self initContacts:self.allData];
//    UIBarButtonItem* countriesButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Filters"] style:UIBarButtonItemStylePlain target:self action:@selector(countriesButtonTapped)];
//    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixedSpace.width = 10.0;
//    self.navigationItem.rightBarButtonItems = @[fixedSpace, countriesButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"BMDataUpdated" object:nil];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

-(void) backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initContacts:(BMInitData*)data {
    for (BMCountry* country in [data.countries allObjects]) {
        for (BMContact *contact in [country.contacts allObjects]) {
            BMContactInfo *info = [[BMContactInfo alloc] init];
            info.contact = contact;
            info.country = country.name;
            [self.allContacts addObject:info];
        }
    }
    self.contacts = [self.allContacts mutableCopy];
    [self sortContacts];
    [self didChooseCountry:self.chosenCountry];
}

- (void) didChooseCountry:(BMCountry *)chosenCountry{
    self.chosenCountry = chosenCountry;
    [self.contacts removeAllObjects];
    for (BMCountry* country in [self.allData.countries allObjects]) {
        if (!chosenCountry || [country.countryId isEqualToNumber:chosenCountry.countryId]) {
            for (BMContact *contact in [country.contacts allObjects]) {
                BMContactInfo *info = [[BMContactInfo alloc] init];
                info.contact = contact;
                info.country = country.name;
                [self.contacts addObject:info];
            }
        }
    }
    [self sortContacts];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.countriesViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.countriesViewController willMoveToParentViewController:nil];
        [self.countriesViewController.view removeFromSuperview];
        [self.countriesViewController removeFromParentViewController];
        self.countriesViewController = nil;
    }];
    
}

- (void) sortContacts{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contact.lastName" ascending:YES];
    self.contacts = [[self.contacts sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 81;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMContactsTableViewCell* cell = (BMContactsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.swipeState){
        [cell hideSwipeAnimated:YES];
    } else {
        [cell showSwipe:MGSwipeDirectionRightToLeft animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactTableViewCell"];
    if (indexPath.row <  self.contacts.count) {
        cell.contactInfo = [self.contacts objectAtIndex:indexPath.row];
        
    }
    cell.actionDelegate = self;
    return cell;
}

- (void)countriesButtonTapped{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.countriesViewController = [storyboard instantiateViewControllerWithIdentifier:@"BMCountriesViewController"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.countriesViewController.countries = [[self.allData.countries allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];    
    self.countriesViewController.delegate = self;
    self.countriesViewController.chosenCountry = self.chosenCountry;
    self.countriesViewController.haveContainerView = YES;

    UINavigationController *nav = nil;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UISplitViewController class]]) {
        nav = [[((UISplitViewController *)rootVC) viewControllers] lastObject];
    } else {
        nav = self.navigationController;
    }
    
    self.countriesViewController.view.frame = nav.view.bounds;
    
    [nav addChildViewController:self.countriesViewController];
    [nav.view addSubview:self.countriesViewController.view];
    [self.countriesViewController didMoveToParentViewController:self];
    
    self.countriesViewController.view.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.countriesViewController.view.alpha = 1.0f;
    }];

}

- (void) call:(BMContactInfo *)contactInfo{
    NSString *phoneNumber = [[contactInfo.contact.phoneNumber componentsSeparatedByCharactersInSet:
                              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                             componentsJoinedByString:@""];
    phoneNumber = [NSString stringWithFormat:@"+%@",phoneNumber];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNumber]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }
}

-(void) sendMail:(BMContactInfo *)contactInfo{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc]init];
        [mailController setSubject:NSLocalizedString(@"Baker & McKenzie LBO Guidebook App Inquiry",nil)];
        [mailController setToRecipients:[NSArray arrayWithObject:contactInfo.contact.email]];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:YES completion:nil];
        
    }
    else
    {
        NSURL* url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"mailto:%@", contactInfo.contact.email]];
        [[UIApplication sharedApplication] openURL: url];
    }
}

-(void) addToContacts:(BMContactInfo *)contactInfo{
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (granted){
            ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);

            ABRecordRef person = ABPersonCreate();
            if (contactInfo.contact.firstName) ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)contactInfo.contact.firstName, nil);
            if (contactInfo.contact.lastName) ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)contactInfo.contact.lastName, nil);
            if (contactInfo.contact.phoneNumber) {
                ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)contactInfo.contact.phoneNumber, kABPersonPhoneMainLabel, NULL);
                ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumbers, nil);
            }
            if (contactInfo.contact.email) {
                ABMutableMultiValueRef emails = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                ABMultiValueAddValueAndLabel(emails, (__bridge CFStringRef)contactInfo.contact.email, kABWorkLabel ,nil);
                ABRecordSetValue(person, kABPersonEmailProperty, emails, nil);

            }
            if (contactInfo.contact.avatar) {
                NSData *imageData = [[NSData alloc] initWithData:[NSData dataFromBase64String:contactInfo.contact.avatar]];
                ABPersonSetImageData(person, (__bridge CFDataRef)imageData, nil);
            }
            
            //NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
            BOOL exists = NO;
//            for (id record in allContacts){
//                ABRecordRef thisContact = (__bridge ABRecordRef)record;
//                if (CFStringCompare(ABRecordCopyCompositeName(thisContact),
//                                    ABRecordCopyCompositeName(person), 0) == kCFCompareEqualTo){
//                    exists = YES;
//                }
//            }
            
            if (exists) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[[[UIAlertView alloc]initWithTitle:@"Alert" message:@"This contact already exists!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                    [[[JSSAlertView alloc] init] warningOneButton:self.navigationController title:@"Alert" text:@"This contact already exists!"];
                }   );
            } else {
                ABAddressBookAddRecord(addressBookRef, person, nil);
                ABAddressBookSave(addressBookRef, nil);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[[[UIAlertView alloc]initWithTitle:@"Success" message:@"Contact added!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
                    [[[JSSAlertView alloc] init] successOneButton:self.navigationController title:@"Success" text:@"Contact added!"];
                });
            }
            
        }
    });
}


//-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction* callAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Call" handler:^(UITableViewRowAction* action, NSIndexPath *indexPath){
//        [self call:self.contacts[indexPath.row]];
//        
//    }];
//    callAction.backgroundColor = [UIColor colorWithRed:157.0/225.0 green:163.0/225.0 blue:43.0/225.0 alpha:1.0];
//    
//    
//    UITableViewRowAction* mailAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Mail"  handler:^(UITableViewRowAction* action, NSIndexPath *indexPath){
//        [self sendMail:self.contacts[indexPath.row]];
//        
//    }];
//    mailAction.backgroundColor = [UIColor colorWithRed:222.0/225.0 green:170.0/225.0 blue:18.0/225.0 alpha:1.0];
//
//    UITableViewRowAction* addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Add"  handler:^(UITableViewRowAction* action, NSIndexPath *indexPath){
//        [self addToContacts:self.contacts[indexPath.row]];
//        
//    }];
//    addAction.backgroundColor = [UIColor colorWithRed:135.0/225.0 green:135.0/225.0 blue:135.0/225.0 alpha:1.0];
//
//    return @[addAction, mailAction, callAction];
//}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)dataUpdated:(NSNotification*) notification{
    JSSAlertViewResponder* responder = [[[JSSAlertView alloc] init] successOneButton:self.navigationController title:@"Success" text:@"Data updated!"];
    [responder addAction:^{
        
        NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        fetchRequest.sortDescriptors = @[descriptor];
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        self.allData = [fetchedObjects firstObject];
        self.contacts = [[NSMutableArray alloc] init];
        self.allContacts = [[NSMutableArray alloc] init];
        [self initContacts:self.allData];
        [self.tableView reloadData];
        
    }];
}

@end
