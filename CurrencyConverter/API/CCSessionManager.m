//
//  CCSessionManager.m
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/22/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import "CCSessionManager.h"

static NSString *kApiUrl = @"https://api.fixer.io/";

@implementation CCSessionManager

+ (CCSessionManager *)sharedManager
{
    // Clear the existing object, if any
    static CCSessionManager *sharedManager = nil;
    
    sharedManager = [[CCSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kApiUrl]];

    return sharedManager;
}

- (void)getExchangeForBaseCurrency:(NSString *)baseCurrency
                           success:(void (^)(NSDictionary *response))success
                           failure:(void (^)(NSError *error))failure {

    NSString *commandString = [NSString stringWithFormat:@"/latest?base=%@", baseCurrency];
    
    [self GET:commandString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        success(responseObject);
    
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}



@end
