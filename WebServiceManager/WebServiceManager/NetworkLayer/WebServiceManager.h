//
//  WebServiceManager.h
//  WebServiceManager
//
//  Created by Malik Wahaj Ahmed on 08/04/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WebServiceManager : AFHTTPSessionManager

+ (WebServiceManager *)sharedClient;
    
-(void)getRequest:(NSString*)urlString
       parameters:(NSDictionary*)params
          handler:(void(^)(id response, NSError* error))completionHandler;

-(void)postRequest:(NSString*)urlString
        parameters:(NSDictionary*)params
           handler:(void(^)(id response, NSError* error))completionHandler;

-(void)postRequest:(NSString*)urlString
        parameters:(NSDictionary*)params
   imageParameters:(NSDictionary*)imageParams
           handler:(void(^)(id response, NSError* error))completionHandler;

- (void)downloadImage:(NSString *)urlString
              handler:(void(^)(UIImage* image, NSError* error))completionHandler;
@end
