//
//  BFTaskCenter.h
//  Pods
//
//  Created by Superbil on 2015/8/22.
//
//

#import <Bolts/Bolts.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFTaskCenter : NSObject

/*!
 A block that can act as a continuation for a task.
 */
typedef void (^BFTaskCenterBlock)(BFTask * _Nonnull task);

+ (nullable instancetype)defaultCenter;

- (nullable instancetype)initWithExecutor:(nonnull BFExecutor *)executor;

- (nullable id)addTaskBlockToCallbacks:(nonnull BFTaskCenterBlock)taskBlock forKey:(nonnull NSString *)key;
- (void)removeTaskBlock:(nonnull id)taskBlock forKey:(nonnull NSString *)key;
- (void)clearAllCallbacksForKey:(nonnull NSString *)key;

- (void)sendToCallbacksWithKey:(nonnull NSString *)key result:(nullable id)result;
- (void)sendToCallbacksWithKey:(nonnull NSString *)key error:(nonnull NSError *)error;

- (nullable BFTaskCompletionSource *)sourceOfSendToCallbacksForKey:(nonnull NSString *)key
                                                          executor:(nonnull BFExecutor *)executor
                                                 cancellationToken:(nullable BFCancellationToken *)cancellationToken;

@end

NS_ASSUME_NONNULL_END
