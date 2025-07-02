@echo off
echo 🚀 开始构建圆时间应用 APK...
echo.

REM 检查Flutter环境
flutter doctor --android-licenses >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter环境未正确配置，请先运行：flutter doctor --android-licenses
    pause
    exit /b 1
)

REM 清理项目
echo 🧹 清理项目...
flutter clean

REM 获取依赖
echo 📦 获取依赖...
flutter pub get

REM 生成应用图标（如果存在配置）
echo 🎨 生成应用图标...
flutter pub run flutter_launcher_icons:main

REM 构建APK
echo 📱 开始构建APK...
echo.
echo 选择构建类型：
echo 1. 调试版本（快速，用于测试）
echo 2. 发布版本（优化，用于分发）
echo 3. 分架构版本（体积更小）
echo.
set /p choice=请输入选择 (1-3): 

if "%choice%"=="1" (
    echo 构建调试版本...
    flutter build apk --debug
    set "apk_path=build\app\outputs\flutter-apk\app-debug.apk"
    set "apk_name=调试版本"
) else if "%choice%"=="2" (
    echo 构建发布版本...
    flutter build apk --release
    set "apk_path=build\app\outputs\flutter-apk\app-release.apk"
    set "apk_name=发布版本"
) else if "%choice%"=="3" (
    echo 构建分架构发布版本...
    flutter build apk --release --split-per-abi
    set "apk_path=build\app\outputs\flutter-apk"
    set "apk_name=分架构发布版本"
) else (
    echo 无效选择，默认构建发布版本...
    flutter build apk --release
    set "apk_path=build\app\outputs\flutter-apk\app-release.apk"
    set "apk_name=发布版本"
)

echo.
if %errorlevel% equ 0 (
    echo ✅ APK构建成功！
    echo.
    echo 📂 APK文件位置：
    echo %apk_path%
    echo.
    echo 🎉 %apk_name% 构建完成！
    echo.
    
    REM 询问是否打开文件夹
    set /p open_folder=是否打开APK文件夹？(Y/N): 
    if /i "%open_folder%"=="Y" (
        start explorer build\app\outputs\flutter-apk
    )
    
    REM 显示APK信息
    echo.
    echo 📊 APK文件信息：
    if "%choice%"=="3" (
        dir /s build\app\outputs\flutter-apk\*.apk
    ) else (
        dir "%apk_path%"
    )
    
) else (
    echo ❌ APK构建失败！
    echo.
    echo 🔍 可能的解决方案：
    echo 1. 检查Flutter环境：flutter doctor
    echo 2. 清理项目后重试：flutter clean
    echo 3. 检查代码是否有错误
    echo 4. 确保网络连接正常
)

echo.
echo 💡 提示：
echo - 调试版本适用于开发测试
echo - 发布版本适用于正式分发
echo - 分架构版本可减小APK体积
echo.
pause 