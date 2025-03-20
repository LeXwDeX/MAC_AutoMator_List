# Mac_AutoMator自动化脚本（个人用）

![Automator Logo](./assets/automator.png)

## 压缩文件
- `zip.sh`：通过调用`zip`命令进行压缩，压缩的时候会忽略`DS_Store`文件，并且不会有`GBK`和`UTF-8`乱码的问题。
- 使用之前先执行`brew install 7zip`确保默认环境有`zip`指令
- `AutoMator`中的环境变量为`bash`
![ZIP Config](./assets/config.png)