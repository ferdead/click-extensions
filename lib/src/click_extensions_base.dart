import 'dart:convert';
import 'dart:math';

import 'package:click_functions_helper/click_functions_helper.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

extension StringExtensionNullable on String? {
  bool get isValidJson {
    try {
      if (this == null) return false;
      final decoded = jsonDecode(this!);

      // Opcional: garantir que seja Map ou List (JSON “raiz” válido)
      return decoded is Map || decoded is List;
    } catch (e) {
      return false;
    }
  }

  ///verifica se a string é vazia ou nula
  bool get isEmptyOrNull {
    return this == null || this!.isEmpty;
  }

  bool get isDate {
    if (this == null) return false;
    List<String> formats = [
      'dd/MM/yyyy',
      'yyyy-MM-dd',
      'dd/MM/yyyy HH:mm',
      'yyyy-MM-dd HH:mm',
      'dd/MM/yyyy HH:mm:ss',
      'yyyy-MM-dd HH:mm:ss',
    ];

    for (var format in formats) {
      try {
        DateFormat formatter = DateFormat(format);
        formatter.parseStrict(this!);
        return true; // Se conseguiu fazer o parse sem exceções, retorna true
      } catch (e) {
        // Continua para o próximo formato se ocorrer erro
      }
    }
    return false; // Se nenhum formato foi válido, retorna false
  }
}

