//
//  CustomSelectionCell.m
//  ambulapp-iPhone
//
//  Created by María Patricia Montalvo Dzib on 27/06/16.
//  Copyright © 2016 María Patricia Montalvo Dzib. All rights reserved.
//

#import "CustomSelectionCell.h"

@implementation CustomSelectionCell

//XLForm.bundle/forwardarrow.png
NSString * const XLFormRowDescriptorTypeCustomSelectionCell = @"XLFormRowDescriptorTypeCustomSelectionCell";

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:@"XLForm.bundle/CustomSelectionCell.xib" forKey:XLFormRowDescriptorTypeCustomSelectionCell];
}

- (void)configure
{
    [super configure];
    self.accessoryType = UITableViewCellAccessoryNone;
    
    CGFloat borderWidth = 2.0f;
    
    self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
    self.selection.layer.borderColor = self.tintColor.CGColor;
    self.selection.layer.borderWidth = borderWidth;
    self.selection.backgroundColor = [UIColor whiteColor];
    
}

- (void)update
{
    [super update];
    
    [self tokenizeTitle];
    self.selection.backgroundColor = [self.rowDescriptor.value boolValue] ? self.tintColor : [UIColor whiteColor];
}
- (void)tokenizeTitle{
    NSString *string = self.rowDescriptor.title;
    NSArray *fields = [string componentsSeparatedByString: @"|"];
    if ([fields count] == 2) {
        self.title.text = [fields objectAtIndex:0];
        self.valueText.text = [fields objectAtIndex:1];
    }
}
//

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor{
    return 80.0;
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    self.selection.backgroundColor = self.tintColor;
    self.rowDescriptor.value = [NSNumber numberWithBool:![self.rowDescriptor.value boolValue]];
    [self.formViewController updateFormRow:self.rowDescriptor];
  //  [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
