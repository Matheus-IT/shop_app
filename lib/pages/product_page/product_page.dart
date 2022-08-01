import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();

  int? _productId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _init();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  void _init() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      _productId = null;
      return;
    }

    final product = args as ProductModel;

    _productId = product.id;
    _nameController.text = product.name;
    _descController.text = product.description;
    _priceController.text =
        product.price.toStringAsFixed(2).replaceAll('.', ',');
    _urlController.text = product.imageUrl;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final productData = <String, dynamic>{};

    productData['id'] = _productId;
    productData['name'] = _nameController.text.trim();
    productData['description'] = _descController.text.trim();
    productData['price'] =
        double.parse(_priceController.text.replaceAll(',', '.'));
    productData['imageUrl'] = _urlController.text;

    final products = Provider.of<ProductProvider>(context, listen: false);
    products.saveProduct(productData);

    Navigator.of(context).pop();
  }

  String? _textFieldValidator(String? text, String fieldName, int minLength) {
    text = text ?? '';

    if (text.isEmpty) {
      return 'O campo $fieldName é obrigatório';
    }
    if (text.length < minLength) {
      return 'O campo $fieldName deve possuir pelo menos $minLength caracteres';
    }
    return null;
  }

  String? _priceFieldValidator(String? text) {
    text = text ?? '';
    if (text.isEmpty) {
      return 'O campo preço é obrigatório';
    }

    text = text.replaceFirst(',', '.');
    final price = double.tryParse(text);
    if ((price == null) || (price < 0.0)) {
      return 'Preço inválido';
    }

    return null;
  }

  String? _urlFieldValidator(String? text) {
    text = text ?? '';
    if (text.isEmpty) {
      return 'O campo URL é obrigatório';
    }
    final url = Uri.tryParse(text);
    if (url == null) {
      return 'A URL é inválida';
    }

    const validTypes = ['jpg', 'jpeg', 'png'];
    final urlText = url.toString().toLowerCase();

    if (!validTypes.any((extension) => urlText.endsWith(extension))) {
      return 'O tipo de imagem é inválido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('***** build()');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produto'),
        actions: [
          IconButton(
            onPressed: _submit,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (name) => _textFieldValidator(name, 'nome', 4),
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              validator: _priceFieldValidator,
            ),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              validator: (desc) => _textFieldValidator(desc, 'descrição', 10),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _urlController,
                    decoration:
                        const InputDecoration(labelText: 'URL da imagem'),
                    keyboardType: TextInputType.url,
                    onChanged: (url) {
                      setState(() {});
                    },
                    validator: _urlFieldValidator,
                  ),
                ),
                Container(
                  height: 100.0,
                  width: 100.0,
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: _urlFieldValidator(_urlController.text) == null
                      ? Image.network(_urlController.text)
                      : const Text('Sem Imagem'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
