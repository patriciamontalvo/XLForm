//
//  XLFormValidateDatePicker.h
//  ambulapp-iPhone
//
//  Created by Patricia on 13/07/17.
//  Copyright © 2017 María Patricia Montalvo Dzib. All rights reserved.
//


#import "XLFormValidatorProtocol.h"

@interface XLFormValidateDatePicker  : XLFormValidator

@property NSString *msg;
@property NSInteger year;

- (id)initWithMsg:(NSString*)msg andYearCheck:(NSInteger)year;

+(XLFormValidator *)yearValidator;

@end
