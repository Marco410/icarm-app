import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/controllers/pagos_controller.dart';
import '../../../config/setting/style.dart';
import '../../providers/pase_lista_service.dart';

class MakePaymentWidget extends StatefulWidget {
  final String userID;
  final String eventoID;
  final WidgetRef ref;
  const MakePaymentWidget(
      {super.key,
      required this.userID,
      required this.eventoID,
      required this.ref});

  @override
  State<MakePaymentWidget> createState() => _MakePaymentWidgetState();
}

class _MakePaymentWidgetState extends State<MakePaymentWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController conceptoController = TextEditingController();
  FocusNode cantidadFocus = FocusNode();
  FocusNode conceptoFocus = FocusNode();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFieldWidget(
              border: true,
              isRequired: true,
              textInputType: TextInputType.number,
              label: "Cantidad",
              hintText: 'Escribe aquí',
              controller: cantidadController,
              focusNode: cantidadFocus,
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              border: true,
              isRequired: true,
              textInputType: TextInputType.text,
              label: "Concepto",
              hintText: 'Escribe aquí',
              controller: conceptoController,
              focusNode: conceptoFocus,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 8,
                    child: CustomButton(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        text: "Hacer pago",
                        size: 'sm',
                        color: ColorStyle.secondaryColor,
                        textColor: Colors.white,
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          PagosController.addPago(
                                  usuarioID: widget.userID,
                                  eventoID: widget.eventoID,
                                  cantidad: cantidadController.text,
                                  concepto: conceptoController.text)
                              .then((value) {
                            context.pop();
                            setState(() {
                              loading = false;
                            });

                            // ignore: unused_result
                            widget.ref.refresh(
                                getUserPaseListaProvider(widget.userID));
                          });
                        },
                        loading: loading)),
                Expanded(
                    flex: 5,
                    child: CustomButton(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        text: "Cancelar",
                        size: 'sm',
                        color: Colors.grey[800],
                        onTap: () => context.pop(),
                        textColor: Colors.white,
                        loading: false)),
              ],
            )
          ])),
    );
  }
}
