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

项目最低要求 Xcode 5，支持 iOS 6 及以上版本。需要 AFNetworking 2，1.x 不再支持。

修改明细
----
* 基于 Xcode 5.0 Single View Application 模版，通用版本；

* 编译脚本辅助系统，特色：
  - 自动编译计数，为了减少冲突，为每个独立用户分别纪录编译数最终加和。也可设置按日期格式命名；
  - 项目文件中文件自动按名称排序，强制按统一规则组织目录，也可减少合并冲突；
  - 特定注释高亮，Xcode 没有 TODO 列表？那是过去了。可指定忽略第三方库（必须放在 Frameworks 目录下）中的 TODO；
  - 强制修改产品名，clone 下项目后不改名就开发了？必须改；
  - 代码审查强制立即修改，使用方式跟高亮注释差不多，但必须指定给某个人，指定的用户必须移除注释才能通过编译。语法：`// KEYWORD(用户名): 留言内容`；
  - 智能修改判断，不会每次把所有脚本都跑一遍，只跑需要的；
  - 支持配置开关；
  - 缺陷是当项目文件修改后，会导致一次编译取消，需再跑一次。

* 包含 API 网络请求模块：
  - 基于定制的 AFNetworking，详见：[github.com/Chinamobo/AFNetworking](https://github.com/Chinamobo/AFNetworking)；
  - 通用接口访问层，基于 AFHTTPRequestOperationManager；
  - AFNetworking 扩展，在更加便捷的同时，支持更丰富的调试；
  - 自动同步插件；
  - 应用版本监测更新模块，支持 App Store 和企业发布；
  - 用户插件，登陆、用户信息获取自动化完成，高度可配置。
  
* 包含数据模块：
  - 以 Core Data 为核心，解决数据更新、获取与持久化；
  - 使用精简的 [JSONModel](https://github.com/Chinamobo/JSONModel) 优雅处理获取的 JSON 数据；
  - 包含 Core Data 基础结构，默认的 Model 文件及其 Stack；
  - Core Data Model 初始版本设为 V0；
  - Core Data Model 不兼容时重置数据，加快开发。
  
* RFUI 集成，外观无关、可复用的界面套件：
  - 引入 RFUI/Core、RFSegue、RFUI/Alpha submodule；
  - RFUI/Alpha 默认引入：RFBackground、RFButton、RFCheckbox、RFCoreData、RFCoreDataAutoFetchTableViewPlugin、RFPlugin；
  - pch 文件调整，默认包含的头文件修改为 RFUI.h。
  
* 调试增强：
  - 定制了不同模式的调试开关；
  - 开启 dout 开关：DOUT_FALG_TRACE、DOUT_ASSERT_AT_ERROR；
  - 增加 debug.h，专用于控制业务模块的调试行为；
  - 添加全局异常断点、测试失败断点。
 
* 国际化定制：
  - 增 Localizable.strings，InfoPlist.strings；
  - 本地化版本去掉英文版本，用 Base 版本替代；
  - CFBundleDevelopmentRegion 设为 zh_CN。

* 添加基础流程界面，根导航控制器，导航条改为不透明，保证后续视图布局与 iOS 6 一致；
* Deployment Target 设置为 iOS 6.0；
* Storyboard 版本设置为 iOS 6；
* 代码签名规则简化，Release 使用发布 Profile；
* 附加一组默认 UI 素材，及相应 UIAppearance 设置；
* 添加仓库级别的 git 忽略规则；
* 添加搜索路径，只需把第三方的库添加到 Frameworks 目录下就可以直接了，无需再添加相应搜索路径；
* 全套应用 Icon 及启动画面；
* Info.plist 中增加 iTunes 文件共享字段，默认关闭；
* 修正 Xcode 默认项目模版重命名后单元测试路径错误；
* 修改 info.plist 和 pch 文件路径，修正项目更名路径可能更新不正确的问题；
* 编译 scheme 整理。

Licenses
----
Copyright 2013-2014 BB9z@me.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.