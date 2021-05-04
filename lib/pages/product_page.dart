import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:form_validation/bloc/provider.dart';
import 'package:form_validation/models/product_model.dart';
import 'package:form_validation/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsBloc? productsBloc;
  ProductModel producto = ProductModel();
  bool _guardando = false;
  File ?foto;

  @override
  Widget build(BuildContext context) {

    productsBloc = Provider.productsBloc(context);
    final ProductModel? prodData = ModalRoute.of(context)?.settings.arguments as ProductModel?;
    if(prodData != null){
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              onPressed: _seleccionarFoto,
              icon: Icon(Icons.photo_size_select_actual)
          ),
          IconButton(
              onPressed: _tomarFoto,
              icon: Icon(Icons.camera_alt)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                SizedBox(height: 30),
                _crearNombre(),
                SizedBox(height: 30),
                _crearPrecio(),
                SizedBox(height: 30),
                _crearDisponible(),
                SizedBox(height: 30),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => producto.titulo = value!,
      validator: (value) {
        if(value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value){
        if( utils.isNumeric(value!)){
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton(){
    return ElevatedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: (_guardando) ? null : _validar,
      style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
      ),
    );
  }

  void _validar() async{
    if( !formKey.currentState!.validate() ) return;
    formKey.currentState?.save();
    setState(() => _guardando = true );

    if(foto != null){
      producto.fotoUrl = await productsBloc!.subirFoto(foto!);
    }

    if( producto.id == '' ){
      productsBloc!.agregarProducto(producto);
    } else {
      productsBloc!.editarProducto(producto);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro Guardado'),
      ),
    );


    Navigator.pop(context);
  }


  Widget _mostrarFoto(){
    if(producto.fotoUrl != ''){
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(producto.fotoUrl),
          height: 300,
          width: double.infinity,
          fit: BoxFit.contain
      );
    } else {
      return Container(
        child: foto == null
            ? Image(
              image: AssetImage('assets/no-image.png'),
              height: 250,
              fit: BoxFit.cover)
            : Image.file(foto!),
      );
    }
  }

  _seleccionarFoto() async{
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async{
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource tipo) async {

    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: tipo);

    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
        producto.fotoUrl = '';
      }
    });

  }
}
