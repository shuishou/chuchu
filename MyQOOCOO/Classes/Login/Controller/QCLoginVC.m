//
//  QCLoginVC.m
//  MyQOOCOO
//
//  Created by Fly_Fish_King on 15/8/5.
//  Copyright (c) 2015年 CN.QOOCOO. All rights reserved.
//

#define kFogetCode  [NSString stringWithFormat:@"忘记密码"]
#define kUpdateCode [NSString stringWithFormat:@"更改密码"]
#define ktimeCount 60
#define kFogetCodetag 10010
#define kRegisterCodetag 10011

#import "QCLoginVC.h"
#import "QCTabBarController.h"
#import "CNPPopupController.h"
#import "QCProtocolVC.h"

//自定义输入框
#import "QCTextField.h"

//自定义PopoverVC
#import "QCPopViewController.h"
#import "QCPersonInfoVC.h"

#import "CommonValidator.h"

//登陆
#import "LoginSession.h"
#import "ApplicationContext.h"
#import "ShareInstance.h"

//完善个人资料
#import "QCUserDataVC.h"
#import "QCFriendInfoModel.h"
#import "QCGetUserMarkModel.h"

//#import <SMS_SDK/SMSSDK.h>
@interface QCLoginVC()<CNPPopupControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIButton *_avatarBtn;
    UIView *_bgNickName;
    UIView *_bgpassword;
    UIButton *_loginBtn;
    
    UIView *_bgBottom;
    //登陆
    UIImageView *_nameView;
    UIImageView *_passWordView;
    UITextField *_useNameText;
    UITextField *_passWordText;
    
    UIButton *_fogotPassWordBtn;
    UIButton *_updatePWBtn;
    UIButton *_registerBtn;
    //注册
    UILabel *_titleLabel;
    QCTextField *_phoneTextField;
    QCTextField *_SecurityCodeTextField;
    NSTimer *_timer;
    UIButton *_getSecurityCodeBtn;
    QCTextField *_passWordTextField;
    QCTextField *_passWordAgainTextField;
    //验证码
    
    UIImageView * imag;
    NSUserDefaults * loginDeFaults;
    CGFloat bgViewH;
    
    UIView *popBackView;
}

@property (nonatomic , strong)QCPopViewController *loginPopoverVC;
@property (nonatomic , strong)UIView *bgView;
@property (nonatomic , strong)UIButton *ensureProtocolBtn;
//@property (nonatomic , strong)QCPopoverBtn *nextStepBtn;
@property (nonatomic , strong)UINavigationController *protocolNav;
@property(copy, nonatomic)NSString * acodeNumber;//验证码
@property (nonatomic) BOOL isTimes;

@end

static int timeCount = ktimeCount;


@implementation QCLoginVC
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_useNameText endEditing:YES];
      [_passWordText endEditing:YES];
}
- (void)loadView
{
    [super loadView];
    loginDeFaults = [NSUserDefaults standardUserDefaults];
    
    NSString * avUrlStr = [loginDeFaults objectForKey:@"HFUserAvatarUrl"];
    
    imag = [UIImageView new];
    if (avUrlStr.length > 0) {
        [imag sd_setImageWithURL:[NSURL URLWithString:avUrlStr] placeholderImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    }
    else
    {
        [imag setImage:[UIImage imageNamed:@"ios-template-1024(1)"]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kLoginbackgoundColor;
    //初始化登陆界面
    [self setupBackgroundLogin];
    
    //点击屏幕缩回键盘
    UITapGestureRecognizer * tap_closeKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardAction:)];
    [self.view addGestureRecognizer:tap_closeKeyBoard];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
}

#pragma mark - 处理键盘弹出事件
//处理键盘弹出事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (ScreenHeight<=480) {
//        CGRect frame = textField.frame;
//        int offset = frame.origin.y + 44 - (self.view.frame.size.height - 285);
//        if (offset > 0) {
//            [UIView animateWithDuration:0.3 animations:^{
//                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//                _bgView.frame = CGRectMake(_bgView.x, -offset, _bgView.width, _bgView.height);
//            }];
//        }
//        if (offset < 0){
//            [UIView animateWithDuration:0.3 animations:^{
//                self.view.frame = CGRectMake(0.0f, offset, self.view.frame.size.width, self.view.frame.size.height);
//                  _bgView.frame = CGRectMake(_bgView.x, offset, _bgView.width, _bgView.height);
//            }];
//        }
//    }
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if ([_passWordTextField isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.frame = CGRectMake(_bgView.x, -height+200, _bgView.width, _bgView.height);
        }];
    }else if ([_passWordAgainTextField isFirstResponder]){
        [UIView animateWithDuration:0.3 animations:^{
            _bgView.frame = CGRectMake(_bgView.x, -height+150, _bgView.width, _bgView.height);
        }];
    }
    
    
}

