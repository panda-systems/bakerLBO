//
//  BMHomeViewController.m
//  Baker_MA_iOS
//
//  Created by Oleg Bolshakov on 6/26/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMHomeViewController.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "BMCountry.h"
#import "BMContact.h"
#import "BMSubject.h"
#import "BMSubTopic.h"
#import "BMTopic.h"
#import "BMInitData.h"
#import "NSData+Base64.h"
#import "Baker_LBO_iOS-Swift.h"
#import "WebViewTool.h"
#import "BMLoaderViewController.h"
#import "BMIntroductionViewController.h"
#import "BMWorldTableViewController.h"
#import "BMContactsViewController.h"
#import "BMGeneralInquiryViewController.h"
#import "BMInfoViewController.h"
#import "BMCountriesViewController.h"

#define BMDefaultGrayColor [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
#define BMLightGrayColor [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
@interface BMHomeViewController ()

@property NSArray *countries;
@property NSArray *contacts;
@property NSArray *topics;
@property NSArray *subTopics;
@property NSArray *subjects;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UIView *aroundView;
@property (weak, nonatomic) IBOutlet UIView *contactsView;
@property (weak, nonatomic) IBOutlet UIView *generalView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) BMLoaderViewController* loaderViewController;

@property (strong, nonatomic) UIView *selectedView;
@end

@implementation BMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    self.navigationItem.titleView = titleImage;
    
   // [self fetchArticlesFromContext];
    // Do any additional setup after loading the view.
    self.separatorHeightConstraint.constant = 1.0/[UIScreen mainScreen].scale;
    
    [self addTapGesturesForMenuViews];
    NSString *checkLoaded = [[NSUserDefaults standardUserDefaults] valueForKey:@"initialDataLoaded"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"BMDataUpdated" object:nil];
    
    if (![checkLoaded isEqualToString:@"YES"]) {
        [self requestData];
    }
    else {
        [self requestUpdate];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.aroundView.backgroundColor = [UIColor clearColor];
    self.introView.backgroundColor = [UIColor clearColor];
    self.infoView.backgroundColor = [UIColor clearColor];
    self.generalView.backgroundColor = [UIColor clearColor];
    self.contactsView.backgroundColor = [UIColor clearColor];
    
    [self selectMenuViewIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RESTKit

- (void)requestData {
    
    NSString *requestPath = @"/api/init/data/";
    [self startLoader];
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         //articles have been saved in core data by now
         //[self fetchArticlesFromContext];
         [self dismissLoader];
         
         NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
         NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
         NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
         fetchRequest.sortDescriptors = @[descriptor];
         NSError *error = nil;
         NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
         NSNumber *timeStamp = ((BMInitData*)[fetchedObjects firstObject]).timestamp;
         [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"initialDataLoaded"];
         [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:@"timeStamp"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [[WebViewTool sharedWebViewTool] updateCSSString];

     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
         [self dismissLoader];
         RKLogError(@"Load failed with error: %@", error);
         //[[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         [[[JSSAlertView alloc] init] dangerOneButton:self.navigationController title:@"Alert" text:@"Network error"];

     }];
    
}

- (void) startLoader{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.loaderViewController = [[BMLoaderViewController alloc] init];
    self.loaderViewController.view.alpha = 0.0;
    self.loaderViewController.view.frame = window.bounds;
    [window addSubview:self.loaderViewController.view];
    
    //UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    self.visualEffectsView = [[UIView alloc] init];
//    self.visualEffectsView.backgroundColor = [UIColor blackColor];
    
//    self.visualEffectsView.frame = window.bounds;
//    self.visualEffectsView.alpha = 0.0;
//    CGRect bounds = window.bounds;
//    UIView* loaderView = [[[NSBundle mainBundle] loadNibNamed:@"BMLoaderView" owner:self options:nil] objectAtIndex:0];
//    CGRect frame = self.activityIndicator.bounds;
//    [scrollview addSubview:myView];
//    [self.activityIndicator setFrame:CGRectMake((bounds.size.width-frame.size.width)/2.0, (bounds.size.height-frame.size.height)/2.0, frame.size.width, frame.size.height)];
//    [self.visualEffectsView addSubview:self.activityIndicator];
//    [window addSubview:self.visualEffectsView];
//    [self.activityIndicator startAnimating];
//    self.activityIndicator.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
//        self.visualEffectsView.alpha = 0.7;
        self.loaderViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
//        [self.activityIndicator startAnimating];
    }];
}

