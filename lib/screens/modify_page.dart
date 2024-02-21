import 'package:flutter/material.dart';
import 'package:product_api/screens/models/product_model.dart';

class ModifyPage extends StatefulWidget {
  final Product? product;
  final Function(Product) onProductSubmitted;
  final int list_size;

  ModifyPage(
      {Key? key,
      this.product,
      required this.onProductSubmitted,
      required this.list_size})
      : super(key: key);

  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    // Initialize text controllers with product data if available
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _imageUrlController =
        TextEditingController(text: widget.product?.image ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
  }

  @override
  void dispose() {
    // Dispose text controllers to avoid memory leaks
    _titleController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create a new product object with the updated data
                //Category category = Category(name: _categoryController.text);
                Category category =
                    CategoryExtension.fromString(_categoryController.text) ??
                        Category.ELECTRONICS;
                final updatedProduct = Product(
                    id: widget.list_size,
                    title: _titleController.text,
                    price: double.tryParse(_priceController.text) ?? 0,
                    image: _imageUrlController.text,
                    category: category,
                    rating: Rating(
                        rate: widget.product?.rating.rate ?? 0,
                        count: widget.product?.rating.count ?? 0),
                    description: _descriptionController.text);

                // Call the onProductSubmitted callback with the updated product
                widget.onProductSubmitted(updatedProduct);

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
//https://images.pexels.com/photos/280250/pexels-photo-280250.jpeg?cs=srgb&dl=pexels-pixabay-280250.jpg&fm=jpg