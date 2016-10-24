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

@interface SGWiFiUploadManager () {
    NSString *_tmpFileName;
    NSString *_tmpFilePath;
}

/*
 *  Callback Blocks
 */
@property (nonatomic, copy) SGWiFiUploadManagerFileUploadStartBlock startBlock;
@property (nonatomic, copy) SGWiFiUploadManagerFileUploadProgressBlock progressBlock;
@property (nonatomic, copy) SGWiFiUploadManagerFileUploadFinishBlock finishBlock;

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
    if (error == nil) {
        [self setupStart];
    }
    return error == nil;
}

- (BOOL)startHTTPServerAtPort:(UInt16)port start:(SGWiFiUploadManagerFileUploadStartBlock)start progress:(SGWiFiUploadManagerFileUploadProgressBlock)progress finish:(SGWiFiUploadManagerFileUploadFinishBlock)finish {
    self.startBlock = start;
    self.progressBlock = progress;
    self.finishBlock = finish;
    return [self startHTTPServerAtPort:port];
}

- (BOOL)isServerRunning {
    return self.httpServer.isRunning;
}

- (void)stopHTTPServer {
    [self.httpServer stop];
    [self setupStop];
}

- (void)showWiFiPageFrontViewController:(UIViewController *)viewController dismiss:(void (^)(void))dismiss {
    SGWiFiViewController *vc = [SGWiFiViewController new];
    vc.dismissBlock = dismiss;
    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

#pragma mark - Setup
- (void)setupStart {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadStart:) name:SGFileUploadDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadFinish:) name:SGFileUploadDidEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadProgress:) name:SGFileUploadProgressNotification object:nil];
}

- (void)setupStop {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.startBlock = nil;
    self.progressBlock = nil;
    self.finishBlock = nil;
}

#pragma mark - Notification Callback
- (void)fileUploadStart:(NSNotification *)nof {
    NSString *fileName = nof.object[@"fileName"];
    NSString *filePath = [self.savePath stringByAppendingPathComponent:fileName];
    _tmpFileName = fileName;
    _tmpFilePath = filePath;
    if (self.startBlock) {
        self.startBlock(fileName, filePath);
    }
}

- (void)fileUploadFinish:(NSNotification *)nof {
    if (self.finishBlock) {
        self.finishBlock(_tmpFileName, _tmpFilePath);
    }
}

- (void)fileUploadProgress:(NSNotification *)nof {
    CGFloat progress = [nof.object[@"progress"] doubleValue];
    if (self.progressBlock) {
        self.progressBlock(_tmpFileName, _tmpFilePath, progress);
    }
}

#pragma mark - Block Setter
- (void)setFileUploadStartCallback:(SGWiFiUploadManagerFileUploadStartBlock)callback {
    self.startBlock = callback;
}

- (void)setFileUploadProgressCallback:(SGWiFiUploadManagerFileUploadProgressBlock)callback {
    self.progressBlock = callback;
}

- (void)setFileUploadFinishCallback:(SGWiFiUploadManagerFileUploadFinishBlock)callback {
    self.finishBlock = callback;
}

- (void)dealloc {
    [self setupStop];
}
    
@end
