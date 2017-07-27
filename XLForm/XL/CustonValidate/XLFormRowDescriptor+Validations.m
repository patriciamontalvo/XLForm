//
//  XLFormRowDescriptor+Validations.m
//  ambulapp-iPhone
//
//  Created by María Patricia Montalvo Dzib on 29/04/16.
//  Copyright © 2016 María Patricia Montalvo Dzib. All rights reserved.
//

#import "XLFormRowDescriptor+Validations.h"
#import "UITableViewCell+PopUpError.h"

@implementation XLFormRowDescriptor (Validations)

- (void)addValidationRequired:(__weak XLFormViewController*)controller messageRequired:(NSString*)textErrorInputEmpty{
    [self.cellConfig setObject:[UIColor blueColor] forKey:@"textLabel.textColor"];
    [self setRequired:YES];
    [self setRequireMsg:textErrorInputEmpty];
    self.onChangeBlock = ^(NSString* oldValue,NSString* newValue,XLFormRowDescriptor* rowDescriptor) {
        if ( ![oldValue isEqual:[NSNull null]] && ![newValue isEqual:[NSNull null]]) {
            XLFormTextFieldCell *cell = [controller.tableView cellForRowAtIndexPath:[controller.form indexPathOfFormRow:rowDescriptor]];
            [cell PopUpError_clear];
        }
    };
}

@end
