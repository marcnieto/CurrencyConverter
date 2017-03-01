//
//  ExchangeSelectionTableViewCell.h
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/21/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeSelectionTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *flagImageView;
@property (strong, nonatomic) UILabel *countryLabel;
@property (strong, nonatomic) UILabel *exchangeRateLabel;

- (void)textForCountryLabel:(NSString *)text;
- (void)textForExchangeRateLabel:(NSString *)text;
- (void)imagePathForFlag:(NSString *)path;

@end
