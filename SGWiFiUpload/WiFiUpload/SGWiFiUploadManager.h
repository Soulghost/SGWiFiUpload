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

typedef void (^SGWiFiUploadManagerFileUploadStartBlock)(NSString *fileName, NSString *savePath);
typedef void (^SGWiFiUploadManagerFileUploadProgressBlock)(NSString *fileName, NSString *savePath, CGFloat progress);
typedef void (^SGWiFiUploadManagerFileUploadFinishBlock)(NSString *fileName, NSString *savePath);

@interface SGWiFiUploadManager : NSObject

@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic, copy) NSString *savePath;
@property (nonatomic, copy) NSString *webPath;

+ (instancetype)sharedManager;
+ (NSString *)ip;

- (BOOL)startHTTPServerAtPort:(UInt16)port;
- (BOOL)startHTTPServerAtPort:(UInt16)port start:(SGWiFiUploadManagerFileUploadStartBlock)start progress:(SGWiFiUploadManagerFileUploadProgressBlock)progress finish:(SGWiFiUploadManagerFileUploadFinishBlock)finish;
- (BOOL)isServerRunning;
- (void)stopHTTPServer;
- (NSString *)ip;
- (UInt16)port;
- (void)showWiFiPageFrontViewController:(UIViewController *)viewController dismiss:(void (^)(void))dismiss;

- (void)setFileUploadStartCallback:(SGWiFiUploadManagerFileUploadStartBlock)callback;
- (void)setFileUploadProgressCallback:(SGWiFiUploadManagerFileUploadProgressBlock)callback;
- (void)setFileUploadFinishCallback:(SGWiFiUploadManagerFileUploadFinishBlock)callback;
    
@end
