class MatchResult
{
  int wavesCount;
  static MatchResult? _globalResult;

  MatchResult({required this.wavesCount});

  static void setResult({required int wavesCount})
  {
    _globalResult = MatchResult(wavesCount: wavesCount);
  }

  static MatchResult getResult()
  {
    return _globalResult!;
  }
}