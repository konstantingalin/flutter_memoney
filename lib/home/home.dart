import 'package:flutter/material.dart';
import 'package:me_money_app/main.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentDate;

  String? _selectedValue;
  String? _selectedValue2;
  String? _selectedValue3;

  TextEditingController nameExpeseslController = TextEditingController();
  TextEditingController amountExpeseslController = TextEditingController();

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('d MMMM');
    return formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('d MMMM', 'ru_RU').format(DateTime.now());
  }

  final expensesStream = supabase.from('expenses').stream(
      primaryKey: ['id']).eq('user_create', supabase.auth.currentUser!.id);

  Future<void> createExpenses(
      String userCreate, String name, double amount) async {
    await supabase.from('expenses').insert({
      'user_create': userCreate,
      'type': 'spending',
      'name': name,
      'amount': amount,
      'currency': 1,
      'storage': 1,
      'category': 1,
      'family_id': 1,
    });
  }

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

    DateFormat timeFormat = DateFormat('HH:mm', 'ru_RU');
    DateFormat dayFormat = DateFormat('EEE', 'ru_RU');

    String formattedTime = timeFormat.format(dateTime);
    String formattedDay = dayFormat.format(dateTime);

    return '$formattedTime ($formattedDay)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 247, 250, 252),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_small_blue.png',
                      width: 43,
                      height: 28,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_left,
                          size: 24,
                          color: Color.fromARGB(255, 93, 127, 160),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          currentDate,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 93, 127, 160),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 24,
                          color: Color.fromARGB(255, 93, 127, 160),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.menu,
                      size: 24,
                      color: Color.fromARGB(255, 93, 127, 160),
                    ),
                  ],
                ), // topmenu
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x05000000),
                            offset: Offset(0, 2),
                            blurRadius: 2,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(255, 61, 153, 246),
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Расходы',
                        style: TextStyle(
                          color: Color.fromARGB(255, 61, 153, 246),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      'Доходы',
                      style: TextStyle(
                        color: Color.fromARGB(255, 93, 127, 160),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      'Перемещения',
                      style: TextStyle(
                        color: Color.fromARGB(255, 93, 127, 160),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      'Обмен',
                      style: TextStyle(
                        color: Color.fromARGB(255, 93, 127, 160),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),

                // Расходы
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    right: 12,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x05000000),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameExpeseslController,
                        autofocus: false,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 93, 127, 160),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Название траты",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 163, 186, 209),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 233, 239, 245),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 233, 239, 245),
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              12, 10, 12, 10),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: amountExpeseslController,
                        autofocus: false,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 93, 127, 160),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Сумма траты",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 163, 186, 209),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 233, 239, 245),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 233, 239, 245),
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              12, 10, 12, 10),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            12, 10, 12, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 233, 239, 245),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            elevation: 0,
                            isDense: true,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color.fromARGB(255, 93, 127, 160),
                              size: 16,
                            ),
                            dropdownColor: Colors.white,
                            value: _selectedValue,
                            hint: const Text(
                              'Выберите валюту',
                              style: TextStyle(
                                color: Color.fromARGB(255, 163, 186, 209),
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedValue = newValue;
                              });
                            },
                            items: <Map<String, String>>[
                              {
                                'value': 'kz',
                                'text': 'Тенге',
                                'image': 'assets/images/kz_flag.png'
                              },
                              {
                                'value': 'ru',
                                'text': 'Рубли',
                                'image': 'assets/images/ru_flag.png'
                              },
                              {
                                'value': 'usa',
                                'text': 'Доллары',
                                'image': 'assets/images/usa_flag.png'
                              },
                              {
                                'value': 'eu',
                                'text': 'Евро',
                                'image': 'assets/images/eu_flag.png'
                              },
                            ].map<DropdownMenuItem<String>>(
                                (Map<String, String> item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      item['image']!,
                                      width: 20,
                                      height: 13,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      item['text']!,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 93, 127, 160),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            12, 10, 12, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 233, 239, 245),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            elevation: 0,
                            isDense: true,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color.fromARGB(255, 93, 127, 160),
                              size: 16,
                            ),
                            dropdownColor: Colors.white,
                            value: _selectedValue2,
                            hint: const Text(
                              'Откуда потрачено',
                              style: TextStyle(
                                color: Color.fromARGB(255, 163, 186, 209),
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedValue2 = newValue;
                              });
                            },
                            items: <Map<String, dynamic>>[
                              {
                                'value': '1',
                                'text': 'Личный кошелек',
                                'image': Icons.account_balance_wallet_outlined
                              },
                              {
                                'value': '2',
                                'text': 'Банковская карта',
                                'image': Icons.credit_card
                              },
                              {
                                'value': '3',
                                'text': 'Наличные',
                                'image': Icons.money
                              },
                              {
                                'value': '4',
                                'text': 'Сберегательный счет',
                                'image': Icons.savings_outlined
                              },
                            ].map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      item['image'],
                                      color: const Color.fromARGB(
                                          255, 93, 127, 160),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      item['text']!,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 93, 127, 160),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            12, 10, 12, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 233, 239, 245),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            elevation: 0,
                            isDense: true,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color.fromARGB(255, 93, 127, 160),
                              size: 16,
                            ),
                            dropdownColor: Colors.white,
                            value: _selectedValue3,
                            hint: const Text(
                              'Выберите категорию',
                              style: TextStyle(
                                color: Color.fromARGB(255, 163, 186, 209),
                                fontSize: 14,
                              ),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedValue3 = newValue;
                              });
                            },
                            items: <Map<String, dynamic>>[
                              {
                                'value': '1',
                                'text': 'Без категории',
                                'image': Icons.circle_outlined
                              },
                              {
                                'value': '2',
                                'text': 'Продукты',
                                'image': Icons.kitchen_outlined
                              },
                              {
                                'value': '3',
                                'text': 'Хозтовары',
                                'image': Icons.inventory_2_outlined
                              },
                              {
                                'value': '4',
                                'text': 'Квартплата',
                                'image': Icons.food_bank_outlined
                              },
                              {
                                'value': '5',
                                'text': 'Кафе и перекусы',
                                'image': Icons.local_cafe_outlined
                              },
                            ].map<DropdownMenuItem<String>>(
                                (Map<String, dynamic> item) {
                              return DropdownMenuItem<String>(
                                value: item['value'],
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      item['image'],
                                      color: const Color.fromARGB(
                                          255, 93, 127, 160),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      item['text']!,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 93, 127, 160),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF71B6FD), Color(0xFF54A5F7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            transform:
                                GradientRotation(139.3 * (3.1415927 / 180)),
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            createExpenses(
                              supabase.auth.currentUser!.id,
                              nameExpeseslController.text,
                              double.parse(amountExpeseslController.text),
                            );

                            nameExpeseslController.text = '';
                            amountExpeseslController.text = '';
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            minimumSize: const Size(double.infinity, 56),
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Внести трату'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 16 * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), // расходы
                const SizedBox(
                  height: 16,
                ),
                // Журнал операций
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    right: 12,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x05000000),
                        offset: Offset(0, 2),
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Журнал операций',
                              style: TextStyle(
                                color: Color.fromARGB(255, 93, 127, 160),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 1,
                          color: const Color.fromARGB(255, 236, 237, 241),
                        ),
                        StreamBuilder(
                          stream: expensesStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final expensesData = snapshot.data ?? [];

                            final totalExpenses = expensesData.fold<double>(
                              0,
                              (previousValue, expense) =>
                                  previousValue + (expense['amount'] ?? 0),
                            );

                            String formattedTotal = totalExpenses % 1 == 0
                                ? totalExpenses.toInt().toString()
                                : totalExpenses.toStringAsFixed(2);

                            return Column(
                              children: [
                                Column(
                                  children: expensesData.map<Widget>((expense) {
                                    return Column(
                                      children: [
                                        Row(
                                          spacing: 8,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 8,
                                                right: 8,
                                                bottom: 5,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 247, 250, 252),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                expense['category'].toString(),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 93, 127, 160),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 8,
                                                right: 8,
                                                bottom: 5,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 247, 250, 252),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                '${expense['type']} - ${expense['storage']}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 93, 127, 160),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                left: 8,
                                                right: 8,
                                                bottom: 5,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 247, 250, 252),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                supabase.auth.currentUser!.email
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 93, 127, 160),
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  expense['name'],
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 93, 127, 160),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  spacing: 16,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${expense["amount"]} тг'
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 61, 153, 246),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                    Text(
                                                      formatDate(expense[
                                                          'created_at']),
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 127, 160),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          height: 1,
                                          color: const Color.fromARGB(
                                              255, 236, 237, 241),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Итого',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 93, 127, 160),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '$formattedTotal тг',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 61, 153, 246),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ), // Журнал операций
              ],
            ),
          ),
        ),
      ),
    );
  }
}
