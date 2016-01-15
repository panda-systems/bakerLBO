//
//  BMIntroductionViewController.m
//  Baker_MA_iOS
//
//  Created by Panda Systems on 7/23/15.
//  Copyright (c) 2015 Panda Systems. All rights reserved.
//

#import "BMIntroductionViewController.h"
#import "WebViewTool.h"
#import "BMInitData.h"
#import "BMSettings.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Baker_LBO_iOS-Swift.h"

@interface BMIntroductionViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* htmlData;
@end

@implementation BMIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    self.webView.delegate = self;
    self.navigationItem.title = @"Introduction";
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:@"BMDataUpdated" object:nil];

    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    BMSettings* settings = [((BMInitData*)[fetchedObjects firstObject]).settings.allObjects firstObject];
    
    self.htmlData = settings.introduction;
    
    [self setWebViewText];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = theWebView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}

- (void)backButtonPushed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setWebViewText {
    self.webView.opaque = NO;
    NSString *htmlString = @"<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'> <html><head><meta name=\"viewport\" content=\"width=320\"/><meta content='text/html; charset=ISO-8859-1' http-equiv='content-type'><title>Russian Federation</title><style> table, th, td { border: 2px solid black; border-collapse: collapse; padding: 5.75pt; font-family: Arial; font-size='10pt'; } </style></head><body><big><font size='-1'><big><span style='font-weight: bold; color: rgb(167, 25, 48); font-family: Arial;'>Russian Federation</span></big></font></big> <p class='Country2' style='font-family: Arial;'><font size='-1'><span style='font-weight: bold;' lang='EN-GB'><span style=''>1.1<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-weight: bold;'>Overview</span><o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The Russian Federation is a continental law jurisdiction. Its current legal system was formed in the early Nineties after the break-up of the Soviet Union. The Russian Civil Code was adopted in 1994, modelled on the Civil Codes of France, Germany and the Netherlands. It was amended in 2014 as part of the government&#8217;s legal reforms to modernise it and further amendments are under discussion.<o:p></o:p></span></font></p> <p class='Country2' style='font-family: Arial;'><font size='-1'><span style='font-weight: bold;' lang='EN-GB'><span style=''>1.2<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-weight: bold;'>General Legal Framework</span><o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Mergers and acquisitions in the Russian Federation are regulated by several laws which impact on various aspects of M&amp;A activity in the corporate, securities, antitrust, employment, tax and other areas. These laws include the Civil Code, the Tax Code, the Labour Code, the Law on Protection of Competition, the Law on Joint Stock Companies, the Law on Limited Liability Companies and the Law on the Securities Market.<o:p></o:p></span></font></p> <p class='Country2' style='font-family: Arial;'><font size='-1'><span style='font-weight: bold;' lang='EN-GB'><span style=''>1.3<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-weight: bold;'>Corporate Entities</span><o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The most common corporate structures for business operations in Russia are limited liability companies (LLCs) and joint stock companies (JSCs), which are regulated by the Civil Code, and the Law on Limited Liability Companies (LLC Law) and the Law on Joint Stock Companies (JSC Law), respectively. The LLC Law and the JSC Law are expected to be amended in 2015&#8211;2016 to modernise and bring the laws in line with recent amendments to the Civil Code.<o:p></o:p></span></font></p> <p class='Country3' style='font-family: Arial;'><font size='-1'><span style='font-weight: bold; font-style: italic;' lang='EN-GB'><span style=''>1.3.1<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-weight: bold; font-style: italic;'>Limited liability companies</span><o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The charter capital of an LLC is divided into participatory interests held by participants in the LLC. The number of participants in an LLC may not exceed 50. A single founder, whether Russian or non-Russian, may establish an LLC but only if that founder is not itself a company owned by a single individual or entity. The participants in an LLC have pre-emptive rights in respect of the sale of participatory interests by a participant to any third party, although it is also possible to prohibit transfers to third parties altogether. LLCs are best suited for small businesses and wholly-owned companies, as well as certain joint ventures.<o:p></o:p></span></font></p> <p class='Country3' style='font-family: Arial;'><font size='-1'><span style='font-style: italic; font-weight: bold;' lang='EN-GB'><span style=''>1.3.2<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-style: italic; font-weight: bold;'>Joint stock companies</span><o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>There are two types of JSC in Russia: public and private. In a public JSC, shares and securities convertible into shares may be offered to the public and the total number of shareholders is unlimited. In a private JSC, shares may not be offered to the public. Shareholders in a private JSC have pre-emptive rights in respect of the sale of shares to third parties.<o:p></o:p></span></font></p> <h1 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>2.<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Acquisition Methods<o:p></o:p></span></font></h1> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The consolidation of two or more businesses in the Russian Federation is usually achieved through a purchase of shares or assets, or a merger. Mergers are rarely used as an acquisition method, particularly in cross-border acquisitions, since Russian law does not allow foreign entities to merge with local companies. In most cases, acquisitions generally occur through share or asset purchases.<o:p></o:p></span></font></p> <h2 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>2.1<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Acquisition of Shares<o:p></o:p></span></font></h2> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Shares in a JSC exist in non-documentary form as entries on a shareholder&#8217;s account in a shareholders&#8217; register maintained by a professional third-party registrar. There are two classes of shares: ordinary (voting) shares and preference shares which are normally non-voting but may become voting in certain circumstances. Shares in JSCs under Russian law are classified as securities and each share issue must be registered with the Central Bank of Russia.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Participatory interests in an LLC are not classified as securities and do not need to be registered. The LLC is obliged to maintain a list of its participants specifying their shareholdings. Participants in the LLC and their shareholdings are also recorded in the Russian companies register which is maintained by the tax authorities and is publicly available.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>As with shares in the JSC, a participatory interest in an LLC may be transferred only after it has been fully-paid up by the founders.<o:p></o:p></span></font></p> <h2 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>2.2<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Acquisition of Assets<o:p></o:p></span></font></h2> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Under the Civil Code, an asset transaction may be made in the form of either an ordinary asset sale (asset sale) or the sale of an enterprise (enterprise sale).<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>An ordinary asset sale enables the buyer to acquire specific assets without liabilities which generally stay with the previous owner.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>An enterprise sale is a sale whereby the seller transfers an enterprise as a whole to the purchaser, which includes all types of property required for its commercial activities. This includes land, buildings, facilities, equipment, tools, raw materials, inventory, claims (receivables) and debts (payables), as well as the company&#8217;s name, trademarks, service marks, and other exclusive rights, unless otherwise provided by statute or contract. The contract for an enterprise sale must generally be concluded in the form of a single document.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Under Russian law, an enterprise is treated as immovable property. Title to the property passes to the purchaser upon registration of the transfer with the Russian Ministry of Justice. However, due to a rather complicated procedure for ascertaining whether a property complex is an enterprise and for registering it, the sale of an enterprise is rarely used in M&amp;A deals.<o:p></o:p></span></font></p> <h2 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>2.3<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Mergers and Consolidations<o:p></o:p></span></font></h2> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Russian corporate legislation defines a merger as a form of corporate reorganisation, whereby one company survives and the other disappears. The surviving company retains its own name and legal status and assumes the assets and liabilities of the absorbed company, while the latter loses its legal status and ceases to exist as a separate legal entity.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>In addition to mergers, Russian legislation allows companies to consolidate. In a consolidation, both companies cease to exist and their assets and liabilities are transferred, by operation of law, to a new legal entity formed as a result of that consolidation.<o:p></o:p></span></font></p> <h1 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>3.<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Negotiation, Signing and Closing<o:p></o:p></span></font></h1> <h2 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>3.1<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Customary Issues in Negotiating Acquisition Agreements<o:p></o:p></span></font></h2> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>Russian laws are not yet sufficiently sophisticated for complex M&amp;A transactions, particularly in relation to risk allocation. In cross-border M&amp;A transactions parties often chose English law to govern important deals. Foreign law may be chosen when one of the parties is a foreign entity or individual. Deals between Russian parties without any cross-border element should be governed by Russian law. Although the Civil Code was recently amended and efforts to further modernise it are under way, concepts like representations and warranties and indemnities do not exist or are not sufficiently developed, and if used in the context of a Russian law-governed contract will likely not work as intended, not least because the Russian courts have no familiarity with these concepts.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The following is a brief overview of certain key provisions in typical English-law governed purchase agreements for Russian deals. Baker&nbsp;&amp; McKenzie&#8217;s fully interactive comparison of these same provisions across the range of jurisdictions covered in this Handbook can be accessed at: <a href='http://crossbordermanda.bakermckenzie.com/'>http://crossbordermanda.bakermckenzie.com/</a><span class='MsoHyperlink'><span style=''>.</span></span><o:p></o:p></span></font></p> <h2 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>3.2<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Formalities for Execution of Documents<o:p></o:p></span></font></h2> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>See<b style=''> 3.3</b>.<o:p></o:p></span></font></p> <h2 style='font-family: Arial;'><font size='-1'><span style='' lang='EN-GB'><span style=''>3.3<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'>Formalities for Transfer Title to Shares or Assets<o:p></o:p></span></font></h2> <h3 style='font-family: Arial;'><font size='-1'><span style='font-style: italic;' lang='EN-GB'><span style=''>3.3.1<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-style: italic;'>Transfers of shares</span><o:p></o:p></span></font></h3> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>It is market practice to document the terms of a sale and purchase of shares in a JSC by way of a written share purchase agreement (SPA). In order to transfer title to shares in a JSC the buyer must open an account with the shareholders&#8217; register. This involves the filing of corporate documents which in the case of foreign buyers need to be notarised and apostilled (an apostille being a special form of certification required by the Hague convention) and translated into Russian. In turn, the seller must sign transfer instructions typically at the registrar&#8217;s office to effect the transfer, which involves payment of a fee.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>In order to transfer title to a participation interest in an LLC, the buyer and seller must sign a Russian-law governed transfer agreement before a Russian notary who checks passports and powers of attorney or other authorisations, as well as corporate documents which in cases of foreign companies should be notarised, apostilled and translated into Russian.<o:p></o:p></span></font></p> <h3 style='font-family: Arial;'><font size='-1'><span style='font-style: italic;' lang='EN-GB'><span style=''>3.3.2<span style='font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span></span><span lang='EN-GB'><span style='font-style: italic;'>Transfers of assets</span><o:p></o:p></span></font></h3> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The sale of assets is normally documented in writing by signing an SPA. Assets should be sufficiently identified, normally by including a clear description and inventory number, if available, in an annex to the SPA. For accounting and tax purposes, it is common to include a price for each asset. Special rules apply to transfers of certain types of assets (e.g. vehicles, real estate or IP), and separate transfer agreements may need to be executed and registered with the traffic police, real estate registry or patent authorities.<o:p></o:p></span></font></p> <p style='font-family: Arial;' class='MsoBodyText'><font size='-1'><span lang='EN-GB'>The contract for the sale of an enterprise must generally be concluded in the form of a single document and should include: a statement of inventory, a balance sheet, an independent auditor&#8217;s statement on the property included in the enterprise and a valuation of it; and a list of all debts (obligations) included in the enterprise, specifying the creditors, nature and size of the debts and their due dates.<o:p></o:p></span></font></p> </body> </html> ";
    htmlString = self.htmlData;
    [self.webView loadHTMLString:[[WebViewTool sharedWebViewTool] insertCssRuleString:htmlString] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dataUpdated:(NSNotification*) notification{
    JSSAlertViewResponder* responder = [[[JSSAlertView alloc] init] successOneButton:self.navigationController title:@"Success" text:@"Data updated!"];
    [responder addAction:^{
        
        NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BMInitData"];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        fetchRequest.sortDescriptors = @[descriptor];
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        BMSettings* settings = [((BMInitData*)[fetchedObjects firstObject]).settings.allObjects firstObject];
        
        self.htmlData = settings.introduction;
        
        [self setWebViewText];
        
    }];
}

@end