/**
 *  此方法为,用户输入完成后 回弹self.view为正常状态
 *
 *  @param textField 为当前用户编辑的textFiled
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        self.bgView.frame = CGRectMake(25,(SCREEN_H-bgViewH-40)/2,SCREEN_W - 50,bgViewH);
    }];
    //结束输入判断
//    _passWordAgainTextField.userInteractionEnabled = _SecurityCodeTextField.text.length;
//    _passWordTextField.userInteractionEnabled = _SecurityCodeTextField.text.length;
    
}

/**
 *  手势关闭键盘
 */
-(void)closeKeyBoardAction:(UITapGestureRecognizer *)sender{
//    [_bgView removeFromSuperview];
//    [_useNameText resignFirstResponder];
//    [_passWordText resignFirstResponder];
//    [_phoneTextField resignFirstResponder];
//    [_SecurityCodeTextField resignFirstResponder];
//    [_getSecurityCodeBtn resignFirstResponder];
//    [_passWordTextField resignFirstResponder];
//    [_passWordAgainTextField resignFirstResponder];
    
}

//登陆
#pragma mark - 登陆请求
-(void)loginBtnClick:(UIButton *)btn{
    
    if (![self checkInputLogin]){
        return ;
    }
    
    //1,参数拼接
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = _useNameText.text;
    parameters[@"password"] = _passWordText.text;
    [self showHint:@"正在登录..."];
    //2,网络请求
    [NetworkManager requestWithURL:USER_LOGIN_URL parameter:parameters success:^(id response) {
       
        //登陆成功后的回调
        NSDictionary *dic = (NSDictionary *)response;
        [self handleLoginSuccess:dic];
        User *user = [User mj_objectWithKeyValues:[dic objectForKey:@"user"]];
        NSString *url = user.avatarUrl;
        [[NSUserDefaults standardUserDefaults]setObject:url forKey:@"userheadimg"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LoginSession *loginUser = [[ApplicationContext sharedInstance]getLoginUser:user];
        [loginDeFaults setObject:loginUser.user.avatarUrl forKey:@"HFUserAvatarUrl"];
        
        //异步登陆环信账号
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:loginUser.user.hid password:loginUser.user.hpass completion:^(NSDictionary *loginInfo, EMError *error) {
            if (loginInfo && !error) {
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                if (!error) {
                    error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                }
                ShareInstance *share = [ShareInstance creatInstance];
                share.user = user;
                 [self hideHud];
                if (user.nickname.length > 0) {
                    QCTabBarController *tabVC = [[QCTabBarController alloc]init];
                    [self presentViewController:tabVC animated:YES completion:nil];
                }else{
                    QCUserDataVC * vc = [[QCUserDataVC alloc] init];
                    QCFriendInfoModel * model = [[QCFriendInfoModel alloc] init];
                    model.userno = dic[@"user"][@"userno"];
                    vc.myData = model;
                    vc.isFirstLogin = @1;
                    
                    UINavigationController * userNav = [[UINavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:userNav animated:YES completion:nil];
                }
            }else{
                [OMGToast showText:@"登录失败"];
                switch (error.errorCode) {
                    case EMErrorServerNotReachable:
                        //[OMGToast showText:@"连接服务器失败!"];
                        break;
                    case EMErrorServerAuthenticationFailure:
                        //[OMGToast showText:@"用户名或密码错误"];
                        break;
                    case EMErrorServerTimeout:
                        //[OMGToast showText:@"连接服务器超时!"];
                        break;
                    default:
                        //[OMGToast showText:@"登录失败"];
                        break;
                }
            }
        } onQueue:nil];
    } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        [self hideHUD];
        [OMGToast showText:@"登录失败"];
    }];
    
}

