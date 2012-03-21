//
//  NetworkMini.m
//  DeamonIphone
//
//  Created by zhangTing zhang on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkMini.h"

@implementation NetworkMini

@synthesize cityData, phoneCallController;

- (void)dealloc
{
    self.cityData = nil;
    self.phoneCallController = nil;
    [connection release]; connection = nil;
    [super dealloc];
}

- (id)init{
    self = [super init];
    if(self != nil){

    }
    return self;
}

- (void)showAlert:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"" , nil];
    [alert show];
    [alert release];
}

//处理接收到电话号码
- (void)locationPhoneNumber:(id)obj
{
    NSNotification *noti = (NSNotification*)obj;
    NSLog(@"noti:%@", noti);
    NSLog(@"phone number:%@", [[noti userInfo] valueForKey:@"number"]);
}

//修改默认的电话号码
- (void)modifyDefaultNumber:(MPIncomingPhoneCallController*)pc
{
    self.phoneCallController = pc;
//    [pc updateLCDWithName:@"中国..." label:@"xxxxxx" breakPoint:nil];
    [self searchRelatedCity:phoneCallController.incomingCallNumber];
}

//#define searchRelatedCityApi @"http://192.168.0.29:8003/webidoit/callSearch.do?to=callSearch&sjhm=%@"
#define pubApi @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx/getMobileCodeInfo?mobileCode=%@&userID="
- (void)searchRelatedCity:(NSString*)callerNumber
{
    self.cityData = nil;
    NSURL *url = nil;
#ifdef pubApi   
    url = [NSURL URLWithString:[NSString stringWithFormat:pubApi, callerNumber]];
#elif
    url = [NSURL URLWithString:[NSString stringWithFormat:searchRelatedCityApi, callerNumber]];    
#endif    
    if(connection != nil){
        [connection cancel];
        [connection release]; connection = nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy             
                                         timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        self.cityData = [[NSMutableData data] retain];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.cityData setLength:0];
    NSLog(@"didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.cityData appendData:data];
    NSLog(@"didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
#ifdef pubApi
    NSString *SIMCardInfo = [[[NSString alloc] initWithData:self.cityData encoding:NSUTF8StringEncoding] autorelease];
    SIMCardInfo = [SIMCardInfo substringWithRange:NSMakeRange(78, [SIMCardInfo length]-78-[@"</string>" length])];    
    [self showAlert:SIMCardInfo];    
    [phoneCallController updateLCDWithName:phoneCallController.callerName label:SIMCardInfo breakPoint:nil];
#else
    NXJsonParser* parser = [[NXJsonParser alloc] initWithData:self.cityData];
	id result = [parser parse:nil ignoreNulls:NO];
    NSDictionary *dic = (NSDictionary*)result;
    if ([dic objectForKey:@"retInfo"]) {
        NSDictionary *retInfo = [dic objectForKey:@"retInfo"];
        NSString *city = [retInfo objectForKey:@"dq"];
        if (city) {
            NSString *cityAndNumber = [NSString stringWithFormat:@"%@ %@", city, phoneCallController.incomingCallNumber];
            [phoneCallController updateLCDWithName:phoneCallController.callerName label:cityAndNumber breakPoint:nil];
        }
    }    
#endif    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlert:@"net error"];
    NSLog(@"search city faild!");
}
@end
