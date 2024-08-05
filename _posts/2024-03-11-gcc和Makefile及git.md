---
layout:     post   				    # 使用的布局（不需要改）
title:      gcc,Makefile与git		# 标题 
subtitle:   《Linux系统与编程实践》第9课 #副标题
date:       2024-03-11 				# 时间
author:     tfzhang 				# 作者
header-img: img/post-bg-2015.jpg 	#这篇文章标题背景图片
catalog: true 						# 是否归档
tags:								#标签
    - ubuntu	
    - linux课程
    - Nginx
---

## gcc,Makefile与git

##### Org: 浙江工商大学 计算机学院 

##### Class: 《Linux系统与编程实践》

##### Author: tfzhang@mail.zjgsu.edu.cn

##### Created: 2024.03.11   

##### Updated: 2024.04.24



本章主要介绍linux下的开发工具gcc、Makefile与git版本管理工具。

#### 1、gcc

Linux环境下编译C语言程序的工具；

命令终端输入：

- gcc  -v

可查询当前系统安装的gcc版本；

要编译当前目录下的hello.c源代码文件：

```c
gcc -o hello hello.c
```

如果顺利，会在当前目录下，生成hello可执行文件。



**gcc编译的主要流程：**

- 预处理阶段：对.c文件的包含、预处理等语句的处理，并生成名为test.i的中间文件；
- 编译阶段：以test.i为输入，编译生成汇编语言文件test.s；
- 汇编阶段：以test.s为输入，生成目标文件test.o；
- 链接阶段：将使用到库函数链接到可执行程序中的正确位置，形成二进制代码文件；



**gcc常用选项：**

- -c：仅生成扩展名为.o的目标文件，不链接生成为可执行文件；
- -o 文件名：指定gcc可执行文件名，系统默认生成的可执行文件名为a.out；
- -g：编译时加入调试信息，使得后期方便对程序进行调试，主要是为支持gdb的调试；



**gdb简单使用：**

什么是gdb？gdb是gnu开源组织发布的、用来调试C程序的调试工具。

- list命令：显示C程序源代码；
- break 行号：给程序对应的行号打断点；
- break 函数名：给函数的入口设置断点；
- info break：查看全部断点信息；
- run：开始运行程序，直到遇到断点；
- continue：程序继续执行；
- next（缩写为n）：执行下一语句；



#### 2、Makefile：

**为什么需要使用Makefile？**

当一个应用程序涉及到的C语言源代码文件达到成百上千后，直接采用gcc编译的问题：
1. 手工敲每个编译命令不现实；
2. 当修改某个文件时，要避免对所有的文件进行编译链接，只对依赖该文件的部分进行重新编译链接，节省时间；



**如何使用Makefile**

1. 根据应用程序的文件数量，依赖关系等书写Makefile编译脚本；
2. 包含Makefile编译脚本的目录下，敲击make命令；

下面是cal.c文件源代码：

```c
#include<stdio.h>
extern int sum(int a, int b);
int main()
{
	Int a = 2;
	Int b = 3;
	printf("sum(a,b)=%d\n", sum(a,b));
	return 0;
}
```

对应的add.c源代码：

```c
int sum(int a, int b)
{
	return a+b;
}
```

要编译cal.c和add.c源代码文件，书写Makefile脚本：

```make
cal:  cal.o add.o
     gcc -o cal  cal.o  add.o
cal.o: cal.c
     gcc -c  cal.c
add.o: add.c
     gcc -c  add.c
```

注意Makefile的大小写，实际编译时，只要在终端敲击命令：make

**Makefile常用的符号：**

```bash
$@ —表示当前目标文件的名字；
$^ —表示用空格隔开的所有依赖文件；
$< —表示第一个依赖文件；
```

Makefile的自动推导功能：make命令可以自动推导文件以及文件依赖关系后面的命令，make会自动识别并自己推导命令。只要make查到某个 .o 文件，它就好自动把相关的 .c 加到依赖文件中。

使用上述的符号，可以简化之前的Makefile文件：

```bash
cal:  cal.o add.o
     gcc –o $@  $^
cal.o: cal.c
     gcc –c  $<
add.o: add.c
     gcc –c  $<
```



**多层次目录结构的Makefile**

- 之前的案例：cal.c、add.c源代码与Makefile在同一个目录；
- 现在：cal.c和add.c位于src子目录，而Makefile位于src的父级目录；
- 要求：编译cal.c和add.c文件，并将可执行文件放置于父级目录；

对应的Makefile脚本实现：

```make
CC=gcc
objects=cal.o add.o
target=cal

$(target):$(objects)
     $(CC) -o  $(target)  $(objects)
cal.o:src/cal.c
     $(CC) -c $<
add.o:src/add.c
     $(CC) -c $<
clean:
     rm  -rf $(objects)  $(target)
```



#### 3、git版本管理器

什么是版本管理器？

代码或者设计稿修改了很多稿，最优化的保存每一稿的信息，便于你随时回到历史的版本，**时光穿梭机**。

git将所有的修改信息放置项目根目录的.git文件中。



**git add和git commit**

- 暂存区
- 版本库

