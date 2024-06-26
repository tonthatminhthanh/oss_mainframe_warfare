import 'package:flutter/cupertino.dart';

class MatchResult
{
  late ValueNotifier<int> mainWavesCount;
  late ValueNotifier<int> wavesCount;
  static MatchResult? _globalResult;

  MatchResult()
  {
    mainWavesCount = ValueNotifier<int>(0);
    wavesCount = ValueNotifier<int>(0);
  }

  static void setMainWavesCount({required int mainWavesCount})
  {
    if(_globalResult == null)
      {
        _globalResult = MatchResult();
      }
    _globalResult!.mainWavesCount.value = mainWavesCount;
  }

  static void setWavesCount({required int wavesCount})
  {
    if(_globalResult == null)
    {
      _globalResult = MatchResult();
    }
    _globalResult!.wavesCount.value = wavesCount;
  }

  static MatchResult getResult()
  {
    return _globalResult!;
  }
}