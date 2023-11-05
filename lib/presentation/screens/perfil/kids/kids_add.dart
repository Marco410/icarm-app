import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:intl/intl.dart';

import '../../../components/dropdown_widget.dart';

class KidsAddPage extends StatefulWidget {
  const KidsAddPage({super.key});

  @override
  State<KidsAddPage> createState() => _KidsAddPageState();
}

class _KidsAddPageState extends State<KidsAddPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController aPaternoController = TextEditingController();
  final TextEditingController aMaternoController = TextEditingController();
  final TextEditingController nacimientoController = TextEditingController();

  FocusNode nombreFocus = FocusNode();
  FocusNode aPaternoFocus = FocusNode();
  FocusNode aMaternoFocus = FocusNode();

  Option sexo = Option(id: 0, name: "Seleccione");
  List<Option> sexoList = [
    Option(id: 1, name: "Hombre"),
    Option(id: 2, name: "Mujer")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              label: 'Nombre',
              border: true,
              isRequired: true,
              textInputType: TextInputType.text,
              hintText: 'Escribe aquí',
              controller: nombreController,
              focusNode: nombreFocus,
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              label: 'Apellido Paterno',
              border: true,
              isRequired: true,
              textInputType: TextInputType.text,
              hintText: 'Escribe aquí',
              controller: aPaternoController,
              focusNode: aPaternoFocus,
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              label: 'Apellido Materno',
              border: true,
              isRequired: true,
              textInputType: TextInputType.text,
              hintText: 'Escribe aquí',
              controller: aMaternoController,
              focusNode: aMaternoFocus,
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              label: 'Fecha de nacimiento',
              border: true,
              labelColor: Colors.black,
              hintText: "aaaa-mm-dd",
              color: Colors.white,
              controller: nacimientoController,
              onTap: () => selectDate(),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: ColorStyle.secondaryColor,
                ),
                onPressed: () => selectDate(),
              ),
              readOnly: true,
              textInputType: TextInputType.datetime,
              isRequired: true,
            ),
            SizedBox(
              height: 5,
            ),
            DropdownWidget(
                title: "Sexo",
                option: sexo,
                isRequired: true,
                onTapFunction: () async {
                  final res = await showDropdownOptions(context,
                      MediaQuery.of(context).size.height * 0.4, sexoList);

                  if (res != null) {
                    setState(() {
                      sexo = res[0] as Option;
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }

  selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        locale: const Locale('es', 'MX'),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year.toInt() - 105),
        lastDate: DateTime(DateTime.now().year.toInt() + 1),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorStyle.secondaryColor,
                onPrimary: ColorStyle.whiteBacground,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black54,
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
            child: child!,
          );
        });

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        nacimientoController.text = formattedDate;
      });
    }
  }
}
