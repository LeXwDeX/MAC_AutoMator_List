#!/bin/bash

# 进入Automator -> 新建服务。
# 创建Shell脚本服务，并选择“自有变量”。
# 粘贴保存该代码
# 在Finder中测试

set -e  # 遇到错误时终止脚本执行

# 检查输入参数
if [ $# -eq 0 ]; then
    echo "错误：请指定要压缩的文件"
    exit 1
fi

# 获取包含目标文件的目录路径
path="${1%/*}"
cd "$path"

# 设置压缩包的基础名称
if [ $# -eq 1 ]; then
    # 如果只选择了一个文件/文件夹，使用其名称作为压缩包名称
    output_zip_base="${1##*/}"
else
    # 如果选择了多个文件/文件夹，使用默认名称
    output_zip_base="压缩文件"
fi

# 初始化最终压缩包名称
output_zip="${output_zip_base}.zip"

# 检查是否已经存在同名的压缩文件，如果是则在名称后添加数字后缀
counter=1
while [ -f "${path}/${output_zip}" ]; do
    output_zip="${output_zip_base}_${counter}.zip"
    ((counter++))
done

# 获取所有文件的相对路径
files=()
for f in "$@"; do
    files+=("${f##*/}")
done

# 直接在原位置压缩文件
if ! zip -r "${path}/${output_zip}" -X "${files[@]}" -x "*.DS_Store"; then
    echo "错误：压缩过程失败"
    exit 1
fi
