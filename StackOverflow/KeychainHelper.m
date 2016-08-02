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
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge id)kSecAttrService] = @"StackOverflow";
    query[(__bridge id)kSecAttrAccount] = @"JohnDoe";


    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, NULL);
    if (status == noErr) {
        NSLog(@"Token is already in keychain");
    } else {
        query[(__bridge id)kSecValueData] = secret;

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
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
  
    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    query[(__bridge id)kSecAttrService] = @"StackOverflow";
    query[(__bridge id)kSecAttrAccount] = @"JohnDoe";
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;

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