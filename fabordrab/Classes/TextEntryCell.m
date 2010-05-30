//
//  TextEntryCell.m
//  fabordrab
//
//  Created by Mark Sands on 5/29/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TextEntryCell.h"

@implementation TextEntryCell

@synthesize label, textField;

@dynamic delegate;

- (void)dealloc {
  [label release];
  [textField release];
  [super dealloc];
}

#pragma mark Event-handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  [self.textField becomeFirstResponder];
}

#pragma mark UITextInputTraits property methods

- (UITextAutocapitalizationType)autocapitalizationType {
  return self.textField.autocapitalizationType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)type {
  self.textField.autocapitalizationType = type;
}

- (UITextAutocorrectionType)autocorrectionType {
  return self.textField.autocorrectionType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)type {
  self.textField.autocorrectionType = type;
}

- (BOOL)enablesReturnKeyAutomatically {
  return self.textField.enablesReturnKeyAutomatically;
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enabled {
  self.textField.enablesReturnKeyAutomatically = enabled;
}

- (UIKeyboardAppearance)keyboardAppearance {
  return self.textField.keyboardAppearance;
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)appearance {
  self.textField.keyboardAppearance = appearance;
}

- (UIKeyboardType)keyboardType {
  return self.textField.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)type {
  self.textField.keyboardType = type;
}

- (UIReturnKeyType)returnKeyType {
  return self.textField.returnKeyType;
}

- (void)setReturnKeyType:(UIReturnKeyType)type {
  self.textField.returnKeyType = type;
}

- (BOOL)secureTextEntry {
  return self.textField.secureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)flag {
  self.textField.secureTextEntry = flag;
}

#pragma mark Instance methods

- (NSString *)text {
  return textField.text;
}

- (void)becomeFirstResponder {
  [self.textField becomeFirstResponder];
}

- (void)resignFirstResponder {
  [self.textField resignFirstResponder];
}

- (id<UITextFieldDelegate>)delegate {
  return self.textField.delegate;
}

- (void)setDelegate:(id<UITextFieldDelegate>)aDelegate {
  self.textField.delegate = aDelegate;
}

@end
