import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:intl/intl.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _selectedCity = "Select City/Municipality";
  final List<String> _cities = [
    "Angat",
    "Balagtas",
    "Baliuag",
    "Bocaue",
    "Bulakan",
    "Bustos",
    "Calumpit",
    "Dona Remedios Trinidad",
    "Guiguinto",
    "Hagonoy",
    "Malolos",
    "Marilao",
    "Meycauayan",
    "Norzagaray",
    "Obando",
    "Pandi",
    "Paombong",
    "Plaridel",
    "Pulilan",
    "San Ildefonso",
    "San Jose del Monte",
    "San Miguel",
    "San Rafael",
    "Santa Maria"
  ];
  String _othersInput = "";
  final _degprogController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _collegeaddressController = TextEditingController();
  final _homeaddressController = TextEditingController();
  final _sponsorController = TextEditingController();
  final _batchController = TextEditingController();
  String _phoneNum = '';
  PhoneNumber number = PhoneNumber(isoCode: 'PH');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Selected date background color
              onPrimary: Colors.white, // Selected date text color
              onSurface: Colors.black, // Default text color
            ),
            dialogBackgroundColor: Colors.white, // Background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Sign Up",
          style: GoogleFonts.patrickHandSc(color: Colors.black, fontSize: 30),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mag Sign Up sa Sandiwapp",
                        style: GoogleFonts.patrickHandSc(
                            color: Colors.black, fontSize: 34),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Name",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _nameController,
                      obscureText: false,
                      hintText: "Enter your name"),
                  const SizedBox(height: 10),
                  Text(
                    "Nickname",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _nicknameController,
                      obscureText: false,
                      hintText: "Enter your nickname"),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Birthday",
                        style: blackText,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: MyTextField2(
                            controller: _birthdayController,
                            obscureText: false,
                            hintText: "Enter your birthday",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          _phoneNum = number.phoneNumber!;
                        });
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      initialValue: number,
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      textFieldController:
                          TextEditingController(text: _phoneNum),
                      formatInput: false,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          top: 12,
                          left: 14,
                          right: 14,
                          bottom: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Color(0xFF1A1A1A)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your contact number",
                        hintStyle: GoogleFonts.patrickHand(
                            color: Color(0xffA1A1A1), fontSize: 15),
                      ),
                      textStyle: GoogleFonts.patrickHand(
                          color: Colors.black, fontSize: 19),
                    ),
                  ),
                  Text(
                    "College Address",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _collegeaddressController,
                      obscureText: false,
                      hintText: "Enter your address"),
                  const SizedBox(height: 10),
                  Text(
                    "Home Address",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField2(
                            controller: _homeaddressController,
                            obscureText: false,
                            hintText: "Enter your barangay"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showCitySelectionDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                _selectedCity.contains("Others") ||
                                        _selectedCity.contains("Select") ||
                                        !_cities.contains(_selectedCity)
                                    ? _selectedCity
                                    : "$_selectedCity, Bulacan",
                                maxLines: 2,
                                style: GoogleFonts.patrickHand(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Degree Program",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _degprogController,
                      obscureText: false,
                      hintText:
                          "Enter degree program (ex. BS Computer Science)"),
                  const SizedBox(height: 10),
                  Text(
                    "Sponsor",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _sponsorController,
                      obscureText: false,
                      hintText: "Enter your sponsor"),
                  const SizedBox(height: 10),
                  Text(
                    "Batch (Put N/A if applicant)",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _batchController,
                      obscureText: false,
                      hintText: "Enter your batch (e.g. Tindig, Alpas)"),
                  const SizedBox(height: 10),
                  Text(
                    "Email Address",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _emailController,
                      isEmail: true,
                      obscureText: false,
                      hintText: "Enter your email"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: blackText,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            MyTextField2(
                              isPassword: true,
                              controller: _passwordController,
                              obscureText: true,
                              hintText: "Enter password",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Confirm Password",
                              style: blackText,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            MyTextField2(
                              controller: _confirmpasswordController,
                              obscureText: true,
                              hintText: "Confirm password",
                              password: _passwordController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !_isLoading
                          ? BlackButton(
                              text: "SIGN UP",
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (_selectedCity.contains("Select") ||
                                      _selectedCity.contains("Others")) {
                                    showCustomSnackBar(
                                        context,
                                        "Please select a city/municipality",
                                        120);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return;
                                  }
                                  _formKey.currentState!.save();
                                  MyUser user = MyUser(
                                    name: _nameController.text,
                                    nickname: _nicknameController.text,
                                    birthday: _birthdayController.text,
                                    age: calculateAge(_birthdayController.text),
                                    contactno: _phoneNum,
                                    collegeAddress:
                                        _collegeaddressController.text,
                                    homeAddress:
                                        "${_homeaddressController.text}, $_selectedCity${_cities.contains(_selectedCity) ? ", Bulacan" : ""}",
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    sponsor: _sponsorController.text,
                                    batch: _batchController.text,
                                    confirmed: false,
                                    paid: false,
                                    balance: "0",
                                    merit: "0",
                                    demerit: "0",
                                    position: "",
                                    photoUrl: "",
                                    lupon: "",
                                    paymentProofUrl: "",
                                    acknowledged: false,
                                    degprog: _degprogController.text,
                                  );
                                  String? message = await context
                                      .read<UserAuthProvider>()
                                      .authService
                                      .signUp(user);
                                  setState(() {
                                    _isLoading = false;
                                    if (message != "" && message!.isNotEmpty) {
                                      showCustomSnackBar(context, message, 80);
                                    } else {
                                      showCustomSnackBar(
                                          context,
                                          "Sign up success! Wait for the admin approval",
                                          30);

                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black)),
                      const SizedBox(height: 10),
                      MyTextButton(
                        text: "Go Back",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              )),
        ),
      )),
    );
  }

  void _showCitySelectionDialog(BuildContext context) {
    String? _selectedRadioValue =
        !_cities.contains(_selectedCity) ? "Others" : _selectedCity;
    ScrollController _scrollController = ScrollController();
    TextEditingController othersController =
        TextEditingController(text: _othersInput);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const PatrickHandSC(
              text: "Select City/Municipality", fontSize: 24),
          content: SingleChildScrollView(
            controller: _scrollController,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._cities.map((city) {
                      return RadioListTile<String>(
                        title: Text(city),
                        value: city,
                        groupValue: _selectedRadioValue,
                        activeColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            _selectedRadioValue = value;
                            _othersInput = "";
                          });
                        },
                      );
                    }).toList(),
                    RadioListTile<String>(
                      title: Text("Others"),
                      value: "Others",
                      activeColor: Colors.black,
                      groupValue: _selectedRadioValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedRadioValue = value;
                        });
                        Future.delayed(Duration(milliseconds: 50), () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                    ),
                    if (_selectedRadioValue == "Others")
                      TextField(
                        controller: othersController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            top: 12,
                            left: 14,
                            right: 14,
                            bottom: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF1A1A1A)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Enter your city/municipality",
                          hintStyle: GoogleFonts.patrickHand(
                              color: Color(0xffA1A1A1), fontSize: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _othersInput = value;
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: BlackButton(
                    onTap: () {
                      setState(() {
                        if (_selectedRadioValue == "Others") {
                          _selectedCity =
                              _othersInput.isNotEmpty ? _othersInput : "Others";
                        } else {
                          _selectedCity = _selectedRadioValue!;
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    text: "OK",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: WhiteButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
