sources = {
   "main.cc",
   "render.cc",
   "render-config.cc",
   "qrcodegen.c",
   "../common/trackball.cc",
   "../common/matrix.cc",
   "../common/imgui/imgui.cpp",
   "../common/imgui/imgui_draw.cpp",
   "../common/imgui/imgui_widgets.cpp",
   "../common/imgui/imgui_impl_btgui.cpp",
   }

-- premake5.lua
solution "QRCodeRenderSolution"
   configurations { "Release", "Debug" }

   if os.is("Windows") then
      platforms { "x64", "x32" }
   else
      platforms { "native", "x64", "x32" }
   end


   projectRootDir = os.getcwd() .. "/../common/"
   dofile ("../common/findOpenGLGlewGlut.lua")
   initOpenGL()
   initGlew()
   
   -- Use C++11
   flags { "c++11" }

   -- A project defines one build target
   project "qrcoderender"
      kind "ConsoleApp"
      language "C++"
      files { sources }

      includedirs { "./", "../../" }
      includedirs { "../common/" }
      includedirs { "../common/imgui/" }

      if os.is("Windows") then
         defines { "NOMINMAX" }
         buildoptions { "/openmp" } -- Assume vs2013 or later
         buildoptions { "/W4" } -- raise compile error level.
         files{
            "../common/OpenGLWindow/Win32OpenGLWindow.cpp",
            "../common/OpenGLWindow/Win32OpenGLWindow.h",
            "../common/OpenGLWindow/Win32Window.cpp",
            "../common/OpenGLWindow/Win32Window.h",
            }
      end
      if os.is("Linux") then
         files {
            "../common/OpenGLWindow/X11OpenGLWindow.cpp",
            "../common/OpenGLWindow/X11OpenGLWindows.h"
            }
         links {"X11", "pthread", "dl"}
      end
      if os.is("MacOSX") then
         links {"Cocoa.framework"}
         files {
                "../common/OpenGLWindow/MacOpenGLWindow.h",
                "../common/OpenGLWindow/MacOpenGLWindow.mm",
               }
      end

      configuration "Debug"
         defines { "DEBUG" } -- -DDEBUG
         flags { "Symbols" }
         targetname "qrcoderender_debug"

      configuration "Release"
         -- defines { "NDEBUG" } -- -NDEBUG
         flags { "Symbols", "Optimize" }
         targetname "qrcoderender"
