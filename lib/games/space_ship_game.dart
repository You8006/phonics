import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/phonics_data.dart';
import '../services/tts_service.dart';

class SpaceShipGame extends StatefulWidget {
  final List<PhonicsItem> items;

  const SpaceShipGame({super.key, required this.items});

  @override
  State<SpaceShipGame> createState() => _SpaceShipGameState();
}

class _Asteroid {
  final String id;
  final PhonicsItem item;
  double x;
  double y;
  final double speed;
  bool destroyed;

  _Asteroid({
    required this.id,
    required this.item,
    required this.x,
    required this.y,
    required this.speed,
    // ignore: unused_element_parameter
    this.destroyed = false,
  });
}

class _Projectile {
  double x;
  double y;
  _Projectile({required this.x, required this.y});
}

class _SpaceShipGameState extends State<SpaceShipGame>
    with SingleTickerProviderStateMixin {
  final _rng = Random();
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  double _shipX = 0.5;
  final List<_Asteroid> _asteroids = [];
  final List<_Projectile> _projectiles = [];

  late PhonicsItem _target;
  int _score = 0;
  int _lives = 3;
  bool _gameOver = false;
  bool _showTutorial = true;

  double _spawnTimer = 0;
  final double _spawnInterval = 1.8;

  // Auto-fire: fires every 0.5s while finger is down
  bool _fingerDown = false;
  double _autoFireTimer = 0;
  final double _autoFireInterval = 0.5;

  late List<Widget> _cachedStars;

  @override
  void initState() {
    super.initState();
    _pickNewTarget();
    _ticker = createTicker(_gameLoop);
    _ticker.start();
    _cachedStars = [];
  }

  void _pickNewTarget() {
    if (widget.items.isEmpty) {
      _target = allPhonicsItems.first;
      return;
    }
    _target = widget.items[_rng.nextInt(widget.items.length)];
    TtsService.speakSound(_target);
  }

  @override
  void dispose() {
    _ticker.dispose();
    TtsService.stop();
    super.dispose();
  }

  void _gameLoop(Duration elapsed) {
    if (_gameOver) {
      if (_ticker.isActive) _ticker.stop();
      return;
    }

    final dt = _lastElapsed == Duration.zero
        ? 1.0 / 60.0
        : (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    final cdt = dt.clamp(0.0, 0.05);

    setState(() {
      // Auto-fire while finger is down
      if (_fingerDown) {
        _autoFireTimer += cdt;
        if (_autoFireTimer >= _autoFireInterval) {
          _autoFireTimer = 0;
          _projectiles.add(_Projectile(x: _shipX, y: 0.82));
        }
      }

      // Spawn asteroids
      _spawnTimer += cdt;
      if (_spawnTimer >= _spawnInterval) {
        _spawnTimer = 0;
        _spawnAsteroid();
      }

      // Move asteroids
      for (final a in _asteroids) {
        a.y += a.speed * cdt;
      }

      // Asteroids reaching bottom → lose life if target
      final escaped =
          _asteroids.where((a) => a.y > 1.1 && !a.destroyed).toList();
      for (final a in escaped) {
        if (a.item.progressKey == _target.progressKey) {
          _lives--;
          if (_lives <= 0) {
            _gameOver = true;
            ProgressService.updateStreak();
            return;
          }
        }
      }
      _asteroids.removeWhere((a) => a.y > 1.2);

      // Move projectiles
      for (final p in _projectiles) {
        p.y -= 1.8 * cdt;
      }
      _projectiles.removeWhere((p) => p.y < -0.1);

      // Collisions
      _checkCollisions();
    });
  }

  void _spawnAsteroid() {
    if (_asteroids.length >= 20) return;

    final spawnTarget = _rng.nextDouble() < 0.4;
    PhonicsItem item;
    if (spawnTarget) {
      item = _target;
    } else {
      final distractors = widget.items
          .where((i) => i.progressKey != _target.progressKey)
          .toList();
      if (distractors.isEmpty) {
        item = _target;
      } else {
        item = distractors[_rng.nextInt(distractors.length)];
      }
    }

    _asteroids.add(_Asteroid(
      id: '${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(9999)}',
      item: item,
      x: 0.1 + _rng.nextDouble() * 0.8,
      y: -0.08,
      speed: 0.12 + _rng.nextDouble() * 0.15,
    ));
  }

  void _checkCollisions() {
    for (final p in List.of(_projectiles)) {
      for (final a in List.of(_asteroids)) {
        if (a.destroyed) continue;
        final dx = p.x - a.x;
        final dy = p.y - a.y;
        if (dx * dx + dy * dy < 0.015) {
          a.destroyed = true;
          _asteroids.remove(a);
          _projectiles.remove(p);

          if (a.item.progressKey == _target.progressKey) {
            _score += 10;
            ProgressService.recordAttempt(_target.progressKey);
            ProgressService.recordCorrect(_target.progressKey);
            TtsService.playCorrect();
            _pickNewTarget();
          } else {
            _score = (_score - 5).clamp(0, 99999);
            ProgressService.recordAttempt(a.item.progressKey);
            ProgressService.recordWrong(a.item.progressKey);
            TtsService.playWrong();
          }
          break;
        }
      }
    }
  }

  void _restart() {
    setState(() {
      _asteroids.clear();
      _projectiles.clear();
      _score = 0;
      _lives = 3;
      _gameOver = false;
      _spawnTimer = 0;
      _autoFireTimer = 0;
      _lastElapsed = Duration.zero;
    });
    _pickNewTarget();
    if (!_ticker.isActive) _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final accentColor = const Color(0xFF00ACC1);

    if (_cachedStars.isEmpty) {
      _cachedStars = _buildStars(size);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CloseButton(color: Colors.white70),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lives
            ...List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  i < _lives ? Icons.favorite : Icons.favorite_border,
                  color: i < _lives ? Colors.redAccent : Colors.white24,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Score
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '$_score',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _gameOver ? null : () => TtsService.speakSound(_target),
            icon: Icon(Icons.volume_up_rounded,
                color: _gameOver ? Colors.white24 : accentColor),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Finger down: move ship + start auto-fire
        onPanStart: (details) {
          if (_gameOver) return;
          _dismissTutorial();
          setState(() {
            _fingerDown = true;
            _autoFireTimer = 0;
            _shipX =
                (details.globalPosition.dx / size.width).clamp(0.05, 0.95);
          });
          // Fire immediately on touch
          _projectiles.add(_Projectile(x: _shipX, y: 0.82));
        },
        // Drag: move ship (auto-fire continues via game loop)
        onPanUpdate: (details) {
          if (_gameOver) return;
          final newX =
              (details.globalPosition.dx / size.width).clamp(0.05, 0.95);
          setState(() {
            _shipX = newX;
          });
        },
        // Finger up: stop auto-fire
        onPanEnd: (_) {
          setState(() => _fingerDown = false);
        },
        onPanCancel: () {
          setState(() => _fingerDown = false);
        },
        child: Stack(
          children: [
            // Stars background
            ..._cachedStars,

            // Asteroids
            ..._asteroids.where((a) => !a.destroyed).map((a) {
              final isTarget = a.item.progressKey == _target.progressKey;
              return Positioned(
                left: a.x * size.width - 28,
                top: a.y * size.height - 28,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isTarget
                        ? accentColor.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isTarget
                          ? accentColor.withValues(alpha: 0.6)
                          : Colors.white24,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    a.item.letter,
                    style: TextStyle(
                      color: isTarget ? Colors.white : Colors.white70,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ),
              );
            }),

            // Projectiles
            ..._projectiles.map((p) {
              return Positioned(
                left: p.x * size.width - 3,
                top: p.y * size.height - 10,
                child: Container(
                  width: 6,
                  height: 20,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Ship
            Positioned(
              left: _shipX * size.width - 24,
              top: size.height * 0.82,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [accentColor, accentColor.withValues(alpha: 0.5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(Icons.navigation_rounded,
                    color: Colors.white, size: 28),
              ),
            ),

            // Target indicator
            if (!_gameOver)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gps_fixed_rounded,
                            color: accentColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Find: ${_target.letter}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Tutorial overlay (shown once)
            if (_showTutorial && !_gameOver)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _dismissTutorial,
                  onPanStart: (_) => _dismissTutorial(),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app_rounded,
                              size: 80, color: accentColor),
                          const SizedBox(height: 24),
                          const Text(
                            '画面をタッチして\nドラッグで移動！',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '触れると自動で弾が出るよ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 12),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'タップしてスタート',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Game Over overlay
            if (_gameOver)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'GAME OVER',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Score: $_score',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white38),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Back',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _restart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text('Retry',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _dismissTutorial() {
    if (_showTutorial) {
      setState(() => _showTutorial = false);
    }
  }

  List<Widget> _buildStars(Size size) {
    final starRng = Random(42);
    return List.generate(30, (i) {
      return Positioned(
        left: starRng.nextDouble() * size.width,
        top: starRng.nextDouble() * size.height,
        child: Container(
          width: 2 + starRng.nextDouble() * 2,
          height: 2 + starRng.nextDouble() * 2,
          decoration: BoxDecoration(
            color:
                Colors.white.withValues(alpha: 0.3 + starRng.nextDouble() * 0.4),
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }
}
