//
//  UITableViewCell+PopUpError.h
//  ambulapp-iPhone
//
//  Created by María Patricia Montalvo Dzib on 06/04/16.
//  Copyright © 2016 María Patricia Montalvo Dzib. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>
#import <AMPopTip/AMPopTip.h>

@interface XLFormBaseCell (PopUpError)
-(void)showErrorIconForMsg:(NSString *)msg;
-(void) PopUpError_clear;
@end