//登陆后回调的方法
-(void)handleLoginSuccess:(NSDictionary *)sessionInfo{
    LoginSession *loginSession = [LoginSession mj_objectWithKeyValues:sessionInfo];
    [[ApplicationContext sharedInstance] saveLoginSession:loginSession];
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:AppUserLoginNotification object:nil userInfo:@{@"loginUser":loginSession.user}];
}

#pragma mark - 检测输入是否正确
//判断输入是否合理
-(BOOL)checkInputLogin{
    [_useNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
    if ([_useNameText.text isEqualToString:@""]) {
        [OMGToast showText:@"登录名不能为空"];
        return NO;
    }
    if ([_passWordText.text isEqualToString:@""]) {
        [OMGToast showText:@"密码不能为空"];
        return NO;
    }
    return YES;
}

- (BOOL)CheckInputPhoneNum{
    [_phoneTextField resignFirstResponder];
    [_SecurityCodeTextField resignFirstResponder];
    
    if ([_phoneTextField.text isEqualToString:@""]) {
        [OMGToast showText:@"电话号码不能为空"];
        
        return NO;
    }
    
    BOOL isPhone = [CommonValidator isPhoneNumber:_phoneTextField.text];
    if (!isPhone) {
        [OMGToast showText:@"请输入正确电话"];
        return NO;
    }
    
    if (_phoneTextField.text.length<11) {
        [OMGToast showText:@"电话号码不能小于11"];
        return NO;
        
    }
    return YES;
}

- (BOOL)chechInputNext{
    
    [_phoneTextField resignFirstResponder];
    [_SecurityCodeTextField resignFirstResponder];
    
    if ([_phoneTextField.text isEqualToString:@""]) {
        [OMGToast showText:@"手机号码不能为空！！"];
        return NO;
    }
    
    BOOL isPhone = [CommonValidator isPhoneNumber:_phoneTextField.text];
    if (!isPhone) {
        [OMGToast showText:@"请输入正确的手机号码"];
        return NO;
    }
    
    if ([_SecurityCodeTextField.text isEqualToString:@""]) {
        
        [OMGToast showText:@"验证码不能为空！！"];
        
        return NO;
    }
    //    if (![_SecurityCodeTextField.text isEqualToString:self.acodeNumber]) {
    //        [OMGToast showText:@"请输入正确的验证码"];
    //        return NO;
    //
    //    }
    if ([_passWordTextField.text isEqualToString:@""]) {
        [OMGToast showText:@"密码不能为空!!"];
        return NO;
    }
    
    if (_passWordTextField.text.length<6 || _passWordTextField.text.length > 30) {
        [OMGToast showText:@"密码不能小于6位或大于30位!!"];
        return NO;
    }
    
    if (![_passWordTextField.text isEqualToString:_passWordAgainTextField.text ]) {
        [OMGToast showText:@"请输入一致的密码!!"];
        return NO;
    }
    
    if (![_titleLabel.text isEqualToString:kFogetCode]) {
        if (_ensureProtocolBtn.selected == NO) {
            [OMGToast showText:@"请同意注册协议!!"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 忘记密码、更改密码或注册新用户
//忘记密码、更改密码
-(void)fogotPassWord:(UIButton *)btn{
    if (btn.tag == 100) {
        [self registerOrFogotPassWordWithName:kFogetCode];
    }else if (btn.tag == 101){
        [self registerOrFogotPassWordWithName:kUpdateCode];
    }
}

//忘记密码下一步
-(void)fogotPassWordClick:(UIButton *)btn{
    [self nextBtnClick:btn];
}

//注册新用户
-(void)registerNowCount:(UIButton *)btn{
    [self registerOrFogotPassWordWithName:@"用户注册"];//注册界面
}

//点击协议
-(void)ensureClick{
    self.ensureProtocolBtn.selected = !self.ensureProtocolBtn.selected;
}

-(void)protocolBtnClick{
    QCProtocolVC *protocolVC = [[QCProtocolVC alloc]init];
    QCNavigationVC *nav = [[QCNavigationVC alloc]initWithRootViewController:protocolVC];
    self.protocolNav = nav;
    [self.view.window addSubview:nav.view];
//    [self.navigationController pushViewController:[QCProtocolVC new] animated:YES];
}

#pragma mark - 注册账号或重设登陆密码
-(void)nextBtnClick:(UIButton *)btn{
    if (![self chechInputNext]) {
        return;
    }
    NSString *phone = _phoneTextField.text;
    NSString *password = _passWordTextField.text;
    NSString *code = _SecurityCodeTextField.text;
    NSDictionary *parameters = @{@"phone":phone,@"password":password,@"code":code};
    if (btn.tag == kFogetCodetag) {
        [NetworkManager requestWithURL:USER_PSW_CHANGE_URL parameter:parameters success:^(id response) {
            [self close];
            [OMGToast showText:@"修改成功"];
            //            QCPersonInfoVC *personInfoVC = [[QCPersonInfoVC alloc]init];
            //            QCNavigationVC *nav = [[QCNavigationVC alloc]initWithRootViewController:personInfoVC];
            //            [self presentViewController:nav animated:YES completion:nil];
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            
        }];
    }
    
    if (btn.tag == kRegisterCodetag) {
        [NetworkManager requestWithURL:USER_REGISTER_URL parameter:parameters success:^(id response) {
            [self close];
            [OMGToast showText:@"注册成功"];
            //            QCPersonInfoVC *personInfoVC = [[QCPersonInfoVC alloc]init];
            //            QCNavigationVC *nav = [[QCNavigationVC alloc]initWithRootViewController:personInfoVC];
            //            [self presentViewController:nav animated:YES completion:nil];
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            
        }];
    }
    
}

#pragma mark - 获取验证码
/**
 *  忘记密码验证码
 */
-(void)fogetSecurityCode{
    if (![self CheckInputPhoneNum]) {
        return;
    }
    //发送完成之后,显示timmer
    timeCount = ktimeCount;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    NSString *phoneNum = _phoneTextField.text;
    NSDictionary *dict = @{@"phone":phoneNum};
    
    if (!self.timeLabel.hidden)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取验证码次数过多，请稍后重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [NetworkManager requestWithURL:USER_MODIFYPSW_GENCODE_URL parameter:dict success:^(id response) {
            
            //#pragma -mark 利用 SMS_SDK 发送验证码到手机
            //        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
            //         //这个参数可以选择是通过发送验证码还是语言来获取验证码
            //                                phoneNumber:phoneNum
            //                                       zone:@"86"
            //                           customIdentifier:nil //自定义短信模板标识[NSString stringWithFormat:@"【掌淘科技】库牌的验证码:%@", response]
            //                                     result:^(NSError *error)
            //         {
            //
            //             if (!error)
            //             {
            //                 NSLog(@"block 获取验证码成功");
            //
            //             }
            //             else
            //             {
            //
            //                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil)
            //                                                                 message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
            //                                                                delegate:self
            //                                                       cancelButtonTitle:NSLocalizedString(@"确定", nil)
            //                                                       otherButtonTitles:nil, nil];
            //                 [alert show];
            //
            //             }
            //
            //         }];
            
            
            self.timeLabel.hidden = NO;
            _getSecurityCodeBtn.userInteractionEnabled = NO;
            _acodeNumber = response;
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
        }];
    }
}

/**
 *  注册新用户获取验证码
 */
-(void)getSecurityCodeBtnClick{
    if (![self CheckInputPhoneNum] ) {
        return;
    }
    
    timeCount = ktimeCount;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    
    NSString *phoneNum = _phoneTextField.text;
    NSDictionary *dict = @{@"phone":phoneNum};
    
    if (!self.timeLabel.hidden)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取验证码次数过多，请稍后重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [NetworkManager requestWithURL:USER_REGISTER_GETCODE_URL parameter:dict success:^(id response) {
            CZLog(@"验证码发送成功response= %@",response);
            
            //#pragma -mark 利用 SMS_SDK 发送验证码到手机
            //        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
            //         //这个参数可以选择是通过发送验证码还是语言来获取验证码
            //                                phoneNumber:phoneNum
            //                                       zone:@"86"
            //                           customIdentifier:nil //自定义短信模板标识[NSString stringWithFormat:@"【掌淘科技】库牌的验证码:%@", response]
            //                                     result:^(NSError *error)
            //        {
            //
            //            if (!error)
            //            {
            //                NSLog(@"block 获取验证码成功");
            //
            //            }
            //            else
            //            {
            //
            //                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil)
            //                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
            //                                                               delegate:self
            //                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
            //                                                      otherButtonTitles:nil, nil];
            //                [alert show];
            //
            //            }
            //
            //        }];
            
            self.timeLabel.hidden = NO;
            
        } error:^(NSURLSessionTask *operation, NSError *error, NSString *description) {
            CZLog(@"验证码发送失败%@",error);
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"验证失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新验证", nil];
            [alertView show];
        }];
        
    }
}

-(void)showTimer{
    timeCount--;
    if (timeCount <= 0)
    {
        self.timeLabel.hidden = YES;
        _getSecurityCodeBtn.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"请(%i)秒后再试",timeCount];
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        _phoneTextField.text = nil;
        [_phoneTextField becomeFirstResponder];
    }
}

-(void)close{
    [_bgView removeFromSuperview];
}

#pragma mark - 用户注册及忘记密码界面
-(void)registerOrFogotPassWordWithName:(NSString *)btnName{
    
    //背景
    bgViewH = 420;
    if ([btnName isEqual:kFogetCode] ||[btnName isEqual:kUpdateCode] ) {
        bgViewH = 390;
    }
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(25,(SCREEN_H-bgViewH-40)/2,SCREEN_W - 50,bgViewH)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5;
    [self.view addSubview:_bgView];
    
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_bgView.width-50, 10, 40, 40);
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_bgView addSubview:closeBtn];
    
    //点击屏幕缩回键盘
