//
//  LoginOperation.m
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#import "LoginOperation.h"
#import "ServicesManager.h"
#import "SecManager.h"
#import "FcConstant.h"

@implementation LoginOperation

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

- (void) main
{
    NSString* baseUrlString = [[[ServicesManager getInstance] services] valueForKey:SERVICE_MACRO_LOGIN];
    NSMutableDictionary* credential = [[SecManager getInstance] secAttributes];
    NSString* urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@", baseUrlString, [credential valueForKey:SEC_ATTR_TEMP_USER], [credential valueForKey:SEC_ATTR_TEMP_PASS]];
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    if (requestURL != nil) {
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:20];
        [request setHTTPMethod:@"GET"];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}


#pragma NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary* headers = [((NSHTTPURLResponse*)response) allHeaderFields];
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[response URL]];
    if ([cookies count] > 0) {
        [[[SecManager getInstance] secAttributes] setValue:cookies forKey:SEC_ATTR_SESSION];
//        NSData* cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:SEC_ATTR_SESSION];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


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
    
    
    
    if (self.target != nil) {
        [self.object performSelector:self.target withObject:jsonData];
    }
}

@end
