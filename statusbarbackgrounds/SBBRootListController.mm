#include "SBBRootListController.h"
#include <CSColorPicker/CSColorPicker.h>
#import <notify.h>
#import <Social/Social.h>


@implementation SBBRootListController

+(NSString *)hb_specifierPlist {
    return @"Root";
}


-(void)respring {
    reloadSB;
    //defined this in header file using HBRespringController
}


- (void)twitter {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=brianvs"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=brianvs"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/brianvs"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/brianvs"]];
    }  else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/brianvs"]];
    }
}


-(void)myOtherTweaks
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://apt.thebigboss.org/developer-packages.php?dev=i0stweak3r"]];
}

-(void)addMyRepo {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://i0s-tweak3r-betas.yourepo.com"]];
}

- (void)donate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/i0stweak3r"]];
}

-(void)love
{
    SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitter setInitialText:@"I’m using #StatusBarBGs by @BrianVS to set a custom background and text color to my status bar system wide. Works on all devices including A12+A13, iOS 11-13.5."];
    if (twitter != nil) {
        [[self navigationController] presentViewController:twitter animated:YES completion:nil];
    }
}


-(void)loadView
{
    [super loadView];
    
    UIBarButtonItem *defaultsButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset Prefs" style:UIBarButtonItemStylePlain target:self action:@selector(resetPrefs)];
    
    //Create a button to reset preferences, not really needed for this tweak but doesn't hurt
    
    defaultsButton.tintColor = [UIColor colorWithRed:1
                                               green:0.22
                                                blue:0.15
                                               alpha:1];
    
    UIImage *heart = [[UIImage alloc] initWithContentsOfFile:[[self bundle] pathForResource:@"Heart" ofType:@"png"]];
    //fetch heart image from pref bundle and create a UIImage for the button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setBackgroundImage:heart forState:UIControlStateNormal];
    [button addTarget:self action:@selector(love) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = YES;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //Create heart button item to display on right side of navbar
    
    self.navigationItem.rightBarButtonItems= @[ defaultsButton, rightButton];
    //Create a 2 button array of right navigation buttons to include reset defaults and heart buttons.
}


-(void)viewWillAppear:(BOOL)animated {
    [self reload];
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.translucent = YES;
    
}




- (void)resetPrefs {
    //This is the selector that's called when defaults button is pressed
    UIAlertController *alertWarning = [UIAlertController
                                       alertControllerWithTitle:@"Reset to Defaults"
                                       message:@"Warning, this will delete all your currently saved settings, and respring. Are you sure you want to proceed?"
                                       preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes, please"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle yes action
                                    //Convenience methods defined in header
                                    prefs_reset;
                                    reloadSB;
                                }];
    
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No, thanks"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks
                               }];
    
    
    
    [alertWarning addAction:yesButton];
    [alertWarning addAction:noButton];
    
    [self presentViewController:alertWarning animated:YES completion:nil];
    alertWarning.view.tintColor = [UIColor redColor];
    //Should really change this so it only colors the YES action red.
}



@end


