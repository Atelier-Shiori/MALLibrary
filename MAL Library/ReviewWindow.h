//
//  ReviewWindow.h
//  Shukofukurou
//
//  Created by 天々座理世 on 2017/04/23.
//  Copyright © 2017年 MAL Updater OS X Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ReviewWindow : NSWindowController <NSTableViewDelegate, NSSplitViewDelegate>
- (void)loadReview:(int)idnum type:(int)type title:(NSString *)title;
@end
