//
//  ABI33_0_0RNBranchEventEmitter.m
//  Pods
//
//  Created by Jimmy Dee on 4/6/17.
//
//

#import <ReactABI33_0_0/ABI33_0_0RCTLog.h>

#import "ABI33_0_0RNBranch.h"
#import "ABI33_0_0RNBranchEventEmitter.h"

// Notification/Event Names
NSString * const ABI33_0_0RNBranchInitSessionSuccess = @"ABI33_0_0RNBranch.initSessionSuccess";
NSString * const ABI33_0_0RNBranchInitSessionError = @"ABI33_0_0RNBranch.initSessionError";

@interface ABI33_0_0RNBranchEventEmitter()
@property (nonatomic) BOOL hasListeners;
@end

@implementation ABI33_0_0RNBranchEventEmitter

ABI33_0_0RCT_EXPORT_MODULE();

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hasListeners = NO;
    }
    return self;
}
    
+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[ABI33_0_0RNBranchInitSessionSuccess,
             ABI33_0_0RNBranchInitSessionError
             ];
}

- (void)startObserving {
    self.hasListeners = YES;
    for (NSString *event in [self supportedEvents]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:event
                                                   object:nil];
    }
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.hasListeners = NO;
}

# pragma mark - Public

+ (void)initSessionDidSucceedWithPayload:(NSDictionary *)payload
{
    [self postNotificationName:ABI33_0_0RNBranchInitSessionSuccess withPayload:payload];
}

+ (void)initSessionDidEncounterErrorWithPayload:(NSDictionary *)payload
{
    [self postNotificationName:ABI33_0_0RNBranchInitSessionError withPayload:payload];
}

# pragma mark - Private

+ (void)postNotificationName:(NSString *)name withPayload:(NSDictionary<NSString *, id> *)payload {
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:payload];
}

- (void)handleNotification:(NSNotification *)notification {
    if (!self.hasListeners) return;
    [self sendEventWithName:notification.name body:notification.userInfo];
}

@end
