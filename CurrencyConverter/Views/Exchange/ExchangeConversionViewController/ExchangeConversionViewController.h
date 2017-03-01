//
//  ExchangeConversionViewController.h
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/21/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeConversionViewController : UIViewController <UITextFieldDelegate>


/* UI Outlets */
@property (strong, nonatomic) UIView *conversionView;
@property (strong, nonatomic) UIView *separator;
@property (strong, nonatomic) UITextField *baseCurrencyTextField;
@property (strong, nonatomic) UITextField *desiredCurrencyTextField;
@property (strong, nonatomic) UILabel *baseCurrencyLabel;
@property (strong, nonatomic) UILabel *desiredCurrencyLabel;
@property (strong, nonatomic) UIImageView *baseFlagImageView;
@property (strong, nonatomic) UIImageView *desiredFlagImageView;
@property (strong, nonatomic) UIButton *backButton;

/* Variables */
@property (nonatomic, assign) NSString *baseCurrency;
@property (nonatomic, assign) NSString *desiredCurrency;
@property (nonatomic, assign) NSNumber *exchangeRate;


@end
