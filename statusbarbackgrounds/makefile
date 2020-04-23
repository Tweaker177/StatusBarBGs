ARCHS = arm64 arm64e
TARGET= iphone:clang:11.2:9.0
DEBUG = 0
#CFLAGS = -fobjc-arc
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = StatusBarBGs
StatusBarBGs_FILES = SBBRootListController.mm
StatusBarBGs_INSTALL_PATH = /Library/PreferenceBundles
StatusBarBGs_FRAMEWORKS = UIKit Foundation
StatusBarBGs_PRIVATE_FRAMEWORKS = Preferences
StatusBarBGs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
StatusBarBGs_CFLAGS = -fobjc-arc
StatusBarBGs_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/StatusBarBGs.plist$(ECHO_END)
