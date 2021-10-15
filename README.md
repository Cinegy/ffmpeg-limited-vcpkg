# FFmpeg-limited-vcpkg: Overview

This repository contains a Windows build script and patch files to automate build of the core FFmpeg libav library, to create a very limited binary that can then be used within Cinegy software to provide AC-3 encoding.

# Prerequisites

The Git command line client and a copy of Visual Studio 2019 should be pre-installed on a machine. It is also desirable but not needed to have 7-Zip installed and in the PATH. The 'vcpkg' repository will be downloaded within the build script, which will then download any other required sources to build.

# Instructions

Clone this repository and run ```ffmpeg-limited-vcpkg.bat```.
