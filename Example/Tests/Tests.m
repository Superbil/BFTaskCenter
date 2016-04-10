//
//  BFTaskCenterTests.m
//  BFTaskCenterTests
//
//  Created by Superbil on 04/11/2016.
//  Copyright (c) 2016 Superbil. All rights reserved.
//

@import XCTest;

#import "BFTaskCenter.h"

@interface Tests : XCTestCase
@property (nonatomic, strong) BFTaskCenter *center;
@end

@implementation Tests

- (void)setUp
{
    [super setUp];

    self.center = [BFTaskCenter defaultCenter];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end

