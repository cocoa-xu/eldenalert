//
//  FontManager.h
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FontManager : NSObject

+ (instancetype)shared;
- (void)registerFonts;
- (NSFont *)agmenaProRegularWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
