//
//  InfoView.h
//  MAL Library
//
//  Created by 天々座理世 on 2017/03/29.
//  Copyright © 2017年 Atelier Shiori. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;

@interface InfoView : NSViewController{
    IBOutlet MainWindow * mw;
}
typedef enum  {
    AnimeType = 0,
    MangaType = 1
} InfoType;
@property (getter=getSelectedId, setter=setSelectedId:) int selectedid;
@property (getter=getSelectedInfo, readonly) NSDictionary * selectedinfo;
@property (getter=getType, setter=setType:) int type;

@property (strong) IBOutlet NSTextView *infoviewbackgroundtextview;
@property (strong) IBOutlet NSTextView *infoviewdetailstextview;
@property (strong) IBOutlet NSTextView *infoviewsynopsistextview;
- (void)populateAnimeInfoView:(id)object;
- (void)populateMangaInfoView:(id)object;
- (IBAction)viewonmal:(id)sender;
@end