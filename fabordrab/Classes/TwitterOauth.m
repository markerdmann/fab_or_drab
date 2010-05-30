//
//  TwitterOauth.m
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TwitterOauth.h"
#import "AppHelpers.h"

@implementation TwitterOauth

+ (void)initialize {
  NSDictionary *headers = [NSDictionary dictionaryWithObject:@"application/x-www-form-urlencoded" 
                                                      forKey:@"Content-Type"];
  [self setHeaders:headers];
  [self setBaseURL:[NSURL URLWithString:@"http://twitter.com"]];
  [self setDelegate:self];
}

+ (void)postStatus:(NSString *)status 
      withUsername:(NSString *)username
          password:(NSString *)password
          delegate:(id)aDelegate {

  [self setBasicAuthWithUsername:username password:password];
  NSDictionary *body = [NSDictionary dictionaryWithObject:status forKey:@"status"];
  NSDictionary *opts = [NSDictionary dictionaryWithObject:body forKey:@"body"];
  [self postPath:@"/statuses/update.json" withOptions:opts object:aDelegate];
}

#pragma mark HRRequestOperation delegate methods

+ (void)restConnection:(NSURLConnection *)connection 
      didFailWithError:(NSError *)error 
                object:(id)object {
  // Handle connection errors.  Failures to connect to the server, etc.
	AlertWithErrorAndDelegate(error, nil);
}

+ (void)restConnection:(NSURLConnection *)connection 
       didReceiveError:(NSError *)error 
              response:(NSHTTPURLResponse *)response object:(id)object {
  // Handle invalid responses, 404, 500, etc.
	AlertWithErrorAndDelegate(error, nil);
}

+ (void)restConnection:(NSURLConnection *)connection 
  didReceiveParseError:(NSError *)error 
          responseBody:(NSString *)string {
  // Request was successful, but couldn't parse the data returned by the server. 
	AlertWithErrorAndDelegate(error, nil);
}

// Fires off method in delegate: receivedNewsItems:
+ (void)restConnection:(NSURLConnection *)connection 
     didReturnResource:(id)resource 
                object:(id)anObject {
  if ([anObject respondsToSelector:@selector(statusUpdateComplete)]) {
    [anObject statusUpdateComplete];
  }
}

@end
