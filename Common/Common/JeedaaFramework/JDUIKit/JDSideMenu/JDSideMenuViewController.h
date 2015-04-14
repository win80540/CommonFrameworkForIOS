//
//  JDLeftMenuViewController.h
//  qinyuan
//
//  Created by 田凯 on 15/3/11.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDSideMenuView.h"
@interface JDSideMenuViewController :UIViewController 
@property (strong,nonatomic) UIViewController *leftMenuController;
//@property (strong,nonatomic) UIViewController *rightMenuController;
@property (strong,nonatomic) UIViewController *mainController;
-(void)setBackgroundImage:(UIImage *)image;
-(void)hidenMenu;
-(void)showMenu;
@end



