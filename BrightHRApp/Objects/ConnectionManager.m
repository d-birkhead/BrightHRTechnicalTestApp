//
//  ConnectionManager.m
//  BrightHRApp
//
//  Created by David Andrew Birkhead on 10/11/2017.
//  Copyright © 2017 David Birkhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"

@interface ConnectionManager(){
    NSMutableData *receivedData;
}

@end

@implementation ConnectionManager

- (id)init{
    if (self) {
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration: _config delegate:self delegateQueue:nil];
    }
    
    return self;
}


- (void)connectAndPostLogin:(NSString *)user :(NSString *)pass{
    NSString *url = @"https://brighthr-api-uat.azurewebsites.net/api/Account/PostValidateUser";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]];
    
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *dataString = [NSString stringWithFormat:@"username=%@&password=%@",user, pass];
    
    NSData *requestBody = [dataString dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    NSURLSessionDataTask *postCredentials = [_session dataTaskWithRequest:request];
    [postCredentials resume];
}

- ( NSURLSession * )getURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
                  ^{
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      session = [NSURLSession sessionWithConfiguration:configuration];
                  } );
    
    return session;
}

#pragma mark - datasession delegate methods
// Response handling delegates
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSLog(@"Response %@", response);
    receivedData=nil; receivedData=[[NSMutableData alloc] init];
    [receivedData setLength:0];
    // Handler allows us to receive and parse responses from the server
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    // Parse the JSON that came in into an NSDictionary
    NSError * err = nil;
    NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    
    if (!err){ // if no error occurred, parse the array of objects as normal
        // Parse the JSON dictionary 'jsonDict' here
        
        NSLog(@"JSON Dict: %@", jsonDict);
    }
    else{ // an error occurred so we need to let the user know
        NSLog(@"error: %@", err);
    }
}

// Error handling delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error == nil){
        // Download from API was successful
        NSLog(@"Data Network Request Did Complete Successfully.");
    }
    else{
        // Describes and logs the error preventing us from receiving a response
        NSLog(@"Error: %@", [error userInfo]);
        
        // Handle network error, letting the user know what happened.
    }
}

@end
