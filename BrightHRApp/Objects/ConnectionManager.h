//
//  ConnectionManager.h
//  BrightHRApp
//
//  Created by David Andrew Birkhead on 10/11/2017.
//  Copyright © 2017 David Birkhead. All rights reserved.
//

@interface ConnectionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>


@property NSURLSessionConfiguration *config;
@property NSURLSession *session;

@property NSInteger statusCheckInt;

- (void)connectAndPostLogin:(NSString*)user :(NSString*)pass;

@end