extension StringExtension on String {
  bool get isValidJson {
    try {
      final decoded = jsonDecode(this);

      // Opcional: garantir que seja Map ou List (JSON “raiz” válido)
      return decoded is Map || decoded is List;
    } catch (e) {
      return false;
    }
  }

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
      if (toLowerCase() == 'sim' || toLowerCase() == 'true' || toLowerCase() == '1' || toLowerCase() == 'yes' || toLowerCase() == 'y' || toLowerCase() == 's') return true;
    }
    return false;
  }

  ///Retorna um blob convertendo a String
  Blob get toBlob {
    List<int> bytes = utf8.encode(this);
    return Blob.fromBytes(bytes);
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
      String data = '';
      if (contains(':')) {
        data = _formatDateTimeStr(this, EnumDateTimeFormat.dateFullBR);
      } else {
        data = _formatDateTimeStr('$this 00:00:00', EnumDateTimeFormat.dateFullBR);
      }

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

  ///Função para converter uma string em um double com correção de flutuação de 2 casas decimais
  double? get toDouble2 {
    final parsedValue = double.tryParse(this);
    if (parsedValue != null) {
      // Aqui, arredondamos o valor para 2 casas decimais para evitar flutuações
      return double.parse(parsedValue.toStringAsFixed(2));
    }
    return null;
  }

  ///Função para converter uma string em um double com correção de flutuação de 3 casas decimais
  double? get toDouble3 {
    final parsedValue = double.tryParse(this);
    if (parsedValue != null) {
      // Aqui, arredondamos o valor para 3 casas decimais para evitar flutuações
      return double.parse(parsedValue.toStringAsFixed(3));
    }
    return null;
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
    return ClickFunctionsHelper.onlyNumbers(this);
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
    return ClickFunctionsHelper.retiraAcentos(this);
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

  ///formata string para telefone:
  ///'24-3371-19-44' => (24) 3371-1944;
  ///'24999991944'   => (24) 99999-1944;
  String get toFone {
    String numeros = replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o número tem o comprimento de um telefone fixo ou celular
    if (numeros.length == 10) {
      // Formato de telefone fixo (XX) XXXX-XXXX
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6)}';
    } else if (numeros.length == 11) {
      // Formato de celular (XX) XXXXX-XXXX
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7)}';
    } else {
      // Retorna a string original se não corresponder aos formatos esperados
      return numeros;
    }
  }

  ///formatar uma string para CPF ou CNPJ
  /// '12345678901'.toCpfCnpj => '123.456.789-01';
  /// '12345678000199'.toCpfCnpj => '12.345.678/0001-99';
  String get toCpfCnpj {
    // Remove caracteres não numéricos
    String numeros = replaceAll(RegExp(r'[^0-9]'), '');

    // Formata como CPF (XXX.XXX.XXX-XX)
    if (numeros.length == 11) {
      return '${numeros.substring(0, 3)}.${numeros.substring(3, 6)}.${numeros.substring(6, 9)}-${numeros.substring(9, 11)}';
    }
    // Formata como CNPJ (XX.XXX.XXX/XXXX-XX)
    else if (numeros.length == 14) {
      return '${numeros.substring(0, 2)}.${numeros.substring(2, 5)}.${numeros.substring(5, 8)}/${numeros.substring(8, 12)}-${numeros.substring(12, 14)}';
    } else {
      // Retorna a string original se não corresponder aos formatos esperados
      return numeros;
    }
  }

  ///Converte uma String chave:valor para um mapa String, dynamic
  Map<String, dynamic> get parseToMap {
    Map<String, dynamic> resultMap = {};

    // Divide a entrada em linhas
    List<String> lines = split('\n');

    for (String line in lines) {
      if (line.trim().isEmpty) {
        continue;
      }

      // Divide cada linha pelo primeiro ':'
      int idx = line.indexOf(':');
      if (idx != -1) {
        String key = line.substring(0, idx).trim();
        dynamic value = line.substring(idx + 1).trim();

        // Tenta converter o valor para um número, se possível
        if (int.tryParse(value) != null) {
          value = int.parse(value);
        }

        resultMap[key] = value;
      }
    }

    return resultMap;
  }

  ///checa se a data é valida
  bool get isDate {
    List<String> formats = [
      'dd/MM/yyyy',
      'yyyy-MM-dd',
      'dd/MM/yyyy HH:mm',
      'yyyy-MM-dd HH:mm',
      'dd/MM/yyyy HH:mm:ss',
      'yyyy-MM-dd HH:mm:ss',
    ];

    for (var format in formats) {
      try {
        DateFormat formatter = DateFormat(format);
        formatter.parseStrict(this);
        return true; // Se conseguiu fazer o parse sem exceções, retorna true
      } catch (e) {
        // Continua para o próximo formato se ocorrer erro
      }
    }
    return false; // Se nenhum formato foi válido, retorna false
  }

  ///Altera a String com textos e quebra de lina para Maiúsculo no inicio da sentença
  ///Ex. O RATO ROEU A ROUPA DO REI DE ROMA -> O rato roeu a roupa do rei de roma
  String get toCapitalizeText {
    // Divide o texto primeiro pelas quebras de linha
    List<String> lines = split('\n');

    // Processa linha por linha, capitalizando corretamente as frases
    List<String> formattedLines = lines.map((line) {
      // Divide a linha em frases com base em ponto final, exclamação ou interrogação
      List<String> sentences = line.split(RegExp(r'(?<=[.!?/])\s+'));

      // Capitaliza cada sentença
      List<String> formattedSentences = sentences.map((sentence) {
        if (sentence.isEmpty) return sentence;
        return sentence[0].toUpperCase() + sentence.substring(1).toLowerCase();
      }).toList();

      // Junta as sentenças novamente com o espaço necessário
      return formattedSentences.join(' ');
    }).toList();

    // Junta todas as linhas novamente, preservando as quebras de linha
    return formattedLines.join('\n');
  }

  /// Capitaliza o título levando em consideração preposições e conjunções comuns
  String get toCapitalizeTitle {
    // Lista de palavras que não devem ser capitalizadas, exceto se forem a primeira palavra
    final List<String> exceptions = ['de', 'do', 'da', 'dos', 'das', 'para', 'e', 'com', 'sem', 'por', 'a', 'o', 'as', 'os', 'ml', 'kg', 'g', 'un', 'l'];

    // Converte o texto para minúsculo, separa em palavras e processa cada uma
    List<String> words = toLowerCase().split(' ').where((word) => word.isNotEmpty).map((word) {
      // Se a palavra não estiver na lista de exceções, capitaliza a primeira letra
      if (!exceptions.contains(word)) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).toList();

    // Garante que a primeira palavra seja capitalizada, mesmo que esteja na lista de exceções
    if (words.isNotEmpty) {
      words[0] = words[0][0].toUpperCase() + words[0].substring(1);
    }

    // Junta as palavras novamente em uma string
    return words.join(' ');
  }
}

