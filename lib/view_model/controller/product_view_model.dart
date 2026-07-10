import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/data/model/product_model.dart';
import 'package:nexus_app/data/repository/product_repository.dart';

class ProductViewModel extends GetxController {
  final repo = ProductRepository();

  // ================= LIST STATE =================
  var productList = <ProductModel>[].obs;
  var isLoading = false.obs;

  // ================= FORM CONTROLLERS =================
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  // ================= INIT =================
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // ================= FETCH =================
  void fetchProducts() async {
    try {
      isLoading(true);
      final data = await repo.getProducts();
      productList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products");
    } finally {
      isLoading(false);
    }
  }

  // ================= FORM HELPERS =================
  void setProduct(ProductModel? product) {
    if (product != null) {
      titleCtrl.text = product.title;
      priceCtrl.text = product.price.toString();
      descCtrl.text = product.description;
      imageCtrl.text = product.image;
    } else {
      clearForm();
    }
  }

  void clearForm() {
    titleCtrl.clear();
    priceCtrl.clear();
    descCtrl.clear();
    imageCtrl.clear();
  }

  // ================= ADD =================
  Future<void> addProduct(ProductModel product) async {
    try {
      final newProduct = await repo.createProduct(product);
      productList.add(newProduct);
    } catch (e) {
      Get.snackbar("Error", "Failed to add product");
    }
  }

  // ================= UPDATE =================
  Future<void> updateProduct(int id, ProductModel product) async {
    try {
      final updated = await repo.updateProduct(id, product);
      int index = productList.indexWhere((e) => e.id == id);
      if (index != -1) {
        productList[index] = updated;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update product");
    }
  }

  // ================= DELETE =================
  Future<void> deleteProduct(int id) async {
    try {
      await repo.deleteProduct(id);
      productList.removeWhere((e) => e.id == id);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete product");
    }
  }

  // ================= SUBMIT =================
  Future<void> submit(ProductModel? oldProduct) async {
    if (titleCtrl.text.isEmpty ||
        priceCtrl.text.isEmpty ||
        descCtrl.text.isEmpty ||
        imageCtrl.text.isEmpty) {
      Get.snackbar("Error", "All fields required");
      return;
    }

    final product = ProductModel(
      id: oldProduct?.id ?? 0,
      title: titleCtrl.text,
      price: double.parse(priceCtrl.text),
      description: descCtrl.text,
      image: imageCtrl.text,
    );

    isLoading(true);

    try {
      if (oldProduct == null) {
        await addProduct(product);
        Get.snackbar("Success", "Product added");
      } else {
        await updateProduct(oldProduct.id, product);
        Get.snackbar("Success", "Product updated");
      }

      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

  // ================= CLEANUP =================
  @override
  void onClose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    descCtrl.dispose();
    imageCtrl.dispose();
    super.onClose();
  }
}
