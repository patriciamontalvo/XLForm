//
//  CustomSelectionCell.h
//  ambulapp-iPhone
//
//  Created by María Patricia Montalvo Dzib on 27/06/16.
//  Copyright © 2016 María Patricia Montalvo Dzib. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString * const XLFormRowDescriptorTypeCustomSelectionCell;

@interface CustomSelectionCell : XLFormBaseCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *valueText;
@property (nonatomic, strong) IBOutlet UIView *selection;

@end


