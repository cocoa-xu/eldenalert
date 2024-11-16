//
//  OverlayWindowController.h
//  eldenalert
//
//  Created by Cocoa on 15/11/2024.
//

#import "EldenAlertView.h"
#import "OverlayWindow.h"
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverlayWindowController : NSWindowController
@property(nonatomic, strong) EldenAlertView *alertView;

- (instancetype)initWithScreen:(NSScreen *)screen;
- (void)showAlert:(NSString *)text
                style:(EldenAlertStyle)style
              dismiss:(NSTimeInterval)after
    completionHandler:(nullable void (^)(void))completionHandler;
- (void)hideOverlay:(nullable void (^)(void))completionHandler;
@end

NS_ASSUME_NONNULL_END