//    UITapGestureRecognizer * tap_closeKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyBoardAction:)];
//    [_bgView addGestureRecognizer:tap_closeKeyBoard];
    //弹出背景
//    QCPopViewController *loginPopoverVC = [[QCPopViewController alloc]initWithContentView:_bgView];
//    self.loginPopoverVC = loginPopoverVC;
//    
//    [loginPopoverVC showInView:self.view position:CZPopViewPositionWindowCeter];
    
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:22];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = btnName;
    
    [_bgView addSubview:_titleLabel];
    _titleLabel.size = [btnName boundingRectWithSize:CGSizeMake(SCREEN_W, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_titleLabel.font,NSFontAttributeName, nil] context:nil].size;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgView.mas_centerX);
        make.top.equalTo(_bgView.mas_top).offset(16);
    }];
    
    //手机输入框
    _phoneTextField = [[QCTextField alloc]initWithFrame:CGRectZero iconName:@"user_black" placeHolderText:@"请输入你的手机号"];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_bgView addSubview:_phoneTextField];
    [_phoneTextField becomeFirstResponder];
    
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(24);
        make.left.equalTo(_bgView.mas_left).offset(20);
        make.right.equalTo(_bgView.mas_right).offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    //验证码
    _SecurityCodeTextField = [[QCTextField alloc]initWithFrame:CGRectZero iconName:@"code" placeHolderText:@"请输入验证码"];
    [_bgView addSubview:_SecurityCodeTextField];
    _SecurityCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_SecurityCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTextField.mas_bottom).offset(12);
        make.left.equalTo(_phoneTextField.mas_left).offset(0);
        make.height.mas_equalTo(@40);
        make.right.equalTo(_phoneTextField.mas_right).offset(-95);
    }];
    //获取验证码
    _getSecurityCodeBtn = [[UIButton alloc ]init];
    [_getSecurityCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getSecurityCodeBtn.titleLabel.textColor = [UIColor whiteColor];
    _getSecurityCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _getSecurityCodeBtn.backgroundColor = UIColorFromRGB(0xEC8686);
    if ([btnName isEqualToString:kFogetCode]) {
        [_getSecurityCodeBtn addTarget:self action:@selector(fogetSecurityCode) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_getSecurityCodeBtn addTarget:self action:@selector(getSecurityCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [_bgView addSubview:_getSecurityCodeBtn];
    [_getSecurityCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SecurityCodeTextField.mas_top).offset(0);
        make.left.equalTo(_SecurityCodeTextField.mas_right).offset(5);
        make.bottom.equalTo(_SecurityCodeTextField.mas_bottom).offset(-0);
        make.right.equalTo(_phoneTextField.mas_right).offset(-0);
    }];
    
    //timeLabel
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.backgroundColor = UIColorFromRGB(0xEC8686);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.hidden = YES;
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SecurityCodeTextField.mas_top).offset(0);
        make.left.equalTo(_SecurityCodeTextField.mas_right).offset(5);
        make.bottom.equalTo(_SecurityCodeTextField.mas_bottom).offset(-0);
        make.right.equalTo(_phoneTextField.mas_right).offset(-0);
    }];
    
    //请输入密码
    if ([btnName isEqualToString:@"忘记密码"] || [btnName isEqualToString:@"更改密码"]) {
        _passWordTextField = [[QCTextField alloc]initWithFrame:CGRectZero iconName:@"key-2_black" placeHolderText:@"请输入新密码"];
    }else{
        _passWordTextField = [[QCTextField alloc]initWithFrame:CGRectZero iconName:@"key-2_black" placeHolderText:@"请输入密码"];
    }
    
