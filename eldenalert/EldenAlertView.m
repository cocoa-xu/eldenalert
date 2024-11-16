//
//  EldenAlertView.m
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "EldenAlertView.h"
#import "FontManager.h"
#import "GradientView.h"

@interface EldenAlertView ()

@property(nonatomic, strong) GradientView *gradientView;

@end

@implementation EldenAlertView

@synthesize textField;
@synthesize shadowTextField;

- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    [self setupGradientTextField];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setupGradientTextField];
  }
  return self;
}

- (void)setupGradientTextField {
  self.gradientView = [[GradientView alloc] initWithFrame:self.bounds];
  self.gradientView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  [self addSubview:self.gradientView positioned:NSWindowBelow relativeTo:nil];

  self.textField = [[NSTextField alloc] initWithFrame:self.bounds];
  [self setupTextField:self.textField];

  self.shadowTextField =
      [[TextFieldWithSpacing alloc] initWithFrame:self.bounds];
  [self setupTextField:self.shadowTextField];

  [self addSubview:self.shadowTextField];
  [self addSubview:self.textField];
}

- (void)setupTextField:(NSTextField *)textField {
  textField.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
  textField.backgroundColor = [NSColor clearColor];
  textField.bezeled = NO;
  textField.editable = NO;
  textField.selectable = NO;
  textField.drawsBackground = NO;
  textField.alignment = NSTextAlignmentCenter;
  textField.textColor = [NSColor whiteColor];
  textField.cell.scrollable = NO;
  textField.cell.wraps = NO;
  textField.cell.lineBreakMode = NSLineBreakByClipping;
}

- (void)setFrame:(NSRect)frame {
  [super setFrame:frame];
  self.gradientView.frame = NSMakeRect(0, -(frame.size.height / 2),
                                       frame.size.width, frame.size.height * 2);
}

- (void)setGradientIntensity:(CGFloat)intensity {
  self.gradientView.intensity = intensity;
  self.gradientView.needsDisplay = YES;
}

- (void)setForeground:(NSString *)text
                 font:(NSFont *)font
                style:(EldenAlertStyle)style {
  NSColor *foregroundTextColor = nil;
  switch (style) {
  case EldenAlertDeathStyle:
    foregroundTextColor = [NSColor colorNamed:@"DeathForeground"];
    break;

  default:
    foregroundTextColor = [NSColor colorNamed:@"VictoryForeground"];
    break;
  }

  self.textField.font = font;
  self.textField.textColor = foregroundTextColor;
  self.textField.stringValue = text;
}

- (void)setShadow:(NSString *)text
             font:(NSFont *)font
          spacing:(CGFloat)multiplier
            style:(EldenAlertStyle)style {
  NSColor *shadowTextColor = [NSColor colorNamed:@"VictoryShadow"];

  NSMutableParagraphStyle *paragraphStyle =
      [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  NSDictionary *attributes = @{
    NSParagraphStyleAttributeName : paragraphStyle,
    NSKernAttributeName : @(font.pointSize * multiplier),
    NSForegroundColorAttributeName : shadowTextColor,
    NSFontAttributeName : font
  };

  NSAttributedString *attributedString =
      [[NSAttributedString alloc] initWithString:text attributes:attributes];
  [self.shadowTextField setAttributedStringValue:attributedString];
}

@end
