#!/usr/bin/env python3
"""
圆时间 App 图标生成脚本
从SVG源文件生成Android所需的各种尺寸的PNG图标
"""

import os
from PIL import Image, ImageDraw, ImageFilter
import math

def create_gradient_background(size, colors):
    """创建渐变背景"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 创建径向渐变效果
    center = size // 2
    max_radius = center
    
    for y in range(size):
        for x in range(size):
            # 计算距离中心的距离
            distance = math.sqrt((x - center) ** 2 + (y - center) ** 2)
            if distance <= max_radius:
                # 计算渐变比例
                ratio = distance / max_radius
                
                # 混合两个颜色
                r = int(colors[0][0] * (1 - ratio) + colors[1][0] * ratio)
                g = int(colors[0][1] * (1 - ratio) + colors[1][1] * ratio)
                b = int(colors[0][2] * (1 - ratio) + colors[1][2] * ratio)
                
                img.putpixel((x, y), (r, g, b, 255))
    
    return img

def create_clock_icon(size):
    """创建时钟图标"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center = size // 2
    
    # 主圆背景 (紫色渐变)
    colors = [(102, 126, 234), (118, 75, 162)]  # 紫色渐变
    bg_img = create_gradient_background(size, colors)
    
    # 绘制主圆
    margin = size // 20
    draw.ellipse([margin, margin, size - margin, size - margin], 
                fill=None, outline=None)
    
    # 将背景渐变应用到圆形区域
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse([margin, margin, size - margin, size - margin], fill=255)
    
    # 应用遮罩
    result = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    result.paste(bg_img, (0, 0), mask)
    img = result
    draw = ImageDraw.Draw(img)
    
    # 内圆环
    inner_margin = size // 8
    inner_colors = [(240, 147, 251), (245, 87, 108)]  # 粉色渐变
    inner_bg = create_gradient_background(size - inner_margin * 2, inner_colors)
    
    inner_mask = Image.new('L', (size, size), 0)
    inner_mask_draw = ImageDraw.Draw(inner_mask)
    inner_mask_draw.ellipse([inner_margin, inner_margin, 
                           size - inner_margin, size - inner_margin], fill=255)
    
    # 应用内圆
    img.paste(inner_bg, (inner_margin, inner_margin), inner_mask)
    
    # 时钟刻度
    clock_radius = center - margin - 20
    for i in range(12):
        angle = i * 30  # 每30度一个刻度
        radian = math.radians(angle - 90)  # -90度让12点在顶部
        
        # 外端点
        x1 = center + (clock_radius - 10) * math.cos(radian)
        y1 = center + (clock_radius - 10) * math.sin(radian)
        # 内端点
        x2 = center + (clock_radius - 25) * math.cos(radian)
        y2 = center + (clock_radius - 25) * math.sin(radian)
        
        line_width = 4 if i % 3 == 0 else 2  # 12, 3, 6, 9点位置粗一些
        draw.line([(x1, y1), (x2, y2)], fill=(255, 255, 255, 200), width=line_width)
    
    # 时钟指针
    # 时针 (指向2点位置)
    hour_angle = math.radians(60 - 90)  # 2点位置
    hour_length = clock_radius * 0.5
    hour_x = center + hour_length * math.cos(hour_angle)
    hour_y = center + hour_length * math.sin(hour_angle)
    draw.line([(center, center), (hour_x, hour_y)], 
             fill=(79, 172, 254, 255), width=max(6, size // 80))
    
    # 分针 (指向4点位置)
    minute_angle = math.radians(120 - 90)  # 4点位置
    minute_length = clock_radius * 0.7
    minute_x = center + minute_length * math.cos(minute_angle)
    minute_y = center + minute_length * math.sin(minute_angle)
    draw.line([(center, center), (minute_x, minute_y)], 
             fill=(0, 242, 254, 255), width=max(4, size // 100))
    
    # 中心圆点
    dot_radius = max(8, size // 60)
    draw.ellipse([center - dot_radius, center - dot_radius,
                 center + dot_radius, center + dot_radius], 
                fill=(255, 255, 255, 255))
    
    # 进度圆弧 (从12点到4点的弧)
    arc_margin = margin + 15
    arc_bbox = [arc_margin, arc_margin, size - arc_margin, size - arc_margin]
    draw.arc(arc_bbox, start=-90, end=30, fill=(255, 255, 255, 230), width=max(4, size // 120))
    
    # 添加光点装饰
    for pos, radius, alpha in [((0.3, 0.3), 0.02, 150), 
                              ((0.7, 0.3), 0.015, 100), 
                              ((0.75, 0.6), 0.01, 120)]:
        x = int(pos[0] * size)
        y = int(pos[1] * size)
        r = int(radius * size)
        draw.ellipse([x - r, y - r, x + r, y + r], 
                    fill=(255, 255, 255, alpha))
    
    return img

def generate_android_icons():
    """生成Android所需的各种尺寸图标"""
    # Android图标尺寸
    sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
        'playstore': 512  # Google Play商店图标
    }
    
    base_dir = os.path.dirname(os.path.dirname(__file__))
    android_res_dir = os.path.join(base_dir, 'android', 'app', 'src', 'main', 'res')
    
    for folder, size in sizes.items():
        print(f"生成 {folder} 图标 ({size}x{size})")
        
        # 创建图标
        icon = create_clock_icon(size)
        
        # 保存路径
        if folder == 'playstore':
            output_dir = os.path.join(base_dir, 'assets', 'icon')
            filename = 'ic_launcher_playstore.png'
        else:
            output_dir = os.path.join(android_res_dir, folder)
            filename = 'ic_launcher.png'
        
        # 确保目录存在
        os.makedirs(output_dir, exist_ok=True)
        
        # 保存图标
        output_path = os.path.join(output_dir, filename)
        icon.save(output_path, 'PNG', quality=100)
        print(f"已保存: {output_path}")
    
    print("\n✅ 所有图标生成完成！")

if __name__ == "__main__":
    generate_android_icons() 