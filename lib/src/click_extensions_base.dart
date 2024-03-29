import 'dart:convert';
import 'dart:math';

import 'package:click_functions_helper/click_functions_helper.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  ///Verifica se a string contém um CPF válido
  bool get isValidCPF => _validarCPF(this);

  ///Verifica se a string contém um CNPJ válido
  bool get isValidCNPJ => _validarCNPJ(this);

  ///Verifica se a string contém um CPF ou CNPJ válido
  bool get isValidCPForCNPJ => _validarCPF(this) || _validarCNPJ(this);

  ///Faz o trim e deixa a string upper case
  String get trimToUpper => trim().toUpperCase();

  ///Faz o trim e deixa a string lower case
  String get trimToLower => trim().toLowerCase();

  ///Transfoma uma *String* em *String* base 64.
  /// ```dart
  /// 'áéíóú'.toBase64 -->  w6HDqcOtw7PDug==
  /// ```
  String get toBase64 {
    final encodedBytes = utf8.encode(this);
    final base64 = base64Encode(encodedBytes);
    return base64;
  }

  ///Transfoma uma *String* base64 em *String*.
  /// ```dart
  /// 'w6HDqcOtw7PDug=='.toBase64 -->  áéíóú
  /// ```
  String get fromBase64 {
    try {
      final base64 = base64Decode(this);
      return utf8.decode(base64);
    } catch (e) {
      return 'Base64 inválida';
    }
  }

  ///Retorna um bool [true/false] baseado na string true = [sim, true, 1, yes, y, s] ou retorna false
  bool get toBool {
    if (runtimeType == String) {
      if (toLowerCase() == 'sim' ||
          toLowerCase() == 'true' ||
          toLowerCase() == '1' ||
          toLowerCase() == 'yes' ||
          toLowerCase() == 'y' ||
          toLowerCase() == 's') return true;
    }
    return false;
  }

  ///Transfoma uma *String* em *Num* .
  /// ```dart
  /// '1.234,56'.toCurrency -->  1234.56
  /// ```
  num get toCurrency {
    final valor = this;
    var v = NumberFormat.currency(locale: 'pt_BR');
    //print('o valor eh ${v.parse(valor)}');
    return v.parse(valor);
  }

  ///Transfoma uma *String* em *DateTime?*.
  /// ```dart
  /// '10/11/2023 14:22:15'.toDate -->  2023-11-10 00:00:00.000
  /// '2023-11-10 14:22:15'.toDate -->  2023-11-10 00:00:00.000
  /// ```
  DateTime? get toDate {
    try {
      var data = _formatDateTimeStr(this, EnumDateTimeFormat.dateFullBR);
      data = data.replaceAll('Z', '');
      data = data.replaceAll('T', ' ');
      var d = DateFormat(EnumDateTimeFormat.dateFullBR.value);
      return d.parse(data);
    } catch (e) {
      return null;
    }
  }

  ///Transfoma uma *String* em *DateTime?*.
  /// ```dart
  /// '10/11/2023 14:22:15'.toDateTime -->  2023-11-10 14:22:15.000
  /// '2023-11-10 14:22:15'.toDateTime -->  2023-11-10 14:22:15.000
  /// ```
  DateTime? get toDateTime {
    try {
      var data = _formatDateTimeStr(this, EnumDateTimeFormat.dateFullTimeFullINTL);
      data = data.replaceAll('Z', '');
      data = data.replaceAll('T', ' ');
      var d = DateFormat(EnumDateTimeFormat.dateFullTimeFullINTL.value);
      return d.parse(data);
    } catch (e) {
      return null;
    }
  }

  ///Formata uma *String* de data para data e hora completo padrão Internacional.
  /// ```dart
  ///'10/11/2023 14:22:15'.toDateTimeFullIntl -->  2023-11-10 14:22:15 | String
  ///'2023-01-02 14:22:15'.toDateTimeFullIntl -->  2023-01-02 14:22:15 | String
  /// ```
  String get toDateTimeFullIntl => _formatDateTimeStr(this, EnumDateTimeFormat.dateFullTimeFullINTL);

  ///Formata uma *String* de data para data completo padrão Internacional.
  /// ```dart
  ///'10/11/2023 14:22:15'.toDateTimeFullIntl -->  2023-11-10 | String
  ///'2023-01-02 14:22:15'.toDateTimeFullIntl -->  2023-01-02 | String
  /// ```
  String get toDateFullIntl => _formatDateTimeStr(this, EnumDateTimeFormat.dateFullINTL);

  ///Formata uma *String* de data para data e hora completo padrão BR.
  /// ```dart
  ///'10/11/2023 14:22:15'.toDateTimeBR -->  10/11/2023 14:22:15 | String
  ///'2023-01-02 14:22:15'.toDateTimeBR -->  02/01/2023 14:22:15 | String
  /// ```
  String get toDateTimeFullBR => _formatDateTimeStr(this, EnumDateTimeFormat.dateFullTimeFullBR);

  ///Formata uma *String* de data para data completa e hora reduzida padrão BR.
  /// ```dart
  ///'10/11/2023 14:22:15'.toDateTimeBR -->  10/11/2023 14:22 | String
  ///'2023-01-02 14:22:15'.toDateTimeBR -->  02/01/2023 14:22 | String
  /// ```
  String get toDateFullTimeShortBR => _formatDateTimeStr(this, EnumDateTimeFormat.dateFullTimeShortBR);

  ///Formata uma *String* de data no padrão de data completa no padrão BR.
  /// ```dart
  ///'2023-11-10 14:22:15'.toDateFullBR -->  10/11/2023 | String
  ///'10/11/2023 14:22:15'.toDateFullBR -->  10/11/2023 | String
  /// ```
  String get toDateFullBR => _formatDateTimeStr(this, EnumDateTimeFormat.dateFullBR);

  ///Formata uma *String* de data no padrão de data e hora reduzida no padrão BR.
  /// ```dart
  ///'2023-11-10 14:22:15'.toDateTimeShortBR -->  10/11 14:22 | String
  ///'10/11/2023 14:22:15'.toDateTimeShortBRs -->  10/11 14:22 | String
  /// ```
  String get toDateTimeShortBR => _formatDateTimeStr(this, EnumDateTimeFormat.dateShortTimeShortBR);

  ///Formata uma *String* de data no padrão de Data reduzido no padrão BR.
  /// ```dart
  ///'2023-11-10 14:22:15'.toTimeShortBR -->  10/11 | String
  ///'10/11/2023 14:22:15'.toTimeShortBR -->  10/11 | String
  /// ```
  String get toDateShortBR => _formatDateTimeStr(this, EnumDateTimeFormat.dateShortBR);

  ///Formata uma *String* de data no padrão de hora reduzido.
  /// ```dart
  ///'2023-11-10 14:22:15'.toTimeShortBR -->  14:22 | String
  ///'10/11/2023 14:22:15'.toTimeShortBR -->  14:22 | String
  /// ```
  String get toTimeShort => _formatDateTimeStr(this, EnumDateTimeFormat.timeShort);

  ///Formata uma *String* de data no padrão de hora completo.
  /// ```dart
  ///'2023-11-10 14:22:15'.toTimeShortBR -->  14:22:15 | String
  ///'10/11/2023 14:22:15'.toTimeShortBR -->  14:22:15 | String
  /// ```
  String get toTimeFull => _formatDateTimeStr(this, EnumDateTimeFormat.timeFull);

  ///Converte um DateTime em String formatando com o padrão RFC3339 (yyyy-mm-ddThh:mm:ssZ).
  String get toRFC3339 => '${_formatDateTimeStr(this, EnumDateTimeFormat.dateFullTimeFullINTL).replaceAll(' ', 'T')}Z';

  ///Converte uma String em um num
  num? get toNum {
    if (isNumeric == false) return null;
    var valor = this;
    var v = NumberFormat.currency(locale: 'pt_BR');
    return v.parse(valor);
  }

  int? get toInt {
    //final a = NumberFormat.decimalPercentPattern(decimalDigits: 0, locale: 'pt_BR');
    //return int.parse(a.parse(this).toString());
    replaceAll('.', '');

    return int.tryParse(toString());
  }

  double? get toDouble {
    return double.tryParse(this);
  }

  ///Retorna se uma String é um número ou não:
  ///'47.5'.isNumeric -->  true | bool
  ///'47,5'.isNumeric -->  true | bool
  ///'47'.isNumeric -->  true | bool
  ///'4a7'.isNumeric -->  false | bool
  bool get isNumeric {
    final double? parseResult = double.tryParse(replaceAll('.', '').replaceAll(',', '.'));
    return parseResult != null; // se parseResult não é nulo, significa que str é numérico
  }

  ///retorna uma *String* e deixa apenas os números dela.
  /// ```dart
  /// '2023-11-10 14:22:15'.toOnlyNumber -->  20231110142215
  /// ```
  String get toOnlyNumber {
    return FunctionsHelper.onlyNumbers(this);
  }

  ///Retorna uma string com apenas textos retirando os caracteres especiais
  ///```dart
  ///'A Data 2023-11-10 14:22:15'.toOnlyTexto -->  A Data 20231110 142215 | String
  ///```
  String get toOnlyTexto {
    var tmp = this;

    if (tmp.isEmpty) {
      return '';
    }

    tmp = tmp.replaceAll('[', '');
    tmp = tmp.replaceAll(']', '');
    tmp = tmp.replaceAll('.', '');
    tmp = tmp.replaceAll(',', '');
    tmp = tmp.replaceAll('-', '');
    tmp = tmp.replaceAll('/', '');
    tmp = tmp.replaceAll('(', '');
    tmp = tmp.replaceAll(')', '');
    tmp = tmp.replaceAll('*', '');
    tmp = tmp.replaceAll('@', '');
    tmp = tmp.replaceAll('#', '');
    tmp = tmp.replaceAll('\$', '');
    tmp = tmp.replaceAll('&', '');
    tmp = tmp.replaceAll('~', '');
    tmp = tmp.replaceAll(':', '');
    tmp = tmp.replaceAll('^', '');
    tmp = tmp.replaceAll('`', '');
    tmp = tmp.replaceAll('´', '');

    return tmp;
  }

  ///Retorna uma string retirando a acentuação das letras
  ///```dart
  ///'áéíóú'.toRetiraAcentos -->  aeiou | String
  ///```
  String get toRetiraAcentos {
    return FunctionsHelper.retiraAcentos(this);
  }

  ///Retorna uma String com o primeiro caractere maiúsculo
  ///```dart
  ///frase de exemplo -> Frase de exemplo
  ///```
  String get toCapitalize {
    return this[0].toUpperCase() + substring(1);
  }

  ///Converte uma string em camel case
  ///```dart
  ///Exemplo: TesteDeString -> testeDeString
  ///```
  String toCamelCase() {
    if (isEmpty) return this;

    List<String> words = trim().split(RegExp(r'\s+|_+|-+'));
    String result = words[0];

    for (int i = 1; i < words.length; i++) {
      result += words[i].substring(0, 1).toUpperCase() + words[i].substring(1).toLowerCase();
    }

    return result;
  }

  ///Converte uma string em pascal case
  ///```dart
  ///Exemplo: primeiroNomePessoa -> PrimeiroNomePessoa
  ///```
  String get toPascalCase {
    return toCamelCase().toCapitalize;
  }

  ///Converte uma string em snack case
  ///```dart
  ///Exemplo: primeiroNomePessoa -> primeiro_nome_pessoa
  ///```
  String get toSnakeCase {
    if (isEmpty) return this;

    String result = this[0].toLowerCase();
    for (int i = 1; i < length; i++) {
      if (this[i] == this[i].toUpperCase()) {
        result += '_${this[i].toLowerCase()}';
      } else {
        result += this[i];
      }
    }

    return result;
  }
}

