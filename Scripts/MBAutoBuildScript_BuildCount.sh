#! /bin/sh
# Copyright (c) 2013-2014 Chinamobo Co., Ltd. All rights reserved.
# Maintained by BB9z (https://github.com/BB9z)

echo "MBAutoBuildScript Build Count 0.5.1"
echo "-----------------------"

# 自动构建数
if [ $enableAutoBuildCount = 1 ]; then
	buildnum=$("$scriptPath/UserBuildCount" "$buildCountRecordFile" "$USER")
	
	if [ $CONFIGURATION = "Debug" ]; then
		echo "Debug 模式，跳过版本设置"
		
	# 项目目录中的文件的没有配置文件新
	# 忽略 .git 目录、xcuserdata、xcworkspace、.DS_Store文件和文件夹
	else 
		if [ -n "$(find "$SRCROOT" -not \( -name .git -prune \) -newer "$buildCountRecordFile" -not -path "*.xcodeproj/xcuserdata*" -not -path "*.xcodeproj/project.xcworkspace*" -not -name ".DS_Store" -not -type d)"]; then
			infoPlistPath="${PROJECT_DIR}/${INFOPLIST_FILE}"

			if [ -n $(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$infoPlistPath") ]; then
				if [ $autoBuildCountUseDataFormat = 1 ]; then
					buildnum=$(date $autoBuildCountDataFormat)
				fi
				/usr/libexec/PlistBuddy -c "Set CFBundleVersion $buildnum" "$infoPlistPath"
				echo "将版本设置为 $buildnum"
			else
				echo "错误：找不到 Info.plist 中的 CFBundleVersion"
			fi
		else
			echo "跳过版本设置"
		fi
	fi
fi
