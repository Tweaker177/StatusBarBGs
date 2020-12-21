#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#include <CSColorPicker/CSColorPicker.h>
#import <Foundation/Foundation.h>

HBPreferences *preferences;

static BOOL kEnabled = NO;
static BOOL kColorForeground = NO;
static BOOL kWantsBackgroundColor = NO;
static NSString *kForegroundColorHex = nil;
static NSString *kBackgroundColorHex = nil;


@interface _UIStatusBarForegroundView : UIView
@end


@interface _UIStatusBarStringView : UILabel
@end

%group tweak

%hook _UIStatusBarStringView

-(id)initWithFrame:(CGRect)frame {
    if(!kEnabled || !kColorForeground) { return %orig; }
    if(kForegroundColorHex  != nil) {
        self = %orig;
        self.textColor = [UIColor cscp_colorFromHexString: kForegroundColorHex];
        return self;
    }
    return %orig;
}
%end


%hook _UIStatusBarForegroundView
-(id)initWithFrame:(CGRect)frame {
    if(!kEnabled) { return %orig; }
      self = %orig;
    if((kWantsBackgroundColor && kBackgroundColorHex != nil) && (kColorForeground && kForegroundColorHex != nil)) {
        self.alpha = 1.f;
        self.backgroundColor =  [UIColor cscp_colorFromHexString: kBackgroundColorHex];
        self.userInteractionEnabled = YES;
        self.opaque = YES;
        self.tintColor = [UIColor cscp_colorFromHexString: kForegroundColorHex];        
        return self;
    }
else if(kWantsBackgroundColor && (kBackgroundColorHex != nil)) {
    self.alpha = 1.f;
    self.backgroundColor =  [UIColor cscp_colorFromHexString: kBackgroundColorHex];
    self.userInteractionEnabled = YES;
    self.opaque = YES;
    return self;
}
  else if(kColorForeground && (kForegroundColorHex  != nil)) {
    self.tintColor  = [UIColor cscp_colorFromHexString: kForegroundColorHex];
    return self;
}
  else { return %orig; }
}
    

//Updating changes to the UIStatusBarItem's color, to ensure any settings changes apply immediately. 
//Should probably use a better method, but this allowed for simplicity, compatibility with almost any other status bar tweak, and it eliminates the need to respring for changes to this setting.

-(void)layoutSubviews {
    if(!kEnabled || !kColorForeground) { return %orig; }
      if((kForegroundColorHex  != nil) && ([self isKindOfClass:%c(_UIStatusBarStringView)] || [self isKindOfClass:%c(UIImageView)])) {
           %orig;
            self.tintColor = [UIColor cscp_colorFromHexString: kForegroundColorHex];
            self.alpha = 1.f;
            self.opaque = YES;
            return;
        }
        return %orig;
    }
%end


%hook _UIStatusBar
-(void)setForegroundColor:(UIColor *)arg1 {
    if(kEnabled && kColorForeground &&  kForegroundColorHex != nil) {
        arg1 = [UIColor cscp_colorFromHexString: kForegroundColorHex];
        return %orig(arg1);
    }
    return %orig;
}

-(UIColor*)foregroundColor {
    if(kEnabled && kColorForeground && kForegroundColorHex != nil) {
        return [UIColor cscp_colorFromHexString: kForegroundColorHex];
    }
    return %orig;
}
%end

%hook UIStatusBarModern
-(BOOL)isTranslucent {
if(kEnabled && kWantsBackgroundColor) {
return YES;
}
else {
    return %orig; }
}
%end

extern NSString *const HBPreferencesDidChangeNotification;
	//Cephei callback

%end  //end of group tweak

%ctor {

/*  This code was contributed by a reddit user to limit the scope of Cephei to where it belongs in system wide tweaks (UIKit as filter). 
I forget the author's name, but will try to find the post to give credit where due.
The simple check to make sure it only loads in apps and SB significantly reduces CPU useage and battery drain.
   */

        BOOL shouldLoad = NO;
        NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
        NSUInteger count = args.count;
        if (count != 0) {
            NSString *executablePath = args[0];
            if (executablePath) {
                NSString *processName = [executablePath lastPathComponent];
                BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
                BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
                BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
                BOOL skip = [processName isEqualToString:@"AdSheet"]
                || [processName isEqualToString:@"CoreAuthUI"]
                || [processName isEqualToString:@"InCallService"]
                || [processName isEqualToString:@"MessagesNotificationViewService"]
                || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
                if (!isFileProvider && (isSpringBoard || isApplication) && !skip) {
                    shouldLoad = YES;
                }
            }
        }
//End of code by Reddit user, besides if(shouldLoad) { 

       
        if(shouldLoad) {
 
            // preference loading, initialization
           
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.i0stweak3r.statusbarbackgrounds"];

[preferences registerBool:&kEnabled default:NO forKey:@"enabled"];

[preferences registerBool:&kWantsBackgroundColor default:NO forKey:@"wantsBackgroundColor"];

[preferences registerObject:&kBackgroundColorHex default:@"FF0000" forKey:@"backgroundColorHex"];
    
    [preferences registerBool:&kColorForeground default:NO forKey:@"colorForeground"];
    
    [preferences registerObject:&kForegroundColorHex default:@"FF0000" forKey:@"foregroundColorHex"];

            %init(tweak);
        }

} //end of %ctor

    
            

