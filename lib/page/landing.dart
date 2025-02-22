// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hw4/page/add.dart';
import 'package:hw4/model.dart';
import 'package:hw4/api.dart';  

class ProductMain extends StatefulWidget {
  const ProductMain({super.key});

  @override
  State<ProductMain> createState() => _ProductMain();
}

class _ProductMain extends State<ProductMain> {
  bool isLoading = true;
  List<Product> products = [];
  List<Product> filteredProducts = [];
  final ApiService apiService = ApiService(); 
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterProducts);
  }

  // Get
  Future<void> fetchData() async {
    try {
      List<Product> fetchedProducts = await apiService.fetchData();
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts; 
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // suggest search
  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name!.toLowerCase().contains(query) ||
              product.desc!.toLowerCase().contains(query) ||
              product.price!.toString().contains(query)) // by price desc and name
          .toList(); 
    });
  }

  // Post 
  Future<bool> createProduct(Product product) async {
    bool success = await apiService.createProduct(product);
    if (success) {
      await fetchData();
    }
    return success;
  }

  // Put 
  Future<bool> updateProduct(Product product) async {
    bool success = await apiService.updateProduct(product);
    if (success) {
      await fetchData();
    }
    return success;
  }

  // Delete 
  Future<bool> deleteProduct(Product product) async {
    bool success = await apiService.deleteProduct(product);
    if (success) {
      await fetchData();
    }
    return success;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(53, 168, 165, 158),
      appBar: AppBar(
        title: const Text("Product RestAPI"),
        backgroundColor: const Color.fromARGB(255, 205, 189, 128),
        //centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: Center(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'ค้นหาชื่อ ราคา รายละเอียด สินค้า',
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: Text("กำลังโหลด"))
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${filteredProducts[index].name}'),
                  subtitle: Text('${filteredProducts[index].desc}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${filteredProducts[index].price} ฿",
                        style: const TextStyle(color: Colors.lightGreen ,fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Rest(
                                product: filteredProducts[index],
                                onProductAdded: (UpdateProduct) async {
                                  bool success =
                                      await updateProduct(UpdateProduct);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success
                                          ? "อัพเดตสินค้าสำเร็จ"
                                          : "อัพเดตสินค้าล้มเหลว"),
                                      backgroundColor:
                                          success ? Colors.green : Colors.red,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.black),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("ยืนยันการลบสินค้า"),
                                content: Text(
                                    "คุณต้องการลบ ${filteredProducts[index].name} ใช่หรือไม่"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      bool success =
                                          await deleteProduct(filteredProducts[index]);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(success
                                              ? "ลบสินค้าสำเร็จ"
                                              : "ลบสินค้าล้มเหลว"),
                                          backgroundColor:
                                              success ? Colors.green : Colors.red,
                                        ),
                                      );
                                    },
                                    child: const Text("ยืนยัน"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("ยกเลิก"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Rest(
                onProductAdded: (newProduct) async {
                  bool success = await createProduct(newProduct);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? "เพิ่มสินค้าสำเร็จ"
                          : "เพิ่มสินค้าล้มเหลว"),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                },
              );
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 243, 243, 155),
        child: const Icon(Icons.add),
      ),
    );
  }
}
