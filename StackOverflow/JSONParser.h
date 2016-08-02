//
//  JSONParser.h
//  StackOverflow
//
//  Created by Jeremy Moore on 8/2/16.
//  Copyright © 2016 Jeremy Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Question.h"

@interface JSONParser : NSObject

+ (NSArray *)questionResultsFromJson:(NSDictionary *)jsonData;
+ (User *)userFromJSON:(NSDictionary *)userData;

@end
