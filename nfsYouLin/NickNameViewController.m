//
//  NickNameViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/4.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "NickNameViewController.h"
#import "PersonalInformationViewController.h"


@interface NickNameViewController ()

@end

@implementation NickNameViewController{
 
    UIColor *_viewColor;
    PersonalInformationViewController *PersonalInformationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor = _viewColor;
    

}

-(void)viewWillAppear:(BOOL)animated{

    /*页面跳转*/
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    PersonalInformationController=[storyBoard instantiateViewControllerWithIdentifier:@"personalinformationcontroller"];
    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    /*设置textfield属性*/
    _nikeNameTextField.backgroundColor=[UIColor whiteColor];
    if(![_nikeNameValue isEqualToString:@""])
    {
      _nikeNameTextField.text=_nikeNameValue;
    }
    }

- (void)returnText:(ReturnTextBlock)block {
   
    self.returnTextBlock = block;
}
-(void)sureAction{

    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_nikeNameTextField.text);
        NSLog(@"nikeNameTextField.text is %@",_nikeNameTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
