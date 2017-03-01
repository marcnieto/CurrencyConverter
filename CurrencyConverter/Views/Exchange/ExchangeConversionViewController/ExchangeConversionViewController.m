//
//  ExchangeConversionViewController.m
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/21/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import "ExchangeConversionViewController.h"

/* Default Base Value */
static NSString * const kDefaultBaseValue = @"1.00";

@interface ExchangeConversionViewController () {
    NSMutableString *oldBaseCurrency;
    NSMutableString *oldDesiredCurrency;
    float exchangeRateValue;
}

@end

@implementation ExchangeConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupLayout];
}

/* ensures the view is fully loaded before pulling up the keyboard */
- (void)viewDidAppear:(BOOL)animated {
    [self.baseCurrencyTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLayout {
    // Hide NavBar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // Set background color
    self.view.backgroundColor = [UIColor colorWithRed:21.0/255 green:127.0/255 blue:252.0/255 alpha:1.0];
    
    /* Conversion View */
    self.conversionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width * (3.0/4.0), self.view.frame.size.height / 3.0)];
    self.conversionView.center = self.view.center;
    self.conversionView.backgroundColor = [UIColor whiteColor];
    
    self.conversionView.layer.cornerRadius = self.conversionView.frame.size.width / 10.0;
    
    [self.view addSubview:self.conversionView];
    
    /* Separator View */
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.conversionView.frame.size.width * (9.0/10.0), 1.0)];
    self.separator.center = CGPointMake(self.conversionView.frame.size.width / 2.0, self.conversionView.frame.size.height / 2.0);
    self.separator.backgroundColor = [UIColor lightGrayColor];
    
    [self.conversionView addSubview:self.separator];
    
    /* Back Button */
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self
               action:@selector(backButtonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setTitle:@"  <  " forState:UIControlStateNormal];
    [self.backButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:35.0f]];
    [self.backButton setFrame:CGRectMake(0.0, (UIApplication.sharedApplication.statusBarFrame.size.height / 2.0), 70.0, 70.0)];
    [self.view addSubview:self.backButton];
    
    /* Base Currency View */
    self.baseCurrencyTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, self.conversionView.frame.size.width * (3.0 / 4.0), self.conversionView.frame.size.height / 4.0)];
    
    self.baseCurrencyTextField.center = CGPointMake(self.conversionView.frame.size.width * (3.0/8.0), self.conversionView.frame.size.height / 4.0);
    
    self.baseCurrencyTextField.text = @"1.00";
    oldBaseCurrency = [NSMutableString stringWithFormat:@"%@", self.baseCurrencyTextField.text];
    
    self.baseCurrencyTextField.textColor = [UIColor darkGrayColor];
    [self.baseCurrencyTextField setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:35.0]];
    
    self.baseCurrencyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.baseCurrencyTextField.textAlignment = NSTextAlignmentCenter;
    self.baseCurrencyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.baseCurrencyTextField.backgroundColor = [UIColor clearColor];
    
    self.baseCurrencyTextField.delegate = self;
    
    [self.conversionView addSubview:self.baseCurrencyTextField];
    
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
    self.baseCurrencyTextField.inputAccessoryView = toolbar;
    [self.baseCurrencyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    /* Base Currency Label */
    self.baseCurrencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.conversionView.frame.size.width / 4.0, self.conversionView.frame.size.height / 4.0)];
    self.baseCurrencyLabel.center = CGPointMake(self.conversionView.frame.size.width * (7.0/8.0), self.conversionView.frame.size.height / 4.0);
    
    self.baseCurrencyLabel.textColor = [UIColor grayColor];
    self.baseCurrencyLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:23.0f];
    self.baseCurrencyLabel.text = self.baseCurrency;
    self.baseCurrencyLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.conversionView addSubview:self.baseCurrencyLabel];
    
    /* Desired Currency View */
    self.desiredCurrencyTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, self.conversionView.frame.size.width * (3.0/4.0), self.conversionView.frame.size.height / 4.0)];
    
    self.desiredCurrencyTextField.center = CGPointMake(self.conversionView.frame.size.width * (3.0/8.0), self.conversionView.frame.size.height * (3.0/4.0));
    
    exchangeRateValue = [self.exchangeRate floatValue];
    oldDesiredCurrency = [NSMutableString stringWithFormat:@"%.02f", exchangeRateValue];
    self.desiredCurrencyTextField.text = oldDesiredCurrency;
    
    self.desiredCurrencyTextField.textColor = [UIColor blueColor];
    [self.desiredCurrencyTextField setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:35.0]];
    
    self.desiredCurrencyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.desiredCurrencyTextField.textAlignment = NSTextAlignmentCenter;
    self.desiredCurrencyTextField.backgroundColor = [UIColor clearColor];
    self.desiredCurrencyTextField.enabled = NO;
    [self.conversionView addSubview:self.desiredCurrencyTextField];
    
    /* Desired Currency Label */
    self.desiredCurrencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.conversionView.frame.size.width / 4.0, self.conversionView.frame.size.height / 4.0)];
    self.desiredCurrencyLabel.center = CGPointMake(self.conversionView.frame.size.width * (7.0/8.0), self.conversionView.frame.size.height * (3.0/4.0));
    
    self.desiredCurrencyLabel.textColor = [UIColor grayColor];
    self.desiredCurrencyLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:23.0f];
    self.desiredCurrencyLabel.text = self.desiredCurrency;
    self.desiredCurrencyLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.conversionView addSubview:self.desiredCurrencyLabel];
}

#pragma mark - Button Actions

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Actions

/* confirmation of the desired currency converstion */
- (void)doneButtonPressed {
    [self.baseCurrencyTextField resignFirstResponder];
    oldBaseCurrency = [NSMutableString stringWithFormat:@"%@", self.baseCurrencyTextField.text];
    oldDesiredCurrency = [NSMutableString stringWithFormat:@"%@", self.desiredCurrencyTextField.text];
}

/* cancelling an edit will revert back to the previous values */
- (void)cancelButtonPressed {
    [self.baseCurrencyTextField resignFirstResponder];
    self.baseCurrencyTextField.text = oldBaseCurrency;
    self.desiredCurrencyTextField.text = oldDesiredCurrency;
}

/* live currency conversion */
- (void)textFieldDidChange:(UITextField *)textField {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    /* checks if text input is in fact a valid float value */
    if([numberFormatter numberFromString:textField.text]){
        float value = [numberFormatter numberFromString:textField.text].floatValue;
        
        self.desiredCurrencyTextField.text = [NSString stringWithFormat:@"%.02f", value * exchangeRateValue];
    }
    else {
        self.desiredCurrencyTextField.text = @"--";
    }
}

#pragma mark - TextField Delegate

/* ensures the length of the text input is at most 11 characters.
   need to come up with a better design solution for more than 11 characters.
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return newLength <= 11;
}

/* moves the conversion view as to not be covered by the keyboard */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.baseCurrencyTextField.textColor = [UIColor lightGrayColor];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.conversionView.center = CGPointMake(self.conversionView.center.x, self.conversionView.center.y * (3.0/4.0) );
    } completion:^(BOOL finished) {
        
    }];
}

/* Reverts the Conversion View back to the center */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.baseCurrencyTextField.textColor = [UIColor darkGrayColor];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.conversionView.center = CGPointMake(self.conversionView.center.x, self.conversionView.center.y * (4.0/3.0) );
    } completion:^(BOOL finished) {
        
    }];
}

@end
