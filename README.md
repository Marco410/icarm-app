# A&R Flutter app

To iOS 📱 y Android 🤖

## Dependencias 💻

| Package Title | Version | Description                                                                                                                                  |
| ------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Flutter       | 3.22.1  | Flutter is an open source framework by Google for building beautiful, natively compiled, multi-platform applications from a single codebase. |
| Dart          | 3.4.1   | Dart is an open-source general-purpose programming language developed by Google.                                                             |

Ajustes para el paquete ´flutter_rte´

En ´editor_widget´, función ´_hintTextWidget()´ linea 336 después del ´else´, añadir esto:

--
return Padding(
padding: const EdgeInsets.only(left: 10, top: 5),
child: Text(editorOptions.hint ?? '',
style: editorOptions.hintStyle ??
TextStyle(
fontWeight: FontWeight.bold,
fontStyle: FontStyle.italic,
fontSize: 9,
color: Theme.of(context)
.textTheme
.bodyMedium
?.color
?.withOpacity(.3))),
);
--

En ´_ScrollPatchState()´linea 463 comentar la excepción para iOS.

/_ else if (!widget.controller.hasFocus) {
if (io.Platform.isIOS) {
return GestureDetector(
onTap: () {
widget.controller.setFocus();
},
child: const AbsorbPointer(child: SizedBox.expand()));
}
} _/
