//
//  SGConst.h
//  SGWiFiUpload
//
//  Created by soulghost on 29/6/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface SGHTTPConnection : HTTPConnection  {
    MultipartFormDataParser* parser;
	NSFileHandle* storeFile;
	NSMutableArray*	uploadedFiles;
}

@end
