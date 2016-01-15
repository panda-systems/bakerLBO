//
//  BMDescriptionViewController.m
//  Baker_MA_iOS
//
//  Created by Evgeny Dedovets on 7/17/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMDescriptionViewController.h"
#import "UIWebView+BMHighlightSearchResults.h"
#import "WebViewTool.h"
#import "BMWorldTableViewController.h"
@interface BMDescriptionViewController () <UIWebViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delimeterHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WebViewTopConstraint;
@property (nonatomic) BOOL searchBarHidden;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end


@implementation BMDescriptionViewController

- (void)viewDidLoad {
    self.delimeterHeight.constant = 0.5;
    self.searchBarHidden = YES;
    self.searchBarTopConstraint.constant = -self.searchBar.frame.size.height;
    self.WebViewTopConstraint.constant = 0;
    self.webView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.webView.opaque = NO;

    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    self.webView.scrollView.delegate = self;
    self.descriptionLabel.text = @"Description";

    self.searchBar.returnKeyType = UIReturnKeyDone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"BMDataUpdated" object:nil];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    float f = - scrollView.contentOffset.y;
    if (f<0) f=0;
    if (f>60) f=60;
    float phase = f/60.0;
    self.titleLabel.alpha = (phase - 0.6)/(1.0 - 0.6);
    self.titleContainerHeight.constant = f;
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = theWebView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}

- (IBAction)dismiss:(id)sender {
    
    self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //self.liftBtn.layer.opacity = 1;
    
                                              [UIView animateWithDuration:0.3f
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveEaseInOut
                                                               animations:^{
                                                                   self.view.transform = CGAffineTransformMakeScale(1.0f, 0.1979f);
                                                                   self.view.layer.opacity = 0.0;
                                                                   self.view.center = self.dismissDestinationCenter;
                                                                self.liftBtn.layer.opacity = 0.0f;
                                                                   //self.view.layer.opacity = 0;
                                                                   // self.view.center = self.dismissDestinationCenter;
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [self willMoveToParentViewController:nil];
                                                                   [self.view removeFromSuperview];
                                                                   [((BMWorldTableViewController*)self.parentViewController) updateDataIfNeeded];
                                                                   [self removeFromParentViewController];
//                                                                   [UIView animateWithDuration:0.2f
//                                                                                         delay:0.0
//                                                                                       options:UIViewAnimationOptionCurveEaseInOut
//                                                                                    animations:^{
//                                                                                     
//                                                                                        self.view.layer.opacity = 0;
//                                                                                     //   self.view.center = self.dismissDestinationCenter;
//                                                                                        
//                                                                                        //self.view.layer.opacity = 0;
//                                                                                        // self.view.center = self.dismissDestinationCenter;
//                                                                                    }
//                                                                                    completion:^(BOOL finished) {
//                                                                                    }];
                                                }];
                                              
                                                                                         
    


}

- (void)setDescriptionTitle:(NSString *)descriptionTitle {
    _descriptionTitle = descriptionTitle;
    self.titleLabel.text = descriptionTitle;
}

- (void)setHtmlData:(NSString *)htmlData {
    _htmlData = htmlData;
    [self.webView loadHTMLString:[[WebViewTool sharedWebViewTool] insertCssRuleString:htmlData] baseURL:nil];
    //[self.webView loadHTMLString:htmlData baseURL:nil];
}



- (IBAction)searchButtonTapped:(id)sender {
    [self.view layoutIfNeeded];
    if (!self.searchBarHidden) {
        
        self.searchBarHidden = YES;
        [self.searchButton setImage:[UIImage imageNamed:@"lupa"] forState:UIControlStateNormal];
        self.searchBarTopConstraint.constant = -self.searchBar.frame.size.height;
        self.WebViewTopConstraint.constant = 0;
        [self.searchBar resignFirstResponder];

    } else {
        
        self.searchBarHidden = NO;
        [self.searchButton setImage:[UIImage imageNamed:@"lupaYellow"] forState:UIControlStateNormal];
        self.searchBarTopConstraint.constant = 0;
        self.WebViewTopConstraint.constant = self.searchBar.frame.size.height;
        [self.searchBar becomeFirstResponder];

    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if ([searchText isEqualToString:@""]) {
        [self.webView removeAllHighlights];
    } else {
        [self.webView highlightAllOccurencesOfString:searchText];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)dataUpdated:(NSNotification*) notification{
    
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

@end
