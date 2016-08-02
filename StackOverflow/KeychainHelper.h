//
//  KeychainHelper.h
//  StackOverflow
//
//  Created by Jeremy Moore on 8/1/16.
//  Copyright © 2016 Jeremy Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface KeychainHelper : NSObject

- (void) saveToken:(NSString *)token;
- (NSString *) getToken;
+ (KeychainHelper *)shared;

@end
