//
//  QuestionSearchViewController.m
//  StackOverflow
//
//  Created by Jeremy Moore on 8/1/16.
//  Copyright © 2016 Jeremy Moore. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "KeychainHelper.h"
#import "Question.h"

@interface QuestionSearchViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *searchedQuestions;
@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSString *token = [[KeychainHelper shared]getToken];
    if (token) {
    [StackOverflowService questionsForSearchTerm:@"iOS" completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"Error in questionsForSearchTerm at QuestionVC %@", error);
            return;
        }
        
        self.searchedQuestions = results;
        [self.tableView reloadData];
    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedQuestions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    Question *currentQuestion = self.searchedQuestions[indexPath.row];
    cell.textLabel.text = currentQuestion.title;
    return cell;
}



@end
