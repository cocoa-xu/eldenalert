//
//  TextFieldWithSpacing.m
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "TextFieldWithSpacing.h"
#import <CoreVideo/CoreVideo.h>

@implementation TextFieldWithSpacing {
  CVDisplayLinkRef _displayLink;
  CGFloat _currentSpacing;
  CGFloat _targetSpacing;
  CGFloat _startSpacing;
  CGFloat _duration;
  NSTimeInterval _startTime;
}

static CVReturn
DisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp *now,
                    const CVTimeStamp *outputTime, CVOptionFlags flagsIn,
                    CVOptionFlags *flagsOut, void *displayLinkContext) {
  TextFieldWithSpacing *self =
      (__bridge TextFieldWithSpacing *)displayLinkContext;
  dispatch_async(dispatch_get_main_queue(), ^{
    [self updateSpacing];
  });
  return kCVReturnSuccess;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    _currentSpacing = 0;
  }
  return self;
}

- (void)animateSpacingFromValue:(CGFloat)fromValue
                        toValue:(CGFloat)toValue
                       duration:(CGFloat)duration
                       onScreen:(NSScreen *)screen {
  if (_displayLink) {
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
    _displayLink = NULL;
  }

  _startSpacing = fromValue;
  _targetSpacing = toValue;
  _duration = duration;
  _startTime = [NSDate timeIntervalSinceReferenceDate];

  NSDictionary *description = [screen deviceDescription];
  NSNumber *screenID = description[@"NSScreenNumber"];
  CGDirectDisplayID displayID = [screenID unsignedIntValue];

  CVReturn error = CVDisplayLinkCreateWithCGDisplay(displayID, &_displayLink);
  if (error != kCVReturnSuccess) {
    NSLog(@"Failed to create display link: %d", error);
    return;
  }

  // Configure for best performance
  CVDisplayLinkSetCurrentCGDisplay(_displayLink, displayID);

  CVDisplayLinkSetOutputCallback(_displayLink, DisplayLinkCallback,
                                 (__bridge void *)self);
  CVDisplayLinkStart(_displayLink);
}

- (void)updateSpacing {
  NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
  CGFloat progress = (currentTime - _startTime) / _duration;

  if (progress >= 1.0) {
    _currentSpacing = _targetSpacing;
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
    _displayLink = NULL;
  } else {
    _currentSpacing =
        _startSpacing + (_targetSpacing - _startSpacing) * progress;
  }

  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
      initWithAttributedString:self.attributedStringValue];
  [attrString addAttribute:NSKernAttributeName
                     value:@(_currentSpacing)
                     range:NSMakeRange(0, attrString.length)];
  self.attributedStringValue = attrString;
}

- (void)dealloc {
  if (_displayLink) {
    CVDisplayLinkStop(_displayLink);
    CVDisplayLinkRelease(_displayLink);
  }
}

@end