extension NumExtension on num {
  ///formata um Num retornando uma string no formato de moeda brasileiro
  String get toFormattedMoney {
    final valor = this;
    var v = NumberFormat.currency(locale: 'pt_BR', decimalDigits: 2, symbol: 'R\$');
    return v.format(valor);
  }

  ///formata um Num retornando uma string no com duas casas decimais padrão BR
  String get toDecimal2Str {
    final valor = this;
    var v = NumberFormat.currency(customPattern: '##,##0.00', locale: 'pt_BR');
    return v.format(valor);
  }

  ///retorna um Num com duas casas decimais padrão US
  num get toDecimal2Us {
    final valor = this;
    var v = NumberFormat.currency(customPattern: '##,##0.00', locale: 'en_US');
    return num.parse(v.format(valor));
  }

  ///trunca um num com precisão informada no parâmetro
  num toTruncate(int precision) {
    final valor = this;
    var strValor = valor.toStringAsFixed(precision + 10);
    final s = strValor.split('.');
    strValor = '${s[0]}.${s[1].substring(0, precision)}';
    return num.parse(strValor);
  }
}

extension DateTimeExtension on DateTime {
  ///Retorna um DateTime com o primeiro dia da semana
  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  ///Retorna um DateTime com o último dia da semana
  DateTime get lastDayOfWeek => add(Duration(days: DateTime.daysPerWeek - weekday));

