//
//  PMODataDownloader.m
//  Parallels-test
//
//  Created by Peter Molnar on 06/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMODataDownloaderWithNotifications.h"
#import "PMOURLSessionDefaults.h"

@interface PMODataDownloaderWithNotifications()
- (NSDictionary *)userInforForErrorNotification:(NSError *)error;
@property (copy, nonatomic) NSString *drawID;
@end

@implementation PMODataDownloaderWithNotifications

#pragma mark - Init
- (instancetype)initWithDrawID:(NSString *)drawID {
    
    self = [super init];
    
    if (self && drawID ) {
        self.drawID = drawID;
        
    }
    
    return self;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Not designated initializer"
                                   reason:@"Use [[PMODataDownloader. alloc] initWithDrawID:]"
                                 userInfo:nil];
    return nil;
}


#pragma mark - Main function
- (void)downloadDataFromURL:(NSURL *)sourceURL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sourceURL];
    
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request completionHandler:
                                          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              if (error) {
                                                  [self notifyObserverWithError:error];
                                              } else {
                                                  [self notifyObserverWithProcessedData:data];
                                              }
                                          }];
    [downloadTask resume];
    
}

#pragma mark - Accessors
- (NSURLSession *)session {
    
    // Session can be injected, but if not initialized a default config is provided.
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfiguration setTimeoutIntervalForRequest:PMODownloaderRequestTimeout];
        [sessionConfiguration setTimeoutIntervalForResource:PMODownloaderResourceTimeout];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:nil
                                            delegateQueue:nil];
        
    }
    
    return _session;
}

#pragma mark - Notifications
- (void)notifyObserverWithProcessedData:(NSData *)data {
    NSDictionary *userInfo = @{@"data" : data,
                               @"drawID" : self.drawID};
    [[NSNotificationCenter defaultCenter] postNotificationName:PMODataDownloaderDidDownloadEnded
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - Customizable for userInfo in case of error
- (NSDictionary *)userInforForErrorNotification:(NSError *)error {
    NSDictionary *userInfo = @{@"error" : error };
    return userInfo;
}

- (void)notifyObserverWithError:(NSError *)error {
    NSDictionary *userInfo = [self userInforForErrorNotification:error];
    [[NSNotificationCenter defaultCenter] postNotificationName:PMODataDownloaderError
                                                        object:self
                                                      userInfo:userInfo];
}
@end