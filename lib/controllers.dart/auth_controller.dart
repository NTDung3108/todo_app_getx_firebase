import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app_getx_firebase/controllers.dart/user_controller.dart';
import 'package:todo_app_getx_firebase/models/user.dart';
import 'package:todo_app_getx_firebase/screens/home_screen.dart';
import 'package:todo_app_getx_firebase/screens/login_screen.dart';
import 'package:todo_app_getx_firebase/services/database.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    Get.put(UserController());
  }

  @override
  void onReady() {
    super.onReady();
    // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
    // Since we have to use that many times I just made a constant file and declared there

    _firebaseUser = Rx<User?>(_auth.currentUser);

    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => LoginScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => HomeScreen());
    }
  }

  void register(String email, name, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      UserModel _user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );
      if (await Database().createNewUser(_user)) {
        //user created succesfully
        Get.find<UserController>().user = _user;
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error creating Account', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
  }

  void login(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<UserController>().user =
          await Database().getUser(userCredential.user!.uid);
    } catch (e) {
      Get.snackbar('Error signing in', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      print(e);
    }
  }

  void signOut() async {
    await _auth.signOut();
    Get.find<UserController>().clear();
  }
}
