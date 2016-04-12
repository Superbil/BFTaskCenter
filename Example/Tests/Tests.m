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
    self.center = nil;
    [super tearDown];
}

- (void)testDefaultCenter
{
    XCTAssertNotNil(self.center, "This must have value");
}

- (void)testSetNotNilBlock
{
    id o = [self.center addTaskBlockToCallbacks:^void(BFTask * _Nonnull task) {
    } forKey:@"A"];
    XCTAssertNotNil(o, @"addTaskBlockToCallbacks return vale must have value.");
    [self.center removeTaskBlock:o forKey:@"A"];
}

- (void)testSend {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing sendToCallbacksWithKey"];

    id o = [self.center addTaskBlockToCallbacks:^void(BFTask * _Nonnull task) {
        [expectation fulfill];
    } forKey:@"B"];

    [self.center sendToCallbacksWithKey:@"B" result:nil];

    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self.center removeTaskBlock:o forKey:@"B"];
    }];
}

- (void)testSendTwo {
    XCTestExpectation *e1 = [self expectationWithDescription:@"Testing sendToCallbacksWithKey2_1"];
    XCTestExpectation *e2 = [self expectationWithDescription:@"Testing sendToCallbacksWithKey2_2"];

    id o1 = [self.center addTaskBlockToCallbacks:^void(BFTask * _Nonnull task) {
        [e1 fulfill];
    } forKey:@"C"];

    id o2 = [self.center addTaskBlockToCallbacks:^void(BFTask * _Nonnull task) {
        [e2 fulfill];
    } forKey:@"C"];

    [self.center sendToCallbacksWithKey:@"C" result:nil];

    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self.center removeTaskBlock:o1 forKey:@"C"];
        [self.center removeTaskBlock:o2 forKey:@"C"];
    }];
}

- (void)testSendResult {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing testSendResult"];
    NSString *key = NSStringFromSelector(_cmd);

    id o = [self.center addTaskBlockToCallbacks:^void(BFTask * _Nonnull task) {
        XCTAssertEqualObjects(task.result, @"689");
        [expectation fulfill];
    } forKey:key];

    [self.center sendToCallbacksWithKey:key result:@"689"];

    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self.center removeTaskBlock:o forKey:key];
    }];
}

- (void)testSendResultAndContinue {
    XCTestExpectation *e = [self expectationWithDescription:@"Testing testSendResultAndContinue"];
    NSString *key = NSStringFromSelector(_cmd);

    id o = [self.center addTaskBlockToCallbacks:^void(BFTask * _Nonnull task) {
        NSLog(@"first %@", task.result);

        [[task continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            NSLog(@"sec %@", task.result);
            XCTAssertTrue([task.result integerValue] == 42);
            return [BFTask taskWithResult:@"yooo"];
        }] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            XCTAssertTrue([task.result isEqualToString:@"yooo"]);
            [e fulfill];
            return nil;
        }];
    } forKey:key];

    [self.center sendToCallbacksWithKey:key result:@42];

    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        [self.center removeTaskBlock:o forKey:key];
    }];
}

@end