  ///Retorna um DateTime com o primeiro dia do mês
  DateTime firstDayOfMonth() => DateTime(DateTime.now().year, DateTime.now().month, 1, 0, 0, 0);

  ///Retorna um DateTime com o primeiro dia do mês informado no parâmetro
  DateTime firstDayOfSpecificMonth(int month) => DateTime(DateTime.now().year, month, 1, 0, 0, 0);

  ///Retorna um DateTime com o último dia do mês
  DateTime get lastDayOfMonth => month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

  ///Retorna um DateTime com o dia, concatenando 23:59:59
  DateTime get lastSecondOfDay {
    final parsedDate = this;
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);
  }

  ///Retorna um DateTime com o dia, concatenando 00:00:00
  DateTime get firstSecondOfDay {
    final parsedDate = this;
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 0, 0, 0);
  }

  ///Converte um DateTime em String formatando com o padrão RFC3339 (yyyy-mm-ddThh:mm:ssZ).
  String get toRFC3339 => '${_formatDateTime(this, EnumDateTimeFormat.dateFullTimeFullINTL).replaceAll(' ', 'T')}Z';

  ///Converte um DateTime em String formatando com a Data completa, padrão BR.
  String get toDateFullBR => _formatDateTime(this, EnumDateTimeFormat.dateFullBR);

  ///Converte um DateTime em String formatando com a Data reduzida, padrão BR.
  String get toDateShortBR => _formatDateTime(this, EnumDateTimeFormat.dateShortBR);

  ///Converte um DateTime em String formatando com a Data e hora completa, padrão BR.
  String get toDateTimeFullBR => _formatDateTime(this, EnumDateTimeFormat.dateFullTimeFullBR);

  ///Converte um DateTime em String formatando com a Data e hora completa, padrão Internacional.
  String get toDateTimeFullIntl => _formatDateTime(this, EnumDateTimeFormat.dateFullTimeFullINTL);

  ///Converte um DateTime em String formatando com a Data completa, padrão Internacional.
  String get toDateFullIntl => _formatDateTime(this, EnumDateTimeFormat.dateFullINTL);

  String get toTimeShort => _formatDateTime(this, EnumDateTimeFormat.timeShort);

  String get toTimeFull => _formatDateTime(this, EnumDateTimeFormat.timeFull);

  String get formatDateTimeSql => _formatDateTime(this, EnumDateTimeFormat.dateFullTimeFullINTL);
}

