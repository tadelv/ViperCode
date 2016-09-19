//
//  ___FILENAME___.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VIPERProtocols.h"
#import "VIPERInteractor.h"

@interface VIPERInteractorTests : XCTestCase

@property (nonatomic, strong) VIPERInteractor *interactor;
@property (nonatomic, strong) id mockOutput;

@end

@implementation VIPERInteractorTests

- (void)setUp {
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.interactor = [[VIPERInteractor alloc] init];

    self.mockOutput = OCMProtocolMock(@protocol(VIPERInteractorInputProtocol));

    self.interactor.presenter = self.mockOutput;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.interactor = nil;

    self.mockOutput = nil;

    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
