#!/usr/bin/env python3
"""
SVG to PNG 图标转换器
将 SVG 格式的应用图标转换为各种尺寸的 PNG 文件

需要安装: pip install cairosvg pillow
"""

import os
import sys
from pathlib import Path

try:
    import cairosvg
    from PIL import Image, ImageDraw
except ImportError:
    print("请安装必需的依赖包:")
    print("pip install cairosvg pillow")
    sys.exit(1)

def convert_svg_to_png(svg_path, output_dir, size):
    """将SVG转换为指定尺寸的PNG"""
    output_path = os.path.join(output_dir, f"app_icon_{size}x{size}.png")
    
    try:
        # 转换SVG到PNG
        cairosvg.svg2png(
            url=svg_path,
            write_to=output_path,
            output_width=size,
            output_height=size
        )
        print(f"✅ 生成 {size}x{size} 图标: {output_path}")
        return output_path
    except Exception as e:
        print(f"❌ 生成 {size}x{size} 图标失败: {e}")
        return None

def create_adaptive_icon_foreground(svg_path, output_dir):
    """创建 Android adaptive icon 的前景图"""
    # 为adaptive icon创建带透明边距的前景图
    size = 1024
    padding = 172  # Android adaptive icon 的安全区域
    
    # 创建一个透明背景的图像
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    
    # 将SVG转换为临时PNG
    temp_path = os.path.join(output_dir, "temp_full.png")
    cairosvg.svg2png(
        url=svg_path,
        write_to=temp_path,
        output_width=size,
        output_height=size
    )
    
    # 打开转换后的图像
    full_img = Image.open(temp_path)
    
    # 计算缩放后的尺寸（留出安全边距）
    inner_size = size - 2 * padding
    resized_img = full_img.resize((inner_size, inner_size), Image.Resampling.LANCZOS)
    
    # 将缩放后的图像粘贴到中心
    img.paste(resized_img, (padding, padding), resized_img)
    
    # 保存前景图
    foreground_path = os.path.join(output_dir, "app_icon_foreground.png")
    img.save(foreground_path, "PNG")
    
    # 清理临时文件
    os.remove(temp_path)
    
    print(f"✅ 生成 Adaptive Icon 前景图: {foreground_path}")
    return foreground_path

def create_basic_png(svg_path, output_dir):
    """创建基础的app_icon.png文件"""
    output_path = os.path.join(output_dir, "app_icon.png")
    
    try:
        cairosvg.svg2png(
            url=svg_path,
            write_to=output_path,
            output_width=1024,
            output_height=1024
        )
        print(f"✅ 生成基础图标: {output_path}")
        return output_path
    except Exception as e:
        print(f"❌ 生成基础图标失败: {e}")
        return None

def main():
    # 设置路径
    project_root = Path(__file__).parent.parent
    svg_path = project_root / "assets" / "icon" / "app_icon.svg"
    output_dir = project_root / "assets" / "icon"
    
    # 确保输出目录存在
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # 检查SVG文件是否存在
    if not svg_path.exists():
        print(f"❌ SVG文件不存在: {svg_path}")
        return
    
    print("🎨 开始转换应用图标...")
    print(f"📁 SVG文件: {svg_path}")
    print(f"📁 输出目录: {output_dir}")
    print()
    
    # 生成基础PNG文件
    create_basic_png(str(svg_path), str(output_dir))
    
    # 生成adaptive icon前景图
    create_adaptive_icon_foreground(str(svg_path), str(output_dir))
    
    # 生成各种尺寸的图标（用于测试和备用）
    sizes = [16, 32, 48, 64, 128, 256, 512, 1024]
    for size in sizes:
        convert_svg_to_png(str(svg_path), str(output_dir), size)
    
    print()
    print("🎉 图标转换完成！")
    print()
    print("接下来的步骤:")
    print("1. 运行: flutter pub get")
    print("2. 运行: flutter pub run flutter_launcher_icons:main")
    print("3. 重新构建应用以应用新图标")

if __name__ == "__main__":
    main() 