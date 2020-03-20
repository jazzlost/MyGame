--[[----------------------------------------------------------------------------
The content of this file includes portions of the AUDIOKINETIC Wwise Technology
released in source code form as part of the SDK installer package.

Commercial License Usage

Licensees holding valid commercial licenses to the AUDIOKINETIC Wwise Technology
may use this file in accordance with the end user license agreement provided
with the software or, alternatively, in accordance with the terms contained in a
written agreement between you and Audiokinetic Inc.

  Version: <VERSION>  Build: <BUILDNUMBER>
  Copyright (c) <COPYRIGHTYEAR> Audiokinetic Inc.
------------------------------------------------------------------------------]]

if not AK then AK = {} end
if not AK.Platforms then AK.Platforms = {} end

AK.Platforms.Android =
{
	name = "Android",
	directories = {
		src = {
			__default__ = "Android",
			["AkMemoryMgr.cpp"] = "Common",
			CommunicationCentral = "POSIX"
		},
		simd = "SIMD",
		include = {
			AkMusicEngine = "POSIX"
		},
		project = {
			__default__ = "Android",
			IntegrationDemoSln = "Android/jni",
			IntegrationDemoMotionSln = "Android/Motion/jni"
		},
		lualib = "Mac", -- TODO Not a typo, must fix for real
		lowlevelio = {
			GameSimulator = "POSIX",
			IntegrationDemo = "Android"
		},
		luasln = "GameSimulator/source/Applications/GameSimulatorAndroid/jni/",
	},
	kinds = {
		GameSimulator = "SharedLib",
		IntegrationDemo = "SharedLib"
	},
	suffix = "Android",
	ndk_stl = "gnustl_static",

	configurations =
	{
		"Debug",
		"Profile",
		"Profile_EnableAsserts",
		"Release",
	},
	platforms = function()
		ndkstl(AK.Platforms.Android.ndk_stl)
		platforms({"android_armeabi-v7a", "android_x86", "android_arm64-v8a", "android_x86_64"})
	end,
	features = { "POSIX", "Motion", "iZotope", "IntegrationDemo" },
	validActions = { "androidmk" },

	AdditionalSoundEngineProjects = function()
		local libzip = require "libzip"
		return { libzip.Create }
	end,

	-- API
	---------------------------------
	ImportAdditionalWwiseSDKProjects = function()
		importproject("zip")
	end,

	-- Project factory. Creates "StaticLib" target by default. Static libs (only) are added to the global list of targets.
	-- Other target types supported by premake are "WindowedApp", "ConsoleApp" and "SharedLib".
	-- Upon returning from this method, the current scope is the newly created project.
	CreateProject = function(in_fileName, in_targetName, in_projectLocation, in_suffix, pathPCH, in_targetType)
		verbosef("        Creating project: %s", in_targetName)
		-- Make sure that directory exist
		os.mkdir(AkMakeAbsolute(in_projectLocation))

		-- Create project
		local prj = project (in_targetName)
			filter "action:androidmk"
				platforms({"android_armeabi-v7a", "android_x86", "android_arm64-v8a", "android_x86_64"})
				toolset "clang"

			filter "action:vs*"
				platforms({"android_armeabi-v7a-NVIDIA", "android_x86-NVIDIA", "android_arm64-v8a-NVIDIA", "android_x86_64-NVIDIA"})
				toolset "msc"

			filter "platforms:android_armeabi-v7a"
				ndkabi "armeabi-v7a"
				ndkplatform "android-14"
			filter "platforms:android_x86"
				ndkabi "x86"
				ndkplatform "android-14"
			filter "platforms:android_arm64-v8a"
				ndkabi "arm64-v8a"
				ndkplatform "android-21"
			filter "platforms:android_x86_64"
				ndkabi "x86_64"
				ndkplatform "android-21"

			filter { "action:androidmk", "*Debug*" }
				flags { "DisableDebugStripping" }

			filter {}

			ndktoolchainversion "4.9"
			location(AkRelativeToCwd(in_projectLocation))
			targetname(in_targetName)
			local targetpath
			if in_targetType == nil or in_targetType == "StaticLib" then
				kind("StaticLib")
				targetprefix("lib")
				targetextension(".a")
				-- Add to global table
				_AK_TARGETS[in_targetName] = in_fileName
				targetpath = "lib"
			else
				kind(in_targetType)
				targetpath = "bin"
			end

			if _ACTION == "androidmk" then
				if in_targetType == nil or in_targetType == "StaticLib" then
					amk_postbuildcommands {
						"",
						"all: $(LOCAL_INSTALLED)"
					}
				else
					amk_postbuildcommands {
						"$(call import-module,android/native_app_glue)",
						"",
						"all: $(LOCAL_INSTALLED)"
					}
				end
			end

			language("C++")
			uuid(GenerateUuid(in_fileName))
			filename(in_fileName)
			characterset("MBCS")
			rtti("Off")
			exceptionhandling("Off")

			if in_targetType ~= "SharedLib" then
				buildoptions
				{
					"-ffast-math",
					"-fvisibility=hidden",
					"-fno-inline-functions"
				}
			end

			if _ACTION == "androidmk" then
				amk_cppflags
				{
					 "-Wno-conversion-null",
					 "-Wno-invalid-offsetof",
					"-Wno-deprecated-declarations",
					"-fvisibility=hidden",
					"-fno-rtti",
					"-fno-exceptions"
				}
			end

			-- Standard configuration settings.
			if _ACTION ~= "androidmk" then
				filter {}
					vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Android/Android.props")
				DisablePropSheetElements()
				filter {}
					removeelements {
						"TargetExt"
					}
				flags { "OmitUserFiles", "ForceFiltersFiles" }		-- We never want .user files, we always want .filters files.
			end

			filter "*Debug*"
				defines ("_DEBUG")
				symbols ("On")

			filter "Profile*"
				defines ("NDEBUG")
				optimize ("Speed")
				symbols ("On")
				buildoptions {"-ffunction-sections -fdata-sections"}

			filter "*Release*"
				defines ({"NDEBUG", "AK_OPTIMIZED"})
				optimize ("Speed")
				buildoptions {"-ffunction-sections", "-fdata-sections"}
				amk_cppflags { "-ffunction-sections","-fdata-sections"}

			filter "*EnableAsserts"
				defines( "AK_ENABLE_ASSERTS" )

			-- Set the scope back to current project
			project(in_targetName)

		ApplyPlatformExceptions(prj.name, prj)

		return prj
	end,

	-- Plugin factory.
	-- Upon returning from this method, the current scope is the newly created plugin project.
	CreatePlugin = function(in_fileName, in_targetName, in_projectLocation, in_suffix, pathPCH, in_targetType)
		local prj = AK.Platforms.Android.CreateProject(in_fileName, in_targetName, in_projectLocation, in_suffix, pathPCH, in_targetType)
		return prj
	end,

	Exceptions = {
		AkMotionSink = function(prj)
			g_PluginDLL["AkMotion"].extralibs = {
				"log"
			}
		end,

		AuroHeadphoneFX = function(prj)
			cppdialect "C++11"
		end,

		CrankcaseAudioREVModelPlayerFX = function(prj)
			includedirs {
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/include",
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/libs/$(APP_ABI)/include"
			}
			buildoptions {
				"--sysroot=$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/include"
			}
		end,

		AkStreamMgr = function(prj)
			filename(prj.name) -- Solution is named the same. Would overwrite the file AkStreamMgrAndroid.mk.
		end,

		GameSimulator = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)

			files {
				prjLoc .. "/jni/main.cpp",
				"$(NDKROOT)/sources/android/native_app_glue/android_native_app_glue.c",
			}

			links {
				"LuaLib",
				"ToLuaLib",
				"log",
				"OpenSLES",
				"android"
			}

			includedirs {
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/include",
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/libs/$(ANDROID_ARCH)/include",
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/backward",
				"$(NDKROOT)/sources/android/native_app_glue",
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/include",
				"$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/libs/$(APP_ABI)/include"
			}

			buildoptions{
				"--sysroot=$(NDKROOT)/sources/cxx-stl/gnu-libstdc++/4.9/include"
			}

			amk_importmodules {
				"android/native_app_glue"
			}

			filter "*Debug*"
				libdirs	{
					prjLoc .. "/../../../../SDK/Android_$(ANDROID_ARCH)/Debug/lib",
					prjLoc .. "/../../../Android_$(ANDROID_ARCH)/Debug/lib",
				}
			filter "*Profile*"
				libdirs	{
					prjLoc .. "/../../../../SDK/Android_$(ANDROID_ARCH)/Profile/lib",
					prjLoc .. "/../../../Android_$(ANDROID_ARCH)/Profile/lib",
				}
			filter "*Release*"
				libdirs	{
					prjLoc .. "/../../../../SDK/Android_$(ANDROID_ARCH)/Release/lib",
					prjLoc .. "/../../../Android_$(ANDROID_ARCH)/Release/lib",
				}
			filter {}
		end,

		IntegrationDemoMotion = function(prj)
			-- Apply same exceptions as IntegrationDemo
			AK.Platforms.Android.Exceptions.IntegrationDemo(prj)

			links {
				"zip",
			}
		end,

		IntegrationDemo = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)

			filename(prj.name) -- Solution is named the same. Would overwrite the file IntegrationDemo_Android.mk.

			includedirs {
				prjLoc .. "/../FreetypeRenderer",

				prjLoc .. "/../../SoundEngine/Android/libzip/lib",
				"$(NDKROOT)/sources/android/native_app_glue",
			}
			files {
				prjLoc .. "/../FreetypeRenderer/*.cpp",
				prjLoc .. "/../FreetypeRenderer/*.h",

				prjLoc .. "/jni/main.cpp",
				prjLoc .. "/../../SoundEngine/Common/AkFileLocationBase.cpp",
				prjLoc .. "/../../SoundEngine/Common/AkFilePackage.cpp",
				prjLoc .. "/../../SoundEngine/Common/AkFilePackageLUT.cpp",
				prjLoc .. "/../../SoundEngine/Android/AkFileHelpers.cpp",
				prjLoc .. "/../../SoundEngine/Android/AkDefaultIOHookBlocking.cpp",
				"$(NDKROOT)/sources/android/native_app_glue/android_native_app_glue.c",
			}

			libdirs {
				prjLoc .. "/../../../Android_$(ArchAbi)/$(Configuration)/lib"
			}

			links {
				"log",
				"OpenSLES",
				"android",
				"EGL",
				"GLESv1_CM",
				"z"
			}

			amk_cppflags {
				"-DLUA_USE_POSIX",
			}
			amk_importmodules {
				"android/native_app_glue",
			}

			filter "Debug*"
				libdirs	{ prjLoc .. "/../../../Android_$(TARGET_ARCH_ABI)/Debug/lib" }
				links "CommunicationCentral"
			filter "Profile*"
				libdirs	{ prjLoc .. "/../../../Android_$(TARGET_ARCH_ABI)/Profile/lib" }
				links "CommunicationCentral"
			filter "Release*"
				libdirs	{ prjLoc .. "/../../../Android_$(TARGET_ARCH_ABI)/Release/lib" }
			filter {}
		end,
		SoundEngineDllProject = function(prj)
			linkoptions "-Wl,--export-dynamic"
			filter "Release"
				symbols "Off"
			filter {}
		end,
	},

	Exclusions = {
		GameSimulator = function(prjLoc)
			excludes {
				prjLoc .. "/../../src/libraries/Common/UniversalScrollBuffer.*"
			}
		end,
		IntegrationDemo = function(projectLocation)
			excludes {
				projectLocation .. "../DemoPages/DemoMicrophone.cpp",
				projectLocation .. "../Common/SoundInputMgrBase.cpp",
				projectLocation .. "../Common/SoundInputMgrBase.h",
				projectLocation .. "../../SoundEngine/POSIX/stdafx.cpp",
				projectLocation .. "../../SoundEngine/Common/AkMultipleFileLocation.cpp",
			}
		end,
	}
}
return AK.Platforms.Android
