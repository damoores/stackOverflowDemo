//
//  JSONParser.m
//  StackOverflow
//
//  Created by Jeremy Moore on 8/2/16.
//  Copyright © 2016 Jeremy Moore. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (NSArray *)questionResultsFromJson:(NSDictionary *)jsonData
{
    NSMutableArray *questions = [[NSMutableArray alloc]init];
    NSArray *items = jsonData[@"items"];
    
    for (NSDictionary *item in items) {
        Question * question = [[Question alloc]init];
        NSDictionary *owner = item[@"ownder"];
        
        question.title = item[@"title"];
        question.profileName = owner[@"display_name"];
        question.imageURL = owner[@"profile_image"];
    
        [questions addObject:question];
    }
    return questions;
}


+ (User *)userFromJSON:(NSDictionary *)userData
{
    NSArray *userArray = userData[@"items"];
    NSDictionary *userInfo = userArray.firstObject;
    
    User *user = [[User alloc]init];
    user.userName = userInfo[@"display_name"];
    user.profileImageURL = userInfo[@"profile_image"];
    
    return user;
}


@end
