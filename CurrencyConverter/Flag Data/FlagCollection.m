//
//  FlagCollection.m
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/22/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import "FlagCollection.h"

@implementation FlagCollection

@synthesize currencyToCountry;

- (instancetype)init {
    self = [super init];
    
    if(self) {
        
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"CountryToCurrency" ofType:@"json"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error;
        id allKeys = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        currencyToCountry = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [allKeys count]; i++) {
            NSDictionary *arrayResult = [allKeys objectAtIndex:i];
            //NSLog(@"country=%@",[arrayResult objectForKey:@"countryCode"]);
            
            NSString *countryCode = [arrayResult objectForKey:@"countryCode"];
            NSString *currencyCode = [arrayResult objectForKey:@"currencyCode"];
            
            currencyToCountry[currencyCode] = countryCode;
        }
        
        /* override US currency to US Flag */
        /* did not realize there are so many nations that use the USD */
        currencyToCountry[@"USD"] = @"US";
    }
    
    return self;
}

- (NSString *)imagePathForCurrencyCode:(NSString *) currencyCode {
    return [NSString stringWithFormat:@"%@.png", currencyToCountry[currencyCode]];
}

@end
