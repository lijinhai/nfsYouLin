//
//  ModifyPasswordViewController.m
//  nfsYouLin
//
//  Created by jinhai on 16/7/5.
//  Copyright © 2016年 jinhai. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "Masonry.h"
#import "AFHTTPSessionManager.h"
#import "StringMD5.h"
#import "HeaderFile.h"
#import "SqliteOperation.h"
#import "SqlDictionary.h"
#import "MBProgressHUBTool.h"

@interface ModifyPasswordViewController ()

@end

@implementation ModifyPasswordViewController{
 
    UIColor *_viewColor;
    UIView *oldrightView;
    UIView *firstrightView;
    UIView *repeatrightView;
    UIImageView* xImageView;
    UIImageView* xImageView1;
    UIImageView* xImageView2;
    UILabel* oldtiplab;
    UILabel* firsttiplab;
    UILabel* repeattiplab;
    CGSize osize;
    CGSize fsize;
    CGSize rsize;
    NSTimer* timer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor = _viewColor;
    
    oldrightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    oldrightView.tag=101;
    firstrightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    firstrightView.tag=102;
    repeatrightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    repeatrightView.tag=103;
    
    xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    xImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    xImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tanhao"]];
    
    oldtiplab=[[UILabel alloc] init];
    oldtiplab.tag=812;
    firsttiplab=[[UILabel alloc] init];
    firsttiplab.tag=815;
    repeattiplab=[[UILabel alloc] init];
    repeattiplab.tag=817;
    
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    oldtiplab.text=@"请先输入旧密码";
    oldtiplab.font = fnt;
    oldtiplab.textColor=[UIColor blackColor];
    osize = [oldtiplab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    
    firsttiplab.text=@"请输入6到16位密码";
    firsttiplab.font = fnt;
    firsttiplab.textColor=[UIColor blackColor];
    fsize = [firsttiplab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    
    repeattiplab.text=@"确认密码不一致";
    repeattiplab.font = fnt;
    repeattiplab.textColor=[UIColor blackColor];
    rsize = [repeattiplab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    
    xImageView.frame = CGRectMake(CGRectGetMaxX(_oldPassWordTextField.frame)-24, 15,15,15);
    xImageView1.frame = CGRectMake(CGRectGetMaxX(_oldPassWordTextField.frame)-24, 15,15,15);
    xImageView2.frame = CGRectMake(CGRectGetMaxX(_oldPassWordTextField.frame)-24, 15,15,15);
    
    [oldrightView addSubview:xImageView];
    [firstrightView addSubview:xImageView1];
    [repeatrightView addSubview:xImageView2];

}

-(void)viewWillAppear:(BOOL)animated{

    /*自定义导航返回箭头*/
    UIImage *backButtonImage = [[UIImage imageNamed:@"mm_title_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0,0)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title=@"";
    UIBarButtonItem *barrightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem=barrightBtn;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _oldPassWordTextField.backgroundColor=[UIColor whiteColor];
    _repeatPassWordTextField.backgroundColor=[UIColor whiteColor];
    _firstPasswordTextField.backgroundColor=[UIColor whiteColor];
    _oldPassWordTextField.layer.cornerRadius=3.0;
    _repeatPassWordTextField.layer.cornerRadius=3.0;
    _firstPasswordTextField.layer.cornerRadius=3.0;
    _oldPassWordTextField.leftView=paddingView1;
    _repeatPassWordTextField.leftView=paddingView2;
    _firstPasswordTextField.leftView=paddingView3;
    _firstPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    _repeatPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    _oldPassWordTextField.leftViewMode = UITextFieldViewModeAlways;
    [_oldPassWordTextField addTarget:self action:@selector(textOldFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_firstPasswordTextField addTarget:self action:@selector(textFirstFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_repeatPassWordTextField addTarget:self action:@selector(textRepeatFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _bgView.layer.cornerRadius=5.0;
    _bgView.backgroundColor=_viewColor;
    
    self.navigationItem.title=@"";
    [_oldPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self.view.mas_top).offset(90);
 
     }];
    [_firstPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(136);
        
    }];
    [_repeatPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(182);
    }];

}
/*更改密码接口*/
-(void)changeLoginPassword{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    [manager.securityPolicy setValidatesDomainName:NO];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* phoneNum = [defaults stringForKey:@"phoneNum"];
    NSString* oldpassWord = [NSString stringWithFormat:@"%@%@",[StringMD5 stringAddMD5:_oldPassWordTextField.text],phoneNum];
    NSString* newpassWord= [NSString stringWithFormat:@"%@%@",[StringMD5 stringAddMD5:_firstPasswordTextField.text],phoneNum];
    NSString* addMD5OldPassWord = [StringMD5 stringAddMD5:oldpassWord];
    NSString* addMD5NewPassWord = [StringMD5 stringAddMD5:newpassWord];
    NSString* userId = [NSString stringWithFormat:@"%ld", [SqliteOperation getUserId]];
    NSString* hashString =[StringMD5 stringAddMD5:[NSString stringWithFormat:@"user_phone_number%@user_password%@user_oldpassword%@user_id%@",phoneNum,addMD5NewPassWord,addMD5OldPassWord,userId]];
    NSString* hashMD5 = [StringMD5 stringAddMD5:[NSString stringWithFormat:@"%@816",hashString]];
    NSDictionary* parameter = @{@"user_phone_number" : phoneNum,
                                @"user_password" : addMD5NewPassWord,
                                @"user_oldpassword" : addMD5OldPassWord,
                                @"user_id" : userId,
                                @"deviceType":@"ios",
                                @"apitype" : @"users",
                                @"tag" : @"modifypwd",
                                @"salt" : @"816",
                                @"hash" : hashMD5,
                            @"keyset" :@"user_phone_number:user_password:user_oldpassword:user_id:",
                                };
    
    [manager POST:POST_URL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject is %@",responseObject);
        if([[responseObject objectForKey:@"flag"] isEqualToString:@"ok"])
        {
            
            timer=[NSTimer scheduledTimerWithTimeInterval:0.8
                                                   target:self
                                                 selector:@selector(jumpLastView)
                                                 userInfo:nil
                                                  repeats:NO];
        }else if([[responseObject objectForKey:@"flag"] isEqualToString:@"no"]){
        
            [MBProgressHUBTool textToast:self.view Tip:@"原密码错误"];
            return;
        }else if([[responseObject objectForKey:@"flag"] isEqualToString:@"no_user"])
        {
            [MBProgressHUBTool textToast:self.view Tip:@"该用户不存在"];
            return;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    
}
-(void)jumpLastView{

  [self.navigationController popViewControllerAnimated:YES];
  [MBProgressHUBTool textToast:self.parentViewController.view Tip:@"修改成功"];
}
/*确认*/
-(void)sureAction{
    
    Boolean firstnullflg=[_firstPasswordTextField.text isEqualToString:@""];
    Boolean repeatnullflg=[_repeatPassWordTextField.text isEqualToString:@""];
    Boolean oldnullflg=[_oldPassWordTextField.text isEqualToString:@""];
    NSInteger firstPassLen=[_firstPasswordTextField.text length];
    
    Boolean  equalflg=[_firstPasswordTextField.text isEqualToString:_repeatPassWordTextField.text];
    
    if((UILabel *)[self.view viewWithTag:101]||(UILabel *)[self.view viewWithTag:102]||(UILabel *)[self.view viewWithTag:103])
    {
        NSLog(@"错误返回");
        return;
    }
      if(oldnullflg&&(firstnullflg||firstPassLen<6||firstPassLen>16))
   {
       [_firstPasswordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(170);
           
       }];
       [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(245.5);
           
       }];
       [self updateViewConstraints];
       [self.view layoutIfNeeded];
       oldtiplab.frame=CGRectMake(CGRectGetMaxX(_oldPassWordTextField.frame)-osize.width, CGRectGetMaxY(_oldPassWordTextField.frame)+2, osize.width, 30);
       firsttiplab.frame=CGRectMake(CGRectGetMaxX(_firstPasswordTextField.frame)-fsize.width, CGRectGetMaxY(_firstPasswordTextField.frame)+2, fsize.width, 30);
       repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
       [_bgView addSubview: firsttiplab];
       [_bgView addSubview: repeattiplab];
       [_bgView addSubview: oldtiplab];
       
       [_oldPassWordTextField addSubview:oldrightView];
       [_repeatPassWordTextField addSubview:repeatrightView];
       [_firstPasswordTextField addSubview:firstrightView];
       return;
    
   }else if(!oldnullflg&&firstnullflg){
   
       [_firstPasswordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view.mas_top).offset(136);
           
       }];
       [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view.mas_top).offset(212);
           
       }];
       [self updateViewConstraints];
       [self.view layoutIfNeeded];
    
       firsttiplab.frame=CGRectMake(CGRectGetMaxX(_firstPasswordTextField.frame)-fsize.width, CGRectGetMaxY(_firstPasswordTextField.frame)+2, fsize.width, 30);
       repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
       [_bgView addSubview: firsttiplab];
       [_bgView addSubview: repeattiplab];

       [_repeatPassWordTextField addSubview:repeatrightView];
       [_firstPasswordTextField addSubview:firstrightView];
       return;
      
   }else if(oldnullflg&&!firstnullflg&&!equalflg){
    
       [_firstPasswordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(170);
           
       }];
       [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(215.5);
           
       }];
       [self updateViewConstraints];
       [self.view layoutIfNeeded];
       oldtiplab.frame=CGRectMake(CGRectGetMaxX(_oldPassWordTextField.frame)-osize.width, CGRectGetMaxY(_oldPassWordTextField.frame)+2, osize.width, 30);
       repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
       [_bgView addSubview: oldtiplab];
       [_bgView addSubview: repeattiplab];
       [_oldPassWordTextField addSubview:oldrightView];
       [_repeatPassWordTextField addSubview:repeatrightView];
       return;
   
   }else if(oldnullflg&&!firstnullflg&&equalflg){
       
       [_firstPasswordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(170);
           
       }];
       [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(215.5);
           
       }];
       [self updateViewConstraints];
       [self.view layoutIfNeeded];
       oldtiplab.frame=CGRectMake(CGRectGetMaxX(_oldPassWordTextField.frame)-osize.width, CGRectGetMaxY(_oldPassWordTextField.frame)+2, osize.width, 30);
       [_bgView addSubview: oldtiplab];
       [_oldPassWordTextField addSubview:oldrightView];
       return;
       
   }else if(!oldnullflg&&!equalflg){
   
       [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(215.5);
           
       }];
       [self updateViewConstraints];
       [self.view layoutIfNeeded];
       repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
       firsttiplab.frame=CGRectMake(CGRectGetMaxX(_firstPasswordTextField.frame)-fsize.width, CGRectGetMaxY(_firstPasswordTextField.frame)+2, fsize.width, 30);
       NSLog(@"repeattiplab text is %@",repeattiplab.text);
       [_bgView addSubview: repeattiplab];
       [_bgView addSubview: firsttiplab];
       [_repeatPassWordTextField addSubview:repeatrightView];
       [_firstPasswordTextField addSubview:firstrightView];
       return;
   
   }else if(!oldnullflg&&firstnullflg&&repeatnullflg){
   
       [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
           
           make.top.equalTo(self.view.mas_top).with.offset(215.5);
           
       }];
       [self updateViewConstraints];
       [self.view layoutIfNeeded];
       repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
       firsttiplab.frame=CGRectMake(CGRectGetMaxX(_firstPasswordTextField.frame)-fsize.width, CGRectGetMaxY(_firstPasswordTextField.frame)+2, fsize.width, 30);
       NSLog(@"repeattiplab text is %@",repeattiplab.text);
       [_bgView addSubview: repeattiplab];
       [_bgView addSubview: firsttiplab];
       [_repeatPassWordTextField addSubview:repeatrightView];
       [_firstPasswordTextField addSubview:firstrightView];
       return;
   }
    [self changeLoginPassword];

    
    
    //[self.navigationController popViewControllerAnimated:YES];

}
- (void)textOldFieldDidChange:(UITextField *)textField
{
    NSLog(@"textField value is %@",textField.text);
    if (textField.markedTextRange == nil) {
        if((UIView *)[self.view viewWithTag:101])
        {
            UIView *imageTanHao = (UIView *)[self.view viewWithTag:101];
            [imageTanHao removeFromSuperview];
        }
        if((UILabel *)[self.view viewWithTag:812])
        {
            UILabel *tiplab = (UILabel *)[self.view viewWithTag:812];
            [tiplab removeFromSuperview];
            [_firstPasswordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(136);
                
            }];
           
            if((UILabel *)[self.view viewWithTag:815])
            {
        
                [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.view.mas_top).with.offset(212.5);
                    
                }];
                [self updateViewConstraints];
                [self.view layoutIfNeeded];
                UILabel* label1=(UILabel *)[self.view viewWithTag:815];
                [label1 removeFromSuperview];
                firsttiplab.frame=CGRectMake(CGRectGetMaxX(_firstPasswordTextField.frame)-fsize.width, CGRectGetMaxY(_firstPasswordTextField.frame)+2, fsize.width, 30);
                [_bgView addSubview:firsttiplab];
               
                
                
            }else{
            
                [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.view.mas_top).with.offset(182);
                    
                }];
                [self updateViewConstraints];
                [self.view layoutIfNeeded];
                
            
            }
            if((UILabel *)[self.view viewWithTag:817])
            {
                UILabel* label2=(UILabel *)[self.view viewWithTag:817];
                [label2 removeFromSuperview];
                repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
                [_bgView addSubview:repeattiplab];
            }
            [self updateViewConstraints];
            [self.view layoutIfNeeded];
        
        }
        
        
    }
}


