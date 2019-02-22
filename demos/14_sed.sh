#!/bin/bash

# 第十四章：sed
# 
# 1. sed介绍
# sed是一个非交互性文本流编辑器。和awk一样，它是个独立的工具，当然也可以和bash联合使用。
# 它可以随意编辑文件或标准输入,对它们进行编辑、删除。它能一次性处理所有改变,对用户来讲,十分高效。sed编辑文件或标准输入时，编辑的是它们的拷贝；也就是说，不会改变原始的文件。若需要保存修改，可以通过重定向操作符>>、>>>,或者在利用sed的写入参数。
# 
# 2. 基本格式
# sed [选项] 输入文件
# 说明：
#   -n 不打印;sed不写编辑行到标准输出,缺省为打印所有行(编辑和未编辑)。
#   -p 命令可以用来打印编辑行。
#   -c 下一命令是编辑命令。使用多项编辑时加入此选项。如果只用到一条 sed命令,此选项无用,但指定它也没有关系。
#   -e 追加执行脚本
#   -f 如果正在调用 sed脚本文件,使用此选项。
#
#
# 3. 使用sed在文件中定位文本的方式
#  ------------------------------------------------------------------------------
#  |  方式            |    说明                                                 |
#  |------------------|---------------------------------------------------------|
#  |  x	              |   x为行号。例如，1                                      |         
#  |  x,y             | 	表示行号范围从x到y。例如，2,5表示从第2行到第5行       |    
#  |  x,y!            | 	查询不包含指定行(x到y)                                |               
#  |  /pattern/       | 	查询包含pattern模式的行。例如, /disk/或/[a-z]/        |               
#  |  pattern/,x      | 	在给定行号上查询包含pattern模式的行。例如， /ribbon/,3|           
#  |  x,/pattern/     |  	通过行号和模式查询匹配行。 例如， 3,/vdu/             |          
#  |----------------------------------------------------------------------------|
#
#
# 4. sed编辑命令
#  ---------------------------------------------------------------------
#  |  方式   |    说明                                                 |
#  |---------|---------------------------------------------------------|
#  |  p      |  打印匹配行                                             |            
#  |  =      |  显示文件行号                                           |     
#  |  a\     |  在定位行后附加文本信息                                 |      
#  |  i\     |  在定位行前附加文本信息                                 |      
#  |  d      |  删除定位行                                             |
#  |  c\     |  用新文本替换定位文本                                   |    
#  |  s      |  使用替换模式                                           |
#  |  r      |  从另一个文件中读文本                                   |    
#  |  w      |  写文本到一个文件                                       |
#  |  q      |  第一个模式匹配完成后退出                               |        
#  |  {}     |  在定位行指定的命令组                                   |    
#  |  n      |  从另一个文件中读取，并追加在下一行                     |         
#  |-------------------------------------------------------------------|
#




# 示例：首先建立一个123.txt，添加任意文本，然后进行以下练习。
# (01), 输出文件第5行
sed -n '5p' 123.txt
# 说明：-n表示默认不输出任何内容。5p表示输出第5行：5表示第5行，p表示输出。
# (02), 输出文件除1-3行之外的行
sed -n '1,3!p' 123.txt
# 说明：
#   "1,3"表示输出范围是第1-3行; "1,3!"表示输出范围是除第1-3行之外。
#   '1,$p'表示输出全部行，因为$表示最后一行。

# (03), 输出"ls -l"结果中的第1-3行
ls -l |sed -n '1,3p'
# 说明：|是管道符号，表示将ls -l的输出作为sed的输入。

# (04), 输出匹配“the”的行
sed -n '/the/p' 123.txt
# 说明：/the/表示匹配the的行

# (05), 输出匹配“the”的行，并且输出每行行号
sed -n -e '/the/p' -e '/the/=' 123.txt
# 说明：-e表示对每行进行多重编辑，多重编辑的每一个命令前都需要添加-e。
#       本例中，-e '/the/p'打印匹配the的行；-e '/the/='表示输出匹配the的行的行号。

# (06), 删除匹配“the”的行
sed '/the/d' 123.txt
# 说明：d表示删除。

# (07), 删除匹配“the”的行；然后输出删除操作之后的所有行，并输出每行行号
sed '/the/d' 123.txt | sed -n -e '1,$p' -e '1,$='
# 说明：
#   (1) sed '/the/d' 123.txt ：得到了删除“the”之后的行
#   (2) | ：管道符号。意味着前面的输出作为后面的输入
#   (3) sed -n -e '1,$p' -e '1,$=' ：表示输出全部行之后，在输出每行行号

# (08), 在每一行前面插入2行文本，第一行是line1,第2行是line2
sed '1,$iline1\nline2' 123.txt
# 说明：
#   1,$i表示第一行到最后一行的每一行都执行插入操作。
#   line1\nline2表示插入的文本，其中\n转义之后表示“换行”符号。

# (09), 在最后一行后面插入1行文本，内容是end
sed '$aend' 123.txt
# 说明：$表示最后一行，a表示在文本后插入，end是插入的内容

# (10), 将“this”全部替换成“that”
sed 's/this/that/g' 123.txt
# 说明：
#   [ address[,address ] ] s / pattern-to-find / replacement-pattern/[gpwn]
#   s 表示替换操作。查询pattern-to-find,成功后用replacement-pattern替换它。
#   替换选项如下:
#      g 缺省情况下只替换每行的第一次匹配，g表示替换每行的所有匹配。
#      p 缺省sed将所有被替换行写入标准输出，加p选项将使-n选项无效。-n选项不打印输出结果。
#      w 后接“文件名”，表示将输出定向到一个文件。

# (11), 将“this”全部替换成“this boy”
sed 's/this/this boy/g' 123.txt
# 或
sed 's/this/boy &/g' 123.txt
# 说明：
#   sed 's/this/boy &/pg' 123.txt中&表示附加修改(即在原始内容的基础上添加内容)。
#   &表示匹配的内容。即，boy &等价于boy this

# (12), 去掉空白行后另存文件
sed '/^$/d' 123.txt > dst.txt
# 或
sed '/^$/c\' 123.txt > dst.txt
# 说明：
#   /^$/表示空白行：^表示开启，$表示结尾，开始和结尾之间没有任何内容，即是空白行。
#   c\表示修改。

# (13), 去掉文件扩展名
echo "hello.txt"| sed 's/.txt//g'

# (14), 添加文件扩展名
echo "hello"| sed 's/$/.txt/g'

# (15), 删除文本中每一行的第2个字符
sed 's/.//2' ori.txt > dst.txt

# (16), 删除文本中每一行的倒数第2个字符
sed 's/\(.\)\(.\)$/\2/' ori.txt > dst.txt
# 说明：考察了sed中"( )"的含义和用法

# (17), 删除每一行的第2个单词
sed 's/\([[:alpha:]]\+\)\(\ \)\([[:alpha:]]\+\)*/\1/' ori.txt > dst.txt

# (18), 隔行删除
sed '' '0~2 d' ori.txt > dst.txt

