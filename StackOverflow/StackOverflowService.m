//
//  StackOverflowService.m
//  StackOverflow
//
//  Created by Jeremy Moore on 8/2/16.
//  Copyright © 2016 Jeremy Moore. All rights reserved.
//

#import "StackOverflowService.h"
#import "KeychainHelper.h"
#import "JSONParser.h"


@import AFNetworking;

NSString const *clientKey = @"w)D5NGT8g6S1MdwR5InWXQ((";
NSString const *kSearchBaseURL = @"https://api.stackexchange.com/2.2/search";

@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(questionFetchCompletion)completionHandler
{
    NSString *accessToken = [[KeychainHelper shared]getToken];
    //TODO: abstract out base url, search parameters
    NSString *searchURLString = [NSString stringWithFormat:@"%@?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@", kSearchBaseURL, searchTerm, clientKey, accessToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:searchURLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //TODO: progress bar for longer requests
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //comeback
        NSLog(@"%@", responseObject);
        NSArray *results = [JSONParser questionResultsFromJson:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(results, nil);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(nil, error);
        });
    }];
}



@end
