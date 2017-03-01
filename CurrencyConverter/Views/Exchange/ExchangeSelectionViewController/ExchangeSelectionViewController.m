//
//  ExchangeSelectionViewController.m
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/21/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import "ExchangeSelectionViewController.h"
#import "ExchangeConversionViewController.h"
#import "ExchangeSelectionTableViewCell.h"
#import "FlagCollection.h"
#import "AFHTTPSessionManager.h"
#import "CCSessionManager.h"

/* Left Edge Inset */
static CGFloat const kPadding = 10.0;

/* Collection View Identifier */
static NSString * const kCellIdentifier = @"ExchangeSelectionCollectionViewCell";

/* Default Base Currency */
static NSString * const kDefaultBaseCurrency = @"USD";

@interface ExchangeSelectionViewController () {
    UIRefreshControl *refreshControl;
    FlagCollection *flags;
}

@end

@implementation ExchangeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flags = [[FlagCollection alloc] init];
    
    [self setupLayout];
    [self setupSpinner];
    
    [self.spinner startAnimating];
    [self setupDataSources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupLayout {
    // Hide NavBar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // Set background color to white
    self.view.backgroundColor = [UIColor whiteColor];
    
    /* Top Panel */
    self.topPanel = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height / 8.0)];
    self.topPanel.backgroundColor = [UIColor colorWithRed:21.0/255 green:127.0/255 blue:252.0/255 alpha:1.0];
    [self.view addSubview:self.topPanel];
    
    /* Base Currency View */
    self.baseCurrencyView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.topPanel.frame.size.width / 2.0, self.topPanel.frame.size.height / 2.0)];
    self.baseCurrencyView.center = CGPointMake(self.topPanel.center.x, self.topPanel.center.y + (UIApplication.sharedApplication.statusBarFrame.size.height / 2.0));
    
    self.baseCurrencyView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    [self.view addSubview:self.baseCurrencyView];
    
    /* Base Flag View */
    self.baseFlagImageView = [[UIImageView alloc] init];
    
    CGFloat lengthOfSide = self.baseCurrencyView.frame.size.height / 2.0;
    
    [self.baseFlagImageView setFrame:CGRectMake(kPadding, self.baseFlagImageView.frame.origin.y, lengthOfSide, lengthOfSide)];
    self.baseFlagImageView.center = CGPointMake(self.baseFlagImageView.center.x, lengthOfSide);
    [self.baseCurrencyView addSubview:self.baseFlagImageView];
    
    [self setBaseFlagImageWithCurrencyCode:kDefaultBaseCurrency];
    
    /* Base Currency Text Field */
    self.baseCurrencyTextField = [[UITextField alloc] initWithFrame:self.baseCurrencyView.bounds];
    
    self.baseCurrencyTextField.text = kDefaultBaseCurrency;
    self.baseCurrencyTextField.textColor = [UIColor blackColor];
    self.baseCurrencyTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:23.0f];
    
    self.baseCurrencyTextField.textAlignment = NSTextAlignmentCenter;
    self.baseCurrencyTextField.backgroundColor = [UIColor clearColor];
    [self.baseCurrencyView addSubview:self.baseCurrencyTextField];
    
    /* Picker View - Countries */
    self.pickerView = [[UIPickerView alloc] init];
    
    UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    toolbar.backgroundColor = [UIColor grayColor];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    [barItems addObject:cancelButton];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [barItems addObject:doneButton];
    
    toolbar.items = barItems;
    
    // Attach Picker to TextField
    self.baseCurrencyTextField.inputView = self.pickerView;
    self.baseCurrencyTextField.inputAccessoryView = toolbar;
    
}

- (void)setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.topPanel.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.topPanel.frame.size.height) style:UITableViewStylePlain];
    [self.tableView registerClass:[ExchangeSelectionTableViewCell class] forCellReuseIdentifier:@"ExchangeSelectionTableViewCell"];
    
    [self.view insertSubview:self.tableView belowSubview:self.spinner];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)setupDataSources {
    
    [[CCSessionManager sharedManager] getExchangeForBaseCurrency:self.baseCurrencyTextField.text success:^(NSDictionary *response)
     {
         self.exchanges = response[@"rates"];
         self.countries = [[self.exchanges allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
         
         if(!self.tableView){
             [self setupTableView];
             
             self.tableView.delegate = self;
             self.tableView.dataSource = self;
             
             self.pickerView.delegate = self;
             self.pickerView.dataSource = self;
         }
         else {
             [self.tableView reloadData];
             [self.pickerView reloadComponent:0];
         }
         
         self.currentBaseCountry = [NSMutableString stringWithFormat:@"%@", self.baseCurrencyTextField.text];
         
         if(refreshControl.isRefreshing) {
             [refreshControl endRefreshing];
         }
         
         if(self.spinner.isAnimating){
             [self.spinner stopAnimating];
         }
     } failure:^(NSError *error) {
         NSLog(@"Error: %@", error);
         self.baseCurrencyTextField.text = [NSString stringWithFormat:@"%@", self.currentBaseCountry];
         
         if(refreshControl.isRefreshing) {
             [refreshControl endRefreshing];
         }
         
         if(self.spinner.isAnimating){
             [self.spinner stopAnimating];
         }
     }];
}

- (void)setBaseFlagImageWithCurrencyCode:(NSString *)currencyCode {
    UIImage *image = [UIImage imageNamed:[flags imagePathForCurrencyCode:currencyCode]];
    self.baseFlagImageView.image = image;
}

#pragma mark - Picker View Action

- (void)doneButtonPressed {
    [self.baseCurrencyTextField resignFirstResponder];
    [self.spinner startAnimating];
    [self setupDataSources];
}

- (void)cancelButtonPressed {
    [self.baseCurrencyTextField resignFirstResponder];
    self.baseCurrencyTextField.text = self.currentBaseCountry;
    [self setBaseFlagImageWithCurrencyCode:self.currentBaseCountry];
}

#pragma mark - Table View Callback Actions

- (void)refreshTable {
    [self setupDataSources];
}

#pragma mark - Table View Data source
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.countries count];
}

- (ExchangeSelectionTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ExchangeSelectionTableViewCell";
    
    ExchangeSelectionTableViewCell *cell = (ExchangeSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ExchangeSelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *country = self.countries[indexPath.row];
    NSNumber *rate = self.exchanges[country];
    
    [cell imagePathForFlag:[flags imagePathForCurrencyCode:country]];
    [cell textForCountryLabel:country];
    [cell textForExchangeRateLabel:[NSString stringWithFormat:@"%.02f", [rate floatValue]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.topPanel.frame.size.height - UIApplication.sharedApplication.statusBarFrame.size.height);
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // untoggle the selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExchangeSelectionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    /* segue to ExchangeConversionViewController */
    ExchangeConversionViewController *ecVC = [[ExchangeConversionViewController alloc] init];
    ecVC.baseCurrency = self.baseCurrencyTextField.text;
    ecVC.desiredCurrency = cell.countryLabel.text;
    ecVC.exchangeRate = self.exchanges[cell.countryLabel.text];
    [self.navigationController pushViewController:ecVC animated:YES];
}

#pragma mark - Picker View Data source

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.countries count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.countries[row];
}

#pragma mark - Picker View Delegate

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.baseCurrencyTextField.text = self.countries[row];
    [self setBaseFlagImageWithCurrencyCode:self.countries[row]];
}


@end
