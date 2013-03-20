#!

# 项目目录中的文件的没有配置文件新
# 忽略 .git 目录、xcuserdata、xcworkspace、.DS_Store文件和文件夹
if [ -n "$(find "$SRCROOT" -not \( -name .git -prune \) -newer "$scriptConfigPath" -not -path "*.xcodeproj/xcuserdata*" -not -path "*.xcodeproj/project.xcworkspace*" -not -name ".DS_Store" -not -type d)" ]
then
	# 自动构建数
	if [ $enableAutoBuildCount = 1 ]; then
		infoPlistPath="${PROJECT_DIR}/${INFOPLIST_FILE}"

		if [ -n $(/usr/libexec/Plistbuddy -c "Print CFBundleVersion" "$infoPlistPath") ]; then
			buildnum=$("$scriptPath/UserBuildCount" "$scriptConfigPath" "$USER")
			# 或使用日期（形如：121204）：
			# buildnum=$(date "+%y%m%d")
			/usr/libexec/Plistbuddy -c "Set CFBundleVersion $buildnum" "$infoPlistPath"
		else
			echo "错误：Info.plist 中没有CFBundleVersion"
		fi
	fi

	# 文件夹自动排序
	if [ $enableAutoGroupSortByName = 1 ]; then
		perl -w "$scriptPath/sort-Xcode-project-file.pl" "$PROJECT_FILE_PATH"
	fi

	# 特定注释高亮
	if [ $enableCodeCommentsHighlight = 1 ]; then
		if [ $codeCommentsHighlightSkipFrameworks = 1 ]; then
			find "$SRCROOT" \( -not -path "${SRCROOT}/Frameworks/*" -and \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($codeCommentsHighlightKeywords).*\$" | perl -p -e "s/($codeCommentsHighlightKeywords)/ warning: \$1/"
		else
			find "$SRCROOT" \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($codeCommentsHighlightKeywords).*\$" | perl -p -e "s/($codeCommentsHighlightKeywords)/ warning: \$1/"
		fi
	fi

	# 更新时间
	touch "$scriptConfigPath"
else
	echo "没有修改，跳过构建脚本"
fi

# currentTime=$(date)
# /usr/libexec/Plistbuddy -c "Set LastRunTime date ${currentTime}" $scriptConfigPath

# REF https://beta.wikiversity.org/wiki/Topic:iOS/Xcode/build_script
