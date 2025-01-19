import 'property_image_service.dart';
import 'property_image_model.dart';

class PropertyImageController {
  final PropertyImageService _propertyImageService = PropertyImageService();

  Future<void> createPropertyImage(PropertyImage image) async {
    await _propertyImageService.createPropertyImage(image);
  }

  Future<PropertyImage?> getPropertyImage(String imageId) async {
    return await _propertyImageService.getPropertyImageById(imageId);
  }

  Future<void> updatePropertyImage(
      String imageId, Map<String, dynamic> updates) async {
    await _propertyImageService.updatePropertyImage(imageId, updates);
  }

  Future<void> deletePropertyImage(String imageId) async {
    await _propertyImageService.deletePropertyImage(imageId);
  }
}
