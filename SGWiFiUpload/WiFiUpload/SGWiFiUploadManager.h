//
//  SGWiFiUploadManager.h
//  SGWiFiUpload
//
//  Created by soulghost on 29/6/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGConst.h"
#import "HTTPServer.h"

@interface SGWiFiUploadManager : NSObject

@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic, copy) NSString *savePath;
@property (nonatomic, copy) NSString *webPath;

+ (instancetype)sharedManager;
+ (NSString *)ip;

- (BOOL)startHTTPServerAtPort:(UInt16)port;
- (BOOL)isServerRunning;
- (void)stopHTTPServer;
- (NSString *)ip;
- (UInt16)port;
- (void)showWiFiPageFrontViewController:(UIViewController *)viewController;
    
@end
