# go-rename

## 📖 项目简介

go-rename 是一个用 Go 语言编写的批量文件重命名工具，支持正则表达式匹配和替换，跨平台使用，简单高效。

### ✨ 主要功能

- 🔍 支持正则表达式匹配文件名
- 🔄 支持分组替换（$1, $2 等）
- 📁 可选择是否包含文件夹重命名
- 🖥️ 跨平台支持（Windows、macOS、Linux）
- 💻 交互式命令行界面

## 📦 下载安装

### 方式一：下载预编译版本（推荐）

前往 [Releases 页面](https://github.com/wungjyan/go-rename/releases) 下载适合您操作系统的预编译版本：

- **Windows 64位**: `go-rename-windows-amd64.exe`
- **Windows 32位**: `go-rename-windows-386.exe`
- **macOS Intel**: `go-rename-darwin-amd64`
- **macOS Apple Silicon**: `go-rename-darwin-arm64`
- **Linux 64位**: `go-rename-linux-amd64`
- **Linux 32位**: `go-rename-linux-386`
- **Linux ARM64**: `go-rename-linux-arm64`
- **Linux ARM**: `go-rename-linux-arm`

### 方式二：从源码编译

1. 确保已安装 Go 1.22 或更高版本
2. 克隆本仓库：
   ```bash
   git clone https://github.com/wungjyan/go-rename.git
   cd go-rename
   ```
3. 编译：
   ```bash
   go build -o go-rename main.go
   ```

## 🚀 使用方法

1. 运行程序：
   ```bash
   ./go-rename
   ```

2. 按照提示依次输入：
   - **文件夹路径**：要处理的目录路径（直接回车使用当前目录）
   - **是否排除文件夹**：选择是否跳过文件夹的重命名
   - **匹配规则**：正则表达式或普通字符串
   - **替换模板**：新的文件名模板（支持 $1, $2 等分组引用）

### 📝 使用示例

#### 示例1：批量添加前缀
```
请输入要重命名的文件夹路径：/path/to/files
是否排除文件夹的重命名？(y/N)：y
请输入用于匹配的正则表达式或字符串：(.*)
请输入新的名称模板：prefix_$1
```

#### 示例2：修改文件扩展名
```
请输入要重命名的文件夹路径：/path/to/files
是否排除文件夹的重命名？(y/N)：y
请输入用于匹配的正则表达式或字符串：(.+)\.txt$
请输入新的名称模板：$1.bak
```

#### 示例3：提取数字并重新排序
```
请输入要重命名的文件夹路径：/path/to/files
是否排除文件夹的重命名？(y/N)：y
请输入用于匹配的正则表达式或字符串：file(\d+)\.jpg
请输入新的名称模板：image_$1.jpg
```

## 🔒 安全性

- 下载文件后可使用 `checksums.txt` 验证文件完整性
- 所有二进制文件均通过 GitHub Actions 自动构建，确保安全可靠

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目采用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。