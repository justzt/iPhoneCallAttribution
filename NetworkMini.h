//
//  NetworkMini.h
//  DeamonIphone
//
//  Created by zhangTing zhang on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPIncomingPhoneCallController.h"
#import "NXJsonParser.h"

@interface NetworkMini : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *cityData;
    NSURLConnection *connection;
    MPIncomingPhoneCallController *phoneCallController;
}
@property (retain, nonatomic) MPIncomingPhoneCallController *phoneCallController;
@property (retain, nonatomic) NSMutableData *cityData;

- (void)locationPhoneNumber:(NSNotificationCenter*)noti;
- (void)modifyDefaultNumber:(MPIncomingPhoneCallController*)pc;
- (void)searchRelatedCity:(NSString*)callerNumber;
@end
