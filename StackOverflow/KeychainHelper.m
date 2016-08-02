//
//  KeychainHelper.m
//  StackOverflow
//
//  Created by Jeremy Moore on 8/1/16.
//  Copyright © 2016 Jeremy Moore. All rights reserved.
//

#import "KeychainHelper.h"

@implementation KeychainHelper

+ (KeychainHelper *)shared
{

    static KeychainHelper *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[KeychainHelper alloc]init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void) saveToken:(NSString *)token
{
    NSData *secret = [token dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *query = @{
                                   (id)kSecClass: (id)kSecClassGenericPassword,
                                   (id)kSecAttrService: @"StackOverflow",
                                   (id)kSecAttrAccount: @"JohnDoe",
                                   (id)kSecValueData: secret,
                                   };


    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, NULL);
    if (status == noErr) {
        NSLog(@"Token is already in keychain");
    } else {

        OSStatus status = SecItemAdd((CFDictionaryRef)query, nil);
        if (status == noErr) {
        NSLog(@"Success saving token %d", status);
        } else {
            NSLog(@"Error saving token. OSStatus code: %d",status);
        }
    }
}

- (NSString *) getToken
{
    NSDictionary *query = @{
                            (id)kSecClass: (id)kSecClassGenericPassword,
                            (id)kSecAttrService: @"StackOverflow",
                            (id)kSecAttrAccount: @"JohnDoe",
                            (id)kSecReturnData: (id)kCFBooleanTrue,
                            (id)kSecReturnAttributes: (id)kCFBooleanTrue,                            };

    CFDictionaryRef result = nil;

    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, ((CFTypeRef*)&result));
    NSLog(@"getToken error code %d",status);
    if (status == noErr) {
        NSDictionary *resultDict = (__bridge_transfer NSDictionary*)result;
        NSData *secret = resultDict[(__bridge id)kSecValueData];
        NSString *tokenResult = [[NSString alloc] initWithData:secret encoding:NSUTF8StringEncoding];
        return tokenResult;
    } else {
        NSLog(@"Error retrieving password from keychain error: %d, or it does not exist in keychain", status);
        return nil;
    }
}



@end