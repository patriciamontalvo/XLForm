//
//  UITableViewCell+PopUpError.m
//  ambulapp-iPhone
//
//  Created by María Patricia Montalvo Dzib on 06/04/16.
//  Copyright © 2016 María Patricia Montalvo Dzib. All rights reserved.
//

#import "UITableViewCell+PopUpError.h"
#import <objc/runtime.h>

static const void* kPopTipKey = &kPopTipKey;
static const void* kErrorButton = &kErrorButton;
static const void* kErrorMessage = &kErrorMessage;


@implementation XLFormBaseCell (PopUpError)

-(void) showErrorIconForMsg:(NSString *)msg{
    objc_setAssociatedObject(self, kErrorMessage, msg, OBJC_ASSOCIATION_RETAIN);
    
    AMPopTip* popTip = objc_getAssociatedObject(self, kPopTipKey);
    if (!popTip) {
        popTip = [AMPopTip popTip];
        popTip.shouldDismissOnTap = YES;
        popTip.shouldDismissOnTapOutside = YES;
        objc_setAssociatedObject(self, kPopTipKey, popTip, OBJC_ASSOCIATION_RETAIN);
    }
    
    UIButton* button = objc_getAssociatedObject(self, kErrorButton);
    if (button) {
        [button removeFromSuperview];
        objc_setAssociatedObject(self, kErrorButton, nil, OBJC_ASSOCIATION_ASSIGN);
    }
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50,
                                                        (self.frame.size.height - 25) / 2.0,
                                                        25,
                                                        25)];
    objc_setAssociatedObject(self, kErrorButton, button, OBJC_ASSOCIATION_RETAIN);
    
    [button addTarget:self action:@selector(PopUpError_tapOnErrorButton) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    [self addSubview:button];
    [self animateCell];
}

-(void) PopUpError_clear {
    UIButton* button = objc_getAssociatedObject(self, kErrorButton);
    [button removeFromSuperview];
    objc_setAssociatedObject(self, kPopTipKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, kErrorButton, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, kErrorMessage, nil, OBJC_ASSOCIATION_ASSIGN);
    
}

-(void) PopUpError_tapOnErrorButton {
    AMPopTip* popTip = objc_getAssociatedObject(self, kPopTipKey);
    UIButton* button = objc_getAssociatedObject(self, kErrorButton);
    NSString* errorMessage = objc_getAssociatedObject(self, kErrorMessage);
    if (popTip && button && errorMessage) {
        [popTip showText:errorMessage
               direction:AMPopTipDirectionLeft
                maxWidth:self.frame.size.width
                  inView:self
               fromFrame:button.frame
                duration:3];
    }
    
    popTip.dismissHandler = ^{
        //[self PopUpError_clear];
    };
}


-(void)animateCell{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [self.layer addAnimation:animation forKey:@"shake"];
}

@end
