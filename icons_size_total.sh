#!/bin/bash

# 设置普通 icons json 文件 1x，2x，3x
# 输入文件名，不包含后缀
func_contents_json() {
    # imageFile=$1
    # renameFile2x=${imageFile/\.png/@2x\.png}
    # renameFile3x=${imageFile/\.png/@3x\.png}
    imageFile="$1@1x.png"
    renameFile2x="$1@2x.png"
    renameFile3x="$1@3x.png"
  
  	cd "${1}.imageset"
    echo {  >> Contents.json
    echo "  \"images\"" : [>> Contents.json
    echo "   "{>> Contents.json
    echo "      \"idiom\"" : "\"universal\"",>> Contents.json
    echo "      \"scale\"" : "\"1x\"",>> Contents.json
    echo "      \"filename\"" : "\"$imageFile\"">> Contents.json
    echo "   "},>> Contents.json
    echo "   "{>> Contents.json
    echo "      \"idiom\"" : "\"universal\"",>> Contents.json
    echo "      \"scale\"" : "\"2x\"",>> Contents.json
    echo "      \"filename\"" : "\"$renameFile2x\"">> Contents.json
    echo "   "},>> Contents.json
    echo "   "{>> Contents.json
    echo "      \"idiom\"" : "\"universal\"",>> Contents.json
    echo "      \"scale\"" : "\"3x\"",>> Contents.json
    echo "      \"filename\"" : "\"$renameFile3x\"">> Contents.json
    echo "   "}>> Contents.json
    echo " "],>> Contents.json
    echo "  \"info\"" : {>> Contents.json
    echo "     \"version\"" : 1,>> Contents.json
    echo "     \"author\"" : "\"xcode\"">> Contents.json
    echo " "}>> Contents.json
    echo }>> Contents.json
    cd ..
}

# 缩放并且保存
# $1 高
# $2 宽
# $3 不包含后缀名
func_scale123_save() {
	name=$3
	mkdir "${name}.imageset"
	for t_size in 1 2 3
	do
		s_name="${name}.png"
		r_name="${name}.imageset/${name}@${t_size}x.png"
		r_height=`expr $1 \* ${t_size}`
		r_width=`expr $2 \* ${t_size}`
		sips -z ${r_height} ${r_width} ${s_name} --out ${r_name}
	done
}

# 获取尺寸
s_height=0
s_width=0
if [ $# == 0 ]; then
    s_height=60
    s_width=60
fi
if [ $# == 1 ]; then
    s_height=$1
    s_width=$1
fi
if [ $# == 2 ]; then
    s_height=$1
    s_width=$2
fi

for f_full in *
do
	f_size=${#f_full}
	f_type=${f_full:f_size-3:3}
	f_name=${f_full:0:f_size-4}
	if [ ${f_type} == "png" ]; then
		func_scale123_save $s_height $s_width $f_name
		func_contents_json $f_name
	fi
done

