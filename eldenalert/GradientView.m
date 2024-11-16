//
//  GradientView.m
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "GradientView.h"

@implementation GradientView

- (instancetype)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _intensity = 0.6;
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];

  NSRect bounds = self.bounds;
  CGFloat totalHeight = NSHeight(bounds);
  CGFloat transitionHeight = (int)(totalHeight * 0.2);
  CGFloat middleHeight = (int)(totalHeight * 0.5);

  NSColor *start = [NSColor colorWithWhite:0.0 alpha:0.0];
  NSColor *end = [NSColor colorWithWhite:0.0 alpha:self.intensity];
  NSGradient *topGradient = [[NSGradient alloc] initWithStartingColor:start
                                                          endingColor:end];

  [topGradient drawInRect:NSMakeRect(0, middleHeight + transitionHeight,
                                     NSWidth(bounds), transitionHeight)
                    angle:-90];

  [[NSColor colorWithWhite:0.0 alpha:self.intensity] setFill];
  NSRectFill(NSMakeRect(0, transitionHeight, NSWidth(bounds), middleHeight));

  [topGradient drawInRect:NSMakeRect(0, 0, NSWidth(bounds), transitionHeight)
                    angle:90];
}

@end
