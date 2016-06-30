//
//  ViewController.m
//  SGWiFiUploadDemo
//
//  Created by soulghost on 29/6/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "ViewController.h"
#import "SGWiFiUploadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupServer];
    [[SGWiFiUploadManager sharedManager] showWiFiPageFrontViewController:self];
}

- (void)setupServer {
    SGWiFiUploadManager *mgr = [SGWiFiUploadManager sharedManager];
    BOOL success = [mgr startHTTPServerAtPort:10086];
    if (success) {
        NSLog(@"URL = %@:%@",mgr.ip,@(mgr.port));
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadStart:) name:SGFileUploadDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadFinish:) name:SGFileUploadDidEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadProgress:) name:SGFileUploadProgressNotification object:nil];
}

#pragma mark Notification Callback
- (void)fileUploadStart:(NSNotification *)nof {
    NSString *fileName = nof.object[@"fileName"];
    NSLog(@"Start Upload <%@>",fileName);
}

- (void)fileUploadFinish:(NSNotification *)nof {
    NSLog(@"File Upload Finished.");
}

- (void)fileUploadProgress:(NSNotification *)nof {
    CGFloat progress = [nof.object[@"progress"] doubleValue];
    NSLog(@"%.2f",progress);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
