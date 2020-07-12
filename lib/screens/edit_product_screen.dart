import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'price': 0,
    'description': '',
    'imageUrl': '',
  };

  var isInit = true;
  var _isLoading = false;

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if(!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')
          || !_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg')){
        return;
      }
      setState(() {
      });
    }
  }

  @override
  void initState() {
   _imageUrlFocusNode.addListener(_updateImageUrl); //adding listner when the image url field lost focus reload the image url
   super.initState();
  }

  @override
  void didChangeDependencies() {
    if(this.isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
          //'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    this.isInit = false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);//free memory from listener
    _priceFocusNode.dispose(); //free memory
    _descriptionFocusNode.dispose(); //free memory
    _imageUrlFocusNode.dispose(); //free memory
    super.dispose();
  }

  void _saveForm(){
    if(!_form.currentState.validate()){
     return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });
    if(_editedProduct.id != null){
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading=false;
      });
    }else{
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct)
        .catchError((error) {
          return showDialog<Null>(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(child: Text('Ok'), onPressed: () {
                      Navigator.of(context).pop();
                    },)
                  ],
                )
          );
        })
        .then((_) {
          Navigator.of(context).pop();
          setState(() {
            _isLoading=false;
          });
        });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save),
          onPressed: _saveForm,)
        ],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator(),):Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues["title"],
                decoration: InputDecoration(
                  labelText: 'Title'
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite
                  );
                },
              ), TextFormField(
                initialValue: _initValues["price"] == 0?'':_initValues["price"],
                decoration: InputDecoration(
                  labelText: 'Price'
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please provide a value.';
                  }
                  if(double.tryParse(value)==null){
                    return 'Please enter a value number';
                  }
                  if(double.parse(value) <=0){
                    return 'Please enter a number greater then zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues["description"],
                decoration: InputDecoration(
                    labelText: 'Description'
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please provide a value.';
                  }
                  if (value.length < 10 ){
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                        width: 1,
                        color: Colors.grey
                      )
                    ),
                    child: _imageUrlController.text.isEmpty?Text('Enter a url'):FittedBox(
                      child: Image.network(_imageUrlController.text),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if(value.isEmpty){
                          return 'Please provide a value.';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please a valid url';
                        }
                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                          return 'Please a valid image(png, jpg, jpeg)';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite
                        );
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
  }
}
