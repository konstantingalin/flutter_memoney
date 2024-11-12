import 'package:flutter/material.dart';
import 'package:me_money_app/main.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> currencies = [];
  List<dynamic> expenses = [];
  late String currentDate;
  late int currentYear;

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

    fetchCurrencyData();
    final now = DateTime.now();
    currentYear = now.year; // Сохраняем текущий год
    currentDate = DateFormat('d MMMM', 'ru_RU').format(now);
  }

  Future<void> fetchCurrencyData() async {
    final response = await supabase.from('currency').select();

    setState(() {
      currencies = response as List<dynamic>;
    });
  }

  Future<void> createExpenses(
      String userCreate, String name, double amount) async {
    await supabase.from('expenses').insert({
      'user_create': userCreate,
      'user_create_name': 'Вадим Паясу',
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

  void changeDate(int days) {
    final date = DateFormat('d MMMM', 'ru_RU').parse(currentDate);
    final newDate = date.add(Duration(days: days));
    setState(() {
      currentDate = DateFormat('d MMMM', 'ru_RU').format(newDate);
    });
  }

  Stream<List<dynamic>> fetchExpenses() async* {
    while (true) {
      final response = await supabase
          .from('expenses')
          .select('*, currency!inner(short)')
          .eq('user_create', supabase.auth.currentUser!.id);

      yield response as List<dynamic>; // Возвращаем данные
      await Future.delayed(
          const Duration(seconds: 5)); // Задержка перед следующим запросом
    }
  }

  @override
  Widget build(BuildContext context) {
    // final expensesStream = supabase.from('expenses').stream(
    //     primaryKey: ['id']).eq('user_create', supabase.auth.currentUser!.id);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(94.0),
        child: SafeArea(
          child: Container(
            color: const Color.fromARGB(255, 247, 250, 252),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
            ),
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
                        InkWell(
                          onTap: () {
                            changeDate(-1);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 24,
                            color: Color.fromARGB(255, 93, 127, 160),
                          ),
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
                        InkWell(
                          onTap: () {
                            changeDate(1);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 24,
                            color: Color.fromARGB(255, 93, 127, 160),
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.menu,
                      size: 24,
                      color: Color.fromARGB(255, 93, 127, 160),
                    ),
                  ],
                ),
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
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 247, 250, 252),
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 0,
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                              items: currencies
                                  .map<DropdownMenuItem<String>>((currency) {
                                return DropdownMenuItem<String>(
                                  value: currency['id'].toString(),
                                  child: Row(
                                    children: <Widget>[
                                      Image.network(
                                        currency['img'],
                                        width: 20,
                                        height: 13,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        currency['name'],
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
                          )),
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
                          stream: fetchExpenses(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            // Получаем день и месяц из currentDate
                            final dateParts = currentDate.split(' ');
                            final currentDay = int.parse(dateParts[0]);
                            final currentMonthName = dateParts[1];

                            // Мапа для сопоставления названий месяцев с их номерами
                            final monthMap = {
                              'января': 1,
                              'февраля': 2,
                              'марта': 3,
                              'апреля': 4,
                              'мая': 5,
                              'июня': 6,
                              'июля': 7,
                              'августа': 8,
                              'сентября': 9,
                              'октября': 10,
                              'ноября': 11,
                              'декабря': 12,
                            };

                            // Получаем номер месяца из мапы
                            final currentMonth =
                                monthMap[currentMonthName] ?? 0;

                            // Фильтруем данные по текущей дате
                            final expensesData =
                                snapshot.data!.where((expense) {
                              final createdAt =
                                  DateTime.parse(expense['created_at'])
                                      .toLocal();
                              // Сравниваем год, месяц и день
                              return createdAt.year == currentYear &&
                                  createdAt.month == currentMonth &&
                                  createdAt.day == currentDay;
                            }).toList();

                            final totalExpenses = expensesData.fold<double>(
                              0,
                              (previousValue, expense) =>
                                  previousValue + (expense['amount'] ?? 0),
                            );

                            String formattedTotal = totalExpenses % 1 == 0
                                ? totalExpenses.toStringAsFixed(0)
                                : totalExpenses.toStringAsFixed(2);

                            return totalExpenses > 0
                                ? Column(
                                    children: [
                                      Column(
                                        children:
                                            expensesData.map<Widget>((expense) {
                                          return Column(
                                            children: [
                                              Row(
                                                spacing: 8,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                      left: 8,
                                                      right: 8,
                                                      bottom: 5,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 247, 250, 252),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      expense['category']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 127, 160),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                      left: 8,
                                                      right: 8,
                                                      bottom: 5,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 247, 250, 252),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Трата - ${expense['storage']}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 93, 127, 160),
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                      left: 8,
                                                      right: 8,
                                                      bottom: 5,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 247, 250, 252),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      expense['user_create_name'] ??
                                                          "-",
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        expense['name'],
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              93,
                                                              127,
                                                              160),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        spacing: 16,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            expense["amount"] %
                                                                        1 ==
                                                                    0
                                                                ? expense["amount"]
                                                                        .toStringAsFixed(
                                                                            0) +
                                                                    ' ' +
                                                                    expense["currency"]
                                                                        [
                                                                        "short"]
                                                                : expense["amount"]
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    ' ₸',
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      61,
                                                                      153,
                                                                      246),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 1.3,
                                                            ),
                                                          ),
                                                          Text(
                                                            formatDate(expense[
                                                                'created_at']),
                                                            style:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      93,
                                                                      127,
                                                                      160),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                              color: Color.fromARGB(
                                                  255, 93, 127, 160),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '$formattedTotal ₸',
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 61, 153, 246),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'Пусто',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 145, 171, 197),
                                    ),
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
