//
//  AppDelegate.m
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "AppDelegate.h"
#import "FontManager.h"
#import "OverlayWindowController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
  [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];

  [[FontManager shared] registerFonts];

  NSMutableArray *screens =
      [[NSMutableArray alloc] initWithArray:@[ [NSScreen mainScreen] ]];
  NSArray *args = [[NSProcessInfo processInfo] arguments];
  NSString *text = nil;
  EldenAlertStyle style = EldenAlertVictoryStyle;
  int dismiss = 3;
  BOOL playSound = YES;
  for (NSUInteger i = 0; i < args.count; i++) {
    if ((i + 1) < args.count) {
      if ([@"-text" isEqualToString:args[i]]) {
        text = args[i + 1];
        i++;
      } else if ([@"-style" isEqualToString:args[i]]) {
        if ([@"death" isEqualToString:args[i + 1]]) {
          style = EldenAlertDeathStyle;
        }
        i++;
      } else if ([@"-dismiss" isEqualToString:args[i]]) {
        dismiss = [(NSString *)args[i + 1] intValue];
        i++;
      } else if ([@"-screen" isEqualToString:args[i]]) {
        if ([(NSString *)args[i + 1] isEqualToString:@"all"]) {
          screens = [[NSMutableArray alloc] initWithArray:[NSScreen screens]];
        }
        i++;
      } else if ([@"-sound" isEqualToString:args[i]]) {
        if ([(NSString *)args[i + 1] isEqualToString:@"off"]) {
          playSound = NO;
        }
        i++;
      }
    }
  }

  if (text != nil) {
    if (playSound) {
      SystemSoundID soundID;
      NSString *soundFile;
      if (style == EldenAlertDeathStyle) {
        soundFile = [[NSBundle mainBundle] pathForResource:@"death"
                                                    ofType:@"m4a"];
      } else {
        soundFile = [[NSBundle mainBundle] pathForResource:@"victory"
                                                    ofType:@"m4a"];
      }
      AudioServicesCreateSystemSoundID(
          (__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
      AudioServicesPlaySystemSound(soundID);
    }

    for (NSUInteger i = 0; i < screens.count; i++) {
      OverlayWindowController *overlayWindowController =
          [[OverlayWindowController alloc] initWithScreen:screens[i]];
      [overlayWindowController showAlert:text
                                   style:style
                                 dismiss:dismiss
                       completionHandler:^{
                         if (i == screens.count - 1) {
                           [NSApp terminate:nil];
                         }
                       }];
    }

  } else {
    [NSApp terminate:nil];
  }
}

@end
