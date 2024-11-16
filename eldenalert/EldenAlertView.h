//
//  EldenAlertView.h
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "TextFieldWithSpacing.h"
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EldenAlertStyle) {
  EldenAlertVictoryStyle,
  EldenAlertDeathStyle
};

@interface EldenAlertView : NSView

@property(nonatomic, strong) NSTextField *textField;
@property(nonatomic, strong) TextFieldWithSpacing *shadowTextField;

- (void)setForeground:(NSString *)text
                 font:(NSFont *)font
                style:(EldenAlertStyle)style;
- (void)setShadow:(NSString *)text
             font:(NSFont *)font
          spacing:(CGFloat)multiplier
            style:(EldenAlertStyle)style;
- (void)setGradientIntensity:(CGFloat)intensity;

@end

NS_ASSUME_NONNULL_END
