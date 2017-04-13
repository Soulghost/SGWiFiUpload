# SGWiFiUpload

SGWiFiUpload is a tool based on [CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer) for iOS to upload files through WiFi. By using this framework, you can upload files easily. It can be used for many locations, such as photos and videos upload.Files will save to Caches by default.

## How To Get Started
- [Download SGWiFiUpload](https://github.com/Soulghost/SGWiFiUpload/archive/master.zip) and try out the included iPhone example app.

## Installation
Drag the `SGWiFiUpload` folder to your project.

## Usage
### Import header

```objc
#import "SGWiFiUploadManager.h"
```

### Start server and add observer to process

```objc
- (void)setupServer {
    SGWiFiUploadManager *mgr = [SGWiFiUploadManager sharedManager];
    BOOL success = [mgr startHTTPServerAtPort:10086];
    if (success) {
        [mgr setFileUploadStartCallback:^(NSString *fileName, NSString *savePath) {
            NSLog(@"File %@ Upload Start", fileName);
        }];
        [mgr setFileUploadProgressCallback:^(NSString *fileName, NSString *savePath, CGFloat progress) {
            NSLog(@"File %@ on progress %f", fileName, progress);
        }];
        [mgr setFileUploadFinishCallback:^(NSString *fileName, NSString *savePath) {
            NSLog(@"File Upload Finish %@ at %@", fileName, savePath);
        }];
    }
    [mgr showWiFiPageFrontViewController:self dismiss:^{
        [mgr stopHTTPServer];
    }];
}
```

### Display a WiFi Page on Device
You can use the default WiFi Page to tell users how and where to use it.
<p>
<img src="https://raw.githubusercontent.com/Soulghost/SGWiFiUpload/master/Images/WiFiPhonePage.png" width = "300" height = "533" alt="WiFi Page" align=center />
</p>

```objc
SGWiFiUploadManager *mgr = [SGWiFiUploadManager sharedManager];
[mgr showWiFiPageFrontViewController:self dismiss:^{
    [mgr stopHTTPServer];
}];
```

### Custom Settings
#### Save Path
You can change the file save location by change the value of `savePath` in `SGWiFiUploadManager`.
#### Web Root
You can change the file save location by change the value of `webRoot` in `SGWiFiUploadManager`, the server will search `index.html` and `upload.html` in this path.
#### The count of files to upload
You can change the count of files to upload by modify the `index.html` in `Web` Folder.
You can add `input` tag with `type="file"` in the `form` whose action is `upload.html` and method is `POST`.
