#! /bin/sh
# Copyright (c) 2013 Chinamobo Co., Ltd. All rights reserved.
# Maintained by BB9z (https://github.com/BB9z)

echo "MBAutoBuildScript 0.4.1"
echo "Copyright (c) 2013 Chinamobo Co., Ltd. All rights reserved."
echo "-----------------------"

cd "$ScriptPath"
timeFile=$"$ScriptPath/PreBuild.time"

# 文件夹自动排序
if [ $EnableAutoGroupSortByName = "YES" ]; then
	if [ -n "$(find "$SRCROOT" -name project.pbxproj -newer "$timeFile")" ]; then
		perl -w "$ScriptPath/sort-Xcode-project-file.pl" "$PROJECT_FILE_PATH"
		echo "$ProjectFilePath:0: 整理 project.pbxproj，请重新编译项目"
		touch "$timeFile"
		exit 1
	else
		echo "跳过 project.pbxproj 整理"
	fi
fi

# 代码审查强制立即修改
# USER="User for test"
codeReviewCommandList=$(find "$SRCROOT" \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "// ($CodeReviewFixRightNowKeywordsExpression)\(($USER)\).*\$")
if [[ -n "$codeReviewCommandList" ]]; then
	echo "请你（$USER）立即对以下代码进行修改"
	echo "$codeReviewCommandList" | perl -p -e "s/\/\/ ($CodeReviewFixRightNowKeywordsExpression)\(($USER)\)/: CodeReview评级\(\$1\)/"
	exit 2
fi

# 特定注释高亮
if [ $EnableCodeCommentsHighlight = "YES" ]; then
	if [ $CodeCommentsHighlightSkipFrameworks = "YES" ]; then
		find "$SRCROOT" \( -not -path "${SRCROOT}/Frameworks/*" -and \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "// ($CodeCommentsHighlightKeywordsExpression):.*\$" | perl -p -e "s/\/\/ ($CodeCommentsHighlightKeywordsExpression):/ warning: \$1/"
	else
		find "$SRCROOT" \( -name "*.h" -or -name "*.m" -or -name "*.mm" -or -name "*.c" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "// ($CodeCommentsHighlightKeywordsExpression):.*\$" | perl -p -e "s/\/\/ ($CodeCommentsHighlightKeywordsExpression):/ warning: \$1/"
	fi
fi

# 提醒修改产品名
if [[ $EnableChangeProductNameRemind = "YES" && $PROJECT = "App" ]]; then
	if [ "$USER" != "BB9z" ]; then
		echo "$ProjectFilePath:0: 提示: 强制提醒修改产品名已启用，你必须先给项目改名才能编译"
		exit 2
	fi
fi

touch "$timeFile"

# REF https://beta.wikiversity.org/wiki/Topic:iOS/Xcode/build_script
