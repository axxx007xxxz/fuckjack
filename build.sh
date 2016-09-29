#!/bin/bash

#
# The "Fuck Jack Build Script"
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Written by Michael S Corigliano (Mike Criggs) (michael.s.corigliano@gmail.com)
#
# The purpose of this script is to work around JACK and NINJA, which have been
# broken in AOSP as of android-7.0.
#
# Usage: ./build.sh <DEVICE>
#

DEVICE="$1"

# Tell the environment not to use NINJA
	export USE_NINJA=false

# Delete the JACK server located in /home/<USER>/.jack*
	rm -rf ~/.jack*

# Resize the JACK Heap size
	export ANDROID_JACK_VM_ARGS="-Xmx4g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

# Restart the JACK server
	./prebuilts/sdk/tools/jack-admin kill-server
	./prebuilts/sdk/tools/jack-admin start-server

# Optionally, you may want to clear CCACHE if you still have issues
#	ccache -C

# Make a clean build, building dirty after you have had jack issues may result in a failed build
	make clean

# Compile the build
	. build/envsetup.sh
	lunch du_$DEVICE-userdebug
	make bacon