//    _passWordTextField.userInteractionEnabled = _SecurityCodeTextField.text.length;
    _passWordTextField.secureTextEntry = YES;
    //    _passWordTextField.textInputMode
    [_bgView addSubview:_passWordTextField];
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SecurityCodeTextField.mas_bottom).offset(24);
        make.left.equalTo(_SecurityCodeTextField.mas_left).offset(0);
        make.height.mas_equalTo(@40);
        make.right.equalTo(_phoneTextField.mas_right).offset(-0);
    }];
    
    //请再次输入密码
    _passWordAgainTextField = [[QCTextField alloc]initWithFrame:CGRectZero iconName:@"key-2_black" placeHolderText:@"请再次输入密码"];
//    _passWordAgainTextField.userInteractionEnabled = _SecurityCodeTextField.text.length;
    _passWordAgainTextField.secureTextEntry = YES;
    [_bgView addSubview:_passWordAgainTextField];
    [_passWordAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordTextField.mas_bottom).offset(12);
        make.left.equalTo(_passWordTextField.mas_left).offset(0);
        make.height.mas_equalTo(@40);
        make.right.equalTo(_passWordTextField.mas_right).offset(-0);
    }];
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextStepBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [nextStepBtn setBackgroundColor:UIColorFromRGB(0xE64545)];
    [nextStepBtn addTarget:self action:@selector(fogotPassWordClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:nextStepBtn];
    if ([btnName isEqualToString:@"忘记密码"] || [btnName isEqualToString:@"更改密码"]) {
        //下一步按钮
        [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextStepBtn.tag = kFogetCodetag;
        [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passWordAgainTextField.mas_bottom).offset(34);
            make.left.equalTo(_phoneTextField.mas_left).offset(0);
            make.right.equalTo(_phoneTextField.mas_right).offset(-0);
            make.height.mas_equalTo(@40);
        }];
    }else if([btnName isEqualToString:@"用户注册"]){
        nextStepBtn.tag = kRegisterCodetag;
        //我已阅读并接受协议
        _ensureProtocolBtn = [[UIButton alloc]init];
        [_ensureProtocolBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
        [_ensureProtocolBtn setImage:[UIImage imageNamed:@"offs"] forState:UIControlStateSelected];
        [_ensureProtocolBtn setTitle:@"我已阅读并接受协议" forState:UIControlStateNormal];
        [_ensureProtocolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _ensureProtocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _ensureProtocolBtn.selected =YES;
        [_ensureProtocolBtn addTarget:self action:@selector(ensureClick) forControlEvents:UIControlEventTouchUpInside];
        self.ensureProtocolBtn = _ensureProtocolBtn;
        [_bgView addSubview:_ensureProtocolBtn];
        _ensureProtocolBtn.size = [_ensureProtocolBtn.titleLabel.text boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_ensureProtocolBtn.titleLabel.font,NSFontAttributeName, nil] context:nil].size;
        [_ensureProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passWordAgainTextField.mas_bottom).offset(16);
            make.left.equalTo(_passWordAgainTextField.mas_left).offset(0);
        }];
        
        //协议按钮
        QCPopoverBtn *_protocolBtn = [[QCPopoverBtn alloc] init];
        [_protocolBtn setTitle:@"《协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_protocolBtn];
        _protocolBtn.size = [_protocolBtn.titleLabel.text boundingRectWithSize:CGSizeMake(50, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_protocolBtn.titleLabel.font,NSFontAttributeName, nil] context:nil].size;
        [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ensureProtocolBtn.mas_top).offset(-5);
            make.left.equalTo(_ensureProtocolBtn.mas_right).offset(12);
        }];
        
        [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_ensureProtocolBtn.mas_bottom).offset(33);
            make.left.equalTo(_phoneTextField.mas_left).offset(0);
            make.right.equalTo(_phoneTextField.mas_right).offset(-0);
            make.height.mas_equalTo(@40);
        }];
    }
    //    代理
    
    _phoneTextField.delegate = self;
    _SecurityCodeTextField.delegate = self;
    _passWordTextField.delegate = self;
    _passWordAgainTextField.delegate = self;
}

