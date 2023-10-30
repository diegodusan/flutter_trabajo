import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch (e) {
      print("Error");
    }
    return null;
  }

  Future<User?> signIn(String email, String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch (e) {
      print("Error");
    }
    return null;
  }

  Future<User?> signInWithUser(User user) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: 'ElPasswordDeTuUserExistente'
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error al iniciar sesión con el usuario existente: $e");
      return null;
    }
  }

}