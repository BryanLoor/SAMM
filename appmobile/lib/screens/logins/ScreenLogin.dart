import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:sammseguridad_apk/screens/ScreanMenu.dart';
import 'package:sammseguridad_apk/screens/ScreenHome.dart';
import 'package:sammseguridad_apk/screens/logins/LoginResponse.dart';
import 'package:sammseguridad_apk/screens/v2/home/Home.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  static const _fontSize = 20.0;
  static const _paddingSize = 15.0;
  static const _buttonFontSize = 18.0;
  static const _sizedBoxHeight = 10.0;
  bool isLoading = false;


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  late MainProvider _mainProvider;

  // Añade esta línea
  bool _obscureText = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainProvider = Provider.of<MainProvider>(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Widget _buildTextField(String label, TextEditingController controller,
  //     {bool isObscured = true}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Text(
  //       //   label,
  //       //   style: const TextStyle(color: Color(0xFF0040AE), fontSize: _fontSize),
  //       //   textAlign: TextAlign.left,
  //       // ),
  //       const SizedBox(height: _sizedBoxHeight),
  //       TextFormField(
  //         controller: controller,
  //         decoration: InputDecoration(
  //           hintText: label,
  //           filled: true,
  //           fillColor: Colors.white,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(color: Color(0xFF0040AE)),
  //           ),
  //           // Añade un sufijo de icono aquí
  //           suffixIcon: isObscured
  //               ? IconButton(
  //                   icon: Icon(
  //                     // Cambiar el ícono en función de si la contraseña está oculta o no
  //                     _obscureText ? Icons.visibility_off : Icons.visibility,
  //                   ),
  //                   onPressed: () {
  //                     // Cambia el estado de _obscureText cuando se presiona el botón
  //                     setState(() {
  //                       _obscureText = !_obscureText;
  //                     });
  //                   },
  //                 )
  //               : null,
  //         ),
  //         obscureText: isObscured ? _obscureText : false, // Modifica esta línea
  //         validator: (value) {
  //           if (value == null || value.isEmpty) {
  //             return 'Por favor, coloque su $label';
  //           }
  //           return null;
  //         },
  //       ),
  //       const SizedBox(height: _sizedBoxHeight),
  //     ],
  //   );
  // }

  saveJwtToken(String token) {
    setState(() {
      _mainProvider.updateToken(token);
    });
  }

  Future<void> postData(
    String endpoint, Map<String, dynamic> data, String jwtToken
  ) async {
    try {
      var response = await _apiService.postData(endpoint, data, jwtToken);
      LoginResponse loginResponse = LoginResponse.fromJson(response);
      if (response['access_token'] != null) {
        _mainProvider.updateToken(response['access_token']);
        _mainProvider.response=response;
        _mainProvider.updateUserInfo(loginResponse);
      }
    } catch (e) {
      throw Exception('Fallo metodo posteo de Api Service: $e');
    }
  }

  Future<bool> login(String Codigo, String Clave) async {
    bool isologin = false;
    try {
      setState(() {
        isLoading = true; // Muestra el loader
      });

      await postData('/login/login', {'Codigo': Codigo, 'Clave': Clave}, '');

      // Si la solicitud se completa con éxito, navega a la siguiente pantalla
      // Navigator.popAndPushNamed(context, Home.routeName);
      isologin = true;
    } catch (e) {
      _usernameController.clear();
      _passwordController.clear();
      isologin = false;
      // throw Exception('Fallo metodo posteo de Api Service: $e');
      showCustomSnackBar(context, 'Error al iniciar sesión: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false; // Oculta el loader
      });
      return isologin;
    }
  }


  Future<void> startLogin(String username, String password) async {
    try {
      setState(() {
        isLoading = true; // Mostrar el loader
      });

      // Espera un breve período (puedes personalizar la duración)
      // await Future.delayed(Duration(seconds: 2)); // Ejemplo de 2 segundos

      bool isologin =await login(username, password);

      setState(() {
        isLoading = false; // Ocultar el loader
      });

      // print(isologin);
      if (isologin) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Ocultar cualquier SnackBar existente
        showCustomSnackBar(context, 'Inicio de sesión exitoso!', Colors.green);
        Navigator.popAndPushNamed(context, Home.routeName);
      }else{
        throw Exception('Error al iniciar sesión');
      }

      // Si se pudo iniciar sesión con éxito, muestra el SnackBar verde
    } catch (e) {
      setState(() {
        isLoading = false; // Ocultar el loader en caso de error
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Ocultar cualquier SnackBar existente
      showCustomSnackBar(context, '$e', Colors.red);

      // Si no se pudo iniciar sesión, muestra el SnackBar rojo
    }
  }



  void showCustomSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
      ? Center(child: CircularProgressIndicator())
      : Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(_paddingSize),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/SAMM.png',
                    width: 100,
                  ),
                  const SizedBox(height: 6 * _sizedBoxHeight),
                  // _buildTextField('Usuario', _usernameController),
                  // _buildTextField('Contraseña', _passwordController,
                      // isObscured: true),
                  CustomTextField(
                    label: 'Usuario',
                    controller: _usernameController,
                    isObscured: false,
                  ),
                  CustomTextField(
                    label: 'Contraseña',
                    controller: _passwordController,
                    isObscured: true,
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {},
                  //       child: const Text(
                  //         'Olvidé mi contraseña',
                  //         style: TextStyle(
                  //           color: Color(0xFF0040AE),
                  //           fontSize: _fontSize,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 6 * _sizedBoxHeight),
                  Container(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          startLogin(_usernameController.text, _passwordController.text);
                        }
                      },
                      // onPressed: () async {
                      //   if (_formKey.currentState!.validate()) {
                      //     try {
                      //       await login(_usernameController.text,
                      //           _passwordController.text);
                      //       showCustomSnackBar(context,
                      //           'Inicio de sesión exitoso!', Colors.green);
                      //     } catch (e) {
                      //       showCustomSnackBar(context,
                      //           'Error al iniciar sesión: $e', Colors.red);
                      //     }
                      //   }
                      // },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        primary: Color(0xFF0040AE),
                        onSurface: Colors.grey,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF0040AE), width: 2),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: _buttonFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: _sizedBoxHeight),
                  // Container(
                  //   width: 250,
                  //   child: ElevatedButton(
                  //     onPressed: () => Navigator.pop(context),
                  //     child: const Text(
                  //       'Regresar',
                  //       style: TextStyle(
                  //         fontSize: _buttonFontSize,
                  //         color: Color(0xFF0040AE),
                  //       ),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 20, horizontal: 80),
                  //       primary: Colors.white,
                  //       // shape: RoundedRectangleBorder(
                  //       //   side: BorderSide(color: Color(0xFF0040AE), width: 2),
                  //       //   borderRadius: BorderRadius.circular(30.0),
                  //       // ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: _sizedBoxHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isObscured;

  CustomTextField({
    super.key, 
    required this.label, 
    required this.controller, 
    required this.isObscured
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    const _fontSize = 20.0;
    const _paddingSize = 15.0;
    const _buttonFontSize = 18.0;
    const _sizedBoxHeight = 5.0;
    bool _obscureText = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(color: Color(0xFF0040AE), fontSize: _fontSize),
        //   textAlign: TextAlign.left,
        // ),
        const SizedBox(height: _sizedBoxHeight),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF0040AE)),
            ),
            // Añade un sufijo de icono aquí
            // suffixIcon: widget.isObscured
            //     ? IconButton(
            //         icon: Icon(
            //           // Cambiar el ícono en función de si la contraseña está oculta o no
            //           _obscureText ? Icons.visibility_off : Icons.visibility,
            //         ),
            //         onPressed: () {
            //           // Cambia el estado de _obscureText cuando se presiona el botón
            //           setState(() {
            //             _obscureText = !_obscureText;
            //           });
            //         },
            //       )
            //     : null,
          ),
          obscureText: widget.isObscured ? _obscureText : false, // Modifica esta línea
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, coloque su ${widget.label}';
            }
            return null;
          },
        ),
        const SizedBox(height: _sizedBoxHeight),
      ],
    );
  }
}
