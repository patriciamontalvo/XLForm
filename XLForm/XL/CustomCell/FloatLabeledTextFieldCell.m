//  FloatLabeledTextFieldCell.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FloatLabeledTextFieldCell.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>


const static CGFloat kVMargin = 8.0f;
const static CGFloat kJLabelFontSize = 16.0f;
const static CGFloat kFloatingLabelFontSize = 11.0f;
const static CGFloat kFloatingLabelFontSizeMin = 10.0f;

@interface FloatLabeledTextFieldCell () <UITextFieldDelegate>
@property (nonatomic) JVFloatLabeledTextField * floatLabeledTextField;
@end

@implementation FloatLabeledTextFieldCell

@synthesize floatLabeledTextField =_floatLabeledTextField;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[FloatLabeledTextFieldCell class] forKey:XLFormRowDescriptorTypeFloatLabeledTextField];
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[FloatLabeledTextFieldCell class] forKey: XLFormRowDescriptorTypeFloatLabeledEmailField];
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[FloatLabeledTextFieldCell class] forKey:XLFormRowDescriptorTypeFloatLabeledPasswordField];
    
}

-(JVFloatLabeledTextField *)floatLabeledTextField
{
    if (_floatLabeledTextField) return _floatLabeledTextField;
    
    _floatLabeledTextField = [JVFloatLabeledTextField autolayoutView];
    _floatLabeledTextField.font = [UIFont systemFontOfSize:kJLabelFontSize];
    _floatLabeledTextField.floatingLabel.font = [UIFont boldSystemFontOfSize:kFloatingLabelFontSize];

    _floatLabeledTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [_floatLabeledTextField setAdjustsFontSizeToFitWidth:YES];
    [_floatLabeledTextField setMinimumFontSize:kFloatingLabelFontSizeMin];
    
    return _floatLabeledTextField;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.floatLabeledTextField];
    [self.floatLabeledTextField setDelegate:self];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self.floatLabeledTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)update
{
    [super update];
    self.floatLabeledTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:self.rowDescriptor.title
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
   
    
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeFloatLabeledTextField]){
        self.floatLabeledTextField.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.floatLabeledTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.floatLabeledTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeFloatLabeledEmailField]){
        self.floatLabeledTextField.keyboardType = UIKeyboardTypeEmailAddress;
        self.floatLabeledTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.floatLabeledTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeFloatLabeledPasswordField]){
        self.floatLabeledTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.floatLabeledTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.floatLabeledTextField.keyboardType = UIKeyboardTypeASCIICapable;
        self.floatLabeledTextField.secureTextEntry = YES;
    }

    
    self.floatLabeledTextField.text = self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText;
    [self.floatLabeledTextField setEnabled:!self.rowDescriptor.isDisabled];
    
    self.floatLabeledTextField.floatingLabelTextColor = [UIColor whiteColor];
    
    [self.floatLabeledTextField setAlpha:((self.rowDescriptor.isDisabled) ? .6 : 1)];
    self.floatLabeledTextField.text = self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText;
    
}

- (CGFloat)requiredFontSize{
    const CGRect  textBounds = [self.floatLabeledTextField textRectForBounds: self.floatLabeledTextField.frame];
    const CGFloat maxWidth   = textBounds.size.width;
    
    UIFont* font     = self.floatLabeledTextField.font;
    CGFloat fontSize = kFloatingLabelFontSize;
    
    BOOL found = NO;
    do{
        if( font.pointSize != fontSize ) {
            font = [font fontWithSize: fontSize];
        }
        
        NSDictionary *attributes = @{NSFontAttributeName: font};
        
        CGSize size = [self.floatLabeledTextField.text sizeWithAttributes:attributes];
        if( size.width <= maxWidth ){
            found = YES;
            break;
        }
        
        fontSize -= 1.0;
        if( fontSize < kFloatingLabelFontSizeMin ){
            fontSize = kFloatingLabelFontSizeMin;
            break;
        }
        
    } while( TRUE );
    NSLog(@"Font %f", fontSize);
    return( fontSize );
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.isDisabled;
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.floatLabeledTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return [self.formViewController textFieldShouldEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.formViewController textFieldDidBeginEditing:textField];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self textFieldDidChange:textField];
    [self.formViewController textFieldDidEndEditing:textField];
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType{
    self.floatLabeledTextField.returnKeyType = returnKeyType;
}

-(UIReturnKeyType)returnKeyType{
    return self.floatLabeledTextField.returnKeyType;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 55;
}



-(NSArray *)layoutConstraints
{
    NSMutableArray * result = [[NSMutableArray alloc] init];

    NSDictionary * views = @{@"floatLabeledTextField": self.floatLabeledTextField};
    NSDictionary *metrics = @{@"vMargin":@(kVMargin)};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[floatLabeledTextField]-|"
                                                                                               options:0
                                                                                               metrics:metrics
                                                                                                 views:views]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|"
                                                                                               options:0
                                                                                               metrics:metrics
                                                                                                 views:views]];
    return result;
}

#pragma mark - Helpers

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.floatLabeledTextField == textField) {
        if ([self.floatLabeledTextField.text length] > 0) {
           /* CGFloat requiredFontSize = [self requiredFontSize];
            if( self.floatLabeledTextField.font.pointSize != requiredFontSize ){
                self.floatLabeledTextField.font = [self.floatLabeledTextField.font fontWithSize:requiredFontSize];
            }*/
            self.rowDescriptor.value = self.floatLabeledTextField.text;
        } else {
            self.rowDescriptor.value = nil;
        }
    }
}



@end
