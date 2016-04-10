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

+ (instancetype)defaultCenter;

- (id)addTaskBlockToCallbacks:(BFContinuationBlock)taskBlock forKey:(NSString *)key;
- (void)removeTaskBlock:(id)taskBlock forKey:(NSString *)key;
- (void)clearAllCallbacksForKey:(NSString *)key;

- (void)sendToCallbacksWithKey:(NSString *)key result:(id)result;
- (void)sendToCallbacksWithKey:(NSString *)key error:(NSError *)error;

@end
