Chinamobo iOS 项目模版
====

使用
----
其实也没什么好说的，就是拿下来推到另一个地址。推荐的做法：

1. git clone https://github.com/Chinamobo/iOS-Project-Template.git
2. 添加目标项目的 remote
3. push 到目标仓库
4. 从目标仓库重新 clone，切到 develop 分支开始开发

这个仓库可以本地留一份，以后直接 push 到新的 remote 就可以了。

项目最低要求 Xcode 4.6。

修改明细
----
* 基于 Xcode 4.6.1 Single View Application 模版，通用版本 + ARC + Storyboard + 单元测试；

* 编译脚本辅助系统，特色：
  - 自动编译计数，为了减少冲突，为每个独立用户分别纪录编译数最终加和。也可设置按日期格式命名；
  - 项目文件中文件自动按名称排序，强制按统一规则组织目录，也可减少合并冲突，有一个缺陷是可能导致编译取消，需重新编译；
  - 特定注释高亮，Xcode 没有 TODO 列表？那是过去了。可指定忽略第三方库（必须放在 Frameworks 目录下）中的 TODO；
  - 强制修改产品名，clone 下项目后不改名就开发了？必须改；
  - 代码审查强制立即修改，使用方式跟高亮注释差不多，但必须指定给某个人，指定的用户必须移除注释才能通过编译。语法：`// KEYWORD(用户名): 留言内容`；
  - 智能修改判断，不会每次把所有脚本都跑一遍，只跑需要的；
  - 支持配置开关。
  
* 引入定制的 AFNetworking submodule，特色：
  - 精简了历史以便传输最小化，clone 下来只有几百KB；
  - 默认包含 SystemConfiguration，MobileCoreServices 两个 Frameworks，而且不必将其加入 pch 文件中；
  - 集成 AFHTTPRequestOperationLogger，便于调试网络请求。
  
* RFUI 集成：
  - 引入 RFUI/Core、RFSegue、RFUI/Alpha submodule；
  - pch 文件调整。
  
* 国际化定制：
  - 除增加默认的 Localizable.strings 外，加入 InfoPlist.strings；
  - 本地化版本去掉英文版本，用 Base 版本替代；
  - CFBundleDevelopmentRegion 设为 zh_CN。
  
* 更严格的编译警告配置，开启：
  - GCC_WARN_SHADOW
  - GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED
  - GCC_WARN_ABOUT_MISSING_FIELD_INITIALIZERS
  - GCC_WARN_ABOUT_MISSING_PROTOTYPES
  - GCC_WARN_ABOUT_MISSING_NEWLINE
  - GCC_WARN_SIGN_COMPARE
  - GCC_WARN_UNKNOWN_PRAGMAS
  - GCC_WARN_UNUSED_FUNCTION
  - GCC_WARN_UNUSED_LABEL
  - CLANG_WARN_OBJC_IMPLICIT_ATOMIC_PROPERTIES
  
* 调试增强：
  - 定制了不同模式的调试开关；
  - 开启 dout 开关：DOUT_FALG_TRACE、DOUT_ASSERT_AT_ERROR；
  - 增加 debug.h，专用于控制业务代码的调试行为；

* 修复 Xcode 默认模版修改产品名后单元测试路径错误；
* Prefix.pch 和 Info.plist 路径简化；
* 代码签名规则简化，Release 使用发布 Profile；
* 添加仓库级别的 git 忽略规则；
* 应用起始改为 RootNavigationController，隐藏导航栏；
* 增加默认的 Core Data Model 及其 Stack；
* Core Data Model 初始版本设为 V0；
* 全套应用 Icon、Launch Image 及 Info.plist 相应定义，只需删除不需要的；
* Info.plist 中增加 iTunes 文件共享字段，默认关闭；
* 添加 CoreData、QuartzCore Frameworks；
* 添加全局异常断点、全局编译 scheme；
* Deployment Target 设置为 iOS 5.0。
* Storyboard 版本设置为 iOS 5，关闭 Autolayout；
* API 模块，内容很多不细说了。
  
Licenses
----
Copyright 2013 BB9z@myopera.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.