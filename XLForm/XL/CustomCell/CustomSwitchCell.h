//
//  CustomSwitchCell.h
//  ambulapp-iPhone
//
//  Created by Patricia on 21/07/17.
//  Copyright © 2017 María Patricia Montalvo Dzib. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString * const XLFormRowDescriptorTypeCustomSwitchCell;

@interface CustomSwitchCell : XLFormBaseCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UISwitch *customSwitch;

@end
