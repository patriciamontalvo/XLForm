//
//  XLFormRowDescriptor+Validations.h
//  ambulapp-iPhone
//
//  Created by María Patricia Montalvo Dzib on 29/04/16.
//  Copyright © 2016 María Patricia Montalvo Dzib. All rights reserved.
//

#import <XLForm/XLForm.h>

@interface XLFormRowDescriptor (Validations)

- (void)addValidationRequired:(__weak XLFormViewController*)controller messageRequired:(NSString*)textErrorInputEmpty;

@end