String _formatDateTimeStr(String data, EnumDateTimeFormat formato) {
  DateTime dateTime;

  data = data.replaceAll('T', ' ').replaceAll('Z', '');

  if (data.contains('/')) {
    dateTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(data);
  } else if (data.contains('-')) {
    if (data.contains(':')) {
      dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(data);
    } else {
      dateTime = DateFormat('yyyy-MM-dd').parse(data);
    }
  } else {
    dateTime = DateFormat('yyyy/MM/dd HH:mm:ss').parse(data);
  }

  return DateFormat(formato.value).format(dateTime);
}

String _formatDateTime(DateTime dateTime, EnumDateTimeFormat formato) {
  return DateFormat(formato.value).format(dateTime);
}

enum EnumDateTimeFormat {
  rfc3339('yyyy-mm-ddTHH:mm:ssZ'),
  dateFullTimeFullBR('dd/MM/yyyy HH:mm:ss'),
  dateFullTimeShortBR('dd/MM/yyyy HH:mm'),
  dateShortTimeShortBR('dd/MM HH:mm'),
  dateFullBR('dd/MM/yyyy'),
  dateShortBR('dd/MM'),
  dateFullTimeFullINTL('yyyy-MM-dd HH:mm:ss'),
  dateFullTimeShortINTL('yyyy-MM-dd HH:mm'),
  dateShortTimeShortINTL('dd/MM HH:mm'),
  dateFullINTL('yyyy-MM-dd'),
  dateShortINTL('dd-MM'),
  timeFull('HH:mm:ss'),
  timeShort('HH:mm');

