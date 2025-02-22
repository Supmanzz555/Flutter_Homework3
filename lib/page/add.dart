// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hw4/model.dart';

class Rest extends StatefulWidget {
  final Function(Product) onProductAdded;
  final Product? product;

  const Rest({super.key, required this.onProductAdded, this.product});

  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<Rest> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? "");
    descriptionController = TextEditingController(text: widget.product?.desc ?? "");
    priceController = TextEditingController(text: widget.product?.price?.toString() ?? "");
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product != null ? "อัพเดทสินค้า" : "เพิ่มสินค้าใหม่"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "ชื่อสินค้า"),
              controller: nameController,
              autofocus: true,
              validator: (value) =>
                  value!.isEmpty ? "กรุณากรอกชื่อสินค้า" : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "รายละเอียดสินค้า"),
              controller: descriptionController,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "ราคา"),
              keyboardType: TextInputType.number,
              controller: priceController,
              validator: (value) => (double.tryParse(value ?? '') ?? 0) <= 0
                  ? "กรุณากรอกราคาที่ถูกต้อง"
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ยกเลิก"),
        ),
        ElevatedButton(
          onPressed: () async {
              if(_formKey.currentState!.validate()){
                final updated = Product(
                  id: widget.product?.id ?? 0,
                  name: nameController.text,
                  desc: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0
                );
                widget.onProductAdded(updated);
                Navigator.pop(context);
            }
          },
          child: Text(widget.product != null ? "อัพเดทสินค้า" : "เพิ่มสินค้า"),
        ),
      ],
    );
  }
}