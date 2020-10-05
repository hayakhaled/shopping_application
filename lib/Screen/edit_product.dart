import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class EditProduct extends StatefulWidget {
  static const routName = '/edit_product';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditProduct();
  }
}

class _EditProduct extends State<EditProduct> {
  var _isInit = true;
  var isLoaded = false;

  final _pricefocus = FocusNode();
  final _description = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imagefocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editingproduct =
  Product(id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'Price': '',
    'imgeurl': ''
  };

  @override
  void dispose() {
    _description.dispose();
    _imageUrlController.dispose();
    _imagefocus.dispose();
    _imagefocus.addListener(_updateImageUrl);
    super.dispose();
  }

  @override
  void initState() {
    _imagefocus.removeListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      if (productId != null) {
        _editingproduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editingproduct.title,
          'description': _editingproduct.description,
          'price': _editingproduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editingproduct.imageUrl;
      }
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
      final validaction = _form.currentState.validate();
      if (!validaction) {
        return;
      }else {
        _form.currentState.save();
        setState(() {
          isLoaded = false;
        });
      }
      if (_editingproduct.id != null) {
      await  Provider.of<Products>(context, listen: false)
            .UpdatProduct(_editingproduct.id, _editingproduct);

      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editingproduct,);

        }    catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) =>
                  AlertDialog(
                    title: Text("An error occurred !"),
                    content: Text("Somethig went wrong."),
                    actions: [
                      FlatButton(
                        child: Text('okey'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
          );
        }
      }
setState(() {
  isLoaded =false;
});
      Navigator.of(context).pop();
  }



void _updateImageUrl() {
  if (!_imagefocus.hasFocus) {
    setState(() {});
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Edit Product'),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            setState(() {
              _saveForm();
            });
          },
        )
      ],
    ),
    body: isLoaded
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_pricefocus);
              },
              onSaved: (value) {
                _editingproduct = Product(
                    id: _editingproduct.id,
                    isFavorite: _editingproduct.isFavorite,
                    title: value,
                    price: _editingproduct.price,
                    description: _editingproduct.description,
                    imageUrl: _editingproduct.imageUrl);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Provider a value';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_description);
              },
              focusNode: _pricefocus,
              onSaved: (value) {
                _editingproduct = Product(
                  id: _editingproduct.id,
                  isFavorite: _editingproduct.isFavorite,
                  title: _editingproduct.title,
                  price: double.parse(value),
                  description: _editingproduct.description,
                  imageUrl: _editingproduct.imageUrl,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              textInputAction: TextInputAction.next,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _description,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_imagefocus);
              },
              onSaved: (value) {
                _editingproduct = Product(
                    id: _editingproduct.id,
                    isFavorite: _editingproduct.isFavorite,
                    title: _editingproduct.title,
                    price: _editingproduct.price,
                    description: value,
                    imageUrl: _editingproduct.imageUrl);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: _imageUrlController.text.isEmpty
                      ? Text('Enter a URL')
                      : FittedBox(
                    child:
                    Image.network(_imageUrlController.text),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image Url'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imagefocus,
                    onFieldSubmitted: (_) {
                      setState(() {
                        _saveForm();
                      });
                    },
                    onSaved: (value) {
                      _editingproduct = Product(
                          id: _editingproduct.id,
                          isFavorite: _editingproduct.isFavorite,
                          title: _editingproduct.title,
                          price: _editingproduct.price,
                          description: _editingproduct.description,
                          imageUrl: value);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}}
