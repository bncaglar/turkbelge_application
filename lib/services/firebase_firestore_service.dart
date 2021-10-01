import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class FireStoreService {
  static FireStoreService instance = FireStoreService();

  FirebaseFirestore? _db;

  FireStoreService() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "Users";
  String _preAppliedUserCollection = "PreAppliedUsers";
  String _faultyInput = "faultyInput";
  String _logInActivity = "LogInActivity";
  String _customerNumberHelper = "CustomerNumberHelper";
  String _subUsers = "SubUsers";
  String _banks = "Banks";
  String _registeredMacs = "RegisteredMacs";

  ///todo The following function [registerUserToTheDB] will be used in different platform to register the user
  Future<void> registerUserToTheDB(
      String _customerNumber,
      String _name,
      String _tckn,
      String _vkn,
      String _email,
      String _firmaAdi,
      Timestamp _kayitTarihi,
      String _status) async {
    return await _db!
        .collection(_preAppliedUserCollection)
        .doc(_customerNumber)
        .set({
      "Name": _name,
      "TCKN": _tckn,
      "VKN": _vkn,
      "customerNumber": _customerNumber,
      "email": _email,
      "firmaAdi": _firmaAdi,
      "kayitTarihi": _kayitTarihi,
      "status": _status
    });
  }

  Future<void> firstStepCreateUserInDB(
      String _uid,
      String _email,
      String _tckimlikNo,
      String _vergiKimlikNo,
      String _phoneNumber,
      String _customerNumber) async {
    try {
      return await _db!.collection(_customerNumberHelper).doc(_uid).set({
        "email": _email,
        "TCKN": _tckimlikNo,
        "VKN": _vergiKimlikNo,
        "phoneNumber": _phoneNumber,
        "customerNumber": _customerNumber
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createSubUserInDB(
      String _email, String _subUserUid, String _customerNumber) async {
    try {
      return await _db!
          .collection(_userCollection)
          .doc(_customerNumber)
          .collection(_subUsers)
          .doc(_subUserUid)
          .set({
        "email": _email,
      });
    } catch (e) {}
  }

  Future<void> secondStepCreateUserInDB(
    String _name,
    String _email,
    String customerNumber,
    String _tckimlikNo,
    String _vergiKimlikNo,
    String _phoneNumber,
    String _endDate,
    String _kayitTarihi,
    String _paketAdi,
    String _startDate,
  ) async {
    try {
      return await _db!.collection(_userCollection).doc(customerNumber).set({
        "customerNumber": customerNumber,
        "name": _name,
        "email": _email,
        "TCKN": _tckimlikNo,
        "VKN": _vergiKimlikNo,
        "phoneNumber": _phoneNumber
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> getEndDate(String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_preAppliedUserCollection)
              .doc(_customerNumber)
              .get())
          .data()!['endDate']
          .toString();
      return data1;
    } on FirebaseException {
      return ";";
    }
  }

  Future<String> getPaketAdi(String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_preAppliedUserCollection)
              .doc(_customerNumber)
              .get())
          .data()!['paketAdi']
          .toString();
      return data1;
    } on FirebaseException {
      return ";";
    }
  }

  Future<String> getStartDate(String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_preAppliedUserCollection)
              .doc(_customerNumber)
              .get())
          .data()!['startDate']
          .toString();
      return data1;
    } on FirebaseException {
      return ";";
    }
  }

  Future<String> getRegistrationDate(String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_preAppliedUserCollection)
              .doc(_customerNumber)
              .get())
          .data()!['kayitTarihi']
          .toString();
      return data1;
    } on FirebaseException {
      return ";";
    }
  }

  Future<String> verifyEmailAddressWithCustomerNumber(
      String _customerNumber) async {
    try {
      var data1 =
          (await _db!.collection(_userCollection).doc(_customerNumber).get())
              .data()!['email']
              .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<String> checkUserEmail(String _customerNumber) async {
    try {
      var data = (await _db!.collection(_subUsers).doc(_customerNumber).get())
          .data()!['email']
          .toString();
      return data;
    } on FirebaseAuthException {
      var error = "Error Occured";
      return error;
    }
  }

  Future<String> checkUserPassword(String _customerNumber) async {
    try {
      var data = (await _db!.collection(_subUsers).doc(_customerNumber).get())
          .data()!['password']
          .toString();
      return data;
    } on FirebaseAuthException {
      var error = "Error Occured";
      return error;
    }
  }

  Future<List> getCollectionDocList(String _collectionName) async {
    QuerySnapshot querySnapshot = await _db!.collection(_collectionName).get();
    var list = querySnapshot.docs;
    return list;
  }

  Future<List> getNumberOfBank(String _customerNumber) async {
    List? bankNameList;
    QuerySnapshot querySnapshot = await _db!
        .collection(_userCollection)
        .doc(_customerNumber)
        .collection(_banks)
        .get();
    print(querySnapshot);
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Future<bool?> checkIfCnExist(String _customerNumber) async {
    try {
      bool? checkCn;
      await _db!
          .collection(_subUsers)
          .doc(_customerNumber)
          .get()
          .then((value) => value.exists ? checkCn = true : checkCn = false);
      if (checkCn == true) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException {
      var error = false;
      return error;
    }
  }

  Future<bool?> checkCnForLogInActivity(String _customerNumber) async {
    try {
      bool? checkCn;
      await _db!
          .collection(_preAppliedUserCollection)
          .doc(_customerNumber)
          .get()
          .then((value) => value.exists ? checkCn = true : checkCn = false);
      if (checkCn == true) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException {
      return false;
    }
  }

  Future<void>? saveUserLogInActivity(String _customerNumber) async {
    try {
      var wifiIP = await WifiInfo().getWifiIP();
      bool? isCnValid =
          await FireStoreService().checkCnForLogInActivity(_customerNumber);
      bool? checkIfExist;
      if (isCnValid == true) {
        await _db?.collection(_logInActivity).doc(_customerNumber).get().then(
            (value) =>
                value.exists ? checkIfExist = true : checkIfExist = false);
        var _ref = _db?.collection(_logInActivity).doc(_customerNumber);
        if (checkIfExist == true) {
          return _ref?.update({
            "girisAktivitesi": FieldValue.arrayUnion([
              {"IP": wifiIP, "time": Timestamp.now()}
            ]),
          });
        } else {
          return _ref?.set({
            "girisAktivitesi": FieldValue.arrayUnion([
              {"IP": wifiIP, "time": Timestamp.now()}
            ]),
          });
        }
      }
    } on FirebaseException {}
  }

  Future<void>? saveUserFaultyInput(String _customerNumber) async {
    try {
      var wifiIP = await WifiInfo().getWifiIP();
      bool? isCnValid =
          await FireStoreService().checkCnForLogInActivity(_customerNumber);
      bool? checkIfExist;
      if (isCnValid == true) {
        await _db?.collection(_faultyInput).doc(_customerNumber).get().then(
            (value) =>
                value.exists ? checkIfExist = true : checkIfExist = false);
        var _ref = _db?.collection(_faultyInput).doc(_customerNumber);
        if (checkIfExist == true) {
          return _ref?.update({
            "hataliGiris": FieldValue.arrayUnion([
              {"IP": wifiIP, "time": Timestamp.now()}
            ]),
          });
        } else {
          return _ref?.set({
            "hataliGiris": FieldValue.arrayUnion([
              {"IP": wifiIP, "time": Timestamp.now()}
            ]),
          });
        }
      }
    } on FirebaseException {}
  }

  Future<void> addMacAddress(String _customerNumber, String _macAddress) async {
    try {
      bool? isCnValid =
          await FireStoreService().checkCnForLogInActivity(_customerNumber);
      bool? checkIfExist;
      if (isCnValid == true) {
        await _db!
            .collection(_userCollection)
            .doc(_customerNumber)
            .collection(_registeredMacs)
            .doc(_macAddress)
            .get()
            .then((value) =>
                value.exists ? checkIfExist = true : checkIfExist = false);
        var _ref = _db!
            .collection(_userCollection)
            .doc(_customerNumber)
            .collection(_registeredMacs)
            .doc(_macAddress);
        if (checkIfExist == true) {
          return _ref.update({
            "macAddresses": FieldValue.arrayUnion([
              {"mac": _macAddress}
            ])
          });
        } else {
          return _ref.set({
            "macAddresses": FieldValue.arrayUnion([
              {"mac": _macAddress}
            ])
          });
        }
      }
    } on FirebaseException {}
  }

  Future<String> getCustomerNumber(String _uid) async {
    try {
      var data1 = (await _db!.collection(_customerNumberHelper).doc(_uid).get())
          .data()!['customerNumber']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<bool?> sendRemindCustomerNumberEmail(
      String customerNumber, String email) async {
    try {
      await _db!.collection("mail").add({
        'to': email,
        'message': {
          'subject': "Türkbelge Müşteri Numaranız",
          'text': "Text",
          'html': "Merhaba" +
              ", " +
              email +
              " için müşteri numaran: " +
              customerNumber,
        },
      }).then((value) => print("email sent"));
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<void> sendRandomGeneratedPassword(
      String randomPassword, String email) async {
    try {
      await _db!.collection("mail").add({
        'to': email,
        'message': {
          'subject': "Türkbelge hesap şifreniz",
          'text': "Text",
          'html': "Merhaba" + ", " + email + " için şifren: " + randomPassword,
        },
      }).then((value) => print("email sent"));
    } on FirebaseException {}
  }

  Future<String> verifyVKN(String _uid) async {
    try {
      var data1 = (await _db!.collection(_customerNumberHelper).doc(_uid).get())
          .data()!['VKN']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<String> verifyTCKN(String _uid) async {
    try {
      var data1 = (await _db!.collection(_customerNumberHelper).doc(_uid).get())
          .data()!['TCKN']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<String> verifyPhoneNumberWithCustomerNumber(
      String _customerNumber, String _uid) async {
    try {
      var data1 =
          (await _db!.collection(_userCollection).doc(_customerNumber).get())
              .data()!['phoneNumber']
              .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<String> verifyCustomerNumberInPreAppliedUserCollectionWithTCKN(
      String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_preAppliedUserCollection)
              .doc(_customerNumber)
              .get())
          .data()!['TCKN']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<String> verifyCustomerNumberInPreAppliedUserCollectionWithVKN(
      String _customerNumber) async {
    try {
      var data1 = (await _db!
              .collection(_preAppliedUserCollection)
              .doc(_customerNumber)
              .get())
          .data()!['VKN']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }

  Future<bool> checkIfUserAdmin(_firebaseAuth) async {
    try {
      User? user = _firebaseAuth!.currentUser;
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException {
      return false;
    }
  }
}
