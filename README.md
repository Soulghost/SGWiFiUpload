# SGWifiUpload

SGWiFiUpload is a tool for iOS to upload files through WiFi. By using this framework, you can upload files easily. It can be used for many locations, such as photos and videos upload.

## How To GET Started
- [Download SGWiFiUpload](https://github.com/Soulghost/SGWiFiUpload/archive/master.zip) and try out the included iPhone example app.

## Installation
Drag the `SGWiFiUpload` folder to your project.

## Usage
### Import header
```objective-c
#import "SGWiFiUploadManager.h"
```

### Start server and add observer to process
```objective-c
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
```

### Display an WiFi Page
You can use the default WiFi Page to tell users how and where to use it.
```objective-c
[[SGWiFiUploadManager sharedManager] showWiFiPageFrontViewController:self];
```
