class CheckIfTCKNValid {
  var odd,
      even,
      result,
      tCToplam = 0,
      i,
      inAccurate = [
        11111111110,
        22222222220,
        33333333330,
        44444444440,
        55555555550,
        66666666660,
        7777777770,
        88888888880,
        99999999990
      ];

  Future<bool?> checkTCKN(String? tckNo) async {
    if (tckNo!.length != 11) return false;
    if (tckNo.isEmpty) return false;
    if (int.parse(tckNo[0]) == 0) return false;

    odd = int.parse(tckNo[0]) +
        int.parse(tckNo[2]) +
        int.parse(tckNo[4]) +
        int.parse(tckNo[6]) +
        int.parse(tckNo[8]);
    even = int.parse(tckNo[1]) +
        int.parse(tckNo[3]) +
        int.parse(tckNo[5]) +
        int.parse(tckNo[7]);
    odd = (odd * 7);
    result = (odd - even).abs();

    if (result % 10 != int.parse(tckNo[9])) return false;
    for (int i = 0; i < 10; i++) {
      tCToplam = tCToplam + int.parse(tckNo[i]);
    }
    if (tCToplam % 10 != int.parse(tckNo[10])) return false;
    if (inAccurate.toString().indexOf(tckNo) != -1) return false;
    return true;
  }
}
