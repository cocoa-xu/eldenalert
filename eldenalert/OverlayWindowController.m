//
//  OverlayWindowController.m
//  elderalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "OverlayWindowController.h"
#import "FontManager.h"

@implementation OverlayWindowController {
  id _eventMonitor;
  NSScreen *_screen;
}

- (instancetype)initWithScreen:(NSScreen *)screen {
  NSRect screenFrame = screen.frame;
  OverlayWindow *overlayWindow =
      [[OverlayWindow alloc] initWithContentRect:screenFrame
                                       styleMask:NSWindowStyleMaskBorderless
                                         backing:NSBackingStoreBuffered
                                           defer:NO];

  self = [super initWithWindow:overlayWindow];
  _screen = screen;
  if (self) {
    overlayWindow.backgroundColor = [NSColor colorWithWhite:0.0 alpha:0.0];
    overlayWindow.opaque = NO;
    overlayWindow.hasShadow = NO;
    overlayWindow.level = CGShieldingWindowLevel() + 19;
    overlayWindow.collectionBehavior =
        NSWindowCollectionBehaviorCanJoinAllSpaces |
        NSWindowCollectionBehaviorStationary |
        NSWindowCollectionBehaviorFullScreenPrimary |
        NSWindowCollectionBehaviorIgnoresCycle;
    overlayWindow.hidesOnDeactivate = NO;
    overlayWindow.ignoresMouseEvents = YES;

    _alertView = [[EldenAlertView alloc] init];
    [overlayWindow.contentView addSubview:_alertView];
    [overlayWindow setFrameTopLeftPoint:NSMakePoint(0, NSHeight(screenFrame))];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(windowDidResignKey:)
               name:NSWindowDidResignKeyNotification
             object:overlayWindow];

    _eventMonitor = [NSEvent
        addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown
                                     handler:^NSEvent *(NSEvent *event) {
                                       if (event.keyCode == 53) {
                                         [self hideOverlay:^{
                                           [NSApp terminate:nil];
                                         }];
                                         return nil;
                                       }
                                       return event;
                                     }];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (_eventMonitor) {
    [NSEvent removeMonitor:_eventMonitor];
    _eventMonitor = nil;
  }
}

- (void)windowDidResignKey:(id)_ {
}

- (void)showAlert:(NSString *)text
                style:(EldenAlertStyle)style
              dismiss:(NSTimeInterval)after
    completionHandler:(nullable void (^)(void))completionHandler {
  if (![NSThread isMainThread]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self showAlert:text
                      style:style
                    dismiss:after
          completionHandler:completionHandler];
    });
    return;
  }

  NSWindow *window = self.window;
  if (!window || window.isVisible) {
    return;
  }

  window.alphaValue = 0.0;
  NSRect screenFrame = _screen.visibleFrame;
  [window setFrame:screenFrame display:NO];
  CGFloat textFieldHeight = (int)(screenFrame.size.height * 0.06);
  NSFont *font =
      [[FontManager shared] agmenaProRegularWithSize:textFieldHeight];
  [_alertView setForeground:text font:font style:style];
  if (style == EldenAlertVictoryStyle) {
    [_alertView setShadow:text font:font spacing:0.03 style:style];
  } else {
    [_alertView setShadow:@"" font:font spacing:0.03 style:style];
  }

  [window makeKeyAndOrderFront:nil];

  NSRect textFieldFrame =
      NSMakeRect(0, 0, screenFrame.size.width, textFieldHeight);
  NSRect contentFrame = self.window.contentView.frame;
  NSPoint centerPoint =
      NSMakePoint(NSMidX(contentFrame) - (NSWidth(textFieldFrame) / 2),
                  NSMidY(contentFrame) - (NSHeight(textFieldFrame) / 2));
  _alertView.frame = textFieldFrame;
  _alertView.frameOrigin = centerPoint;

  [NSAnimationContext
      runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        window.animator.alphaValue = 1.0;

        if (style == EldenAlertVictoryStyle) {
          CGFloat from = font.pointSize * 0.03;
          CGFloat to = font.pointSize * 0.07;
          [_alertView.shadowTextField animateSpacingFromValue:from
                                                      toValue:to
                                                     duration:after
                                                     onScreen:_screen];
        }
      }
      completionHandler:^{
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
              [self hideOverlay:completionHandler];
            });
      }];
}

- (void)hideOverlay:(nullable void (^)(void))completionHandler {
  if (![NSThread isMainThread]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self hideOverlay:completionHandler];
    });
    return;
  }

  [NSAnimationContext
      runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        self.window.animator.alphaValue = 0.0;
      }
      completionHandler:^{
        [self.window orderOut:nil];
        if (completionHandler) {
          completionHandler();
        }
      }];
}

@end
