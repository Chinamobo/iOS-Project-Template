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


修改明细
----
* 基于 Xcode 4.6.1 Single View Application 模版，通用版本 + ARC + Storyboard + 单元测试；

* 编译脚本辅助系统，特色：
  - 自动编译计数，为了减少冲突，为每个独立用户分别纪录编译数最终加和。也可设置按日期格式命名；
  - 项目文件中文件自动按名称排序，强制按统一规则组织目录，也可减少合并冲突；
  - 特定注释高亮，Xcode 没有 TODO 列表？那是过去了。可指定忽略第三方库中的 TODO；
  - 强制修改产品名，clone 下项目后不改名就开发了？必须改；
  - 智能修改判断，不会每次把所有脚本都跑一遍，只跑需要的；
  - 支持配置开关。
  
* 引入定制的 AFNetworking submodule，特色：
  - 传输最小化，clone 下来只有几百KB；
  - 默认包含 SystemConfiguration，MobileCoreServices 两个 Frameworks，而且不必将其加入 pch 文件中；
  - 加入 AFHTTPRequestOperationLogger，便于查看做了哪些请求。
  
* RFUI 集成：
  - 引入 RFUI/Core、RFSegue submodule；
  - pch 文件调整；
  - 为不同编译模式添加调试开关定义；
  
* 修复 Xcode 默认模版修改产品名后默认的单元测试路径错误；
* Prefix.pch 和 Info.plist 路径简化；
* 增加 debug.h，控制开发调试行为；
* 代码签名规则简化，Release 使用发布 Profile；
* 添加仓库级别的 git 忽略规则；
* 项目国际化设置增加简体中文；
* Storyboard 默认本地化语言改为简体中文；
* 应用起始改为 RootNavigationController，隐藏导航栏；
* 增加默认的 Core Data Model 及其 Stack；
* 全套应用 Icon、Launch Image 及 Info.plist 相应定义，只需删除不需要的；
* 添加了最常见的二进制 Frameworks：CoreData、QuartzCore；
* 添加全局异常断点、全局编译 scheme；
* iOS 5.0 的 Deployment Target。Storyboard 版本设置为 iOS 5，关闭 Autolayout；
* API 模块，不细说了。
  
