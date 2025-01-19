import 'package:firebase_database/firebase_database.dart';
import 'property_image_model.dart';

class PropertyImageService {
  final DatabaseReference _imagesRef =
      FirebaseDatabase.instance.ref('property_images');

  // Créer une image de propriété
  Future<void> createPropertyImage(PropertyImage image) async {
    final imageRef = _imagesRef.push();
    image.imageId = imageRef.key;
    await imageRef.set(image.toMap());
  }

  // Récupérer une image de propriété par ID
  Future<PropertyImage?> getPropertyImageById(String imageId) async {
    final snapshot = await _imagesRef.child(imageId).get();
    if (snapshot.exists) {
      return PropertyImage.fromMap(
          snapshot.value as Map<String, dynamic>, imageId);
    }
    return null;
  }

  // Mettre à jour une image de propriété
  Future<void> updatePropertyImage(
      String imageId, Map<String, dynamic> updates) async {
    await _imagesRef.child(imageId).update(updates);
  }

  // Supprimer une image de propriété
  Future<void> deletePropertyImage(String imageId) async {
    await _imagesRef.child(imageId).remove();
  }
}
