// AFAppDotNetAPIClient.h
//
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Aria2AppClient.h"

//static NSString * const Aria2AppBaseURLString = @"http://192.168.1.1:6800/";
static NSString * const defaultIP = @"192.168.1.1";

@interface Aria2AppClient ()

@property (nonatomic)NSURL *url;
@property (nonatomic)NSURL *defaultBaseURL;

@end

@implementation Aria2AppClient

+ (instancetype)sharedClient {
    static Aria2AppClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [Aria2AppClient baseURLWithUserDefaults];
        
        _sharedClient = [[Aria2AppClient alloc] initWithBaseURL:baseURL];
        _sharedClient.defaultBaseURL = baseURL;
        
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer =[AFJSONResponseSerializer serializer];
        
        NSSet *acceptableContentTypes = _sharedClient.responseSerializer.acceptableContentTypes;
        _sharedClient.responseSerializer.acceptableContentTypes = [acceptableContentTypes setByAddingObject:@"application/json-rpc"];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:_sharedClient selector:@selector(ipDidChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    });
    
    return _sharedClient;
}

+ (NSURL *)baseURLWithUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ip = [userDefaults stringForKey:@"routerIP"];
    NSString *baseURL = [NSString stringWithFormat:@"http://%@:6800/", ip? ip : defaultIP];
    return [NSURL URLWithString:baseURL];
}

- (NSURL *)baseURL {
    return self.url? self.url : self.defaultBaseURL;
}

- (void)ipDidChanged {
    self.url = [Aria2AppClient baseURLWithUserDefaults];
}

@end
