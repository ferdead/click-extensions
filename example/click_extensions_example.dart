import 'package:click_extensions/click_extensions.dart';

void main() {
  final data = DateTime.now();
  print('a data é: ${data.toDateTimeFullBR}');
  final data1 = data.toUtcFuso();
  print('a data1 é ${data1.toDateTimeFullBR}');
  final data2 = data1.toUtcFuso();
  print('a data2 é ${data2.toDateTimeFullBR}');

  print('----------------------');
  print('EXTENSIONS DATETIME');
  print('----------------------');

  print('DateTime.now().toUtcFuso() -->  ${DateTime.now().toUtcFuso()} | String');
  print('DateTime.now().toDateFullBR -->  ${DateTime.now().toDateFullBR} | String');
  print('DateTime.now().toDateShortBR -->  ${DateTime.now().toDateShortBR} | String');
  print('DateTime.now().toDateTimeFullBR -->  ${DateTime.now().toDateTimeFullBR} | String');
  print('DateTime.now().toDateTimeFullIntl -->  ${DateTime.now().toDateTimeFullIntl} | String');
  print('DateTime.now().toRFC339 -->  ${DateTime.now().toRFC3339} | String');
  print('DateTime.now().toLongDate -->  ${DateTime.now().toLongDate} | String');
  print('DateTime.now().toMesAnoDescrito -->  ${DateTime.now().toMesAnoDescrito} | String');

  print('----------------------');
  print('EXTENSIONS STRING');
  print('----------------------');
  print('\'2023-01-02 14:22:15\'.isdate -->  ${'2023-01-02 14:22:15'.isDate} | bool');
  print('\'2023-01-02\'.isdate -->  ${'2023-01-02'.isDate} | bool');
  print('\'2023-02-30\'.isdate -->  ${'2023-02-30'.isDate} | bool');
  print('\'áéíóú\'.toBase64 -->  ${'áéíóú'.toBase64} | String');
  print('\'w6HDqcOtw7PDug==\'.fromBase64 -->  ${'w6HDqcOtw7PDug=='.fromBase64} | String');
  print('\'1.234,56\'.toCurrency -->  ${'1.234,56'.toCurrency} | Num');
  print('\'10/11/2023 14:22:15\'.toDate -->  ${'10/11/2023 14:22:15'.toDate} | DateTime?');
  print('\'2023-01-02 14:22:15\'.toDate -->  ${'2023-01-02 14:22:15'.toDate} | DateTime?');
  print('\'10/12/2023\'.toDate -->  ${'10/12/2023'.toDate} | DateTime?');
  print('\'2023-12-10\'.toDate -->  ${'2023-12-10'.toDate} | DateTime?');
  print('\'10/11/2023 14:22:15\'.toDateTime -->  ${'10/11/2023 14:22:15'.toDateTime} | DateTime?');
  print('\'2023-01-02\'.toDateTime -->  ${'2023-01-02'.toDateTime} | DateTime?');
  print('\'10/11/2023 14:22:15\'.toDateTimeFullBR -->  ${'10/11/2023 14:22:15'.toDateTimeFullBR} | String');
  print('\'10/11/2023 14:22:16\'.toDateTimeFullBR -->  ${'10/11/2023 14:22:16'.toDateTimeFullBR} | String');
  print('\'2023-01-02 14:22:17\'.toDateTimeFullBR -->  ${'2023-01-02 14:22:17'.toDateTimeFullBR} | String');
  print('\'10/11/2023 14:22:15\'.toDateTimeFullIntl -->  ${'10/11/2023 14:22:15'.toDateTimeFullIntl} | String');
  print('\'10/11/2023 14:22:16\'.toDateTimeFullIntl -->  ${'10/11/2023 14:22:16'.toDateTimeFullIntl} | String');
  print('\'2023-01-02 14:22:17\'.toDateTimeFullIntl -->  ${'2023-01-02 14:22:17'.toDateTimeFullIntl} | String');
  print('\'10/11/2023 14:22:15\'.toDateFullIntl -->  ${'10/11/2023 14:22:15'.toDateFullIntl} | String');
  print('\'10/11/2023 14:22:16\'.toDateFullIntl -->  ${'10/11/2023 14:22:16'.toDateFullIntl} | String');
  print('\'2023-01-02 14:22:17\'.toDateFullIntl -->  ${'2023-01-02 14:22:17'.toDateFullIntl} | String');
  print('\'10/11/2023 14:22:15\'.toDateFullTimeShortBR -->  ${'10/11/2023 14:22:15'.toDateFullTimeShortBR} | String');
  print('\'10/11/2023 14:22:16\'.toDateFullTimeShortBR -->  ${'10/11/2023 14:22:16'.toDateFullTimeShortBR} | String');
  print('\'2023-01-02 14:22:17\'.toDateFullTimeShortBR -->  ${'2023-01-02 14:22:17'.toDateFullTimeShortBR} | String');
  print('\'2023-11-10 14:22:15\'.toDateFullBR -->  ${'2023-11-10 14:22:15'.toDateFullBR} | String');
  print('\'10/11/2023 14:22:15\'.toDateFullBR -->  ${'10/11/2023 14:22:15'.toDateFullBR} | String');
  print('\'2023-11-10 14:22:15\'.toDateTimeShortBR -->  ${'2023-11-10 14:22:15'.toDateTimeShortBR} | String');
  print('\'10/11/2023 14:22:15\'.toDateTimeShortBR -->  ${'10/11/2023 14:22:15'.toDateTimeShortBR} | String');
  print('\'2023-11-10 14:23:15\'.toDateShortBR -->  ${'2023-11-10 14:23:15'.toDateShortBR} | String');
  print('\'2023-11-10 14:22:15\'.toDateShortBR -->  ${'2023-11-10 14:22:15'.toDateShortBR} | String');
  print('\'2023-11-10 14:22:15\'.toTimeShort -->  ${'2023-11-10 14:22:15'.toTimeShort} | String');
  print('\'10/11/2023 14:22:15\'.toTimeShort -->  ${'10/11/2023 14:22:15'.toTimeShort} | String');
  print('\'2023-11-10 14:22:15\'.toTimeFull -->  ${'2023-11-10 14:22:15'.toTimeFull} | String');
  print('\'2023-11-10 14:22:15\'.toTimeFull -->  ${'2023-11-10 14:22:15'.toTimeShort} | String');
  print('DateTime.now().toUtcFuso() -->  ${DateTime.now().toUtcFuso()} | DateTime');
  print('\'1a2b3c\'.toOnlyNumber -->  ${'1a2b3c'.toOnlyNumber} | String');
  print('\'A Data 2023-11-10 14:22:15\'.toOnlyTexto -->  ${'A Data 2023-11-10 14:22:15'.toOnlyTexto} | String');
  print('\'áéíóú\'.toRetiraAcentos -->  ${'áéíóú'.toRetiraAcentos} | String');
  print('\'47.5\'.isNumeric -->  ${'47.5'.isNumeric} | bool');
  print('\'47,5\'.isNumeric -->  ${'47,5'.isNumeric} | bool');
  print('\'47\'.isNumeric -->  ${'47'.isNumeric} | bool');
  print('\'4a7\'.isNumeric -->  ${'4a7'.isNumeric} | bool');
  print('\'123.000,12\'.toInt -->  ${'123.000,12'.toInt} | bool');
  print('\'123,000.12\'.toInt -->  ${'123,000.12'.toInt} | bool');
  print('\'47\'.toInt -->  ${'47'.toInt} | bool');
  print('\'4a7\'.toInt -->  ${'4a7'.toInt} | bool');
  print('\'O Rato ROEU A ROUPA DO REI DE ROMA\'.toCapitalizeText -->  ${'O Rato ROEU A ROUPA DO REI DE ROMA'.toCapitalizeText} | String');
  print('\'MERENGUE 300 ML\'.toCapitalizeTitle -->  ${'MERENGUE 300 ML'.toCapitalizeTitle} | String');

  print('----------------------');
  print('EXTENSIONS LIST');
  print('----------------------');
  print('[\'abc\', \'def\', \'ghy\'].toListString --> ${['abc', 'def', 'ghy'].toListString} | String');

  print('----------------------');
  print('EXTENSIONS Double');
  print('----------------------');
  print('(1.123).toDecimalBr(5) -> ${(1.123).toDecimalBr(5)}');
  print('(1,111.123).toDecimal2Us(5) -> ${(1111.123).toDecimal2Us}');
}
