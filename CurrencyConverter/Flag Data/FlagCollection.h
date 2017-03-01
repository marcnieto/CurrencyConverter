//
//  FlagCollection.h
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/22/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlagCollection : NSObject

@property (strong, nonatomic) NSMutableDictionary *currencyToCountry;

- (instancetype)init;
- (NSString *)imagePathForCurrencyCode:(NSString *) currencyCode;

@end
