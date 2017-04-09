//
//  ViewController.m
//  WebServiceManager
//
//  Created by Malik Wahaj Ahmed on 08/04/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

#import "ViewController.h"
#import "WebServiceManager.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getRequestButtonTapped:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedClient]getRequest:@"posts" parameters:nil handler:^(id response, NSError* error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSLog(@"%@",response);
        }
    }];
}

- (IBAction)postRequestButtonTapped:(UIButton *)sender {
    
    NSDictionary * params = @{@"title": @"foo", @"body": @"bar", @"id":@"1"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebServiceManager sharedClient]postRequest:@"posts" parameters:params handler:^(id response, NSError* error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSLog(@"%@",response);
        }
    }];
}


@end
