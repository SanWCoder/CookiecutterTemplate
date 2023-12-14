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
