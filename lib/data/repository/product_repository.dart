import 'package:nexus_app/data/network/network_api_service.dart';
import '../model/product_model.dart';

class ProductRepository {
  final NetworkApiService api = NetworkApiService();

  Future<List<ProductModel>> getProducts() async {
    final res = await api.get("products");

    return (res.data as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final res = await api.post("products", product.toJson());
    return ProductModel.fromJson(res.data);
  }

  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    final res = await api.put("products/$id", product.toJson());
    return ProductModel.fromJson(res.data);
  }

  Future<void> deleteProduct(int id) async {
    await api.delete("products/$id");
  }
}