/** 初始化登陆页面 ********************************************************************************* */
#pragma mark - 初始化登陆界面
-(void)setupBackgroundLogin{
    //头像
    _avatarBtn = [[UIButton alloc]init];
    [_avatarBtn setImage:imag.image forState:UIControlStateNormal];
    //    [_avatarBtn setImage:[UIImage imageWithColor:[UIColor greenColor] andSize:CGSizeMake(105, 105)] forState:UIControlStateNormal];
    _avatarBtn.imageView.layer.cornerRadius = (WIDTH(self.view)/4+5)/2;
    _avatarBtn.userInteractionEnabled = NO;
    [self.view addSubview:_avatarBtn];
    [_avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(90);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(WIDTH(self.view)/4+5,WIDTH(self.view)/4+5));
    }];
    
    //昵称背景
    _bgNickName = [[UIView alloc]init];
    _bgNickName.backgroundColor = UIColorFromRGB(0xF18B89);
    [self.view addSubview:_bgNickName];
    [_bgNickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-45);
        make.height.mas_equalTo(@40);
        make.top.equalTo(_avatarBtn.mas_bottom).offset(28);
    }];
    
    _nameView = [[UIImageView alloc]init];
    _nameView.image = [UIImage imageNamed:@"user"];
    [_bgNickName addSubview:_nameView];
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgNickName.mas_left).offset(10);
        make.centerY.mas_equalTo(_bgNickName.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18,18));
    }];
    
    _useNameText = [[UITextField alloc]init];
    _useNameText.placeholder = @"请输入账号";
    _useNameText.keyboardType = UIKeyboardTypeNumberPad;
    _useNameText.text = [[ApplicationContext sharedInstance] getUserPhone];
    [_useNameText setValue:UIColorFromRGB(0xf7bfbe) forKeyPath:@"_placeholderLabel.textColor"];
    _useNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _useNameText.textColor = [UIColor whiteColor];
    _useNameText.font = [UIFont systemFontOfSize:17.0f];
    
    [_bgNickName addSubview:_useNameText];
    [_useNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameView.mas_right).offset(15);
        make.right.equalTo(_bgNickName.mas_right).offset(-0);
        make.top.equalTo(_bgNickName.mas_top).offset(0);
        make.bottom.equalTo(_bgNickName.mas_bottom).offset(-0);
    }];
    
    //密码背景
    _bgpassword = [[UIView alloc]init];
    _bgpassword.backgroundColor = UIColorFromRGB(0xF18B89);
    [self.view addSubview:_bgpassword];
    [_bgpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-45);
        make.height.mas_equalTo(@40);
        make.top.equalTo(_bgNickName.mas_bottom).offset(12);
    }];
    
    _passWordView = [[UIImageView alloc]init];
    _passWordView.image = [UIImage imageNamed:@"key-2"];
    [_bgpassword addSubview:_passWordView];
    [_passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgpassword.mas_left).offset(10);
        make.centerY.mas_equalTo(_bgpassword.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18,18));
    }];
    
    //密码框
    _passWordText = [[UITextField alloc]init];
    _passWordText.placeholder = @"请输入密码";
    [_passWordText setValue:UIColorFromRGB(0xf7bfbe) forKeyPath:@"_placeholderLabel.textColor"];
    _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordText.textColor = [UIColor whiteColor];
    _passWordText.font = [UIFont systemFontOfSize:17.0f];
    _passWordText.secureTextEntry = YES;
    
    [_bgpassword addSubview:_passWordText];
    [_passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passWordView.mas_right).offset(15);
        make.right.equalTo(_bgpassword.mas_right).offset(-0);
        make.top.equalTo(_bgpassword.mas_top).offset(0);
        make.bottom.equalTo(_bgpassword.mas_bottom).offset(-0);
    }];
    
    //登陆按钮
    _loginBtn = [[UIButton alloc]init];
    _loginBtn.backgroundColor = UIColorFromRGB(0xE64545);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:UIColorFromRGB(0xF7BEBC) forState:UIControlStateDisabled];
    _loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(45);
        make.right.equalTo(self.view.mas_right).offset(-45);
        make.height.mas_equalTo(@40);
        make.top.equalTo(_bgpassword.mas_bottom).offset(28);
    }];
    
    //底部背景
    _bgBottom = [[UIView alloc]init];
    _bgBottom.backgroundColor = UIColorFromRGB(0x9C303B);
    [self.view addSubview:_bgBottom];
    [_bgBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //忘记密码
    _fogotPassWordBtn = [[UIButton alloc]init];
    
    [_fogotPassWordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_fogotPassWordBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _fogotPassWordBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _fogotPassWordBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _fogotPassWordBtn.tag = 100;
    
    [_fogotPassWordBtn addTarget:self action:@selector(fogotPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [_bgBottom addSubview:_fogotPassWordBtn];
    [_fogotPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgBottom.mas_left).offset(0);
        make.right.equalTo(_bgBottom.mas_right).offset(-SCREEN_W *2/ 3);
        make.top.equalTo(_bgBottom.mas_top).offset(0);
        make.bottom.equalTo(_bgBottom.mas_bottom).offset(0);
    }];
    
    //更改密码
    _updatePWBtn = [[UIButton alloc]init];
    
    [_updatePWBtn setTitle:@"更改密码" forState:UIControlStateNormal];
    [_updatePWBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _updatePWBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _updatePWBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _updatePWBtn.tag  = 101;
    
    [_updatePWBtn addTarget:self action:@selector(fogotPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [_bgBottom addSubview:_updatePWBtn];
    [_updatePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgBottom.mas_left).offset(SCREEN_W / 3);
        make.right.equalTo(_bgBottom.mas_right).offset(-SCREEN_W / 3);
        make.top.equalTo(_bgBottom.mas_top).offset(0);
        make.bottom.equalTo(_bgBottom.mas_bottom).offset(0);
    }];
    
    
    //注册新用户
    _registerBtn = [[UIButton alloc]init];
    [_registerBtn setTitle:@"新用户" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    _registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    [_registerBtn addTarget:self action:@selector(registerNowCount:) forControlEvents:UIControlEventTouchUpInside];
    [_bgBottom addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgBottom.mas_left).offset(SCREEN_W *2/ 3);
        make.right.equalTo(_bgBottom.mas_right).offset(0);
        make.top.equalTo(_bgBottom.mas_top).offset(0);
        make.bottom.equalTo(_bgBottom.mas_bottom).offset(0);
    }];
    
    //    代理
    _useNameText.delegate = self;
    _passWordText.delegate = self;
}




@end
