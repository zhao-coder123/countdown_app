# 🤝 贡献指南

感谢您对"圆时间"项目的关注和贡献！我们欢迎所有形式的贡献，包括但不限于：

- 🐛 Bug修复
- ✨ 新功能开发
- 📚 文档改进
- 🎨 UI/UX优化
- 🌐 国际化翻译
- 💡 功能建议

## 📋 贡献流程

### 1. 准备工作

1. **Fork仓库** - 点击项目页面右上角的"Fork"按钮
2. **克隆到本地**
   ```bash
   git clone https://github.com/your-username/circle-time.git
   cd circle-time
   ```
3. **设置上游仓库**
   ```bash
   git remote add upstream https://github.com/original-owner/circle-time.git
   ```

### 2. 开发环境

1. **安装Flutter** - 确保Flutter SDK >= 3.32.0
2. **安装依赖**
   ```bash
   flutter pub get
   ```
3. **运行项目**
   ```bash
   flutter run
   ```
4. **运行测试**
   ```bash
   flutter test
   ```

### 3. 开发流程

1. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或者
   git checkout -b fix/bug-description
   ```

2. **编写代码**
   - 遵循项目的代码规范
   - 添加必要的注释
   - 编写测试用例

3. **提交更改**
   ```bash
   git add .
   git commit -m "feat: add new countdown animation"
   ```

4. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **创建Pull Request**
   - 在GitHub上创建PR
   - 详细描述更改内容
   - 关联相关Issue

## 📝 代码规范

### Dart代码规范

遵循[Effective Dart](https://dart.dev/guides/language/effective-dart)指南：

1. **命名规范**
   ```dart
   // 类名使用PascalCase
   class CountdownModel {}
   
   // 变量和函数使用camelCase
   String countdownTitle = '';
   void createCountdown() {}
   
   // 常量使用lowerCamelCase
   const double defaultPadding = 16.0;
   
   // 私有成员以_开头
   String _privateVariable = '';
   ```

2. **代码格式化**
   ```bash
   # 使用dart format格式化代码
   dart format .
   
   # 使用flutter analyze检查代码
   flutter analyze
   ```

3. **注释规范**
   ```dart
   /// 倒计时数据模型
   /// 
   /// 包含倒计时的所有基本信息，如标题、目标日期、事件类型等
   class CountdownModel {
     /// 倒计时标题
     final String title;
     
     /// 目标日期
     final DateTime targetDate;
     
     /// 创建新的倒计时实例
     /// 
     /// [title] 倒计时标题，不能为空
     /// [targetDate] 目标日期，必须是未来时间
     CountdownModel({
       required this.title,
       required this.targetDate,
     });
   }
   ```

### Git提交规范

使用[Conventional Commits](https://www.conventionalcommits.org/)规范：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**类型说明:**
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建工具、依赖管理等

**示例:**
```
feat(countdown): add circular progress animation

Add smooth circular progress animation for countdown display.
The animation updates every second and shows visual progress.

Closes #123
```

## 🧪 测试指南

### 1. 单元测试
```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/models/countdown_model_test.dart

# 生成测试覆盖率报告
flutter test --coverage
```

### 2. 集成测试
```bash
# 运行集成测试
flutter test integration_test/
```

### 3. 测试示例
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/countdown_model.dart';

void main() {
  group('CountdownModel', () {
    test('should create countdown with valid data', () {
      final countdown = CountdownModel(
        title: 'Test Event',
        targetDate: DateTime.now().add(Duration(days: 30)),
        createdAt: DateTime.now(),
      );
      
      expect(countdown.title, 'Test Event');
      expect(countdown.isExpired, false);
    });
  });
}
```

## 🐛 报告Issue

报告Bug或提出功能建议时，请提供：

### Bug报告模板
```markdown
**Bug描述**
简洁明了地描述Bug

**重现步骤**
1. 打开应用
2. 点击'...'
3. 滚动到'...'
4. 看到错误

**期望行为**
描述您期望发生的行为

**实际行为**
描述实际发生的行为

**环境信息**
- 设备: [例如 iPhone 12, Samsung Galaxy S21]
- 操作系统: [例如 iOS 15.0, Android 12]
- 应用版本: [例如 1.0.0]
- Flutter版本: [例如 3.32.4]

**截图**
如果适用，添加截图来解释问题
```

### 功能请求模板
```markdown
**功能描述**
简洁明了地描述您想要的功能

**问题解决**
这个功能解决了什么问题？

**解决方案**
描述您希望实现的解决方案

**替代方案**
描述您考虑过的其他替代解决方案

**其他信息**
添加关于功能请求的其他信息或截图
```

## 🎨 设计指南

### UI/UX原则
1. **简洁性** - 界面简洁明了，避免复杂操作
2. **一致性** - 保持设计风格和交互模式的一致性
3. **可访问性** - 考虑不同用户群体的使用需求
4. **反馈性** - 提供明确的操作反馈

### 颜色系统
项目使用预定义的渐变色彩系统，新增颜色时请：
1. 保持与现有色彩的协调性
2. 确保足够的对比度
3. 在深色和浅色主题下都能良好显示

### 动画规范
1. **持续时间** - 短距离动画 200-300ms，长距离动画 400-500ms
2. **缓动函数** - 使用Material Design的标准缓动曲线
3. **性能** - 避免过度复杂的动画影响性能

## 📦 发布流程

### 版本号规范
使用[语义化版本控制](https://semver.org/)：

```
MAJOR.MINOR.PATCH

1.0.0 -> 1.0.1 (补丁)
1.0.1 -> 1.1.0 (次版本)
1.1.0 -> 2.0.0 (主版本)
```

### 发布检查清单
- [ ] 所有测试通过
- [ ] 代码分析无错误
- [ ] 更新版本号
- [ ] 更新CHANGELOG.md
- [ ] 创建发布标签
- [ ] 构建发布版本

## 🙋‍♀️ 获得帮助

如果您在贡献过程中遇到问题：

1. **查看文档** - 首先查看项目文档和README
2. **搜索Issues** - 查看是否有相关的讨论或解决方案
3. **创建Discussion** - 在GitHub Discussions中提问
4. **联系维护者** - 通过Issue或邮件联系项目维护者

## 📜 行为准则

我们致力于创建一个开放、友好的社区环境。参与项目时请：

1. **尊重他人** - 尊重不同的观点和经验
2. **建设性沟通** - 提供有建设性的反馈和建议
3. **包容性** - 欢迎所有背景的贡献者
4. **专业性** - 保持专业和友善的态度

## 🎉 感谢贡献者

所有贡献者都会在项目中得到认可。我们使用[All Contributors](https://allcontributors.org/)规范来致谢贡献者。

---

再次感谢您的贡献！每一个PR、Issue和建议都让"圆时间"变得更好。 🙏 