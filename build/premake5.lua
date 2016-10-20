-- premake5.lua
--[[
Usage examples: 
	for windows: premake5.exe --os=windows vs2015
	fot linux:   premake5.exe --os=linux gmake
]]

grpc_root = "../third_party/grpc"
protobuf_root = grpc_root .. "/third_party/protobuf"

workspace "grpc_cb"
	configurations { "Debug", "Release" }
	language "C++"
	flags {
		"C++11",
		"StaticRuntime",
	}
	includedirs {
		"../include",
		grpc_root .. "/include",
		protobuf_root .. "/src",
	}
	libdirs {
		grpc_root .. "/vsprojects/%{cfg.buildcfg}",
		protobuf_root .. "/cmake/%{cfg.buildcfg}",
	}
	links {
		"grpc_cb",
		"grpc",
		"gpr",
		"zlib",
	}

	filter "configurations:Debug"
		flags { "Symbols" }
		links {
			"libprotobufd",
		}
	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"
		links {
			"libprotobuf",
		}
	filter {}

	if os.is("windows") then
		defines {
			"_WIN32_WINNT=0x0600"  -- i.e. Windows 7 target
		}
	end

project "grpc_cb"
	kind "StaticLib"
	files {
		"../include/grpc_cb/**.h",
		"../src/cpp_cb/**",
	}

project "greeter_cb_client"
	kind "ConsoleApp"
	files {
		"../examples/cpp_cb/helloworld/**",
	}
	removefiles {
		"../examples/cpp_cb/helloworld/greeter_cb_server.cc",
	}
project "greeter_cb_server"
	kind "ConsoleApp"
	files {
		"../examples/cpp_cb/helloworld/**",
	}
	removefiles {
		"../examples/cpp_cb/helloworld/greeter_cb_client.cc",
	}
project "route_guide_cb_client"
	kind "ConsoleApp"
	files {
		"../examples/cpp_cb/route_guide/**",
	}
	removefiles {
		"../examples/cpp_cb/route_guide/route_guide_cb_server.cc",
	}
project "route_guide_cb_server"
	kind "ConsoleApp"
	files {
		"../examples/cpp_cb/route_guide/**",
	}
	removefiles {
		"../examples/cpp_cb/route_guide/route_guide_cb_client.cc",
	}

project "grpc_cpp_cb_plugin"
	kind "ConsoleApp"
	files {
		"../src/compiler/**",
	}
	includedirs {
		"..",
		grpc_root,
	}
	libdirs {
		grpc_root .. "/vsprojects/%{cfg.buildcfg}",  -- DEL
		protobuf_root .. "/cmake/%{cfg.buildcfg}",  -- DEL
	}
	links {
		"grpc_plugin_support",
	}
	removelinks {
		"grpc_cb",
		"grpc",
		"gpr",
		"zlib",
	}

	filter "configurations:Debug"
		links {
			"libprotocd",
		}
	filter "configurations:Release"
		links {
			"libprotoc",
		}
	filter {}
