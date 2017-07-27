//
//  XLFormValidateDatePicker.m
//  ambulapp-iPhone
//
//  Created by Patricia on 13/07/17.
//  Copyright © 2017 María Patricia Montalvo Dzib. All rights reserved.
//


#import "XLFormValidationStatus.h"
#import "XLFormRegexValidator.h"
#import "XLFormValidateDatePicker.h"

@implementation XLFormValidateDatePicker

- (id)initWithMsg:(NSString*)msg andYearCheck:(NSInteger)year {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.year = year;
    }
    
    return self;
}


-(XLFormValidationStatus *)isValid:(XLFormRowDescriptor *)row
{
    
    if (row != nil && row.value != nil) {
        
        NSDate *value = row.value;
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger years = [[gregorian components:NSCalendarUnitYear fromDate:value  toDate:[NSDate date] options:0] year];
        
        if (years < self.year) {
            return [XLFormValidationStatus formValidationStatusWithMsg:self.msg status:NO rowDescriptor:row];
        }else{
            return [XLFormValidationStatus formValidationStatusWithMsg:self.msg status:YES rowDescriptor:row];
        }
        
    }
    return [XLFormValidationStatus formValidationStatusWithMsg:nil status:NO rowDescriptor:row];
    
}

#pragma mark - Validators


+(XLFormValidator *)yearValidator
{
    return  [[XLFormValidateDatePicker alloc] initWithMsg:NSLocalizedString(@"Debes tener 18 años", nil) andYearCheck:18];
}

@end
