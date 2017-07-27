//
//  CustomSwitchCell.m
//  ambulapp-iPhone
//
//  Created by Patricia on 21/07/17.
//  Copyright © 2017 María Patricia Montalvo Dzib. All rights reserved.
//

#import "CustomSwitchCell.h"

@implementation CustomSwitchCell



+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"CustomSwitchCell" forKey:XLFormRowDescriptorTypeCustomSwitchCell];
}

#pragma mark - XLFormDescriptorCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.customSwitch.transform = CGAffineTransformMakeScale(1.5, 1.5);
   
    self.editingAccessoryView = self.accessoryView;
    [self.customSwitch addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    //self.textLabel.text = self.rowDescriptor.title;
    self.title.text = self.rowDescriptor.title;
    self.customSwitch.on = [self.rowDescriptor.value boolValue];
    self.customSwitch.enabled = !self.rowDescriptor.isDisabled;
}


- (void)valueChanged
{
    self.rowDescriptor.value = @(self.customSwitch.on);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 75;
}

@end
