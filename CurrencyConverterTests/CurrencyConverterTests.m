//
//  CurrencyConverterTests.m
//  CurrencyConverterTests
//
//  Created by Marc Nieto on 2/28/17.
//  Copyright © 2017 KandidProductions. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ExchangeConversionViewController.h"

@interface CurrencyConverterTests : XCTestCase
    @property (nonatomic) ExchangeConversionViewController *ecVC;
@end

@implementation CurrencyConverterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.ecVC = [[ExchangeConversionViewController alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testConversionViewDidLoad {
    [self.ecVC viewDidLoad];
    XCTAssertTrue([self.ecVC.baseCurrencyTextField.text isEqualToString:@"1.00"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
