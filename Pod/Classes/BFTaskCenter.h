//
//  BFTaskCenter.h
//  Pods
//
//  Created by Superbil on 2015/8/22.
//
//

#import <Foundation/Foundation.h>
#import "Bolts.h"

@interface BFTaskCenter : NSObject

+ (nonnull instancetype)defaultCenter;

- (nullable id)addTaskBlockToCallbacks:(nonnull BFContinuationBlock)taskBlock forKey:(nonnull NSString *)key;
- (void)removeTaskBlock:(nonnull id)taskBlock forKey:(nonnull NSString *)key;
- (void)clearAllCallbacksForKey:(nonnull NSString *)key;

- (void)sendToCallbacksWithKey:(nonnull NSString *)key result:(nullable id)result;
- (void)sendToCallbacksWithKey:(nonnull NSString *)key error:(nonnull NSError *)error;

- (nonnull BFTaskCompletionSource *)sourceOfSendToCallbacksForKey:(nonnull NSString *)key
                                                         executor:(nonnull BFExecutor *)executor
                                                cancellationToken:(nullable BFCancellationToken *)cancellationToken;

@end
