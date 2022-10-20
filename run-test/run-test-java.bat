chcp 65001
:: Set Param
@ECHO OFF
@SETLOCAL

:MainExec
echo "测试GPU版请先安装Vulkan SDK，https://vulkan.lunarg.com/sdk/home"
echo "请输入测试选项并回车: 1)CPU-x64, 2)CPU-x86, 3)GPU-x64, 4)GPU-x86"
set /p flag=
if %flag% == 1 (call :PrepareCpuX64)^
else if %flag% == 2 (call :PrepareCpuX86)^
else if %flag% == 3 (call :PrepareGpuX64)^
else if %flag% == 4 (call :PrepareGpuX86)^
else (echo 输入错误！Input Error!)

SET TARGET_IMG=images/1.jpg
if not exist %TARGET_IMG% (
echo "找不到待识别的目标图片：%TARGET_IMG%，请打开本文件并编辑TARGET_IMG"
PAUSE
exit
)


java -Djava.library.path=%LIB_PATH% -Dfile.encoding=UTF-8 -jar RapidOcrNcnnJvm.jar models ^
ch_PP-OCRv3_det_infer ^
ch_ppocr_mobile_v2.0_cls_infer ^
ch_PP-OCRv3_rec_infer ^
ppocr_keys_v1.txt ^
%TARGET_IMG% ^
%NUMBER_OF_PROCESSORS% ^
50 ^
1024 ^
0.5 ^
0.3 ^
1.6 ^
1 ^
1 ^
%GPU_INDEX%

echo.
GOTO:MainExec

:PrepareCpuX64
set LIB_PATH=win-JNI-CPU-x64\bin
set GPU_INDEX=-1
GOTO:EOF

:PrepareCpuX86
set LIB_PATH=win-JNI-CPU-Win32\bin
set GPU_INDEX=-1
GOTO:EOF

:PrepareGpuX64
set LIB_PATH=win-JNI-GPU-x64\bin
set GPU_INDEX=0
GOTO:EOF

:PrepareGpuX86
set LIB_PATH=win-JNI-GPU-Win32\bin
set GPU_INDEX=0
GOTO:EOF

@ENDLOCAL
