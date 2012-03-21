include theos/makefiles/common.mk

TWEAK_NAME = myTweak
myTweak_FILES = Tweak.xm NetworkMini.m NSError+Extensions.m NXDebug.m NXJsonParser.m NXJsonSerializer.m
myTweak_FRAMEWORKS = UIKit CoreTelephony Foundation  CoreFoundation

include $(THEOS_MAKE_PATH)/tweak.mk
