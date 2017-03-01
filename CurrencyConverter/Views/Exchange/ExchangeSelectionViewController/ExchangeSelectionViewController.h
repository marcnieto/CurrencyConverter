//
//  ExchangeSelectionViewController.h
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/21/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeSelectionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

/* UI Outlets */
@property (strong, nonatomic) UIView *topPanel;
@property (strong, nonatomic) UIView *baseCurrencyView;
@property (strong, nonatomic) UIImageView *baseFlagImageView;
@property (strong, nonatomic) UITextField *baseCurrencyTextField;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

/* Variables */
@property (strong, nonatomic) NSDictionary *exchanges;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSMutableString *currentBaseCountry;

@end
