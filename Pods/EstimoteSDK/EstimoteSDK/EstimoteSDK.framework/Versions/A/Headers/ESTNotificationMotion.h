//
//   ______     _   _                 _          _____ _____  _  __
//  |  ____|   | | (_)               | |        / ____|  __ \| |/ /
//  | |__   ___| |_ _ _ __ ___   ___ | |_ ___  | (___ | |  | | ' /
//  |  __| / __| __| | '_ ` _ \ / _ \| __/ _ \  \___ \| |  | |  <
//  | |____\__ \ |_| | | | | | | (_) | ||  __/  ____) | |__| | . \
//  |______|___/\__|_|_| |_| |_|\___/ \__\___| |_____/|_____/|_|\_\
//
//
//  Copyright © 2016 Estimote. All rights reserved.

#import <Foundation/Foundation.h>
#import "ESTDeviceNotificationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ESTNotificationMotionBlock)(BOOL inMotion);


/**
 *  ESTNotificationMotion
 */
@interface ESTNotificationMotion : NSObject <ESTDeviceNotificationProtocol, NSCopying>

- (instancetype)initWithHandlerBlock:(ESTNotificationMotionBlock)handler;

@end

NS_ASSUME_NONNULL_END
