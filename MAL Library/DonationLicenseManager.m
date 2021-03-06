//
//  DonationLicenseManager.m
//  Shukofukurou
//
//  Created by 小鳥遊六花 on 4/17/18.
//  Copyright © 2018 Atelier Shiori. All rights reserved.
//

#import "DonationLicenseManager.h"
#import <DonationCheck/DonationCheck.h>
#import "PatreonLicenseManager.h"
#import "AppDelegate.h"
#import "MainWindow.h"
#import "Utility.h"

@interface DonationLicenseManager ()
@property (strong) IBOutlet NSButton *registerbtn;
@property (strong) IBOutlet NSButton *cancelbtn;
@property (strong) IBOutlet NSButton *upgradebtn;
@property (strong) IBOutlet NSTextField *name;
@property (strong) IBOutlet NSTextField *donationkey;
@property (strong) IBOutlet NSButton *patreonlicense;
@end

@implementation DonationLicenseManager
- (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[NSApplication sharedApplication].delegate;
}

- (instancetype)init {
    self = [super initWithWindowNibName:@"DonationLicenseManager"];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)registerkey:(id)sender {
    if (_patreonlicense.state) {
        [self performPatreonLicenseCheck];
    }
    else {
        [self performRegularLicenseCheck];
    }
}

- (void)performRegularLicenseCheck {
    bool success = [DonationKeyVerify checkLicense:_name.stringValue withDonationKey:_donationkey.stringValue isUpgradeLicense:false];
    if (success) {
        [self donationKeyRegister:_name.stringValue withKey:_donationkey.stringValue];
        [self.window close];
    }
    else {
        success = [DonationKeyVerify checkLicense:_name.stringValue withDonationKey:_donationkey.stringValue isUpgradeLicense:true];
        if (success) {
            [MigrateAppStoreLicense validateApp:self.window completionHandler:^(bool success, id responseObject, NSString *path) {
                if (success) {
                    [self donationKeyRegister:_name.stringValue withKey:_donationkey.stringValue];
                    [self.window close];
                }
            }];
        }
        else {
            [Utility showsheetmessage:@"Invalid Donation Key" explaination:@"Make sure you entered the name and license key exactly shown in your email." window:self.window];
        }
    }
}

- (void)performPatreonLicenseCheck {
    [[PatreonLicenseManager sharedInstance] validateLicense:_name.stringValue withLicenseKey:_donationkey.stringValue withCompletion:^(bool success, bool error) {
        if (success && !error) {
            [self donationKeyRegister:_name.stringValue withKey:_donationkey.stringValue];
            [self.window close];
        }
        else {
            [Utility showsheetmessage:@"Invalid Donation Key" explaination:@"Make sure you entered the name and license key exactly shown on the Patreon License Portal." window:self.window];
        }
    }];
}

- (IBAction)upgrade:(id)sender {
    [self disablebtns:false];
    [MigrateAppStoreLicense validateApp:self.window completionHandler:^(bool success, id responseObject, NSString *path) {
        if (success) {
        [MigrateAppStoreLicense getUpgradeKeyWithReciept:path withName:NSUserName() completionHandler:^(bool success, bool freeupgrade, NSString *name, NSString *license, NSString *path) {
            if (success && freeupgrade){
                NSString *licensedetails = [NSString stringWithFormat:@"\n\nName: %@\nLicense: %@", name, license];
                [self writeLicensetoDesktop:licensedetails];
                [Utility showsheetmessage:@"Your License" explaination:[NSString stringWithFormat:@"Use these details to register Shukofukurou. The details are saved to your desktop.%@",licensedetails] window:self.window];
            }
            else if (success && !freeupgrade) {
                [MigrateAppStoreLicense showfreeupgradenoteligible:self.window];
            }
            else {
                [Utility showsheetmessage:@"Invalid Copy of MAL Library" explaination:@"Please select a valid copy of MAL Library you downloaded from the App Store." window:self.window];
            }
            [self disablebtns:true];
        }];
        }
        else {
            [Utility showsheetmessage:@"Invalid Copy of MAL Library" explaination:@"Please select a valid copy of MAL Library you downloaded from the App Store." window:self.window];
            [self disablebtns:true];
        }
    }];
}

- (IBAction)purchasekey:(id)sender {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://softwareateliershiori.onfastspring.com/shukofukurou"]];
}

- (IBAction)lookupkey:(id)sender {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://softwareateliershiori.onfastspring.com/account"]];
}

- (void)writeLicensetoDesktop:(NSString *)details {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *desktopDirectory = [paths objectAtIndex:0]; // Get documents directory
    
    NSError *error;
    BOOL success = [details writeToFile:[desktopDirectory stringByAppendingPathComponent:@"Shukofukurou License Details"]
                              atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!success) {
        // Handle error here
        NSLog((@"Wrote License Details"));
    }
}

- (IBAction)cancel:(id)sender {
    [self.window close];
}

- (void)disablebtns:(bool)enable {
    _registerbtn.enabled = enable;
    _cancelbtn.enabled = enable;
    _upgradebtn.enabled = enable;
}

- (void)donationKeyRegister:(NSString *)name withKey:(NSString *)license {
#if defined(AppStore)
#else
    MainWindow *mw = [[self getAppDelegate] getMainWindowController];
    [Utility showsheetmessage:@"Registered" explaination:@"All Pro features are unlocked. Thank you for supporting the development of Shukofukurou!" window:mw.window];
    if (_patreonlicense.state) {
        [[PatreonLicenseManager sharedInstance] storeLicense:name withLicenseKey:license];
        [NSUserDefaults.standardUserDefaults setValue:[NSDate date] forKey:@"patreon_license_last_checked"];
    }
    else {
        // Add to the preferences
        [[NSUserDefaults standardUserDefaults] setObject:license forKey:@"donation_license"];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"donation_name"];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"donated"];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
    [mw generateSourceList];
    [mw loadmainview];
#endif
}

- (IBAction)becomepatron:(id)sender {
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://www.patreon.com/bePatron?c=677182"]];
}

- (IBAction)openpatreonlicenseportal:(id)sender {
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://patreonlicensing.malupdaterosx.moe"]];
}

@end
