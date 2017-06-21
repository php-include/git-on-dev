#!/bin/bash
#+++++++++++++++++++++++
#
#    *主要实现git打包指定用户的指定描述内容修改过的文件
#    * @author php-include<haikun2012@qq.com>
#    * @since  2017年5月15日
#
#!!!!!该执行文件需要放至站点的根目录
#!!!!!注意定义自己的打包文件目标目录，因为它是每次都会清空一次的
#+++++++++++++++++++++++

#时间
datetime=$(date "+%Y%m%d")
#当前文件目录
git_cp=${PWD##*/}
#打包文件目标目录
cpdir=/Users/haikun/online/$git_cp$datetime
#文件目录列表
files=./cp.txt
#commit ID 的文件
filetmp=./cp_tmp.txt 

#先删除上次的文件包
rm -rf $cpdir/*
rm -rf $files
rm -rf $filetmp

#从git 找出该次的commit id 
if [ -z $1 ] || [ -z $2 ];then
echo '请按照示例使用：'
echo './git-on-dev.sh 名字 描述'
exit
fi
#生产临时commit ID 的文件
git log --pretty=format:"%H" --author=$1 --grep=$2 >> $filetmp
#追加一行，以免报错
echo " " >> $filetmp

#循环 找出修改过的文件名字
cat $filetmp | while read line 
do
 if [ $line ] ; then
  git diff-tree --no-commit-id --name-only -r $line >> $files
 else
  echo '无相关记录操作'
 fi
done

#判断是否生产文件目录
if [ ! -f $files ] ; then
rm -rf $filetmp
echo '停止操作'
exit
fi

#复制文件目录的文件到指定位置
while read line
do
path=$(dirname $line)
if [ ! -d $cpdir/$path ]; then 
    mkdir -p $cpdir/$path
fi
cp -rf $line $cpdir/$line 
done < $files

#清除不需要的文件
rm -rf $files
rm -rf $filetmp

#苹果电脑，额外清除隐藏文件
find . -name '*.DS_Store' -type f -delete
