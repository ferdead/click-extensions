import 'package:click_extensions/click_extensions.dart';

void main() {
  print('----------------------');
  print('EXTENSIONS DATETIME');
  print('----------------------');

  print('DateTime.now().toDateFullBR -->  ${DateTime.now().toDateFullBR} | String');
  print('DateTime.now().toDateShortBR -->  ${DateTime.now().toDateShortBR} | String');
  print('DateTime.now().toDateTimeFullBR -->  ${DateTime.now().toDateTimeFullBR} | String');
  print('DateTime.now().toDateTimeFullIntl -->  ${DateTime.now().toDateTimeFullIntl} | String');
  print('DateTime.now().toRFC339 -->  ${DateTime.now().toRFC3339} | String');

  print('----------------------');
  print('EXTENSIONS STRING');
  print('----------------------');
  print('\'áéíóú\'.toBase64 -->  ${'áéíóú'.toBase64} | String');
  print('\'w6HDqcOtw7PDug==\'.fromBase64 -->  ${'w6HDqcOtw7PDug=='.fromBase64} | String');
  print('\'1.234,56\'.toCurrency -->  ${'1.234,56'.toCurrency} | Num');
  print('\'10/11/2023 14:22:15\'.toDate -->  ${'10/11/2023 14:22:15'.toDate} | DateTime?');
  print('\'2023-01-02 14:22:15\'.toDate -->  ${'2023-01-02 14:22:15'.toDate} | DateTime?');
  print('\'10/11/2023 14:22:15\'.toDateTimeFullBR -->  ${'10/11/2023 14:22:15'.toDateTimeFullBR} | String');
  print('\'2023-01-02 14:22:15\'.toDateTimeFullBR -->  ${'2023-01-02 14:22:15'.toDateTimeFullBR} | String');
  print('\'10/11/2023 14:22:15\'.toDateFullTimeShortBR -->  ${'10/11/2023 14:22:15'.toDateFullTimeShortBR} | String');
  print('\'2023-01-02 14:22:15\'.toDateFullTimeShortBR -->  ${'2023-01-02 14:22:15'.toDateFullTimeShortBR} | String');
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
  print('\'1a2b3c\'.toOnlyNumber -->  ${'1a2b3c'.toOnlyNumber} | String');
  print('\'A Data 2023-11-10 14:22:15\'.toOnlyTexto -->  ${'A Data 2023-11-10 14:22:15'.toOnlyTexto} | String');
  print('\'áéíóú\'.toRetiraAcentos -->  ${'áéíóú'.toRetiraAcentos} | String');
}
