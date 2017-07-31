//
//  CharacterView.m
//  MAL Library
//
//  Created by 桐間紗路 on 2017/07/26.
//  Copyright © 2017年 Atelier Shiori. All rights reserved.
//

#import "CharacterView.h"
#import "CharactersBrowser.h"
#import "Utility.h"
#import "MainWindow.h"
#import "AppDelegate.h"
#import "NSTableViewAction.h"
#import "NSString_stripHtml.h"

@interface CharacterView ()
@property (strong) IBOutlet NSTextField *charactername;
@property (strong) IBOutlet NSTextView *details;
@property (strong) IBOutlet NSTextField *tableview_first_heading;
@property (strong) IBOutlet NSBox *tableview_first_line;
@property (strong) IBOutlet NSImageView *posterimage;
@property (weak) MainWindow *mw;
@property (strong) IBOutlet NSPopUpButton *popupfilter;
@property (strong) IBOutlet NSArrayController *arraycontroller;
@property (strong) IBOutlet NSTableViewAction *tb;
@end

@implementation CharacterView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _mw = [((AppDelegate *)[NSApplication sharedApplication].delegate) getMainWindowController];
}

- (void)populateCharacterInfo:(NSDictionary *)d withTitle:(NSString *)title {
    _charactername.stringValue = d[@"name"];
    _posterimage.image = [Utility loadImage:[NSString stringWithFormat:@"%@.jpg",[[(NSString *)d[@"image"] stringByReplacingOccurrencesOfString:@"https://myanimelist.cdn-dena.com/images/" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"-"]] withAppendPath:@"imgcache" fromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",d[@"image"]]]];
    _details.string = [NSString stringWithFormat:@"%@ character from %@. View more details on MyAnimeList.", d[@"role"], title];
    _selectedid = ((NSNumber *)d[@"id"]).intValue;
    _persontype = PersonCharacter;
    [self clearArrayController];
    _tableview_first_heading.stringValue = @"Voice Actors";
    if (d[@"actors"]) {
        [self populatetableview:d[@"actors"] type:actors];
    }
    _popupfilter.hidden = YES;
    [self reloadtableview];
    
}

- (void)populateStaffInformation:(NSDictionary *)d {
    NSMutableString *tmpstr = [NSMutableString new];
    _charactername.stringValue = d[@"name"];
    _posterimage.image = [Utility loadImage:[NSString stringWithFormat:@"%@.jpg",[[(NSString *)d[@"image_url"] stringByReplacingOccurrencesOfString:@"https://myanimelist.cdn-dena.com/images/" withString:@""] stringByReplacingOccurrencesOfString:@"/" withString:@"-"]] withAppendPath:@"imgcache" fromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",d[@"image_url"]]]];
    /*if (d[@"given_name"] && d[@"family_name"]) {
        [tmpstr appendFormat:@"%@, %@\n",d[@"family_name"], d[@"given_name"]];
    }*/
    if (((NSArray *)d[@"alternate_names"]).count > 0 ) {
        [tmpstr appendFormat:@"Other Names: %@\n",[Utility appendstringwithArray:d[@"alternate_names"]]];
    }
    if (d[@"birthday"]) {
        [tmpstr appendFormat:@"Birthday: %@\n",d[@"birthday"]];
    }
    if (d[@"more_details"]) {
        [tmpstr appendFormat:@"%@\n",[(NSString *)d[@"more_details"] stripHtml]];
    }
    if (d[@"favorited_count"]) {
        [tmpstr appendFormat:@"Favorited: %@\n",d[@"favorited_count"]];
    }
    if (d[@"website_url"]) {
        _personhomepage = d[@"website_url"];
    }
    else {
        _personhomepage = @"";
    }
    _details.string = tmpstr;
    _selectedid = ((NSNumber *)d[@"id"]).intValue;
    _persontype = PersonStaff;
    [self clearArrayController];
    _tableview_first_heading.stringValue = @"Positions";
    [self populatetableview:d[@"voice_acting_roles"] type:voiceactingroles];
    [self populatetableview:d[@"anime_staff_positions"] type:staffpositions];
    [self populatetableview:d[@"published_manga"] type:publishedmanga];
    _popupfilter.hidden = NO;
    [self reloadtableview];
    [self filtertableview];
}

- (void)clearArrayController {
    NSMutableArray *a = [_arraycontroller mutableArrayValueForKey:@"content"];
    [a removeAllObjects];
    _arraycontroller.filterPredicate = nil;
}

- (void)populatetableview:(NSArray *)arraycontent type:(int)arraytype {
    NSMutableArray *tmparray = [NSMutableArray new];
    for (NSDictionary *d in arraycontent) {
        switch (arraytype) {
            case actors: {
                [tmparray addObject:@{@"id":d[@"id"],@"image":d[@"image"],@"title":[NSString stringWithFormat:@"%@\n%@",d[@"name"],d[@"language"]]}];
                break;
            }
            case staffpositions: {
                [tmparray addObject:@{@"id":d[@"anime"][@"id"],@"image":d[@"anime"][@"image_url"],@"title":[NSString stringWithFormat:@"%@\n%@",d[@"anime"][@"title"],d[@"position"]], @"type":@"Staff Positions"}];
                break;
            }
            case voiceactingroles: {
                NSString * role;
                if (((NSNumber *)d[@"main_role"]).boolValue) {
                    role = @"Main role";
                }
                else {
                    role = @"Supporting role";
                }
                [tmparray addObject:@{@"id":d[@"anime"][@"id"],@"image":d[@"image_url"],@"title":[NSString stringWithFormat:@"%@\n%@\n%@",d[@"name"],d[@"anime"][@"title"],role], @"type":@"Voice Acting Roles"}];
                break;
            }
            case publishedmanga: {
                [tmparray addObject:@{@"id":d[@"manga"][@"id"],@"image":d[@"manga"][@"image_url"],@"title":[NSString stringWithFormat:@"%@\n%@",d[@"manga"][@"title"],d[@"position"]], @"type":@"Published Manga"}];
                break;
            }
            default: {
                break;
            }
        }
    }
    if (tmparray.count > 0) {
        [_arraycontroller addObjects:tmparray];
    }
}

- (void)reloadtableview {
    [_tb reloadData];
    [_tb deselectAll:self];
}

- (void)filtertableview {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type ==[cd] %@",_popupfilter.selectedItem.title];
    _arraycontroller.filterPredicate = predicate;
}

- (IBAction)performfilter:(id)sender {
    [self filtertableview];
}

- (IBAction)tbdoubleclick:(id)sender {
    if (_tb.selectedRow >=0){
        if (_tb.selectedRow >-1){
            NSDictionary *d = _arraycontroller.selectedObjects[0];
            if (_persontype == PersonCharacter) {
                // View voice actor directly from the list.
                    [_cb.sourceList selectRowIndexes:[NSIndexSet indexSetWithIndex:[_cb getIndexOfItemWithIdentifier:[NSString stringWithFormat:@"staff-%@",d[@"id"]]]]byExtendingSelection:false];
            }
            else {
                if ([(NSString *)d[@"type"] isEqualToString:@"Published Manga"]){
                    [_mw loadinfo:d[@"id"] type:1];
                }
                else {
                    [_mw loadinfo:d[@"id"] type:0];
                }
                [_mw.window makeKeyAndOrderFront:self];
            }
        }
    }
}
@end
