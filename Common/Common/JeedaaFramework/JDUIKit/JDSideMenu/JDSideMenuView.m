//
//  JDSideMenuView.m
//  qinyuan
//
//  Created by 田凯 on 15/3/12.
//  Copyright (c) 2015年 田凯. All rights reserved.
//

#import "JDSideMenuView.h"

@implementation JDSideMenuView
-(id)initWithCoder:(NSCoder *)aDecoder{
   self = [super initWithCoder:aDecoder];
    if (self) {
         [self initSelf];
    }
    return self;
}
-(id)init{
   self = [super init];
    if (self) {
         [self initSelf];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}
-(void)initSelf{

}
-(void)setContentView:(UIView *)contentView{
   if(_contentView!=contentView)
   {
       [_contentView removeFromSuperview];
       [self addSubview:contentView];
       _contentView=contentView;
       //_contentView.frame=CGRectMake(20, 20, CGRectGetWidth(self.bounds)-40, CGRectGetHeight(self.bounds)-40);
       _contentView.frame=self.bounds;
   }
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if (_contentView) {
        _contentView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
