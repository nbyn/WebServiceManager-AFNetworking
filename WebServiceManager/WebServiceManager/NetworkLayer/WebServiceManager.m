//
//  WebServiceManager.m
//  WebServiceManager
//
//  Created by Malik Wahaj Ahmed on 08/04/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

#import "WebServiceManager.h"
#import "AFImageDownloader.h"

@implementation WebServiceManager

static NSString * kBaseURL = @"https://jsonplaceholder.typicode.com/";

+ (WebServiceManager *)sharedClient {
    static WebServiceManager *_serviceClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceClient = [[WebServiceManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    });
    return _serviceClient;
}
    
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"application/x-www-form-urlencoded", nil];
     [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"Internet Working");
        }else{
           NSLog(@"Internet Not Working...");
        }
    }];
    return self;
}
    
    
-(void)getRequest:(NSString*)urlString
       parameters:(NSDictionary*)params
          handler:(void(^)(id response, NSError* error))completionHandler {

    [self GET:urlString parameters:params
      progress:nil
       success:^(NSURLSessionTask *task, id response) {
           completionHandler(response,nil);
       }
       failure:^(NSURLSessionTask *operation, NSError *error) {
           completionHandler(nil,error);
    }];
}

-(void)postRequest:(NSString*)urlString
       parameters:(NSDictionary*)params
          handler:(void(^)(id response, NSError* error))completionHandler {
    
    [self POST:urlString parameters:params
      progress:nil
       success:^(NSURLSessionTask *task, id response) {
          completionHandler(response,nil);
       }
       failure:^(NSURLSessionTask *operation, NSError *error) {
          completionHandler(nil,error);
    }];
}

-(void)postRequest:(NSString*)urlString
        parameters:(NSDictionary*)params
   imageParameters:(NSDictionary*)imageParams
           handler:(void(^)(id response, NSError* error))completionHandler {
    
    [self POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage * image = imageParams[@"image"];
        NSString * imageKey = imageParams[@"image_key"];
        NSString * imageType = imageParams[@"image_type"];
        CGFloat imageCompression = [imageParams[@"image_compression"]floatValue];
        NSData * imageData;
        if ([imageType isEqualToString:@"jpeg"]) {
            imageData = UIImageJPEGRepresentation(image, imageCompression);
        }
        else if ([imageType isEqualToString:@"png"]) {
            imageData = UIImagePNGRepresentation(image);
        }
        [formData appendPartWithFileData:imageData
                                    name:imageKey
                                fileName:[NSString stringWithFormat:@"%@.%@",imageKey,imageType]
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType]];
    }
      progress:nil
       success:^(NSURLSessionDataTask * task, id response) {
        completionHandler(response,nil);
       }
       failure:^(NSURLSessionDataTask * task, NSError * error) {
        completionHandler(nil,error);
    }];
}

- (void)downloadImage:(NSString *)urlString
            handler:(void(^)(UIImage* image, NSError* error))completionHandler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        completionHandler(image,nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        completionHandler(nil,error);
    }];
}

    
@end
