#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <objc/runtime.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import <UIKit/UIKit.h>

#define prefs [[HBPreferences alloc] initWithIdentifier:@"com.i0stweak3r.statusbarbackgrounds"]
#define prefs_reset [prefs removeAllObjects]
#define reloadSB [HBRespringController respring]

@interface HBTintedTableCell : PSTableCell
@end


@interface SBBRootListController : HBRootListController
-(void)respring;
-(void)donate;
-(void)twitter;
-(void)addMyRepo;
-(void)myOtherTweaks;
-(void)resetPrefs;
//:(id)sender; (was part of resetPrefs until changing to Cephei's RespringController)
-(void)love;

@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
@end

@interface SHSwitchTableCell : PSSwitchTableCell
@end

@implementation SHSwitchTableCell
//Create a cellClass of PSSwitchTableCell for customization
//Same idea as iphonedevwiki's SRSwitchTableCell, but with more then just an "on color"

-(id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier {
    //init method
    
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
    //call the super init method
    

    if (self) {
        [((UISwitch *)[self control]) setOnTintColor: [UIColor colorWithRed:(213/255) green:(215/255) blue:(232/255) alpha:0.75f]];
        UIColor *thumbColor = [UIColor colorWithRed: 0.2f green: 0.2f blue: 0.3f alpha: 1.f];
        [((UISwitch *)[self control]) setThumbTintColor: thumbColor];
        [[((UISwitch *)[self control]) layer] setBorderWidth: 2.5f];
        [[((UISwitch *)[self control]) layer] setCornerRadius:14.65f];
        [[((UISwitch *)[self control]) layer] setBorderColor: [[UIColor colorWithRed:0.99 green: 0.f blue: 0.0866f alpha:1.f] CGColor]];
        [[((UISwitch *)[self control]) layer] setShadowRadius: 11.f];
        CGSize switchShadowOffset = CGSizeMake(0.05f,0.09f);
        [[((UISwitch *)[self control]) layer] setShadowOffset: switchShadowOffset];
        [[((UISwitch *)[self control]) layer] setShadowColor:[[UIColor colorWithRed:(235/255) green:(245/255) blue:(250/255) alpha:1.f] CGColor]];
       [[((UISwitch *)[self control]) layer] setShadowOpacity: 1.f];
        
        
    }
    return self;
}

@end

