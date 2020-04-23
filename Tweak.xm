#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#include <CSColorPicker/CSColorPicker.h>
#import <Foundation/Foundation.h>

HBPreferences *preferences;

static bool kEnabled = NO;
static bool kColorForeground = NO;
static bool kWantsBackgroundColor = NO;
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
        [self setTextColor: [UIColor cscp_colorFromHexString: kForegroundColorHex]];
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
        self.alpha = 1;
        self.backgroundColor =  [UIColor cscp_colorFromHexString: kBackgroundColorHex];
        self.userInteractionEnabled = YES;
        self.opaque = 1;
        self.tintColor = [UIColor cscp_colorFromHexString: kForegroundColorHex];        
        return self;
    }
else if(kWantsBackgroundColor && (kBackgroundColorHex != nil)) {
    self.alpha = 1;
    self.backgroundColor =  [UIColor cscp_colorFromHexString: kBackgroundColorHex];
    self.userInteractionEnabled = YES;
    self.opaque = 1;
    return self;
}
  else if(kColorForeground && (kForegroundColorHex  != nil)) {
    self.tintColor  = [UIColor cscp_colorFromHexString: kForegroundColorHex];
    return self;
}
  else { return %orig; }
}
    
-(void)layoutSubviews {
    if(!kEnabled || !kColorForeground) { return %orig; }
      if((kForegroundColorHex  != nil) && ([self isKindOfClass:%c(_UIStatusBarStringView)] || [self isKindOfClass:%c(UIImageView)])) {
           %orig;
            self.tintColor = [UIColor cscp_colorFromHexString: kForegroundColorHex];
            self.alpha = 1;
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

-(id)foregroundColor {
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

/*  This code was contributed by a reddit user to limit the scope of Cephei to where it belongs in system wide tweaks. I forget the author's name, but will try to find the post to give appropriate credit soon.  */

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
//End of filter code by Reddit user, besides if(shouldLoad) { 

       
        if(shouldLoad) {
 
            // preference loading, initialization
           
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.i0stweak3r.statusbarbackgrounds"];

[preferences registerBool:&kEnabled default:NO forKey:@"kEnabled"];

[preferences registerBool:&kWantsBackgroundColor default:NO forKey:@"wantsBackgroundColor"];

[preferences registerObject:&kBackgroundColorHex default:@"FF0000" forKey:@"backgroundColorHex"];
    
    [preferences registerBool:&kColorForeground default:NO forKey:@"colorForeground"];
    
    [preferences registerObject:&kForegroundColorHex default:@"FF0000" forKey:@"foregroundColorHex"];

            %init(tweak);
        }
}

    
            

