import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practica_form/widgets/custom_buttom.dart';
import 'package:practica_form/widgets/custom_text_form_field.dart';

class PageForm extends StatelessWidget {
  const PageForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF11A199),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              children: [
                const Text('Formulario',
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 3, left: 10, right: 10, top: 10),
                        child: Column(
                          children: <Widget>[
                            CustomTextFormField(
                              labelText: 'Nombre',
                              hintText: 'Nombre(s)',
                              validator: (value) => Validators.validateRequired(
                                  value, 'El nombre es necesario'),
                              maxLength: 30,
                              inputFormatters: [OnlyLettersFormatter()],
                            ),
                            CustomTextFormField(
                              labelText: 'Apellidos',
                              hintText: 'Apellido Paterno y Materno',
                              validator: (value) => Validators.validateRequired(
                                value,
                                'Los apellidos son necesarios',
                              ),
                              inputFormatters: [OnlyLettersFormatter()],
                              maxLength: 30,
                            ),
                            CustomTextFormField(
                              labelText: 'Calle',
                              hintText: 'Calle 1',
                              validator: (value) => Validators.validateRequired(
                                value,
                                'La calle es necesaria',
                              ),
                              inputFormatters: [
                                LettersNumbersSpacesFormatter()
                              ],
                              maxLength: 20,
                            ),
                            CustomTextFormField(
                              labelText: 'Numero de casa',
                              hintText: '123A',
                              validator: (value) => Validators.validateRequired(
                                value,
                                'El número de casa es necesario ',
                              ),
                              inputFormatters: [
                                LettersNumbersSpacesFormatter()
                              ],
                              maxLength: 5,
                            ),
                            CustomTextFormField(
                                labelText: 'Cruzamientos',
                                hintText: 'Calle 1 con Calle 2',
                                validator: (value) =>
                                    Validators.validateRequired(value,
                                        'Los cruzamientos son necesarios'),
                                inputFormatters: [
                                  LettersNumbersSpacesFormatter()
                                ],
                                maxLength: 40),
                            CustomTextFormField(
                              labelText: 'Numero de tarjeta',
                              validator: Validators.validateCardNumber,
                              inputFormatters: [OnlyNumbersFormatter()],
                              maxLength: 16,
                            ),
                            Row(children: [
                              Expanded(
                                child: CustomTextFormField(
                                  labelText: 'Vencimiento',
                                  hintText: 'MM/AA',
                                  validator: Validators.validateExpiryDate,
                                  inputFormatters: [
                                    ExpiryDateFormatter(),
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  maxLength: 5,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: CustomTextFormField(
                                      labelText: 'CVV',
                                      validator: Validators.validateCVV,
                                      inputFormatters: [OnlyNumbersFormatter()],
                                      maxLength: 3)),
                            ]),
                            CustomButtom(onPressed: () {
                              if (formkey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Formulario enviado'),
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Validators {
  static String? validateRequired(String? value, String message) {
    // Usa trim() para eliminar espacios en blanco al principio y al final
    if (value == null || value.trim().isEmpty) {
      return message; // Retornar el mensaje si el campo está vacío o solo tiene espacios
    }
    return null; // Retornar null si la validación es exitosa
  }

  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de tarjeta es obligatorio';
    } else if (value.length != 16) {
      return 'El número de tarjeta debe tener 16 dígitos';
    }
    return null;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'El CVV es obligatorio';
    } else if (value.length != 3) {
      return 'El CVV son 3 digitos';
    }
    return null;
  }

  static String? validateExpiryDate(String? value) {
    // Verificar el formato MM/YY o MM/YYYY
    final RegExp expiryDateRegex =
        RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2}|[0-9]{4})$');

    if (value == null || !expiryDateRegex.hasMatch(value)) {
      return 'Fecha invalida.';
    }

    // Extraer mes y año
    final parts = value.split('/');
    int month = int.parse(parts[0]);
    int year = int.parse(parts[1].length == 2
        ? '20${parts[1]}'
        : parts[1]); // Asumir que los años son del siglo XXI

    // Fecha actual
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // Validar si la fecha está en el pasado
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Fecha invalida.';
    }

    return null; // Validación exitosa
  }
}

class OnlyNumbersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permite solo números (0-9)
    final RegExp numbersRegex = RegExp(r'^[0-9]*$');
    if (numbersRegex.hasMatch(newValue.text)) {
      return newValue; // Si coincide, permite el valor nuevo
    }
    return oldValue; // Si no coincide, devuelve el valor anterior
  }
}

class OnlyLettersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permite solo letras (a-zA-Z) y espacios
    final RegExp lettersRegex = RegExp(r'^[a-zA-Z\s]*$');

    if (lettersRegex.hasMatch(newValue.text)) {
      return newValue; // Si coincide, permite el valor nuevo
    }
    return oldValue; // Si no coincide, devuelve el valor anterior
  }
}

class LettersNumbersSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permitir letras (a-zA-Z), números (0-9) y espacios
    final RegExp allowedCharactersRegex = RegExp(r'^[a-zA-Z0-9\s]*$');

    if (allowedCharactersRegex.hasMatch(newValue.text)) {
      return newValue; // Si coincide, permite el valor nuevo
    }
    return oldValue; // Si no coincide, devuelve el valor anterior
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permitir solo números
    final RegExp expiryDateRegex = RegExp(r'^[0-9/]*$');

    // Verificar si el nuevo valor coincide con la expresión regular
    if (!expiryDateRegex.hasMatch(newValue.text)) {
      return oldValue; // Si no coincide, devolver el valor anterior
    }



    // Borrar el último carácter si se está borrando el '/' 
    if (oldValue.text.length > newValue.text.length &&
        oldValue.selection.baseOffset == 3 && // Si el cursor está en la posición del '/'
        newValue.text.length == 2) {
      return TextEditingValue(
        text: newValue.text.substring(0, newValue.text.length - 1), // Borra el carácter anterior
        selection: TextSelection.collapsed(offset: newValue.text.length - 1), // Mueve el cursor al final
      );
    }

    // Agregar automáticamente el '/' después de los dos primeros números
    String newText = newValue.text;
    if (newText.length == 2 && !newText.contains('/')) {
      newText += '/'; // Agregar la barra inclinada
    }

    // Devolver el nuevo valor formateado
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length), // Mover el cursor al final
    );
  }
}
