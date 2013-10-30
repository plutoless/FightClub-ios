//
//  BaseHttpOperation.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/28/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "BaseHttpOperation.h"
#import "ServicesManager.h"
#import "SecManager.h"
#import "FcConstant.h"

@implementation BaseHttpOperation

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.data = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (id) initWithObject:(id)object target:(SEL)target
{
    self = [self init];
    if (self != nil) {
        self.target = target;
        self.object = object;
    }
    
    return self;
}

- (id) initWithObject:(id)object target:(SEL)target type:(FcServiceType)type
{
    self = [self init];
    if (self != nil) {
        self.target = target;
        self.object = object;
        self.type = type;
    }
    
    return self;
}

- (id) initWithObject:(id)object target:(SEL)target param:(OperationParams*)param
{
    self = [self init];
    if (self != nil) {
        self.target = target;
        self.object = object;
    }
    
    return self;
}

- (void) main
{
    NSString* urlString = [ServicesManager getServiceURLById:self.type];
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    if (requestURL != nil) {
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60];
        [request setHTTPMethod:@"GET"];
        
        NSArray* cookies = [[[SecManager getInstance] secAttributes] valueForKey:SEC_ATTR_SESSION];
        
        for (NSHTTPCookie* cookie in cookies) {
            [request addValue:[cookie value] forHTTPHeaderField:@"Cookies"];
        }
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}


#pragma NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    
//    NSString* dataStr = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", dataStr);
    
    if (self.target != nil) {
        [self.object performSelector:self.target withObject:jsonData];
    }
}


@end
