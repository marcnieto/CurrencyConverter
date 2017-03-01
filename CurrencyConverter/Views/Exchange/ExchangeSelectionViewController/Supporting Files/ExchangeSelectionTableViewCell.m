//
//  ExchangeSelectionTableViewCell.m
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/21/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import "ExchangeSelectionTableViewCell.h"

/* UI Size Constants */
static const CGFloat kPadding = 10.0;

@implementation ExchangeSelectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.countryLabel = [[UILabel alloc] init];
        self.countryLabel.textColor = [UIColor blackColor];
        self.countryLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20.0f];
        
        [self addSubview:self.countryLabel];
        
        self.exchangeRateLabel = [[UILabel alloc] init];
        self.exchangeRateLabel.textColor = [UIColor grayColor];
        self.exchangeRateLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20.0f];
        
        [self addSubview:self.exchangeRateLabel];
        
        self.flagImageView = [[UIImageView alloc] init];
        [self addSubview:self.flagImageView];
    }
    
    return self;
}

- (void)imagePathForFlag:(NSString *)path {
    CGFloat lengthOfSide = self.frame.size.height / 2.0;
    
    [self.flagImageView setFrame:CGRectMake(kPadding, self.flagImageView.frame.origin.y, lengthOfSide, lengthOfSide)];
    self.flagImageView.center = CGPointMake(self.flagImageView.center.x, self.frame.size.height / 2.0);
    
    UIImage *image = [UIImage imageNamed:path];
    self.flagImageView.image = image;
}

- (void)textForCountryLabel:(NSString *)text {
    self.countryLabel.text = text;
    [self.countryLabel sizeToFit];
    
    [self.countryLabel setFrame:CGRectMake((2*kPadding) + (self.frame.size.height / 2.0), self.countryLabel.frame.origin.y, self.countryLabel.frame.size.width, self.countryLabel.frame.size.height)];
    self.countryLabel.center = CGPointMake(self.countryLabel.center.x, self.frame.size.height / 2.0);
}

- (void)textForExchangeRateLabel:(NSString *)text {
    self.exchangeRateLabel.text = text;
    [self.exchangeRateLabel sizeToFit];
    
    [self.exchangeRateLabel setFrame:CGRectMake(self.frame.size.width - self.exchangeRateLabel.frame.size.width - kPadding, self.exchangeRateLabel.frame.origin.y, self.exchangeRateLabel.frame.size.width, self.exchangeRateLabel.frame.size.height)];
    self.exchangeRateLabel.center = CGPointMake(self.exchangeRateLabel.center.x, self.frame.size.height / 2.0);
}

@end
