//
//  CreateTopicVC.m
//  nfsYouLin
//
//  Created by Macx on 16/8/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "CreateTopicVC.h"

@interface CreateTopicVC ()

@end

@implementation CreateTopicVC

- (id) init
{
    self = [super init];
    if(self)
    {
        
        self.view.backgroundColor = [UIColor whiteColor];
        UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
        label.text = @"大师傅";
        [self.view addSubview:label];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendResult:)];
    self.navigationItem.rightBarButtonItem = rightItem;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendResult:(id)sender
{
    NSLog(@"发送");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
