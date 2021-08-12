import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static FireStoreService instance = FireStoreService();

  FirebaseFirestore? _db;

  FireStoreService() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "Users";
  String _preAppliedUserCollection = "PreAppliedUsers";

  Future<void> firstStepCreateUserInDB(
    String _uid,
    String _email,
    String _tckimlikNo,
    String _vergiKimlikNo,
    String _phoneNumber,
  ) async {
    try {
      return await _db!.collection(_userCollection).doc(_uid).set({
        "email": _email,
        "TCKN": _tckimlikNo,
        "VKN": _vergiKimlikNo,
        "phoneNumber": _phoneNumber
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> secondStepCreateUserInDB(
    String _uid,
    String _name,
    String _email,
    String customerNumber,
    String _tckimlikNo,
    String _vergiKimlikNo,
    String _phoneNumber,
  ) async {
    try {
      return await _db!
          .collection(_userCollection)
          .doc(_uid)
          .collection("CustomerNumber")
          .doc(customerNumber)
          .set({
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

  Future<String> verifyEmailAddressWithCustomerNumber(
      String _customerNumber, String _uid) async {
    try {
      var data1 = (await _db!
              .collection(_userCollection)
              .doc(_uid)
              .collection("CustomerNumber")
              .doc(_customerNumber)
              .get())
          .data()!['email']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }
  Future<String> verifyVKN(
      String _uid) async {
    try {
      var data1 = (await _db!
          .collection(_userCollection)
          .doc(_uid)
          .get())
          .data()!['VKN']
          .toString();
      return data1;
    } catch (e) {
      var error = "Error";
      return error;
    }
  }
  Future<String> verifyTCKN(
      String _uid) async {
    try {
      var data1 = (await _db!
          .collection(_userCollection)
          .doc(_uid)
          .get())
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
      var data1 = (await _db!
              .collection(_userCollection)
              .doc(_uid)
              .collection("CustomerNumber")
              .doc(_customerNumber)
              .get())
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
}
