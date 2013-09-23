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

项目最低要求 Xcode 5.0。

修改明细
----
* 基于 Xcode 5.0 Single View Application 模版，通用版本；
* 引入定制的 AFNetworking submodule，详见：[github.com/Chinamobo/AFNetworking](https://github.com/Chinamobo/AFNetworking)
* 引入精简的 [JSONModel](https://github.com/Chinamobo/JSONModel) submodule，默认只包含了 model 的核心文件，网络部分没有使用；
* RFUI 集成：
  - 引入 RFUI/Core、RFSegue、RFUI/Alpha submodule；
  - RFUI/Alpha 默认引入：RFBackground、RFButton、RFCheckbox、RFCoreData、RFCoreDataAutoFetchTableViewPlugin、RFPlugin；
  - pch 文件调整，默认包含的头文件修改为 RFUI.h。
* 添加基础流程界面，根导航控制器，导航条改为不透明，保证后续视图布局与 iOS 6 一致；
* 国际化定制：
  - CFBundleDevelopmentRegion 设为 zh_CN。
* Deployment Target 设置为 iOS 6.0；
* Storyboard 版本设置为 iOS 6；
* 全套应用 Icon 及启动画面；

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