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

AK.Platforms.Windows =
{
	name = "Windows",
	directories = {
		src = {
			__default__ = "Win32",
			["AkMemoryMgr.cpp"] = "Win32",
			CommunicationCentral = "PC",
			IntegrationDemo = "Windows",
			AkSoundEngineDLL = "Win32",
		},
		project = {
			__default__ = "Win32",
			GameSimulator = "PC",
			CommunicationCentral = "PC",
			LuaLib = "PC",
			ToLuaLib = "PC",
			IntegrationDemoSln = "Windows",
			IntegrationDemoMotionSln = "Windows",
		},
		simd = "SIMD",
		lualib = "Win32",
		lowlevelio = "Win32",
		luasln = "GameSimulator/source/",
	},
	kinds = {
		GameSimulator = "ConsoleApp",
		IntegrationDemo = "WindowedApp"
	},
	suffix = {
		__default__ = "Windows",
		CommunicationCentral = "PC",
		GameSimulator = "PC",
		LuaLib = "PC",
		ToLuaLib = "PC",
		LuaSolutions = "PC",
		AllEffectsSln = "PC",
		SamplePluginsSln = "PC",
		AkStreamMgrSln = "PC",
	},

	configurations =
	{
		"Debug",
		"Debug(StaticCRT)",
		"Profile",
		"Profile_EnableAsserts",
		"Profile(StaticCRT)" ,
		"Profile(StaticCRT)_EnableAsserts" ,
		"Release",
		"Release(StaticCRT)",
	},
	platforms = { "Win32", "x64" },
	features = { "Motion", "iZotope", "UnitTests", "Sce3DAudio", "SampleSink", "IntegrationDemo", "SoundEngineDLL", "fastcall" },
	validActions = { "vs2013", "vs2015", "vs2017" },
	
	AdditionalSoundEngineProjects = function()
		return {}
	end,
	AddActionSuffixToDllProjects = true,

	-- API
	---------------------------------
	ImportAdditionalWwiseSDKProjects = function()
	end,

	-- Project factory. Creates "StaticLib" target by default. Static libs (only) are added to the global list of targets.
	-- Other target types supported by premake are "WindowedApp", "ConsoleApp" and "SharedLib".
	-- Upon returning from this method, the current scope is the newly created project.
	CreateProject = function(in_fileName, in_targetName, in_projectLocation, in_suffix, pathPCH, in_targetType)
		verbosef("        Creating project: %s", in_targetName)

		-- Make sure that directory exist
		os.mkdir(AkMakeAbsolute(in_projectLocation))

		-- Create project
		local prj = project(in_targetName)
			if not _AK_BUILD_AUTHORING then
				platforms({"Win32", "x64"})
			end
			location(AkRelativeToCwd(in_projectLocation))
			targetname(in_targetName)
			if in_targetType == nil or in_targetType == "StaticLib" then
				kind("StaticLib")
				-- Add to global table
				_AK_TARGETS[in_targetName] = in_fileName
			else
				kind(in_targetType)
			end
			language("C++")
			uuid(GenerateUuid(in_fileName))
			filename(in_fileName)
			symbols ("on")
			symbolspath "$(OutDir)$(TargetName).pdb"
			flags { "OmitUserFiles", "ForceFiltersFiles" } -- We never want .user files, we always want .filters files.

			-- Common flags.
			characterset "Unicode"
			exceptionhandling "Default"

			-- Precompiled headers.
			if pathPCH ~= nil then
				files
				{
					AkRelativeToCwd(pathPCH) .. "stdafx.cpp",
					AkRelativeToCwd(pathPCH) .. "stdafx.h",
				}
				--pchheader ( AkRelativeToCwd(pathPCH) .. "stdafx.h" )
				pchheader "stdafx.h"
				pchsource ( AkRelativeToCwd(pathPCH) .. "stdafx.cpp" )
				--pchsource "stdafx.cpp"
			end

			-- Standard configuration settings.
			filter ("Debug*")
				defines "_DEBUG"

			filter ("Profile*")
				defines "NDEBUG"
				optimize ("Speed")

			filter ("Release*")
				defines "NDEBUG"
				optimize ("Speed")

			filter "*EnableAsserts"
				defines "AK_ENABLE_ASSERTS"

			filter {}

			if not _AK_BUILD_AUTHORING then
			-- Note: The AuthoringRelease config is "profile", really. It must not be AK_OPTIMIZED.
			filter "Release*"
				defines "AK_OPTIMIZED"
			end

			-- Add configuration specific options.
			filter "*_fastcall"
				callingconvention "FastCall"

			-- Add architecture specific libdirs.
			filter "platforms:Win32"
				architecture "x86"
				defines "WIN32"
				libdirs{"$(DXSDK_DIR)/lib/x86"}
				vectorextensions "SSE"
			filter "platforms:x64"
				architecture "x86_64"
				defines "WIN64"
				libdirs{"$(DXSDK_DIR)/lib/x64"}

			filter {}

			-- Style sheets.
			local ssext = ".props"

			if in_targetType == "SharedLib" then
				if _AK_BUILD_AUTHORING then
					filter "Debug*"
						vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/Debug" .. GetSuffixFromCurrentAction() .. ssext)
					filter "Profile* or Release*"
						vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/NDebug" .. GetSuffixFromCurrentAction() .. ssext)
				else
					filter "Debug*"
						vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/Debug_StaticCRT" .. in_suffix .. ssext)
					filter "Profile* or Release*"
						vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/NDebug_StaticCRT" .. in_suffix .. ssext)
				end

			else
				filter "*Debug or Debug_fastcall"
					vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/Debug" .. in_suffix .. ssext)
				filter "*Debug(StaticCRT)*"
					vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/Debug_StaticCRT" .. in_suffix .. ssext)
				filter "*Profile or *Profile_EnableAsserts or *Release or Profile_fastcall or Release_fastcall"
					vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/NDebug" .. in_suffix .. ssext)
				filter "*Profile(StaticCRT)* or *Release(StaticCRT)*"
					vs_propsheet(AkRelativeToCwd(_AK_ROOT_DIR) .. "PropertySheets/Win32/NDebug_StaticCRT" .. in_suffix .. ssext)
			end

			DisablePropSheetElements()
			filter {}
				removeelements {
					"TargetExt"
				}

			-- Set the scope back to current project
			project(in_targetName)
		
		ApplyPlatformExceptions(prj.name, prj)

		return prj
	end,

	-- Plugin factory.
	-- Upon returning from this method, the current scope is the newly created plugin project.
	CreatePlugin = function(in_fileName, in_targetName, in_projectLocation, in_suffix, pathPCH, in_targetType)
		local prj = AK.Platforms.Windows.CreateProject(in_fileName, in_targetName, in_projectLocation, in_suffix, pathPCH, in_targetType)
		return prj
	end,

	Exceptions = {
		AkSoundEngine = function(prj)
			includedirs {
				"$(FrameworkSdkDir)/include/um",
				"$(DXSDK_DIR)/include",				
			}
			local prjLoc = AkRelativeToCwd(prj.location)
			if not _AK_BUILD_AUTHORING then
				filter { "files:" .. prjLoc .. "/../../SoundEngineProxy/**.cpp", "Release*" }
					flags { "ExcludeFromBuild" }
				filter {}
			end
			defines({"AKSOUNDENGINE_DLL", "AKSOUNDENGINE_EXPORTS"})
		end,
		AkSoundEngineDLL = function(prj)
			links {	"dxguid", "XInput","msacm32", "ws2_32" }
			runtime "Debug"
		end,
		AkSoundEngineTests = function(prj)
			links {	
				"dxguid"
			}

			filter "Debug*"
				links "ws2_32"
			filter "Profile*"
				links "ws2_32"
			filter {}
		end,
		AkMemoryMgr = function(prj)
			defines({"AKSOUNDENGINE_DLL", "AKSOUNDENGINE_EXPORTS"})
		end,
		AkMusicEngine = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)
			if not _AK_BUILD_AUTHORING then
				filter { "files:" .. prjLoc .. "/../../SoundEngineProxy/**.cpp", "Release*" }
					-- This is how we exclude files per config in Visual Studio
					flags { "ExcludeFromBuild" }
				filter {}
			end

			defines({"AKSOUNDENGINE_DLL", "AKSOUNDENGINE_EXPORTS"})
		end,
		AkSpatialAudio = function(prj)
			defines({"AKSOUNDENGINE_DLL", "AKSOUNDENGINE_EXPORTS"})
		end,
		AkStreamMgr = function(prj)
			defines({"AKSOUNDENGINE_DLL", "AKSOUNDENGINE_EXPORTS"})
		end,
		AkVorbisDecoder = function(prj)
			filter "*Debug or Debug_fastcall or *Profile or *Release or Profile_fastcall or Release_fastcall"
				defines({"AKSOUNDENGINE_DLL"})
			filter {}
		end,
		AkOpusDecoder = function(prj)
			configuration { "*Debug or Debug_fastcall or *Profile or *Release or Profile_fastcall or Release_fastcall" }
				defines({"AKSOUNDENGINE_DLL"})
			configuration {}
		end,
		AkMotionSink = function(prj)
			g_PluginDLL["AkMotion"].extralibs = {
				"dinput8"
			}
		end,
		AkSink = function(prj)
			includedirs { 
				"$(DXSDK_DIR)\\include" 
			}
		end,
		AkConvolutionReverbFX = function(prj)
			defines({"AK_USE_PREFETCH"})
		end,
		SceAudio3dEngine = function(prj)
			-- Remove from AK_TARGETS on Windows. Don't want the Windows IntegrationDemo to link with it.
			_AK_TARGETS['SceAudio3dEngine'] = nil

			local prjLoc = AkRelativeToCwd(prj.location)
			includedirs { 
				prjLoc .. "/../../../../../Authoring/source/3rdParty/Sony/Audio3d/include",
			}
		end,
		CrankcaseAudioREVModelPlayerFX = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)
			local soundREVRuntimeLocation = prjLoc .. "/../REV.Runtime/src/"
			files {
				soundREVRuntimeLocation .. "RTTI/class.*",
				soundREVRuntimeLocation .. "RTTI/field.*",
				soundREVRuntimeLocation .. "RTTI/method.*",
				soundREVRuntimeLocation .. "RTTI/reflect.*",
				soundREVRuntimeLocation .. "RTTI/RTTI.*",
				soundREVRuntimeLocation .. "RTTI/type.*",
				soundREVRuntimeLocation .. "RTTI/typedecl.*",
				soundREVRuntimeLocation .. "RTTI/linear_alloc.*",
			}
		end,
		iZTrashBoxModelerFX = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)
			files {
				prjLoc .. "/../../../../iZBaseConsole/src/iZBase/Util/CriticalSection.*",
			}
		end,

		GameSimulator = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)
			local suffix = GetSuffixFromCurrentAction()
			includedirs { 
				prjLoc .. "/../../../../SDK/samples/Motion/Win32",
				"$(DXSDK_DIR)\\include"
			}
			files { 
				prjLoc .. "/*.rc",
				prjLoc .. "/../../../../SDK/samples/IntegrationDemo/MenuSystem/UniversalInput.*",				
				prjLoc .. "/../../../../SDK/samples/IntegrationDemo/Windows/InputMgr.*",
				prjLoc .. "/../../../../SDK/samples/Motion/Win32/AkDirectInputHelper.*"
			}

			libdirs {
				prjLoc .. "/../../../$(Platform)" .. suffix .. "/$(Configuration)/lib"
			}

			entrypoint "mainCRTStartup"
			
			-- lua libs
			links {
				"LuaLib",
				"ToLuaLib",

				"dxguid",
				"ws2_32",
				"dinput8",
				"XInput",
				"Dsound",
				"shlwapi",				
				"Msacm32",
				"Dbghelp",
				"d3d9",
				"D3dx9",
				"Winmm",

				"iZHybridReverbFX",
				"iZTrashBoxModelerFX",
				"iZTrashDelayFX",
				"iZTrashDistortionFX",
				"iZTrashDynamicsFX",
				"iZTrashFiltersFX", 
				"iZTrashMultibandDistortionFX",

				"AkSink"
			}
			filter "Debug*"
				libdirs {
					prjLoc .. "/../../../../SDK/$(Platform)" .. suffix .. "/Debug/lib"
				}
			filter "Profile*"
				libdirs {
					prjLoc .. "/../../../../SDK/$(Platform)" .. suffix .. "/Profile/lib"
				}
			filter "Release*"
				libdirs {
					prjLoc .. "/../../../../SDK/$(Platform)" .. suffix .. "/Release/lib"
				}
			filter {}
			
			-- IMPORTANT! This path below MUST be added AFTER SDK/ above!
			libdirs {
				prjLoc .. "/../../../../Authoring/$(Platform)/$(Configuration)/lib"
			}
		end,
		LuaLib = function(prj)
			-- Generating AkLuaFramework.c: only during development on Windows, now that the AkLuaFramework.cpp file is in the repository.
			prebuildcommands("..\\..\\..\\..\\Tools\\Win32\\bin\\lua2c ..\\..\\..\\Scripts\\audiokinetic\\AkLuaFramework.lua ..\\..\\src\\libraries\\Common\\AkLuaFramework.cpp")
		end,
		IntegrationDemoMotion = function(prj)
			AK.Platforms.Windows.Exceptions.IntegrationDemo(prj)
		end,
		IntegrationDemo = function(prj)
			local prjLoc = AkRelativeToCwd(prj.location)
			local suffix = GetSuffixFromCurrentAction()

			entrypoint "WinMainCRTStartup"
			includedirs {
				"$(DXSDK_DIR)\\include"
			}
			libdirs { prjLoc .. "/../../../$(Platform)" .. suffix .. "/$(Configuration)/lib" }
			
			-- System
			links { 
				"dxguid",
				"ws2_32",
				"dinput8",
				"Dsound",				
				"XInput",
				"Msacm32",
				"Dbghelp",
				"d3d9",
				"D3dx9",
				"Winmm",
			}
			
			filter "Debug*"
				links "CommunicationCentral"
			filter "Profile*"
				links "CommunicationCentral"
			filter {}
		end,
		SoundEngineDllProject = function(prj)
			libdirs{"$(OutDir)../../$(Configuration)(StaticCRT)/lib"}
			flags{"WinXP"}
			staticruntime "On"
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
				projectLocation .. "../Common/stdafx.cpp"
			}
		end
	}
}
return AK.Platforms.Windows