- (void)textFirstFieldDidChange:(UITextField *)textField
{

    NSLog(@"textField value is %@",textField.text);
    if (textField.markedTextRange == nil) {
        if((UIView *)[self.view viewWithTag:102])
        {
            UIView *imageTanHao = (UIView *)[self.view viewWithTag:102];
            [imageTanHao removeFromSuperview];
        }
        if((UILabel *)[self.view viewWithTag:815]&&(UILabel *)[self.view viewWithTag:812]==NULL)
        {
                 UILabel *tiplab = (UILabel *)[self.view viewWithTag:815];
                [tiplab removeFromSuperview];
                [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.view.mas_top).with.offset(182);
                    
                }];
                [self updateViewConstraints];
                [self.view layoutIfNeeded];
                if((UILabel *)[self.view viewWithTag:817]){

                    UILabel* label2=(UILabel *)[self.view viewWithTag:817];
                    [label2 removeFromSuperview];
                    repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
                    [_bgView addSubview:repeattiplab];
                    
                }
                
           }else if((UILabel *)[self.view viewWithTag:815]==NULL&&(UILabel *)[self.view viewWithTag:812]==NULL){

                [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(self.view.mas_top).with.offset(182);
                    
                }];
               [self updateViewConstraints];
               [self.view layoutIfNeeded];
                if((UILabel *)[self.view viewWithTag:817]){

                    UILabel* label2=(UILabel *)[self.view viewWithTag:817];
                    [label2 removeFromSuperview];
                    repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
                    [_bgView addSubview:repeattiplab];
                    
                }
            
            
           }else if((UILabel *)[self.view viewWithTag:815]==NULL&&(UILabel *)[self.view viewWithTag:812]){
           
               [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                   make.top.equalTo(self.view.mas_top).with.offset(215.5);
                   
               }];
               [self updateViewConstraints];
               [self.view layoutIfNeeded];
               if((UILabel *)[self.view viewWithTag:817]){
                   
                   UILabel* label2=(UILabel *)[self.view viewWithTag:817];
                   [label2 removeFromSuperview];
                   repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
                   [_bgView addSubview:repeattiplab];
                   
               }
           
           }else{
           
               UILabel *tiplab = (UILabel *)[self.view viewWithTag:815];
               [tiplab removeFromSuperview];
               [_repeatPassWordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                   make.top.equalTo(self.view.mas_top).with.offset(215.5);
                   
               }];
               [self updateViewConstraints];
               [self.view layoutIfNeeded];
               if((UILabel *)[self.view viewWithTag:817]){
                   
                   UILabel* label2=(UILabel *)[self.view viewWithTag:817];
                   [label2 removeFromSuperview];
                   repeattiplab.frame=CGRectMake(CGRectGetMaxX(_repeatPassWordTextField.frame)-rsize.width, CGRectGetMaxY(_repeatPassWordTextField.frame)+2, rsize.width, 30);
                   [_bgView addSubview:repeattiplab];
                   
               }
           
           }
        
    }
}

- (void)textRepeatFieldDidChange:(UITextField *)textField
{
    
    if (textField.markedTextRange == nil) {
        if((UIView *)[self.view viewWithTag:103])
        {
            UIView *imageTanHao = (UIView *)[self.view viewWithTag:103];
            [imageTanHao removeFromSuperview];
        }
        if((UILabel *)[self.view viewWithTag:817])
        {
            UILabel *tiplab = (UILabel *)[self.view viewWithTag:817];
            [tiplab removeFromSuperview];
            
        }
    }
    
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

- (IBAction)oldTextField_DidEndOnExit:(id)sender {
    
    [self.firstPasswordTextField becomeFirstResponder];
}

- (IBAction)firstTextField_DidEndOnExit:(id)sender {
    
    [self.repeatPassWordTextField becomeFirstResponder];
}

- (IBAction)repeatTextField_DidEndOnExit:(id)sender {
    
    // 隐藏键盘.
    [sender resignFirstResponder];
    
}

- (IBAction)View_TouchDown:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
