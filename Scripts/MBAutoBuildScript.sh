#! /bin/sh
# Copyright (c) 2013 Chinamobo Co., Ltd. All rights reserved.
# Maintained by BB9z (https://github.com/BB9z)

echo "MBAutoBuildScript 0.3.0"
echo "-----------------------"

# allSourceFilePathList=$(find "${SRCROOT}" \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \))
# echo "$allSourceFilePathList"

# 文件夹自动排序
if [ $enableAutoGroupSortByName = 1 ]; then
	if [ -n "$(find "$SRCROOT" -name project.pbxproj -newer "$scriptConfigPath")" ]; then
		echo "整理 project.pbxproj"
		perl -w "$scriptPath/sort-Xcode-project-file.pl" "$PROJECT_FILE_PATH"
	else
		echo "跳过 project.pbxproj 整理"
	fi
fi

# 特定注释高亮
if [ $enableCodeCommentsHighlight = 1 ]; then
	if [ $codeCommentsHighlightSkipFrameworks = 1 ]; then
		find "$SRCROOT" \( -not -path "${SRCROOT}/Frameworks/*" -and \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "// ($codeCommentsHighlightKeywords):.*\$" | perl -p -e "s/\/\/ ($codeCommentsHighlightKeywords):/ warning: \$1/"
	else
		find "$SRCROOT" \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "// ($codeCommentsHighlightKeywords):.*\$" | perl -p -e "s/\/\/ ($codeCommentsHighlightKeywords):/ warning: \$1/"
	fi
fi

# 自动构建数
if [ $enableAutoBuildCount = 1 ]; then

	# 项目目录中的文件的没有配置文件新
	# 忽略 .git 目录、xcuserdata、xcworkspace、.DS_Store文件和文件夹
	if [ -n "$(find "$SRCROOT" -not \( -name .git -prune \) -newer "$scriptConfigPath" -not -path "*.xcodeproj/xcuserdata*" -not -path "*.xcodeproj/project.xcworkspace*" -not -name ".DS_Store" -not -type d)" ]; then
		infoPlistPath="${PROJECT_DIR}/${INFOPLIST_FILE}"

		if [ -n $(/usr/libexec/Plistbuddy -c "Print CFBundleVersion" "$infoPlistPath") ]; then
			if [ $autoBuildCountUseDataFormat = 1 ]; then
				buildnum=$(date $autoBuildCountDataFormat)
			else
				buildnum=$("$scriptPath/UserBuildCount" "$scriptConfigPath" "$USER")
			fi
			/usr/libexec/Plistbuddy -c "Set CFBundleVersion $buildnum" "$infoPlistPath"
			echo "将版本设置为 $buildnum"
		else
			echo "错误：找不到 Info.plist 中的 CFBundleVersion"
		fi
	else
		echo "跳过版本设置"
	fi
fi

# 代码审查强制立即修改
# USER="User for test"
codeReviewCommandList=$(find "$SRCROOT" \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "// ($codeReviewFixRightNowKeywords)\(($USER)\).*\$")
if [[ -n "$codeReviewCommandList" ]]; then
	echo "请你（$USER）立即对以下代码进行修改"
	echo "$codeReviewCommandList" | perl -p -e "s/\/\/ ($codeReviewFixRightNowKeywords)\(($USER)\)/: CodeReview评价\(\$1\)/"
	exit 2
fi

# 提醒修改产品名
if [[ $enableChangeProductNameRemind = 1 && $PROJECT = "App" ]]; then
	if [ "$USER" != "BB9z" ]; then
		projectFilePath="${SRCROOT}/${PROJECT}.xcodeproj"
		echo "$projectFilePath:0: TODO:你必须先给项目改名"
		exit 2
	fi
fi

# 更新时间
touch "$scriptConfigPath"

# currentTime=$(date)
# /usr/libexec/Plistbuddy -c "Set LastRunTime date ${currentTime}" $scriptConfigPath

# REF https://beta.wikiversity.org/wiki/Topic:iOS/Xcode/build_script
