//
//  TextFieldWithSpacing.h
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldWithSpacing : NSTextField
- (void)animateSpacingFromValue:(CGFloat)fromValue
                        toValue:(CGFloat)toValue
                       duration:(CGFloat)duration
                       onScreen:(NSScreen *)screen;
@end

NS_ASSUME_NONNULL_END