extension NumExtensionNullable on num? {
  ///verifica se a string é vazia ou nula
  bool get isEmptyOrNull {
    return this == null || this == 0;
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

extension DoubleExtension on double {
  ///formata um Num retornando uma string no formato de moeda brasileiro
  String get toFormattedMoney {
    final valor = this;
    var v = NumberFormat.currency(locale: 'pt_BR', decimalDigits: 2, symbol: 'R\$');
    return v.format(valor);
  }

  ///formata um Num retornando uma string no com duas casas decimais padrão BR
  String get toDecimal2Br {
    final valor = this;
    var v = NumberFormat.currency(customPattern: '##,##0.00', locale: 'pt_BR');
    return v.format(valor);
  }

  String toDecimalBr(int decimalDigits) {
    final valor = this;
    var v = NumberFormat.currency(customPattern: '##,##0.00', locale: 'pt_BR', decimalDigits: decimalDigits);
    return v.format(valor);
  }

  ///retorna um Num com duas casas decimais padrão US
  num get toDecimal2Us {
    final valor = this;
    var v = NumberFormat.currency(customPattern: '0.00', locale: 'en_US');
    return num.parse(v.format(valor));
  }

  num get toDecimal2UsTruncate {
    final valor = this;
    return (valor * 100).floor() / 100;
  }

  double arredondarComPrecisao(int precisao) {
    int fator = pow(10, precisao) as int;
    return (this * fator).round() / fator;
  }

  ///trunca um num com precisão informada no parâmetro
  num toTruncate(int precision) {
    final valor = this;
    var strValor = valor.toStringAsFixed(precision + 10);
    final s = strValor.split('.');
    strValor = '${s[0]}.${s[1].substring(0, precision)}';
    return num.parse(strValor);
  }

  /// retorna um double com duas casas decimais, arredondando 0.5 para cima.
  double get toDouble2 {
    return _roundHalfUp(2);
  }

  /// retorna um double com três casas decimais, arredondando 0.5 para cima.
  double get toDouble3 {
    return _roundHalfUp(3);
  }

  // ///retorna um double com duas casas decimais
  // double get toDouble2 {
  //   return double.parse(toStringAsFixed(2));
  // }

  // ///retorna um double com três casas decimais
  // double get toDouble3 {
  //   return double.parse(toStringAsFixed(3));
  // }

  /// Internal helper to round a double to a specified number of decimal places
  /// using "round half up" logic.
  /// (e.g., 0.5 rounds up, 0.4 rounds down)
  double _roundHalfUp(int decimalPlaces) {
    if (decimalPlaces < 0) {
      throw ArgumentError('decimalPlaces must be non-negative');
    }
    if (decimalPlaces == 0) {
      return roundToDouble();
    }
    final factor = pow(10, decimalPlaces).toDouble();
    // Multiply by factor, round, then divide by factor
    return (this * factor).round() / factor;
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

  ///Adiciona o número de mes a uma data
  DateTime addMonth(int meses) {
    int novoMes = (month + meses) % 12;
    int novoAno = year + ((month + meses) ~/ 12);
    int novoDia = day;

    // Lida com o caso em que o dia é maior do que o último dia do novo mês
    if (novoDia > DateTime(novoAno, novoMes + 1, 0).day) {
      novoDia = DateTime(novoAno, novoMes + 1, 0).day;
    }

    return DateTime(novoAno, novoMes, novoDia, hour, minute, second, millisecond, microsecond);
  }

  ///Retorna um DateTime com UTC e altera as horas do fuso-horário
  DateTime toUtcFuso([int fuso = -3]) {
    //if (isUtc) return this;
    //add(timeZoneOffset);
    //return toUtc().add(Duration(hours: fuso));

    if (isUtc) return this;
    return DateTime.utc(year, month, day, hour, minute, second);
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

  ///Converte um DateTime em String no formato: 07 de março de 2024
  String get toLongDate {
    return '${day.toString().padLeft(2, '0')} de ${EnumMeses.fromMes(month).nomeCompleto} de $year';
  }

  ///Escreve a data no formato de nome do mês/ano EX. AGOSTO/2024
  String get toMesAnoDescrito {
    const months = ['JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO', 'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'];

    String monthName = months[month - 1];
    return '$monthName/$year';
  }
}

enum EnumMeses {
  janeiro(1, 'janeiro', 'jan'),
  fevereiro(2, 'fevereiro', 'fev'),
  marco(3, 'março', 'mar'),
  abril(4, 'abril', 'abr'),
  maio(5, 'maio', 'mai'),
  junho(6, 'junho', 'jun'),
  julho(7, 'julho', 'jul'),
  agosto(8, 'agosto', 'ago'),
  setembro(9, 'setembro', 'set'),
  outubro(10, 'outubro', 'out'),
  novembro(11, 'novembro', 'nov'),
  dezembro(12, 'dezembro', 'dec');

  const EnumMeses(this.numero, this.nomeCompleto, this.nomeAbreviado);

  final int numero;
  final String nomeCompleto;
  final String nomeAbreviado;

  static EnumMeses fromMes(int numero) {
    return values.firstWhere((t) => t.numero == numero);
  }
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

extension BlobExtension on Blob {
  ///converter blob do mysql para string
  String get toStr => utf8.decode((this).toBytes());
}