  const EnumDateTimeFormat(this.value);

  final String value;

  static EnumDateTimeFormat fromInt(String value) {
    return values.firstWhere((t) => t.value == value);
  }
}

extension ListExtension<T> on List<T> {
  ///Esta função escolhe um item aleatório da lista e retorna um valor escolhido
  T randomChoice() {
    final random = Random();
    return this[random.nextInt(length)];
  }

  String get toListString {
    if (this is List<String>) {
      final lista = join(', ');
      return lista;
    } else {
      return 'toListString somente é permitido em uma lista de strings';
    }
  }
}

bool _validarCPF(String cpf) {
  // Remove caracteres não numéricos do CPF
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  // Verifica se o CPF tem 11 dígitos
  if (cpf.length != 11) {
    return false;
  }

  // Verifica se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
    return false;
  }

  // Calcula o primeiro dígito verificador
  int soma = 0;
  for (int i = 0; i < 9; i++) {
    soma += int.parse(cpf[i]) * (10 - i);
  }
  int digito1 = 11 - (soma % 11);
  if (digito1 > 9) {
    digito1 = 0;
  }

  // Calcula o segundo dígito verificador
  soma = 0;
  for (int i = 0; i < 10; i++) {
    soma += int.parse(cpf[i]) * (11 - i);
  }
  int digito2 = 11 - (soma % 11);
  if (digito2 > 9) {
    digito2 = 0;
  }

  // Verifica se os dígitos calculados são iguais aos dígitos do CPF
  if (digito1 == int.parse(cpf[9]) && digito2 == int.parse(cpf[10])) {
    return true;
  } else {
    return false;
  }
}

bool _validarCNPJ(String cnpj) {
  // Remove caracteres não numéricos do CNPJ
  cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

  // Verifica se o CNPJ tem 14 dígitos
  if (cnpj.length != 14) {
    return false;
  }

  // Verifica se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) {
    return false;
  }

  // Calcula o primeiro dígito verificador
  int soma = 0;
  int peso = 2;
  for (int i = 11; i >= 0; i--) {
    soma += int.parse(cnpj[i]) * peso;
    peso = (peso == 9) ? 2 : peso + 1;
  }
  int digito1 = 11 - (soma % 11);
  if (digito1 > 9) {
    digito1 = 0;
  }

  // Calcula o segundo dígito verificador
  soma = 0;
  peso = 2;
  for (int i = 12; i >= 0; i--) {
    soma += int.parse(cnpj[i]) * peso;
    peso = (peso == 9) ? 2 : peso + 1;
  }
  int digito2 = 11 - (soma % 11);
  if (digito2 > 9) {
    digito2 = 0;
  }

  // Verifica se os dígitos calculados são iguais aos dígitos do CNPJ
  if (digito1 == int.parse(cnpj[12]) && digito2 == int.parse(cnpj[13])) {
    return true;
  } else {
    return false;
  }
}
