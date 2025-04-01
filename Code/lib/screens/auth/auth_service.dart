import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user with Firestore
  Future<bool> registerWithEmailPassword(
      String email, String password, String name) async {
    try {
      // Check if the user already exists
      var userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        print('User already exists.');
        return false;
      }

      // Hash the password before saving it to Firestore
      String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Store user details in Firestore
      await _firestore.collection('users').add({
        'name': name,
        'email': email,
        'passwordHash': hashedPassword,
        'avatarUrl':
            "https://api.dicebear.com/9.x/notionists/svg?seed=Jade", // hard-coded for now - change later
      });

      return true; // Registration successful
    } catch (e) {
      print('Error during registration: $e');
      return false; // Registration failed
    }
  }

  // Check if user credentials are correct
  Future<Map<String, dynamic>?> loginWithEmailPassword(
      String email, String password) async {
    try {
      // Fetch the user data from Firestore based on email
      var userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs[0].data();

        if (userData.containsKey('passwordHash')) {
          String storedPasswordHash = userData['passwordHash'];

          print("Stored hash: $storedPasswordHash");

          // Ensure stored password hash is not null or empty
          if (storedPasswordHash.isNotEmpty) {
            bool isPasswordValid = BCrypt.checkpw(password, storedPasswordHash);

            if (isPasswordValid) {
              // Return the full user data. For example, assume Firestore has 'name' and 'avatar' fields.
              return userData;
            }
          }
        }
      }

      return null; // User not found or password field missing
    } catch (e) {
      print('Error during login: $e');
      return null; // Login failed
    }
  }
}
