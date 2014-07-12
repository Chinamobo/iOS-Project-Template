Chinamobo iOS 项目模版 v3.3
====
<base href="//github.com/BB9z/iOS-Project-Template/blob/master/" />
<big>[猛击此处阅读：使用指南](Guide.md)</big>


需求
----
项目最低要求 Xcode 5.1，iOS 7 SDK，支持 iOS 6 及以上版本。


修改明细
----
* 基于 Xcode 5.0 Single View Application 模版，通用版本，已整合 Xcode 5.1 推荐设置；

* 全新 RFAPI 网络请求框架，集自动解析、错误处理、状态提醒、队列控制、缓存控制于一身，只需一行代码即可优雅完成大部分接口调用；
  - 请求基于 AFNetworking 2，理论上支持 1.x 版本。已集成[定制版](https://github.com/Chinamobo/AFNetworking)，包括 SDWebImage 及请求打印组件；
  - 集成精简的 [JSONModel](https://github.com/Chinamobo/JSONModel) 优雅处理获取的 JSON 数据；
  - 为 Reachability Manager 加入 SystemConfiguration.framework；
  - 多种插件，应用版本更新检测、用户系统插件、数据同步插件。
  
* 一整套项目级的 UI 复用控件，涉及外观定制、数据交换等等，详见 General 和 Service 目录下各文件自身的说明；

* 编译脚本辅助系统，特色：
  - 自动编译计数，为了减少冲突，为每个独立用户分别纪录编译数最终加和。也可设置按日期格式命名；
  - 项目文件中文件自动按名称排序，强制按统一规则组织目录，也可减少合并冲突；
  - 特定注释高亮，Xcode 没有 TODO 列表？那是过去了。可指定忽略第三方库（必须放在 Frameworks 目录下）中的 TODO；
  - 强制修改产品名，clone 下项目后不改名就开发了？必须改；
  - 代码审查强制立即修改，使用方式跟高亮注释差不多，但必须指定给某个人，指定的用户必须移除注释才能通过编译。语法：`// KEYWORD(用户名): 留言内容`；
  - 智能修改判断，不会每次把所有脚本都跑一遍，只跑需要的；
  - 支持配置开关；
  - 缺陷是当项目文件修改后，会导致一次编译取消，需再跑一次。
  
* 包含 Core Data 模块：
  - 包含默认的 Model 文件及其 Stack；
  - Core Data Model 初始版本设为 V0；
  - Core Data Model 不兼容时重置数据，加快开发。
  
* RFUI 集成，外观无关、可复用的界面与工具套件：
  - 引入 RFUI/Core、RFSegue、RFUI/Alpha submodule；
  - RFUI/Alpha；
  - pch 文件调整，默认包含的头文件修改为 RFUI.h。
  
* 调试增强：
  - 定制了不同模式的调试开关；
  - 开启 dout 开关：DOUT_FALG_TRACE、DOUT_ASSERT_AT_ERROR；
  - 增加 debug.h，专用于控制业务模块的调试行为；
  - 添加全局异常断点、测试失败断点。
  
* 编译设置定制：
  - 增加 AdHocTest 编译配置，专用于内部测试发布版本使用；
  - 代码签名规则简化整合；
  - 默认开启 -Wall。
 
* 国际化定制：
  - 增 Localizable.strings，InfoPlist.strings；
  - 本地化版本去掉英文版本，用 Base 版本替代；
  - CFBundleDevelopmentRegion 设为 zh_CN。

* 添加基础流程界面，根导航控制器，导航条不透明；
* Deployment Target 设置为 iOS 6.0；
* Storyboard 编译版本设为 iOS 6，全局颜色设置为红色；
* 添加仓库级别的 git 忽略规则；
* 全套应用 Icon 及启动画面；
* Info.plist 中增加 iTunes 文件共享字段，默认关闭；
* 修正 Xcode 默认项目模版重命名后单元测试路径错误；
* 修改 info.plist 和 pch 文件路径，修正项目更名路径可能更新不正确的问题；
* 编译 scheme 整理。

Licenses
----
Copyright 2013-2014 2014 Chinamobo Co., Ltd., BB9z@me.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.