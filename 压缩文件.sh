#!/bin/bash
set -e  # 遇到错误时终止脚本执行

# 检查输入参数
if [ $# -eq 0 ]; then
    echo "错误：请指定要压缩的文件"
    exit 1
fi

# 获取包含目标文件的目录路径
path="${1%/*}"
cd "$path"

# 创建临时目录
tempdir="${path}/temp_$$"
mkdir "$tempdir" || {
    echo "错误：无法创建临时目录"
    exit 1
}

# 移动所有选定的文件和目录到临时目录中
for f in "$@"
do
    # 获取目标文件名
    name="${f##*/}"
    cp -r "$f" "$tempdir/"
done

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

# 压缩所有临时目录中的内容
cd "$tempdir"
if ! zip -r "${path}/${output_zip}" -X . -x "*.DS_Store"; then
    cd "$path"
    rm -rf "$tempdir"
    echo "错误：压缩过程失败"
    exit 1
fi

# 返回起始目录并清理临时目录
cd "$path"
rm -rf "$tempdir"