- (void) dismissLoader{
    [self.loaderViewController.imageView stopAnimating];

    [UIView animateWithDuration:0.3 animations:^{
        self.loaderViewController.view.alpha = 0.0;
//        self.visualEffectsView.alpha = 0.0;
    } completion:^(BOOL finished) {
//        [self.visualEffectsView removeFromSuperview];
        [self.loaderViewController.view removeFromSuperview];
    }];
}

- (void)requestUpdate{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSNumber *timeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:@"timeStamp"];
    double temp = [timeStamp doubleValue] - 75000;
    timeStamp = [NSNumber numberWithDouble:temp];
    NSString *date = [NSString stringWithFormat:@"%ld", [timeStamp longValue]];
    
    NSString *requestPath = [NSString stringWithFormat:@"%@%@", @"/api/refresh/data/?date=",date];
    //NSString *requestPath = @"/api/refresh/data/?date=2015-07-20";
    [self startLoader];
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         
         

         NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
         NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
         NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
         fetchRequest.sortDescriptors = @[descriptor];
         NSError *error = nil;
         NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
         NSNumber *timeStamp = ((BMInitData*)[fetchedObjects firstObject]).lastUpdate;
         [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:@"timeStamp"];
         NSString *dataChanged = ((BMInitData*)[fetchedObjects firstObject]).dataChanged;

         NSArray* notificationTypes = @[@"none"];
         if (notificationTypes && [dataChanged isEqualToString:@"yes"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BMDataUpdated" object:nil userInfo:@{@"types": notificationTypes}];
         }
         [[WebViewTool sharedWebViewTool] updateCSSString];
         [self dismissLoader];
         //articles have been saved in core data by now
         //[self fetchArticlesFromContext];
         //[[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"initDataLoaded"];
         //[[NSUserDefaults standardUserDefaults] synchronize];
         
     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
         [self dismissLoader];
         RKLogError(@"Load failed with error: %@", error);
         //[[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }
     ];
}

- (void)fetchArticlesFromContext {
    
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    BMInitData *countryList = [fetchedObjects firstObject];
    
    self.countries = [countryList.countries allObjects];
    
    BMCountry *country = (BMCountry*)[self.countries firstObject];
    
    self.contacts = [country.contacts allObjects];
    
    BMContact *contact = (BMContact*)[self.contacts firstObject];
    
    self.topics = [country.topics allObjects];
    
    BMTopic *topic = (BMTopic*)[self.topics firstObject];
    
    self.subTopics = [topic.subtopics allObjects];
    
    BMSubTopic *subTopic = (BMSubTopic*)[self.subTopics firstObject];
    
    self.subjects = [subTopic.subjects allObjects];
    
    BMSubject *subject = (BMSubject*)[self.subjects firstObject];

    NSLog(@"%@", subject.title);
    NSLog(@"%@", country.name);
    NSLog(@"%@ %@ %@ %@", contact.firstName, contact.lastName, contact.email, contact.phoneNumber);
    
    
    NSData *data = [[NSData alloc] initWithData:[NSData
                                                 dataFromBase64String:contact.avatar]];
    
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = titleImage;
    
}

- (void)dataUpdated:(NSNotification*) notification{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

    if (self.navigationController.topViewController == self && ![rootVC isKindOfClass:[UISplitViewController class]]) {
        JSSAlertViewResponder* responder = [[[JSSAlertView alloc] init] successOneButton:self.navigationController title:@"Success" text:@"Data updated!"];
    }
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UIUserInterfaceIdiom deviceType = [[UIDevice currentDevice] userInterfaceIdiom];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    Class rootVCClass = rootVC.class;
    
    if (deviceType == UIUserInterfaceIdiomPad && (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) && rootVCClass != [UISplitViewController class]) {
        [self changeRootViewController];
        [self selectMenuViewIfNeeded];
    } else if (deviceType == UIUserInterfaceIdiomPad && rootVCClass == [UISplitViewController class]) {
        UINavigationController *detailNav = [((UISplitViewController *)rootVC).viewControllers lastObject];
        UIViewController *detailVC = [detailNav topViewController];
        detailVC.navigationItem.leftBarButtonItem = nil;
    }
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Methods

- (void)changeRootViewController {
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    
    BMHomeViewController *masterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BMHomeViewController"];
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:masterVC];
    splitVC.delegate = masterVC;
    
    UIViewController *detailVC = nil;
    
    UIViewController *topVC = [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count] > 1 ? 1 : 0)];     //object at index 0 == HomeViewController. Object at index 1 == any of menu controllers
    if ([topVC isKindOfClass:[BMHomeViewController class]]) {
        BMIntroductionViewController *introVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BMIntroductionViewController"];
        detailVC = introVC;
    } else {
        detailVC = topVC;
    }
    
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    detailVC.navigationItem.leftBarButtonItem = nil;
    
    splitVC.viewControllers = [NSArray arrayWithObjects:masterNav, detailNav, nil];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = splitVC;
}

