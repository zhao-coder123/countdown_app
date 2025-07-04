import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 沙漏视图组件，专门用于纪念日模式展示时间经过
class HourglassView extends StatefulWidget {
  final Duration elapsed; // 已经过去的时间
  final Color primaryColor;
  final Color secondaryColor;

  const HourglassView({
    super.key,
    required this.elapsed,
    this.primaryColor = Colors.amber,
    this.secondaryColor = const Color(0xFFD4AF37),
  });

  @override
  State<HourglassView> createState() => _HourglassViewState();
}

class _HourglassViewState extends State<HourglassView>
    with TickerProviderStateMixin {
  late AnimationController _sandFallController;
  late AnimationController _rotateController;
  late Animation<double> _sandFallAnimation;
  late Animation<double> _rotateAnimation;

  // 时间单位统计
  int totalDays = 0;
  int years = 0;
  int months = 0;
  int remainingDays = 0;

  @override
  void initState() {
    super.initState();
    _calculateTimeUnits();
    _initAnimations();
  }

  void _initAnimations() {
    // 沙粒掉落动画 - 更快的循环让沙粒流动更连续
    _sandFallController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _sandFallAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sandFallController,
      curve: Curves.linear, // 线性动画让沙粒流更均匀
    ));

    // 沙漏旋转动画 - 更慢更优雅的旋转
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // 完整翻转
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOutBack, // 更有弹性的翻转效果
    ));

    // 启动动画
    _sandFallController.repeat();
    
    // 每15秒旋转一次沙漏，给用户足够时间观察
    _rotateController.repeat(period: const Duration(seconds: 15));
  }

  void _calculateTimeUnits() {
    totalDays = widget.elapsed.inDays;
    
    if (totalDays >= 365) {
      years = totalDays ~/ 365;
      int remainingAfterYears = totalDays % 365;
      
      if (remainingAfterYears >= 30) {
        months = remainingAfterYears ~/ 30;
        remainingDays = remainingAfterYears % 30;
      } else {
        months = 0;
        remainingDays = remainingAfterYears;
      }
    } else if (totalDays >= 30) {
      years = 0;
      months = totalDays ~/ 30;
      remainingDays = totalDays % 30;
    } else {
      years = 0;
      months = 0;
      remainingDays = totalDays;
    }
  }

  @override
  void dispose() {
    _sandFallController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 400,
      child: Column(
        children: [
          _buildTimeDisplay(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildHourglass(),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            '时光流逝',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getFormattedTimeText(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getFormattedTimeText() {
    List<String> parts = [];
    
    if (years > 0) {
      parts.add('$years年');
    }
    if (months > 0) {
      parts.add('$months个月');
    }
    if (remainingDays > 0 || parts.isEmpty) {
      parts.add('$remainingDays天');
    }
    
    return '已经经过 ${parts.join(' ')}';
  }

  Widget _buildHourglass() {
    return AnimatedBuilder(
      animation: Listenable.merge([_sandFallAnimation, _rotateAnimation]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnimation.value * 2 * math.pi,
          child: CustomPaint(
            size: const Size(200, 300),
            painter: HourglassPainter(
              sandFallProgress: _sandFallAnimation.value,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              years: years,
              months: months,
              days: remainingDays,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem('年', years, Colors.amber.shade700, Icons.diamond),
          _buildLegendItem('月', months, Colors.amber.shade500, Icons.circle),
          _buildLegendItem('日', remainingDays, Colors.amber.shade300, Icons.grain),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String unit, int count, Color color, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

/// 沙漏绘制器
class HourglassPainter extends CustomPainter {
  final double sandFallProgress;
  final Color primaryColor;
  final Color secondaryColor;
  final int years;
  final int months;
  final int days;

  HourglassPainter({
    required this.sandFallProgress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.years,
    required this.months,
    required this.days,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    _drawHourglassFrame(canvas, size);
    _drawSandInLowerHalf(canvas, size);
    _drawFallingSand(canvas, size);
    _drawSandInUpperHalf(canvas, size);
  }

  void _drawHourglassFrame(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final width = size.width * 0.8;
    final height = size.height * 0.9;
    
    // 外轮廓
    final outlinePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 内部阴影
    final shadowPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // 创建沙漏路径
    final path = Path();
    
    // 上半部分
    path.moveTo(centerX - width / 2, centerY - height / 2);
    path.lineTo(centerX + width / 2, centerY - height / 2);
    path.lineTo(centerX + width / 6, centerY - 2);
    path.lineTo(centerX - width / 6, centerY - 2);
    path.close();
    
    // 下半部分
    path.moveTo(centerX - width / 6, centerY + 2);
    path.lineTo(centerX + width / 6, centerY + 2);
    path.lineTo(centerX + width / 2, centerY + height / 2);
    path.lineTo(centerX - width / 2, centerY + height / 2);
    path.close();

    // 绘制阴影
    canvas.drawPath(path, shadowPaint);
    
    // 绘制轮廓
    canvas.drawPath(path, outlinePaint);
    
    // 添加装饰性的顶部和底部
    final decorPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    
    // 顶部装饰
    canvas.drawLine(
      Offset(centerX - width / 2 - 5, centerY - height / 2),
      Offset(centerX + width / 2 + 5, centerY - height / 2),
      decorPaint,
    );
    
    // 底部装饰
    canvas.drawLine(
      Offset(centerX - width / 2 - 5, centerY + height / 2),
      Offset(centerX + width / 2 + 5, centerY + height / 2),
      decorPaint,
    );
    
    // 中心连接点的高光
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(centerX, centerY), 3, highlightPaint);
  }

  void _drawSandInLowerHalf(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final width = size.width * 0.8;
    final height = size.height * 0.9;
    
    // 计算下半部分的沙子高度
    final totalUnits = years + months + days;
    if (totalUnits == 0) return;
    
    final sandHeight = (height / 2) * 0.8; // 最大高度的80%
    
    // 绘制年份（大粒钻石）
    _drawYearSand(canvas, centerX, centerY, width, sandHeight);
    
    // 绘制月份（中粒圆形）
    _drawMonthSand(canvas, centerX, centerY, width, sandHeight);
    
    // 绘制天数（小粒）
    _drawDaySand(canvas, centerX, centerY, width, sandHeight);
  }

  void _drawYearSand(Canvas canvas, double centerX, double centerY, double width, double sandHeight) {
    if (years == 0) return;
    
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // 年份沙粒放在底部，使用钻石形状
    final baseY = centerY + sandHeight / 2 - 10;
    
    for (int i = 0; i < years && i < 20; i++) {
      final x = centerX + (i % 5 - 2) * 15.0;
      final y = baseY - (i ~/ 5) * 12.0;
      
      _drawDiamond(canvas, Offset(x, y), 8, paint);
    }
  }

  void _drawMonthSand(Canvas canvas, double centerX, double centerY, double width, double sandHeight) {
    if (months == 0) return;
    
    final paint = Paint()
      ..color = secondaryColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // 月份沙粒放在年份上方，使用圆形
    final baseY = centerY + sandHeight / 2 - 50 - (years > 0 ? years ~/ 5 * 12 : 0);
    
    for (int i = 0; i < months && i < 30; i++) {
      final x = centerX + (i % 6 - 2.5) * 12.0;
      final y = baseY - (i ~/ 6) * 10.0;
      
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  void _drawDaySand(Canvas canvas, double centerX, double centerY, double width, double sandHeight) {
    if (days == 0) return;
    
    final paint = Paint()
      ..color = Colors.amber.shade300.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // 天数沙粒放在最上方，使用小圆点
    final baseY = centerY + sandHeight / 2 - 100 - 
                  (years > 0 ? years ~/ 5 * 12 : 0) - 
                  (months > 0 ? months ~/ 6 * 10 : 0);
    
    for (int i = 0; i < days && i < 50; i++) {
      final x = centerX + (i % 8 - 3.5) * 8.0;
      final y = baseY - (i ~/ 8) * 6.0;
      
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  void _drawFallingSand(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // 绘制掉落的沙粒流
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // 沙粒流的位置和速度
    final flowHeight = 60.0;
    final neckWidth = 8.0; // 沙漏颈部宽度
    
    // 主要沙粒流
    for (int i = 0; i < 25; i++) {
      final progress = (sandFallProgress * 2 + i * 0.08) % 1.0;
      
      // 在颈部添加一些随机偏移
      final horizontalOffset = math.sin(i * 0.7 + sandFallProgress * 6) * 1.5;
      final x = centerX + horizontalOffset;
      final y = centerY - flowHeight / 2 + progress * flowHeight;
      
      // 粒子大小随位置变化
      final particleSize = 1.0 + math.sin(progress * math.pi) * 0.8;
      
      // 颜色渐变效果
      final alpha = 0.4 + progress * 0.4;
      final particlePaint = Paint()
        ..color = Colors.amber.withOpacity(alpha)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
    }
    
    // 添加一些散射的沙粒，模拟真实的沙漏效果
    for (int i = 0; i < 15; i++) {
      final progress = (sandFallProgress * 1.5 + i * 0.15) % 1.0;
      final scatterOffset = math.sin(i * 1.2) * 3;
      final x = centerX + scatterOffset;
      final y = centerY - flowHeight / 3 + progress * flowHeight * 0.8;
      
      final scatterPaint = Paint()
        ..color = Colors.amber.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 0.8, scatterPaint);
    }
  }

  void _drawSandInUpperHalf(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final width = size.width * 0.8;
    final height = size.height * 0.9;
    
    // 上半部分显示未来时间的抽象表示
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // 绘制上半部分的沙子堆积，表示无限的时间
    final topY = centerY - height / 2 + 20;
    final sandDensity = 0.7; // 固定密度，表示时间的持续性
    
    // 创建更有序的沙粒分布
    for (int row = 0; row < 15; row++) {
      for (int col = 0; col < 10; col++) {
        final x = centerX + (col - 4.5) * (width / 15) + 
                  (math.sin(row * 0.5) * 5); // 添加一些波动
        final y = topY + row * (height / 40);
        
        // 添加一些随机性，但保持确定性
        final noise = math.sin(row * col * 0.1) * 2;
        
        if (x >= centerX - width / 6 && x <= centerX + width / 6 && 
            y <= centerY - 10) { // 确保在沙漏范围内
          canvas.drawCircle(
            Offset(x + noise, y), 
            1.5 + math.sin(row * 0.3) * 0.5, 
            paint
          );
        }
      }
    }
  }

  void _drawDiamond(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size, center.dy);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HourglassPainter oldDelegate) {
    return oldDelegate.sandFallProgress != sandFallProgress ||
           oldDelegate.years != years ||
           oldDelegate.months != months ||
           oldDelegate.days != days;
  }
} 