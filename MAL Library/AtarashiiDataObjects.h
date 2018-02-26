//
//  AtarashiiDataObjects.h
//  MAL Library
//
//  Created by 桐間紗路 on 2017/12/19.
//  Copyright © 2017年 Atelier Shiori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtarashiiAnimeObject : NSObject
@property int titleid;
@property (strong) NSString *title;
@property (strong) NSDictionary *other_titles;
@property int rank;
@property int popularity_rank;
@property (strong) NSString *image_url;
@property (strong) NSString *type;
@property int episodes;
@property (strong) NSString *status;
@property (strong) NSString *start_date;
@property (strong) NSString *end_date;
@property (strong) NSString *broadcast;
@property int duration;
@property (strong) NSString *classification;
@property double members_score;
@property int members_count;
@property int favorited_count;
@property (strong) NSString *synposis;
@property (strong) NSString *background;
@property (strong) NSArray *producers;
@property (strong) NSArray *genres;
@property (strong) NSArray *manga_adaptations;
@property (strong) NSArray *prequels;
@property (strong) NSArray *sequels;
@property (strong) NSArray *side_stories;
@property (strong) NSArray *parent_story;
@property (strong) NSArray *character_anime;
@property (strong) NSArray *spin_offs;
@property (strong) NSArray *opening_theme;
@property (strong) NSArray *ending_theme;
@property (strong) NSArray *recommendations;
@property (strong) NSDictionary *mappings;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarashiiAnimeListObject : NSObject
@property int titleid;
@property (strong) NSString *title;
@property int entryid;
@property int episodes;
@property int episode_length;
@property (strong) NSString *image_url;
@property (strong) NSString *type;
@property (strong) NSString *status;
@property (strong) NSString *watched_status;
@property int watched_episodes;
@property int score;
@property int score_type;
@property (strong) NSString *watching_start;
@property (strong) NSString *watching_end;
@property bool rewatching;
@property int rewatch_count;
@property (strong) NSString *personal_comments;
@property bool private_entry;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarashiiMangaObject : NSObject
@property int titleid;
@property (strong) NSString *title;
@property (strong) NSDictionary *other_titles;
@property int rank;
@property int popularity_rank;
@property (strong) NSString *image_url;
@property (strong) NSString *type;
@property int chapters;
@property int volumes;
@property (strong) NSString *status;
@property double members_score;
@property int members_count;
@property int favorited_count;
@property (strong) NSString *synposis;
@property (strong) NSArray *genres;
@property (strong) NSArray *anime_adaptations;
@property (strong) NSArray *related_manga;
@property (strong) NSArray *alternative_versions;
@property (strong) NSDictionary *mappings;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarashiiMangaListObject : NSObject
@property int titleid;
@property (strong) NSString *title;
@property int entryid;
@property int chapters;
@property int volumes;
@property (strong) NSString *image_url;
@property (strong) NSString *type;
@property (strong) NSString *status;
@property (strong) NSString *read_status;
@property int chapters_read;
@property int volumes_read;
@property int score;
@property int score_type;
@property (strong) NSString *reading_start;
@property (strong) NSString *reading_end;
@property bool rereading;
@property int reread_count;
@property (strong) NSString *personal_comments;
@property bool private_entry;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarashiiPersonObject : NSObject
@property int personid;
@property (strong) NSString *name;
@property (strong) NSArray *alternate_names;
@property (strong) NSString *given_name;
@property (strong) NSString *familyname;
@property (strong) NSString *birthdate;
@property (strong) NSString *website_url;
@property (strong) NSString *more_details;
@property int favorited_count;
@property (strong) NSArray *voice_acting_roles;
@property (strong) NSArray *anime_staff_positions;
@property (strong) NSArray *published_manga;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarashiiVoiceActingRoleObject : NSObject
@property int characterid;
@property (strong) NSString *name;
@property (strong) NSString *image_url;
@property bool main_role;
@property (strong) NSArray *anime;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarrashiiStaffObject : NSObject
@property (strong) NSString *position;
@property (strong) NSString *details;
@property (strong) NSArray *anime;
- (NSDictionary *)NSDictionaryRepresentation;
@end

@interface AtarashiiPublishedMangaObject : NSObject
@property (strong) NSString *position;
@property (strong) NSArray *manga;
- (NSDictionary *)NSDictionaryRepresentation;
@end