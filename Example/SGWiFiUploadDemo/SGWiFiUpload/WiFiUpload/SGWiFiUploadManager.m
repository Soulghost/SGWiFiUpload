//
//  SGWiFiUploadManager.m
//  SGWiFiUpload
//
//  Created by soulghost on 29/6/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGWiFiUploadManager.h"
#import "HYBIPHelper.h"
#import "SGHTTPConnection.h"
#import "SGWiFiViewController.h"

@interface SGWiFiUploadManager ()

@end

@implementation SGWiFiUploadManager

+ (instancetype)sharedManager {
    static SGWiFiUploadManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSString *)ip {
    return [HYBIPHelper deviceIPAdress];
}

- (NSString *)ip {
    return [HYBIPHelper deviceIPAdress];
}

- (UInt16)port {
    return self.httpServer.port;
}

- (instancetype)init {
    if (self = [super init]) {
        self.webPath = [[NSBundle mainBundle] resourcePath];
        self.savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    return self;
}

- (BOOL)startHTTPServerAtPort:(UInt16)port {
    HTTPServer *server = [HTTPServer new];
    server.port = port;
    self.httpServer = server;
    [self.httpServer setDocumentRoot:self.webPath];
    [self.httpServer setConnectionClass:[SGHTTPConnection class]];
    NSError *error = nil;
    [self.httpServer start:&error];
    return error == nil;
}

- (BOOL)isServerRunning {
    return self.httpServer.isRunning;
}

- (void)stopHTTPServer {
    [self.httpServer stop];
}

- (void)showWiFiPageFrontViewController:(UIViewController *)viewController {
    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[SGWiFiViewController new]] animated:YES completion:nil];
}
    
@end