![](https://image.zhangtiefei.cn/gt-bigbug55/git%E6%9A%82%E5%AD%98%E5%8C%BA.png)

git add：将文件添加到暂存区；

git commit:  将暂存区的内容添加到版本库；



**git reset**

撤销已经add的文件，例如添加a.txt错误，那么可以：

```bash
git add a.txt
##撤销a.txt的添加
git reset a.txt
```



**切换回历史上的某个版本**

使用命令git log查看历史信息，找到你要返回的历史版本的提交信息；

> 要快速找到历史版本，需要你平时commit时要写上注释。

![gitlog的sha值](https://image.zhangtiefei.cn/gt-bigbug55/gitlog%E7%9A%84sha%E5%80%BC.jpg)

然后根据commit的值来返回到历史上的版本：

```bash
git checkout commit值前几位 ##上图中可见，commit值很长，不需要全部写，只需要前几位即可。
```



**分支的概念：**

通过git log，可以发现所有的历史版本构成一个链条，我们可以通过git checkout命令在版本链条上移动，切换到任意的历史版本。

这个历史版本构成的链条，称为**分支**。

这也解释了，在操作git时，我们经常见到的"master"关键词，"master"代表的就是主分支。



**如果在历史上的某个版本，执行git commit会发生什么？**

Git 会创建一个新的提交，但这个新提交不会与任何分支相关联。换句话说，您创建了一个“孤儿”提交，它悬浮在历史中的某个点，并不属于任何分支。这种情况可能会导致一些问题，因为：

- 容易丢失提交：由于这个新的提交没有分支引用它，所以如果您不特别小心，很容易在未来的操作中丢失它。例如，如果您切换回一个不同的分支或再次检出到另一个提交，那么这个没有分支引用的提交可能就会变得难以访问。

- 不便于协作：在多人协作的项目中，孤儿提交很难被其他人找到或理解其上下文，因为它们不属于任何明显的开发线。

- 可能破坏历史：如果您不小心将孤儿提交合并到一个主分支，它可能会破坏项目的提交历史，使得理解项目的演变变得更加困难。



**解决上述问题的两种方法：**

1、如果你已经在历史版本上git commit了，那么：

```bash
##创建一个新的分支：
git branch 新分支的名称
##切换到新分支工作;
git checkout 新分支的名称
```

2、如果你还没有在新分支上commit，直接基于当前历史版本创建新分支：

```
git checkout -b 新分支的名称  历史版本的commit值前几位
```



**关于分支的常用操作**

```bash
##创建分支
git branch 新分支名称

##切换到新分支
git checkout 新分支名称
##切换回主分支：
git checkout master
```



**合并分支：**

如果我们在新的分支，比如dev中完成开发，现在希望将新开发的代码合并到主分支中，那么我们可以采用如下操作：

```bash
##从当前dev分支切换到master分支
git checkout master
##将dev分支中的代码合并到master分支中
git merge dev
```

分支合并可能的结果：

- 两个分支没有冲突
- 两个分支有冲突；

发生冲突怎么解决？

- 放弃合并：git merge --abort
- 采用手动的方式去修改发生冲突的文件，保存修改git add，git commit, 然后再合并；

> 更多的关于git branch的学习，可以本文底部参考文献1。



**git操作远程仓库：**

git远程代码仓库，国内的话，建议使用[gitee](https://www.gitee.com)

在gitee网站新建一个仓库，比如名为test的仓库；

![gitee新建一个test仓库](https://image.zhangtiefei.cn/gt-bigbug55/gitee%E6%96%B0%E5%BB%BA%E4%B8%80%E4%B8%AAtest%E4%BB%93%E5%BA%93.jpg)

远程仓库创建完毕后，在电脑本地（你需要先安装git客户端）：

> 关注公众号"青椒工具"，发送"git"，获取windows的git客户端安装包下载链接。

**ubuntu版本：**

```bash
##本地创建test目录与初始化
mkdir test 
cd test
git init 

##创建README.md文件
touch README.md

##将文件添加到本地库；
git add README.md
git commit -m "first commit"

##将本地库的更新推送到gitee远程库
git remote add origin https://gitee.com/bigbug55/test.git
git push -u origin "master"
```



**windows版本：**

选择自己常用的一个工作盘，比如D盘下创建test文件夹；

在test文件夹中，使用记事本创建一个readme.txt的文件夹；

```bash
win+R，输入cmd，回车启动命令行窗口；
命令行中，输入D: 回车切换到D盘；
输入cd test，进入test目录；

##剩余的操作与ubuntu系统下类似；
git init 
git add README.md
git commit -m "first commit"

git remote add origin https://gitee.com/bigbug55/test.git
git push -u origin "master"
```

在执行git commit命令时，git会要求你输入账户名和邮箱名：

```bash
git config user.name "你的gitee用户账号名"
git config user.email "你的gitee用户邮箱"
```

在执行git push时，git会要求你输入你的gitee账户密码，注意不要输错密码。

**重要提醒：**如果你git push到远程仓库的代码是开源的，一定要注意保护自己的隐私信息，比如你开发过程中包含个人账号的文件，不要上传到仓库。

**如何不上传包含个人敏感信息的文件：**可以在git项目中定义一个.gitignore文件，在该文件中添加你要避免提交到远程开源仓库的配置文件或者敏感文件。



#### 4、java开发环境

java是一种常用的程序开发语言，在ubuntu下安装java的命令：

```bash
sudo apt install openjdk-11-jdk
```

验证是否安装成功，可以运行如下命令：

```bash
java -version
javac -version
```

如果有版本信息输出，说明安装成功。如下是java下的hello world示例程序：

```java
public class HelloWorld {  
    public static void main(String[] args) {  
        System.out.println("Hello, World!");  
    }  
}
```

编译上述代码的命令：

```bash
javac HelloWorld.java
```

要使用java命令来运行编译后的程序，这一点和C语言程序有较大区别：

```bash
java HelloWorld
```



#### 参考资料：

1、一个很有趣的交互式学习git branch的网站：[Learn Git Branching](https://learngitbranching.js.org/?locale=zh_CN)

上述网站的github仓库：[GitHub - pcottle/learnGitBranching: An interactive git visualization and tutorial. Aspiring students of git can use this app to educate and challenge themselves towards mastery of git!](https://github.com/pcottle/learnGitbranching)



