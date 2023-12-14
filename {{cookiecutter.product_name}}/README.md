
## intro

使用Cookiecutter模板创建项目

```
~ brew install Cookiecutter
```

## use

```
~ cd /xxx/xxx // 项目目录
~ cookiecutter https://github.com/SanWCoder/CookiecutterTemplate.git
```

## 创建模版

#### 打开 Xcode，新建一个单页应用。

```
Product Name: {{cookiecutter.product_name}}
Organization Name: {{cookiecutter.organization_name}}
Organization Identifier: {{cookiecutter.organization_identifier}}
```

#### 配置文件

在{{cookiecutter.product_name}} 文件夹所在的目录，创建一个 cookiecutter.json 文件

```
// JSON 中的 key 就是我们刚才创建项目时填写的那几个用双括号包含起来的名称，并且去掉 cookiecutter 前缀，key 对应的值表示默认值。使用 Cookiecutter 从模版创建项目时，它会询问配置文件中的这几个 key，让我们给它指定名称，如果不指定，则使用配置文件中的默认值。
// cookiecutter.json
{
    "product_name": "Project",
    "organization_name": "Test Co.,Ltd.",
    "bundle_identifier": "com.test.project"
}

```
#### 安装pods
Cookiecutter 支持两个事件，即创建项目之前和创建项目完成之后，会分别调用对应的脚本文件，目前支持 shell 脚本和 python 脚本。在安装前调用的脚本需要命名为 pre_gen_project.sh 或者 pre_gen_project.py；同样的，在安装之后调用的脚本需要命名为 post_gen_project.sh 或者 post_gen_project.py，取决于脚本使用的语言。

1. 在 {{cookiecutter.product_name}}/ 目录下创建 Podfile 文件，并配置好常用的依赖库：

```
// {{cookiecutter.product_name}}/Podfile

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
# export LANG=en_US.UTF-8
target '{{cookiecutter.product_name}}' do
    # Comment the next line if you don't want to use dynamic frameworks
  source 'https://github.com/CocoaPods/Specs.git'
  
  use_frameworks!
  
  ## 第三方SDK
  # runScript => "${PODS_ROOT}/SwiftLint/swiftlint"
  pod 'SwiftFormat/CLI',                    "0.50.1"
  pod 'SwiftLint',                          '0.51.0'
  pod 'Schedule',                           "2.1.0"
end

## 检查是否安装插件
pre_install do |installer|
  # 插件路径
  sandbox_root = Pathname(installer.sandbox.root)
  ycroot = File.expand_path("../", sandbox_root)
  # lint-staged
  node_module_lint_stage = File.expand_path("node_modules/lint-staged/",ycroot)
  has_lint_stage = File.exist?(node_module_lint_stage)
  # husky
  node_module_husky = File.expand_path("node_modules/husky",ycroot)
  has_husky = File.exist?(node_module_husky)
  # commitizen
  node_module_commitizen = File.expand_path("node_modules/commitizen",ycroot)
  has_commitizen = File.exist?(node_module_commitizen)
  # cz-conventional-changelog
  node_module_changelog = File.expand_path("node_modules/cz-conventional-changelog",ycroot)
  has_changelog = File.exist?(node_module_changelog)
  # cz-customizable
  node_module_customizable = File.expand_path("node_modules/cz-customizable",ycroot)
  has_customizable = File.exist?(node_module_customizable)
  # commitlint
  node_module_commitlint = File.expand_path("node_modules/@commitlint",ycroot)
  has_commitlint = File.exist?(node_module_commitlint)
  
  if has_husky && has_lint_stage && has_commitizen && node_module_changelog && has_customizable && has_commitlint
    Pod::UI.puts "lint staged，husky，commitizen，cz-conventional-changelog，cz-customizable，commitlint 已安装"
  else
    raise "warning error： lint staged，husky，commitizen，cz-conventional-changelog，cz-customizable，commitlint不存在，请使用以下命令安装: npm install"
  end
end

# error: File not found: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphoneos.a
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

```
2. 在 跟目录下创建hooks文件夹，并创建post_gen_project.sh脚本

