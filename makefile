ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:9.0
DEBUG = 0
#CFLAGS = -fobjc-arc
GO_EASY_ON_ME = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StatusBarBGs
StatusBarBGs_FILES = Tweak.xm 
StatusBarBGs_FRAMEWORKS = UIKit Foundation
StatusBarBGs_EXTRA_FRAMEWORKS += Cephei
StatusBarBGs_LDFLAGS += -lCSColorPicker
StatusBarBGs_CFLAGS = -fobjc-arc  -Wno-deprecated -Wno-deprecated-declarations 

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += statusbarbackgrounds
include $(THEOS_MAKE_PATH)/aggregate.mk