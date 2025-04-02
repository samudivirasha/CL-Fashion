import 'package:cl_fashion/model/user_model.dart';
import 'package:cl_fashion/model/work.dart';
import 'package:cl_fashion/service/auth_service.dart';
import 'package:cl_fashion/service/database_service.dart';

class Test {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  Test() {
    print("Test function executed");
    // _auth.signOut();
    if (_auth.getCurrentUser() == null) {
      _auth.signInWithEmailAndPassword("admin@email.com", '12345678');
    } else {
      print("User logged in: ${_auth.getCurrentUser()!.email}");
    }

    // createUser();

    // createUser();
    // getUser();
    // saveUserData();
    getUserData();
    addWork();
  }

  Future<void> createUser() async {
    try {
      await _auth.createUserWithEmailAndPassword("emp1@email.com", 'emp1pass');
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  void getUser() async {
    try {
      final user = await _auth.getCurrentUser();
      print("Current user: ${user?.email}");
    } catch (e) {
      print("Error getting user: $e");
    }
  }

  Future<UserModel?> getUserData({String? userid}) async {
    try {
      print("Getting user data ${_auth.getCurrentUser()!.uid}");
      userid ??= _auth.getCurrentUser()!.uid;
      UserModel? user = await _db.getUserData(_auth.getCurrentUser()!.uid);
      return user;
    } catch (e) {
      print("Error getting user data: $e");
    }
  }

  Future<void> saveUserData() async {
    try {
      UserModel u = UserModel(
        id: _auth.getCurrentUser()!.uid,
        name: "Test User",
        email: _auth.getCurrentUser()!.email ?? "",
        phone: "1234567890",
        address: "123 Test St, Test City, TC 12345",
      );
      await _db.saveUserData(_auth.getCurrentUser()!.uid, u);
    } on Exception catch (e) {
      print("Error saving user data: $e");
    }
  }

  Future<void> addWork() async {
    try {
      UserModel? user = await getUserData();
      UserModel? assingedTo =
          await getUserData(userid: 'eWlCXTiynEVoR08PVkgxoEizolw1');
      if (user == null) {
        print("User not found");
        return;
      }
      WorkModel work = WorkModel(
        name: '',
        orderDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        status: 'pending',
        user: user,
        assingedTo: assingedTo ?? user,
        description: '',
        priority: 'pending',
      );
      await _db.addWork(work);
    } catch (e) {
      print("Error adding work: $e");
    }
  }
}
