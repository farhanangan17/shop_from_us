import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
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
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies(){
    //this condition is given because didChangeDependencies runs multiple times and this condition will only let it run one time before build function executes
    if(_isInit){
      //if we wanted we could get the id through providers
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        //as initialValue and controller cannot work together
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //image preview shows when not have focus on it
  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if((!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) || (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))){
        return ;
      }
      setState(() {});
    }
  }

  @override
  void dispose(){
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != null){
      try{
        await Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      }
      catch(error){
        await showDialog(
          context: context,
          builder: (ctx)=>
            AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went wrong'),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.of(ctx).pop();
                      // _isLoading = false;
                    },
                    child: Text('Okay')
                )
              ],
            )
        );
      }
    }else{
      try{
        await Provider.of<ProductsProvider>(context, listen: false).addProduct(_editedProduct);
      }
      catch(error){
       await showDialog(
         context: context,
         builder: (ctx)=>
           AlertDialog(
             title: Text('An error occurred!'),
             content: Text('Something went wrong'),
             actions: <Widget>[
               TextButton(
                 onPressed: (){
                   Navigator.of(ctx).pop();
                   // _isLoading = false;
                 },
                 child: Text('Okay')
               )
             ],
           )
       );
      }
      // finally{
      //     setState(() {
      //       print('helo');
      //       _isLoading = false;
      //     });
      //     Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // print('${_editedProduct.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
      ?Center(child: CircularProgressIndicator(),)
      :Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                //initialValue is for showing the existing product to edit or empty to add new
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (val){
                  _editedProduct = Product(
                    title: val,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Provide product title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                focusNode: _priceFocusNode,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (val){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(val),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Provide product price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Invalid input';
                  }
                  if(double.parse(value) <= 0){
                    return 'Invalid input';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (val){
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: val,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Provide product description';
                  }
                  if(value.length < 10){
                    return 'Type at least 10 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty 
                        ? Padding(padding: EdgeInsets.only(left: 7),child: Text('Enter a URL'))
                        : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //initialValue and controller cannot work together
                      // initialValue: _initValues['imageUrl'],
                      focusNode: _imageUrlFocusNode,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_){
                        return _saveForm();
                      },
                      onSaved: (val){
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: val,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return 'Provide image URL';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Invalid URL';
                        }
                        if(!value.endsWith('png') && !value.endsWith('jpg') && !value.endsWith('jpeg')){
                          return 'Image not found';
                        }
                        return null;
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
