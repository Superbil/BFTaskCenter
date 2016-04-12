//
//  BFTaskCenter.m
//  Pods
//
//  Created by Superbil on 2015/8/22.
//
//

#import "BFTaskCenter.h"

@interface BFTaskCenter ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *callbacks;
@property (nonatomic, strong) BFExecutor *executor;
@end

@implementation BFTaskCenter

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken;
    static BFTaskCenter *staticCenter;
    dispatch_once(&onceToken, ^{
        staticCenter = [[BFTaskCenter alloc] init];
    });
    return staticCenter;
}

- (instancetype)init {
    if (self = [super init]) {
        _callbacks = [[NSMutableDictionary alloc] init];
        _executor = [BFExecutor defaultExecutor];
    }
    return self;
}

- (instancetype)initWithExecutor:(BFExecutor *)executor {
    if (self = [super init]) {
        _callbacks = [[NSMutableDictionary alloc] init];
        _executor = executor;
    }
    return self;
}

- (void)dealloc {
    [self.callbacks removeAllObjects];
}

- (id)addTaskBlockToCallbacks:(BFTaskCenterBlock)taskBlock forKey:(NSString *)key {
    if (key.length == 0) {
        return nil;
    }
    NSMutableArray<BFTaskCenterBlock> *callbacksOfKey = self.callbacks[key];
    if (!callbacksOfKey) {
        callbacksOfKey = [[NSMutableArray alloc] init];
        self.callbacks[key] = callbacksOfKey;
    }
    id copyBlock = [taskBlock copy];
    if ([callbacksOfKey isKindOfClass:[NSMutableArray class]]) {
        [callbacksOfKey addObject:copyBlock];
    } else if ([callbacksOfKey isKindOfClass:[NSArray class]]) {
        NSMutableArray<BFTaskCenterBlock> *newCallbacks = [NSMutableArray arrayWithArray:callbacksOfKey];
        [newCallbacks addObject:copyBlock];
    }
    return copyBlock;
}

- (void)removeTaskBlock:(id)taskBlock forKey:(NSString *)key {
    if (self.callbacks[key]) {
        NSMutableArray<BFTaskCenterBlock> *callbacksOfKey = self.callbacks[key];
        if ([callbacksOfKey containsObject:taskBlock]) {
            [callbacksOfKey removeObject:taskBlock];
        }
    }
}

- (void)clearAllCallbacksForKey:(NSString *)key {
    if (key.length == 0) {
        return;
    }
    if (self.callbacks[key]) {
        [self.callbacks[key] removeAllObjects];
    }
}

- (BFTaskCompletionSource *)sourceOfSendToCallbacksForKey:(NSString *)key executor:(BFExecutor *)executor cancellationToken:(BFCancellationToken *)cancellationToken {
    if (key.length == 0) {
        return nil;
    }
    BFTaskCompletionSource *s = [BFTaskCompletionSource taskCompletionSource];
    for (BFTaskCenterBlock block in self.callbacks[key]) {
        [s.task continueWithExecutor:executor block:^id _Nullable(BFTask * _Nonnull task) {
            block(task);
            return nil;
        } cancellationToken:cancellationToken];
    }
    return s;
}

- (void)sendToCallbacksWithKey:(NSString *)key result:(id)result {
    if (key.length == 0) {
        return;
    }
    [[self sourceOfSendToCallbacksForKey:key executor:self.executor cancellationToken:nil] setResult:result];
}

- (void)sendToCallbacksWithKey:(NSString *)key error:(NSError *)error {
    if (key.length == 0) {
        return;
    }
    [[self sourceOfSendToCallbacksForKey:key executor:self.executor cancellationToken:nil] setError:error];
}

@end
