LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := AkStreamMgr
LOCAL_MODULE_FILENAME := libAkStreamMgr

LOCAL_SRC_FILES := ../Common/AkDeviceBase.cpp ../Common/AkDeviceBlocking.cpp ../Common/AkDeviceDeferredLinedUp.cpp ../Common/AkIOMemMgr.cpp ../Common/AkStreamMgr.cpp ../Common/AkTransferDeferred.cpp ../POSIX/AkIOThread.cpp stdafx.cpp

ifeq ($(PM5_CONFIG),debug_android_armeabi-v7a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -D_DEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -mfloat-abi=softfp -mfpu=neon -ffast-math -fvisibility=hidden -fno-inline-functions -g
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),debug_android_x86)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -D_DEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -g
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),debug_android_arm64-v8a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -D_DEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -g
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),debug_android_x86_64)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -D_DEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -g
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_android_armeabi-v7a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -mfloat-abi=softfp -mfpu=neon -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_android_x86)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_android_arm64-v8a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_android_x86_64)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_enableasserts_android_armeabi-v7a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_ENABLE_ASSERTS -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -mfloat-abi=softfp -mfpu=neon -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_enableasserts_android_x86)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_ENABLE_ASSERTS -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_enableasserts_android_arm64-v8a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_ENABLE_ASSERTS -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),profile_enableasserts_android_x86_64)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_ENABLE_ASSERTS -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -g -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  cmd-strip :=
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),release_android_armeabi-v7a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_OPTIMIZED -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -mfloat-abi=softfp -mfpu=neon -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),release_android_x86)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_OPTIMIZED -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),release_android_arm64-v8a)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_OPTIMIZED -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  include $(BUILD_STATIC_LIBRARY)
endif

ifeq ($(PM5_CONFIG),release_android_x86_64)
  LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include $(LOCAL_PATH)/. $(LOCAL_PATH)/../Common $(LOCAL_PATH)/../POSIX
  LOCAL_CFLAGS := -DNDEBUG -DAK_OPTIMIZED -DAUDIOKINETIC -DAKSOUNDENGINE_EXPORTS -ffast-math -fvisibility=hidden -fno-inline-functions -ffunction-sections -fdata-sections -O3
  LOCAL_CPPFLAGS := -Wno-conversion-null -Wno-invalid-offsetof -Wno-deprecated-declarations -fvisibility=hidden -fno-rtti -fno-exceptions
  include $(BUILD_STATIC_LIBRARY)
endif


all: $(LOCAL_INSTALLED)