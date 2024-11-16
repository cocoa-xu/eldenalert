//
//  FontManager.m
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "FontManager.h"
#import <CoreText/CoreText.h>

@implementation FontManager

+ (instancetype)shared {
  static FontManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)registerFonts {
  NSArray *fontNames = @[
    @"AgmenaPro-Regular",
  ];

  for (NSString *fontName in fontNames) {
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName
                                                         ofType:@"ttf"];
    if (fontPath) {
      CFURLRef fontUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:fontPath];
      CFErrorRef error = NULL;

      if (!CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeProcess,
                                            &error)) {
        NSLog(@"Error registering font %@: %@", fontName, error);
        if (error) {
          CFRelease(error);
        }
      }
    }
  }
}

- (NSFont *)agmenaProRegularWithSize:(CGFloat)size {
  return [NSFont fontWithName:@"Agmena Pro Regular" size:size]
             ?: [NSFont systemFontOfSize:size];
}

@end
