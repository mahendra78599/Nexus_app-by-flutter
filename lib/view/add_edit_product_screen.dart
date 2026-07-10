import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/product_view_model.dart';
import '../data/model/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final controller = Get.find<ProductViewModel>();

  final _formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 👉 Edit mode
    if (widget.product != null) {
      titleCtrl.text = widget.product!.title;
      priceCtrl.text = widget.product!.price.toString();
      descCtrl.text = widget.product!.description;
      imageCtrl.text = widget.product!.image;
    }
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      id: widget.product?.id ?? 0,
      title: titleCtrl.text,
      price: double.parse(priceCtrl.text),
      description: descCtrl.text,
      image: imageCtrl.text,
    );

    if (widget.product == null) {
      controller.addProduct(product);
    } else {
      controller.updateProduct(widget.product!.id, product);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Product" : "Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v!.isEmpty ? "Enter title" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
                validator: (v) => v!.isEmpty ? "Enter price" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (v) => v!.isEmpty ? "Enter description" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: "Image URL"),
                validator: (v) => v!.isEmpty ? "Enter image url" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: submit,
                child: Text(isEdit ? "Update" : "Create"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