- (void)addTapGesturesForMenuViews {
    UITapGestureRecognizer *introViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showIntro)];
    [self.introView addGestureRecognizer:introViewTap];
    self.introView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *aroundViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAround)];
    [self.aroundView addGestureRecognizer:aroundViewTap];
    self.aroundView.userInteractionEnabled = YES;

    UITapGestureRecognizer *contactsViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContacts)];
    [self.contactsView addGestureRecognizer:contactsViewTap];
    self.contactsView.userInteractionEnabled = YES;

    UITapGestureRecognizer *generalViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGeneral)];
    [self.generalView addGestureRecognizer:generalViewTap];
    self.generalView.userInteractionEnabled = YES;

    UITapGestureRecognizer *infoViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfo)];
    [self.infoView addGestureRecognizer:infoViewTap];
    self.infoView.userInteractionEnabled = YES;
}

- (void)showViewController:(UIViewController *)vc {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)rootVC;
        UINavigationController *nav = (UINavigationController *)[splitVC.viewControllers lastObject];
        [nav setViewControllers:@[vc] animated:NO];
        [splitVC showDetailViewController:nav sender:nil];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectMenuViewIfNeeded {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)rootVC;
        UINavigationController *nav = (UINavigationController *)[splitVC.viewControllers lastObject];
        UIViewController *vc = [[nav viewControllers] firstObject];     //rootVC of nav

        if ([vc isKindOfClass:[BMIntroductionViewController class]]) {
            [self setViewSelected:self.introView];
        } else if ([vc isKindOfClass:[BMWorldTableViewController class]]) {
            [self setViewSelected:self.aroundView];
        } else if ([vc isKindOfClass:[BMContactsViewController class]]) {
            [self setViewSelected:self.contactsView];
        } else if ([vc isKindOfClass:[BMGeneralInquiryViewController class]]) {
            [self setViewSelected:self.generalView];
        } else if ([vc isKindOfClass:[BMInfoViewController class]]) {
            [self setViewSelected:self.infoView];
        }
    }
}

- (void)setViewSelected:(UIView *)view {
    self.selectedView.backgroundColor = BMDefaultGrayColor;
    self.selectedView = view;
    view.backgroundColor = BMLightGrayColor;
}

#pragma mark - Navigation

- (void)showIntro {
    [self setViewSelected:self.introView];

    BMIntroductionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMIntroductionViewController"];
    [self showViewController:vc];
}

- (void)showAround {
    [self setViewSelected:self.aroundView];

    BMWorldTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMWorldTableViewController"];
    [self showViewController:vc];
}

- (NSSet *)fetchCountriesFromContext {
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return ((BMInitData *)[fetchedObjects firstObject]).countries;
}

- (void)showContacts {
//    [self setViewSelected:self.contactsView];
//
//    BMContactsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMContactsViewController"];
//    [self showViewController:vc];
    [self setViewSelected:self.contactsView];
    
    BMCountriesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMCountriesViewController"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    vc.countries = [NSMutableArray arrayWithArray:[[[self fetchCountriesFromContext] allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (BMCountry *country in vc.countries) {
        if (!country.contacts.count > 0)
            [discardedItems addObject:country];
    }
    [vc.countries removeObjectsInArray:discardedItems];
    vc.haveContainerView = NO;
    
    [self showViewController:vc];
}

- (void)showGeneral {
    [self setViewSelected:self.generalView];

    BMGeneralInquiryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMGeneralInquiryViewController"];
    [self showViewController:vc];

}

- (void)showInfo {
    [self setViewSelected:self.infoView];

    BMInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BMInfoViewController"];
    [self showViewController:vc];
}

@end
