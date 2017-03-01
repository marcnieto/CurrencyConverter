//
//  CCSessionManager.h
//  CurrencyConverter
//
//  Created by Marc Nieto on 2/22/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CCSessionManager : AFHTTPSessionManager

+ (CCSessionManager *)sharedManager;

- (void)getExchangeForBaseCurrency:(NSString *)baseCurrency
                           success:(void (^)(NSDictionary *response))success
                           failure:(void (^)(NSError *error))failure;

@end
