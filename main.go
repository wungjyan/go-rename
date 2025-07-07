package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	// 1. 询问路径
	fmt.Print("请输入要重命名的文件夹路径（直接回车为当前路径）：")
	inputPath, _ := reader.ReadString('\n')
	inputPath = strings.TrimSpace(inputPath)
	if inputPath == "" {
		inputPath, _ = os.Getwd()
	}

	// 2. 是否排除文件夹
	fmt.Print("是否排除文件夹的重命名？(y/N)：")
	excludeDirInput, _ := reader.ReadString('\n')
	excludeDirInput = strings.TrimSpace(strings.ToLower(excludeDirInput))
	excludeDir := excludeDirInput == "y" || excludeDirInput == "yes"

	// 3. 输入匹配规则
	fmt.Print("请输入用于匹配的正则表达式或字符串：")
	pattern, _ := reader.ReadString('\n')
	pattern = strings.TrimSpace(pattern)
	if pattern == "" {
		fmt.Println("匹配规则不能为空，程序退出。")
		return
	}

	// 4. 输入新名称模板
	fmt.Print("请输入新的名称模板（可用 $1, $2... 表示分组）：")
	replaceTemplate, _ := reader.ReadString('\n')
	replaceTemplate = strings.TrimSpace(replaceTemplate)
	if replaceTemplate == "" {
		fmt.Println("新名称不能为空，程序退出。")
		return
	}

	// 5. 遍历并重命名
	err := batchRename(inputPath, pattern, replaceTemplate, excludeDir)
	if err != nil {
		fmt.Println("重命名过程中发生错误：", err)
	} else {
		fmt.Println("重命名完成！")
	}
}

func batchRename(root, pattern, replaceTemplate string, excludeDir bool) error {
	re, err := regexp.Compile(pattern)
	if err != nil {
		return fmt.Errorf("正则表达式错误: %v", err)
	}

	return filepath.Walk(root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if path == root {
			return nil // 跳过根目录
		}
		if excludeDir && info.IsDir() {
			return nil
		}
		oldName := info.Name()
		if re.MatchString(oldName) {
			newName := re.ReplaceAllString(oldName, replaceTemplate)
			if newName != oldName {
				newPath := filepath.Join(filepath.Dir(path), newName)
				err := os.Rename(path, newPath)
				if err != nil {
					fmt.Printf("重命名失败: %s -> %s, 错误: %v\n", path, newPath, err)
				} else {
					fmt.Printf("重命名: %s -> %s\n", path, newPath)
				}
			}
		}
		return nil
	})
}