```
#!/bin/bash

DEFAULT='\033[0;39m'
WHITE='\033[0;97m'
GREEN='\033[0;32m'
LIGHTGREEN='\033[0;92m'
CYAN='\033[0;36m'
LIGHTCYAN='\033[0;96m'

echo -e "${GREEN}All files successfuly generated!"

# 一.git install
echo -e "${CYAN}git init...${DEFAULT}"

git init

echo -e "${GREEN}git init successfuly"

# 二.npm install
echo -e "${CYAN}Running npm install on your new library."
# 1.add package.json
touch package.json
echo '{
  "name": "lint",
  "version": "1.0.0",
  "private": true,
  "devDependencies": {
    "@commitlint/cli": "^17.7.1",
    "@commitlint/config-conventional": "^17.7.0",
    "commitizen": "^4.3.0",
    "cz-conventional-changelog": "^3.3.0",
    "cz-customizable": "^7.0.0",
    "husky": "^8.0.3",
    "lint-staged": "^13.2.3"
  },
  "lint-staged": {
    "*.swift": [
      "Pods/SwiftLint/swiftlint lint"
    ]
  },
  "scripts": {
    "commit": "git-cz"
  },
  "config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    },
    "cz-customizable": {
      "config": "cz-config.js"
    }
  }
}' >> package.json

# 2.add SwiftLint
npm install --save-dev lint-staged
npm install husky --save-dev
npx husky install
npx husky add .husky/pre-commit "Pods/SwiftFormat/CommandLineTool/swiftformat ./{{cookiecutter.product_name}}

npx lint-staged"
npm install commitizen cz-conventional-changelog -D
npm i @commitlint/config-conventional @commitlint/cli -D
npm install cz-customizable -D
npx husky add .husky/commit-msg "npx --no-install commitlint --edit $1"

# 3.add .swiftlint.yml
touch .swiftlint.yml
echo 'included:                                       # 执行lint包含的路径
#    - Example/Folder                            # 指定目录
#    - Example/Folder/AppDelegate.swift         # 指定文件
    - {{cookiecutter.product_name}}                 # 指定lint需包含../xxx/Classes目录

excluded:                                       # 执行lint忽略的路径，优先级高于 `included`
    - Pods                                      # 忽略Pods

#disabled_rules:                                 # 执行时排除掉的规则
#    - identifier_name                           # 驼峰命名检查,between 3 and 40
#    - trailing_whitespace                       # 空行不能有空格

#force_try: warning                              # 避免使用强制try

#force_cast: warning                             # 直接强解类型 eg: NSNumber() as! Int

#type_name: warning                              # 类型名称违规 eg：类型首字母需大写

#shorthand_operator: warning                     # 推荐使用简短操作符 eg：+= ， -=， *=， /=

function_parameter_count:                       # 函数参数个数
    warning: 5
    error: 10

function_body_length:                           # 函数体长度 40lines - 100lines
    warning: 150
    error: 200

cyclomatic_complexity:                          # 代码复杂度,默认为10
    warning: 40
    error: 50

large_tuple:                                     # 元组成员个数:2
    warning: 5
    error: 7

line_length:                                    # 单行代码长度,默认error 200
    warning: 300
    error: 350

type_body_length:                               # 文件长度
    warning: 800
    error: 1000

' >> .swiftlint.yml

# 4.add .swiftformat
touch .swiftformat
echo '--allman false
--assetliterals visual-width
--beforemarks
--binarygrouping none
--categorymark "MARK: %c"
--classthreshold 0
--closingparen balanced
--commas always
--conflictmarkers reject
--decimalgrouping none
--elseposition same-line
--enumthreshold 0
--exponentcase lowercase
--exponentgrouping disabled
--extensionacl on-extension
--extensionlength 0
--extensionmark "MARK: - %t + %c"
--fractiongrouping disabled
--fragment false
--funcattributes preserve
--groupedextension "MARK: %c"
--guardelse auto
--header ignore
--hexgrouping 4,8
--hexliteralcase uppercase
--ifdef indent
--importgrouping alphabetized
--indent 4
--indentcase false
--lifecycle
--linebreaks lf
--markextensions always
--marktypes always
--maxwidth none
--modifierorder
--nevertrailing
--nospaceoperators ...,..<
--nowrapoperators
--octalgrouping none
--operatorfunc spaced
--organizetypes class,enum,struct
--patternlet hoist
--ranges spaced
--redundanttype inferred
--self remove
--selfrequired
--semicolons inline
--shortoptionals always
--smarttabs enabled
--stripunusedargs closure-only
--structthreshold 0
--tabwidth unspecified
--trailingclosures
--trimwhitespace always
--typeattributes preserve
--typemark "MARK: - %t"
--varattributes preserve
--voidtype void
--wraparguments preserve
--wrapcollections preserve
--wrapconditions preserve
--wrapparameters preserve
--wrapreturntype preserve
--xcodeindentation disabled
--yodaswap always
' >> .swiftformat

# 5.add commitlint.config.js
touch commitlint.config.js
echo 'module.exports = {
  extends: ["@commitlint/config-conventional"]
}' >> commitlint.config.js

# 6.add .cz-config.js
touch .cz-config.js
echo 'module.exports = {
    types: [
      { value: "feat", name: "feat: 新增功能" },
      { value: "fix", name: "fix: 修复 bug" },
      { value: "docs", name: "docs: 文档变更" },
      { value: "style", name: "style: 代码格式（不影响功能，例如空格、分号等格式修正）" },
      { value: "refactor", name: "refactor: 代码重构（不包括 bug 修复、功能新增）" },
      { value: "perf", name: "perf: 性能优化" },
      { value: "test", name: "test: 添加、修改测试用例" },
      { value: "build", name: "build: 构建流程、外部依赖变更（如升级 npm 包、修改 webpack 配置等）" },
      { value: "ci", name: "ci: 修改 CI 配置、脚本" },
      { value: "chore", name: "chore: 对构建过程或辅助工具和库的更改（不影响源文件、测试用例）" },
      { value: "revert", name: "revert: 回滚 commit" }
    ],
    scopes: [
      ["components", "组件相关"],
      ["hooks", "hook 相关"],
      ["utils", "utils 相关"],
      ["styles", "样式相关"],
      ["deps", "项目依赖"],
      ["auth", "对 auth 修改"],
      ["other", "其他修改"],
      ["custom", "以上都不是？我要自定义"]
    ].map(([value, description]) => {
      return {
        value,
        name: `${value.padEnd(30)} (${description})`
      }
    }),
    messages: {
      type: "请选择提交类型(必填)",
      scope: "选择一个 scope (可选)",
      customScope: "请输入文件修改范围(可选)",
      subject: "请简要描述提交(必填)",
      body:"请输入详细描述(可选)",
      breaking: "列出任何BREAKING CHANGES(破坏性修改)(可选)",
      footer: "请输入要关闭的issue(可选)",
      confirmCommit: "确认提交？"
    },
    allowBreakingChanges: ["feat", "fix"],
    subjectLimit: 100,
    breaklineChar: "|"
  }' >> .cz-config.js
        
echo -e "${GREEN}npm install successfuly generated!"

# 三.pod install
echo -e "${CYAN}Installing Pods...${DEFAULT}"

pod install

echo -e "${LIGHTGREEN}Project {{cookiecutter.product_name}} successfully generated!${DEFAULT}"

# 四.Open project
echo -n "Open project with Xcode? (y/n) "

read open

if [ $open == "y" ]
then
open -a Xcode {{cookiecutter.product_name}}.xcworkspace
echo -e "${LIGHTGREEN}Open project {{cookiecutter.product_name}} whit Xcode.${DEFAULT}"
fi

```

#### 分发模版

```
cookiecutter https://github.com/SanWCoder/CookiecutterTemplate.git

```











