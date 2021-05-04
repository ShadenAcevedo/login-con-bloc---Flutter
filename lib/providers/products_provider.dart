
import 'dart:convert';
import 'dart:io';
import 'package:form_validation/user_preferences/user_preferences.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:form_validation/models/product_model.dart';

class ProductsProvider {

  final String _url = 'https://todo-flutter-61e50-default-rtdb.firebaseio.com';
  final _prefs = UserPreferences();

  Future<bool> crearProducto(ProductModel producto) async{

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.post(Uri.parse(url), body: productModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print('creado' + decodedData.toString());
    return true;
  }

  Future<bool> editarProducto(ProductModel producto) async{

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.put(Uri.parse(url), body: productModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print('editado' + decodedData.toString());
    return true;
  }

  Future<List<ProductModel>> cargarProductos() async {

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(Uri.parse(url));
    final Map? decodedData = json.decode(resp.body);
    final List<ProductModel> productos = [];

    if(decodedData == null) return [];

    if(decodedData['error'] != null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    return productos;
  }

  Future<int> borrarProducto(String id) async {

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(Uri.parse(url));

    print(json.decode(resp.body));
    return 1;
  }

  Future<String> subirImagen(File imagen) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/djh1jfzvs/image/upload?upload_preset=q0fkozz2');
    // con el mimeType se divide en imagen / el tipo o extension
    final mimeType = mime(imagen.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      return '';
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];
  }

}
