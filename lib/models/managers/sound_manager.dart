import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundManager {
  Soundpool _soundPool = Soundpool();

  AssetsAudioPlayer _bellPlayer = AssetsAudioPlayer();
  AssetsAudioPlayer _bgmPlayer = AssetsAudioPlayer();

  int gongSoundId = 0;
  double bellVolume = 0.2;

  SoundManager() {
    init();
  }

  Future<void> init() async {
    gongSoundId = await _loadSound("assets/sounds/gong_sound.mp3");
    _soundPool.setVolume(soundId: gongSoundId, volume: bellVolume);
  }

  Future<void> prepareSounds(String bellPath, String bgmPath, bool isNeedBgm) async {
    await _bellPlayer.open(
      Audio(bellPath),
      volume: bellVolume,
      loopMode: LoopMode.single,
      autoStart: false,
    );

    if (isNeedBgm) {
      await _bgmPlayer.open(
        Audio(bgmPath),
        loopMode: LoopMode.single,
        autoStart: false,
      );
    }
  }

  _loadSound(String soundPath) {
    return rootBundle.load(soundPath).then((value) => _soundPool.load(value));
  }

  Future<void> startBgm(String bellPath, String bgmPath, bool isNeedBgm) async {
    await _bellPlayer.setVolume(bellVolume);
    _bellPlayer.play();
    _bgmPlayer.play();
  }

  void stopBgm(bool isNeedBgm) {
    _bellPlayer.stop();
    if (isNeedBgm) _bgmPlayer.stop();
  }

  void ringFinalGong() {
    _soundPool.play(gongSoundId);
  }

  void changeVolume(double newVolume) {
    bellVolume = newVolume / 100;
    _bellPlayer.setVolume(bellVolume);
    _soundPool.setVolume(soundId: gongSoundId, volume: bellVolume);
  }

  void dispose() {
    _soundPool.dispose();
    _bellPlayer.dispose();
    _bgmPlayer.dispose();
  }
}
