//
//  AutoCompleteTextViewCell.m
//  XLForm
//
//  Created by Josejulio Martínez on 30/05/17.
//  Copyright © 2017 Xmartlabs. All rights reserved.
//

#import "AutoCompleteTextViewCell.h"
#import <ARAutocompleteTextView/ARAutoCompleteWordsTextView.h>

NSString * const XLFormRowDescriptorTypeAutoCompleteTextView = @"XLFormRowDescriptorTypeAutoCompleteTextView";

@interface AutoCompleteTextViewCell () <UITextViewDelegate>{
     NSMutableArray * _dynamicCustomConstraints;
    
}
@property (nonatomic) ARAutoCompleteWordsTextView * autocompleteTextView;
@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic) NSNumber *textViewLengthPercentage;
@property (nonatomic, strong) NSMutableArray* wordsAutocomplete;



@end

@implementation AutoCompleteTextViewCell
@synthesize autocompleteTextView =_autocompleteTextView;
@synthesize textLabel = _textLabel;
@synthesize wordsAutocomplete = _wordsAutocomplete;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[AutoCompleteTextViewCell class] forKey:XLFormRowDescriptorTypeAutoCompleteTextView];
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dynamicCustomConstraints = [NSMutableArray array];
        _wordsAutocomplete = [NSMutableArray array];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.textLabel && [keyPath isEqualToString:@"text"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self needsUpdateConstraints];
        }
    }
}

#pragma mark - properties
-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    [_textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    return _textLabel;
}

-(UILabel *)label
{
    return self.textLabel;
}

-(ARAutoCompleteWordsTextView*)autocompleteTextView
{
    if (_autocompleteTextView) return _autocompleteTextView;
    
    _autocompleteTextView = [ARAutoCompleteWordsTextView autolayoutView];
    return _autocompleteTextView;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.autocompleteTextView];
    

    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    NSDictionary * views = @{@"label": self.textLabel, @"textView": self.autocompleteTextView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]" options:0 metrics:0 views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.autocompleteTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.autocompleteTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textView]-0-|" options:0 metrics:0 views:views]];
}

-(void)update
{
    [super update];
    self.autocompleteTextView.autocomplete = self.rowDescriptor.wordsAutocomplete;
    self.autocompleteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.autocompleteTextView.delegate = self;
    self.autocompleteTextView.keyboardType = UIKeyboardTypeDefault;
    self.autocompleteTextView.text = self.rowDescriptor.value;
    [self.autocompleteTextView setEditable:!self.rowDescriptor.isDisabled];
    self.autocompleteTextView.textColor  = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title]: self.rowDescriptor.title);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 110.f;
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.autocompleteTextView becomeFirstResponder];
}

-(void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    [self.formViewController updateFormRow:self.rowDescriptor];
}

#pragma mark - Constraints

-(void)updateConstraints
{
    if (_dynamicCustomConstraints){
        [self.contentView removeConstraints:_dynamicCustomConstraints];
        [_dynamicCustomConstraints removeAllObjects];
    }
    NSDictionary * views = @{@"label": self.textLabel, @"textView": self.autocompleteTextView};
    if (!self.textLabel.text || [self.textLabel.text isEqualToString:@""]){
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:0 views:views]];
    }
    else{
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textView]-|" options:0 metrics:0 views:views]];
        if (self.textViewLengthPercentage) {
            [_dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_autocompleteTextView
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeWidth
                                                                             multiplier:[self.textViewLengthPercentage floatValue]
                                                                               constant:0.0]];
        }
    }
    [self.contentView addConstraints:_dynamicCustomConstraints];
    [super updateConstraints];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.formViewController beginEditing:self.rowDescriptor];
    return [self.formViewController textViewDidBeginEditing:textView];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.autocompleteTextView.text length] > 0) {
        self.rowDescriptor.value = self.autocompleteTextView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
    [self.formViewController endEditing:self.rowDescriptor];
    [self.formViewController textViewDidEndEditing:textView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return [self.formViewController textViewShouldBeginEditing:textView];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([self.autocompleteTextView.text length] > 0) {
        self.rowDescriptor.value = self.autocompleteTextView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [self.formViewController textView:textView shouldChangeTextInRange:range replacementText:text];
}


@end
