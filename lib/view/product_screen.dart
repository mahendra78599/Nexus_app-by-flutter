import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/product_view_model.dart';
import 'add_edit_product_screen.dart';

class ProductScreen extends StatelessWidget {
  final controller = Get.put(ProductViewModel());

  ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tops"),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 10),
          Icon(Icons.shopping_cart),
          SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [

          // 🔽 Sort & Filter Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 5),
                    Text("Sort"),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.filter_list),
                    SizedBox(width: 5),
                    Text("Filters"),
                  ],
                ),
              ],
            ),
          ),

          // 🛍️ Product Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.productList.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = controller.productList[index];

                  return GestureDetector(
                    onTap: () {
                      controller.setProduct(product); // 🔥 important
                      Get.to(() =>
                          AddEditProductScreen(product: product));
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 🖼️ Image + Wishlist
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                child: Image.network(
                                  product.image,
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                  const SizedBox(
                                    height: 140,
                                    child: Icon(Icons.image),
                                  ),
                                ),
                              ),

                              const Positioned(
                                right: 6,
                                top: 6,
                                child: Icon(Icons.favorite_border,
                                    color: Colors.grey),
                              ),
                            ],
                          ),

                          // 📦 Details
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "Brand",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),

                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),

                                const SizedBox(height: 4),

                                // 💰 Price Row
                                Row(
                                  children: [
                                    Text(
                                      "₹${product.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "₹999",
                                      style: TextStyle(
                                        decoration:
                                        TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "60% off",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                // ⭐ Rating + Actions Row
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [

                                    // ⭐ Rating
                                    Row(
                                      children: [
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          ),
                                          child: const Row(
                                            children: [
                                              Text("4.2",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10)),
                                              Icon(Icons.star,
                                                  size: 10,
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text("(120)",
                                            style: TextStyle(fontSize: 10)),
                                      ],
                                    ),

                                    // 🔥 ACTIONS (EDIT + DELETE)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.setProduct(product);
                                            Get.to(() =>
                                                AddEditProductScreen(
                                                    product: product));
                                          },
                                          child: const Icon(Icons.edit,
                                              size: 16,
                                              color: Colors.blue),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            controller.deleteProduct(product.id);
                                          },
                                          child: const Icon(Icons.delete,
                                              size: 16,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // ➕ Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearForm();
          Get.to(() => const AddEditProductScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
