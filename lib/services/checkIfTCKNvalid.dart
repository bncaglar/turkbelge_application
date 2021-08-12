class CheckIfTCKNValid {
  var tek,
      cift,
      sonuc,
      TCToplam = 0,
      i,
      hatali = [
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

  Future<bool?> checkTCKN(String? Tckno) async {
    if (Tckno!.length != 11) return false;
    if (Tckno.isEmpty) return false;
    if (int.parse(Tckno[0]) == 0) return false;

    tek = int.parse(Tckno[0]) +
        int.parse(Tckno[2]) +
        int.parse(Tckno[4]) +
        int.parse(Tckno[6]) +
        int.parse(Tckno[8]);
    cift = int.parse(Tckno[1]) +
        int.parse(Tckno[3]) +
        int.parse(Tckno[5]) +
        int.parse(Tckno[7]);
    tek = (tek * 7);
    sonuc = (tek - cift).abs();

    if (sonuc % 10 != int.parse(Tckno[9])) return false;
    for (int i = 0; i < 10; i++) {
      TCToplam = TCToplam + int.parse(Tckno[i]);
    }
    if (TCToplam % 10 != int.parse(Tckno[10])) return false;
    if (hatali.toString().indexOf(Tckno) != -1) return false;
    return true;
  }
}
