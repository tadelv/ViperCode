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
#import "VIPERPresenter.h"

@interface VIPERPresenterTests : XCTestCase

@property (nonatomic, strong) VIPERPresenter *presenter;
@property (nonatomic, strong) id mockInteractor;
@property (nonatomic, strong) id mockWireframe;
@property (nonatomic, strong) id mockView;

@end

@implementation VIPERPresenterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.presenter = [[VIPERPresenter alloc] init];

    self.mockInteractor = OCMProtocolMock(@protocol(VIPERInteractorInputProtocol));
    self.mockWireframe = OCMProtocolMock(@protocol(VIPERWireFrameProtocol));
    self.mockViewController = OCMProtocolMock(@protocol(VIPERViewProtocol));

    self.presenter.interactor = self.mockInteractor;
    self.presenter.router = self.mockWireframe;
    self.presenter.view = self.mockViewController;

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.

    self.presenter = nil;

    self.mockViewController = nil;
    self.mockWireframe = nil;
    self.mockInteractor = nil;

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
