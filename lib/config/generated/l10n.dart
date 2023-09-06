// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S current = S();

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current;
    });
  }

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `icarm`
  String get company {
    return Intl.message(
      'icarm',
      name: 'company',
      desc: '',
      args: [],
    );
  }

  /// `Bienvenido`
  String get welcome {
    return Intl.message(
      'Bienvenido',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Correo Electrónico`
  String get email {
    return Intl.message(
      'Correo Electrónico',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña`
  String get password {
    return Intl.message(
      'Contraseña',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Repetir Contraseña`
  String get confirmPassword {
    return Intl.message(
      'Repetir Contraseña',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `SALTAR`
  String get skip {
    return Intl.message(
      'SALTAR',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `TERMINAR`
  String get done {
    return Intl.message(
      'TERMINAR',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Configuraciones`
  String get settings {
    return Intl.message(
      'Configuraciones',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `IDIOMA`
  String get languaje {
    return Intl.message(
      'IDIOMA',
      name: 'languaje',
      desc: '',
      args: [],
    );
  }

  /// `Inglés`
  String get english {
    return Intl.message(
      'Inglés',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Español`
  String get spanish {
    return Intl.message(
      'Español',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Seleccione:`
  String get select {
    return Intl.message(
      'Seleccione:',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Guardar`
  String get save {
    return Intl.message(
      'Guardar',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Aceptar`
  String get accept {
    return Intl.message(
      'Aceptar',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Cancelar`
  String get cancel {
    return Intl.message(
      'Cancelar',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Entrar`
  String get logIn {
    return Intl.message(
      'Entrar',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `El correo o la contraseña son incorrectos`
  String get invalidLogin {
    return Intl.message(
      'El correo o la contraseña son incorrectos',
      name: 'invalidLogin',
      desc: '',
      args: [],
    );
  }

  /// `Revisa tu conexión a internet`
  String get checkConection {
    return Intl.message(
      'Revisa tu conexión a internet',
      name: 'checkConection',
      desc: '',
      args: [],
    );
  }

  /// `Registrarme`
  String get signIn {
    return Intl.message(
      'Registrarme',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar Sesión`
  String get signOut {
    return Intl.message(
      'Cerrar Sesión',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Sesión`
  String get sesion {
    return Intl.message(
      'Sesión',
      name: 'sesion',
      desc: '',
      args: [],
    );
  }

  /// `Registrate Ahora`
  String get signInNow {
    return Intl.message(
      'Registrate Ahora',
      name: 'signInNow',
      desc: '',
      args: [],
    );
  }

  /// `Olvide mi contraseña`
  String get forgotPassword {
    return Intl.message(
      'Olvide mi contraseña',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `No es un correo válido`
  String get validEmail {
    return Intl.message(
      'No es un correo válido',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Por favor escribe tu correo`
  String get insertEmail {
    return Intl.message(
      'Por favor escribe tu nombre de usuario',
      name: 'insertEmail',
      desc: '',
      args: [],
    );
  }

  /// `Por favor escribe tu contraseña`
  String get insertPassword {
    return Intl.message(
      'Por favor escribe tu contraseña',
      name: 'insertPassword',
      desc: '',
      args: [],
    );
  }

  /// `Escribe una contraseña de más de 6 caracteres`
  String get insertPasswordValid {
    return Intl.message(
      'Escribe una contraseña de más de 6 caracteres',
      name: 'insertPasswordValid',
      desc: '',
      args: [],
    );
  }

  /// `Las contraseñas deben coincidir`
  String get insertPasswordConfirm {
    return Intl.message(
      'Las contraseñas deben coincidir',
      name: 'insertPasswordConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Idioma del sistema`
  String get systemLanguage {
    return Intl.message(
      'Idioma del sistema',
      name: 'systemLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Idioma`
  String get language {
    return Intl.message(
      'Idioma',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Símbolos`
  String get symbols {
    return Intl.message(
      'Símbolos',
      name: 'symbols',
      desc: '',
      args: [],
    );
  }

  /// `Símbolo`
  String get symbol {
    return Intl.message(
      'Símbolo',
      name: 'symbol',
      desc: '',
      args: [],
    );
  }

  /// `Mis Posturas`
  String get myPositions {
    return Intl.message(
      'Mis Posturas',
      name: 'myPositions',
      desc: '',
      args: [],
    );
  }

  /// `Corro`
  String get corro {
    return Intl.message(
      'Corro',
      name: 'corro',
      desc: '',
      args: [],
    );
  }

  /// `Aceptar`
  String get toAccept {
    return Intl.message(
      'Aceptar',
      name: 'toAccept',
      desc: '',
      args: [],
    );
  }

  /// `Acepto las reglas de funcionamiento y cierre de eventos del evento`
  String get iAccept {
    return Intl.message(
      'Acepto las reglas de funcionamiento y cierre de eventos del evento',
      name: 'iAccept',
      desc: '',
      args: [],
    );
  }

  /// `Activo`
  String get active {
    return Intl.message(
      'Activo',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Actualizar datos`
  String get updateData {
    return Intl.message(
      'Actualizar datos',
      name: 'updateData',
      desc: '',
      args: [],
    );
  }

  /// `Agregar evento`
  String get addEvent {
    return Intl.message(
      'Agregar evento',
      name: 'addEvent',
      desc: '',
      args: [],
    );
  }

  /// `Agregar un grupo de usuarios`
  String get addAUserGroup {
    return Intl.message(
      'Agregar un grupo de usuarios',
      name: 'addAUserGroup',
      desc: '',
      args: [],
    );
  }

  /// `Alcanza el nivel {no} realizando mas actividades`
  String reachLevel(Object no) {
    return Intl.message(
      'Alcanza el nivel $no realizando mas actividades',
      name: 'reachLevel',
      desc: '',
      args: [no],
    );
  }

  /// `Aplica en línea`
  String get applyOnline {
    return Intl.message(
      'Aplica en línea',
      name: 'applyOnline',
      desc: '',
      args: [],
    );
  }

  /// `Archivos`
  String get records {
    return Intl.message(
      'Archivos',
      name: 'records',
      desc: '',
      args: [],
    );
  }

  /// `Ayuda`
  String get help {
    return Intl.message(
      'Ayuda',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Buscar`
  String get lookFor {
    return Intl.message(
      'Buscar',
      name: 'lookFor',
      desc: '',
      args: [],
    );
  }

  /// `Busqueda avanzada`
  String get advancedSearch {
    return Intl.message(
      'Busqueda avanzada',
      name: 'advancedSearch',
      desc: '',
      args: [],
    );
  }

  /// `Cartera`
  String get purse {
    return Intl.message(
      'Cartera',
      name: 'purse',
      desc: '',
      args: [],
    );
  }

  /// `Categoria`
  String get category {
    return Intl.message(
      'Categoria',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Comentarios`
  String get comments {
    return Intl.message(
      'Comentarios',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Comisión`
  String get commission {
    return Intl.message(
      'Comisión',
      name: 'commission',
      desc: '',
      args: [],
    );
  }

  /// `Compra`
  String get purchase {
    return Intl.message(
      'Compra',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `Comprando paquete`
  String get buyingPackage {
    return Intl.message(
      'Comprando paquete',
      name: 'buyingPackage',
      desc: '',
      args: [],
    );
  }

  /// `Comprometido`
  String get committed {
    return Intl.message(
      'Comprometido',
      name: 'committed',
      desc: '',
      args: [],
    );
  }

  /// `Continuar`
  String get continu {
    return Intl.message(
      'Continuar',
      name: 'continu',
      desc: '',
      args: [],
    );
  }

  /// `Correo`
  String get mail {
    return Intl.message(
      'Correo',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// `Cuenta`
  String get bill {
    return Intl.message(
      'Cuenta',
      name: 'bill',
      desc: '',
      args: [],
    );
  }

  /// `Datos generales`
  String get generalData {
    return Intl.message(
      'Datos generales',
      name: 'generalData',
      desc: '',
      args: [],
    );
  }

  /// `Descripción`
  String get description {
    return Intl.message(
      'Descripción',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Detalle`
  String get detail {
    return Intl.message(
      'Detalle',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Disponible`
  String get available {
    return Intl.message(
      'Disponible',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Editar grupo`
  String get editGroup {
    return Intl.message(
      'Editar grupo',
      name: 'editGroup',
      desc: '',
      args: [],
    );
  }

  /// `En juego`
  String get inGame {
    return Intl.message(
      'En juego',
      name: 'inGame',
      desc: '',
      args: [],
    );
  }

  /// `Entrar`
  String get getIn {
    return Intl.message(
      'Entrar',
      name: 'getIn',
      desc: '',
      args: [],
    );
  }

  /// `Equipo 1`
  String get team1 {
    return Intl.message(
      'Equipo 1',
      name: 'team1',
      desc: '',
      args: [],
    );
  }

  /// `Equipo 2`
  String get team2 {
    return Intl.message(
      'Equipo 2',
      name: 'team2',
      desc: '',
      args: [],
    );
  }

  /// `Escribe aquí tu comentario`
  String get writeYour {
    return Intl.message(
      'Escribe aquí tu comentario',
      name: 'writeYour',
      desc: '',
      args: [],
    );
  }

  /// `Estas en el nivel`
  String get youAreOnThELevel {
    return Intl.message(
      'Estas en el nivel',
      name: 'youAreOnThELevel',
      desc: '',
      args: [],
    );
  }

  /// `Evento`
  String get event {
    return Intl.message(
      'Evento',
      name: 'event',
      desc: '',
      args: [],
    );
  }

  /// `Fecha`
  String get date {
    return Intl.message(
      'Fecha',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Grupos`
  String get groups {
    return Intl.message(
      'Grupos',
      name: 'groups',
      desc: '',
      args: [],
    );
  }

  /// `Grupos de usuarios`
  String get userGroups {
    return Intl.message(
      'Grupos de usuarios',
      name: 'userGroups',
      desc: '',
      args: [],
    );
  }

  /// `Guardar`
  String get keep {
    return Intl.message(
      'Guardar',
      name: 'keep',
      desc: '',
      args: [],
    );
  }

  /// `Interventor`
  String get controller {
    return Intl.message(
      'Interventor',
      name: 'controller',
      desc: '',
      args: [],
    );
  }

  /// `Invitados`
  String get guests {
    return Intl.message(
      'Invitados',
      name: 'guests',
      desc: '',
      args: [],
    );
  }

  /// `Liguilla completa en la quiniela`
  String get completeLeague {
    return Intl.message(
      'Liguilla completa en la quiniela',
      name: 'completeLeague',
      desc: '',
      args: [],
    );
  }

  /// `Limpiar`
  String get cleanUp {
    return Intl.message(
      'Limpiar',
      name: 'cleanUp',
      desc: '',
      args: [],
    );
  }

  /// `Línea`
  String get line {
    return Intl.message(
      'Línea',
      name: 'line',
      desc: '',
      args: [],
    );
  }

  /// `Listas`
  String get lists {
    return Intl.message(
      'Listas',
      name: 'lists',
      desc: '',
      args: [],
    );
  }

  /// `Mercado pago`
  String get paidMarket {
    return Intl.message(
      'Mercado pago',
      name: 'paidMarket',
      desc: '',
      args: [],
    );
  }

  /// `Mi cartera`
  String get myWallet {
    return Intl.message(
      'Mi cartera',
      name: 'myWallet',
      desc: '',
      args: [],
    );
  }

  /// `Moneda real`
  String get realCoin {
    return Intl.message(
      'Moneda real',
      name: 'realCoin',
      desc: '',
      args: [],
    );
  }

  /// `Moneda virtual`
  String get virtualCurrency {
    return Intl.message(
      'Moneda virtual',
      name: 'virtualCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Monto`
  String get amount {
    return Intl.message(
      'Monto',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Monto Total`
  String get amountTotal {
    return Intl.message(
      'Monto Total',
      name: 'amountTotal',
      desc: '',
      args: [],
    );
  }

  /// `Nombre del grupo`
  String get groupName {
    return Intl.message(
      'Nombre del grupo',
      name: 'groupName',
      desc: '',
      args: [],
    );
  }

  /// `Notificaciones`
  String get notifications {
    return Intl.message(
      'Notificaciones',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Paypal`
  String get paypal {
    return Intl.message(
      'Paypal',
      name: 'paypal',
      desc: '',
      args: [],
    );
  }

  /// `Perfil`
  String get profile {
    return Intl.message(
      'Perfil',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Personalizado`
  String get personalized {
    return Intl.message(
      'Personalizado',
      name: 'personalized',
      desc: '',
      args: [],
    );
  }

  /// `Politicas de uso`
  String get policiesOfUse {
    return Intl.message(
      'Politicas de uso',
      name: 'policiesOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Postulaciones nuevas`
  String get newApplications {
    return Intl.message(
      'Postulaciones nuevas',
      name: 'newApplications',
      desc: '',
      args: [],
    );
  }

  /// `Postura`
  String get position {
    return Intl.message(
      'Postura',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `Posturas`
  String get postures {
    return Intl.message(
      'Posturas',
      name: 'postures',
      desc: '',
      args: [],
    );
  }

  /// `Precio`
  String get price {
    return Intl.message(
      'Precio',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Quitar todas las notificaciones`
  String get removeAllNotifications {
    return Intl.message(
      'Quitar todas las notificaciones',
      name: 'removeAllNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Registrarme`
  String get signUp {
    return Intl.message(
      'Registrarme',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Registrarme ahoora`
  String get registerNow {
    return Intl.message(
      'Registrarme ahoora',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Reglas`
  String get rules {
    return Intl.message(
      'Reglas',
      name: 'rules',
      desc: '',
      args: [],
    );
  }

  /// `Reglas del evento`
  String get eventRules {
    return Intl.message(
      'Reglas del evento',
      name: 'eventRules',
      desc: '',
      args: [],
    );
  }

  /// `Reglas del grupo`
  String get groupRules {
    return Intl.message(
      'Reglas del grupo',
      name: 'groupRules',
      desc: '',
      args: [],
    );
  }

  /// `Repetir contraseña`
  String get repeatPassword {
    return Intl.message(
      'Repetir contraseña',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Resultado`
  String get outcome {
    return Intl.message(
      'Resultado',
      name: 'outcome',
      desc: '',
      args: [],
    );
  }

  /// `Resultado de rango inicial`
  String get initialRangeResult {
    return Intl.message(
      'Resultado de rango inicial',
      name: 'initialRangeResult',
      desc: '',
      args: [],
    );
  }

  /// `Resultado de rango inicial/final`
  String get resultofstartendrange {
    return Intl.message(
      'Resultado de rango inicial/final',
      name: 'resultofstartendrange',
      desc: '',
      args: [],
    );
  }

  /// `Resultado deportivo`
  String get sportsResult {
    return Intl.message(
      'Resultado deportivo',
      name: 'sportsResult',
      desc: '',
      args: [],
    );
  }

  /// `Resultado gana/pierde`
  String get resultWiNLose {
    return Intl.message(
      'Resultado gana/pierde',
      name: 'resultWiNLose',
      desc: '',
      args: [],
    );
  }

  /// `Resultados asignados`
  String get assignedResults {
    return Intl.message(
      'Resultados asignados',
      name: 'assignedResults',
      desc: '',
      args: [],
    );
  }

  /// `Resultados sin asignar`
  String get unassignedResults {
    return Intl.message(
      'Resultados sin asignar',
      name: 'unassignedResults',
      desc: '',
      args: [],
    );
  }

  /// `Saldo`
  String get balance {
    return Intl.message(
      'Saldo',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Selecciona método de pago`
  String get selectPaymentMethod {
    return Intl.message(
      'Selecciona método de pago',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Servicio`
  String get service {
    return Intl.message(
      'Servicio',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// `Solicitudes de acceso`
  String get accessRequests {
    return Intl.message(
      'Solicitudes de acceso',
      name: 'accessRequests',
      desc: '',
      args: [],
    );
  }

  /// `Solicitar Acceso`
  String get accessRequest {
    return Intl.message(
      'Solicitar Acceso',
      name: 'accessRequest',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Tus postulaciones`
  String get yourApplications {
    return Intl.message(
      'Tus postulaciones',
      name: 'yourApplications',
      desc: '',
      args: [],
    );
  }

  /// `Usuario`
  String get user {
    return Intl.message(
      'Usuario',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Usuarios`
  String get users {
    return Intl.message(
      'Usuarios',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Venta`
  String get sale {
    return Intl.message(
      'Venta',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `Ventas y compras`
  String get salesAndPurchases {
    return Intl.message(
      'Ventas y compras',
      name: 'salesAndPurchases',
      desc: '',
      args: [],
    );
  }

  /// `Ver mis fondeos`
  String get seeMyAnchors {
    return Intl.message(
      'Ver mis fondeos',
      name: 'seeMyAnchors',
      desc: '',
      args: [],
    );
  }

  /// `Ver movimientos`
  String get seeMovements {
    return Intl.message(
      'Ver movimientos',
      name: 'seeMovements',
      desc: '',
      args: [],
    );
  }

  /// `Volumen`
  String get volume {
    return Intl.message(
      'Volumen',
      name: 'volume',
      desc: '',
      args: [],
    );
  }

  /// `Has alcanzado el nivel 5`
  String get hasReachedLevel {
    return Intl.message(
      'Has alcanzado el nivel 5',
      name: 'hasReachedLevel',
      desc: '',
      args: [],
    );
  }

  /// `En Espera de Acceso al Evento`
  String get waitingAccessEvent {
    return Intl.message(
      'En Espera de Acceso al Evento',
      name: 'waitingAccessEvent',
      desc: '',
      args: [],
    );
  }

  /// `Nombres`
  String get names {
    return Intl.message(
      'Nombres',
      name: 'names',
      desc: '',
      args: [],
    );
  }

  /// `No hay Datos`
  String get noData {
    return Intl.message(
      'No hay Datos',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Volumen`
  String get volumen {
    return Intl.message(
      'Volumen',
      name: 'volumen',
      desc: '',
      args: [],
    );
  }

  /// `El volumen es el número de veces que vas a realizar la postura`
  String get volumenDescript {
    return Intl.message(
      'El volumen es el número de veces que vas a realizar la postura',
      name: 'volumenDescript',
      desc: '',
      args: [],
    );
  }

  /// `Precio Referencia`
  String get referencePrice {
    return Intl.message(
      'Precio Referencia',
      name: 'referencePrice',
      desc: '',
      args: [],
    );
  }

  /// `$`
  String get dollar {
    return Intl.message(
      '\$',
      name: 'dollar',
      desc: '',
      args: [],
    );
  }

  /// `Enviar`
  String get send {
    return Intl.message(
      'Enviar',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Sin Acceso`
  String get noAccess {
    return Intl.message(
      'Sin Acceso',
      name: 'noAccess',
      desc: '',
      args: [],
    );
  }

  /// `Selecciona un Símbolo`
  String get selectSymbol {
    return Intl.message(
      'Selecciona un Símbolo',
      name: 'selectSymbol',
      desc: '',
      args: [],
    );
  }

  /// `No tienes suficiente saldo`
  String get enoughBalance {
    return Intl.message(
      'No tienes suficiente saldo',
      name: 'enoughBalance',
      desc: '',
      args: [],
    );
  }

  /// `Compra realizada correctamente`
  String get purchaseCorrect {
    return Intl.message(
      'Compra realizada correctamente',
      name: 'purchaseCorrect',
      desc: '',
      args: [],
    );
  }

  /// `Venta realizada correctamente`
  String get saleCorrect {
    return Intl.message(
      'Venta realizada correctamente',
      name: 'saleCorrect',
      desc: '',
      args: [],
    );
  }

  /// `Éxito`
  String get success {
    return Intl.message(
      'Éxito',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
