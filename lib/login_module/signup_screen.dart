import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_motors/app_drawer_module/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Lato'
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.08
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.04,),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          // Store default values so drawer shows 'User' and '000-000'
                          await prefs.setString('name', 'User');
                          await prefs.setString('email', '');
                          await prefs.remove('address');

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => HomeScreen())
                          );
                        },
                        child: Text('Skip',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF005F65),
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05,),
                    Center(
                      child: Image.asset('assets/login_image/signup.png',
                        height: 200,
                        width: 200,
                      ),
                    ),

                    SizedBox(height: height * 0.03,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Profile Update',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.03,),
                    TextFormField(
                      controller: nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],

                      decoration: InputDecoration(
                          hintText: 'Enter Your Name',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            color: Color(0xFF7C7C7C),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Color(0xFF817979)
                              )
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF817979),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF005F65),
                              width: 1.5,
                            ),
                          ),

                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12
                          )
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Name';
                        }

                        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Name should contain only Alphabets';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: height * 0.03,),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,

                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],

                      decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            color: Color(0xFF7C7C7C),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF817979),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF005F65),
                              width: 1.5,
                            ),
                          ),

                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12
                          )
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }

                        if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: height * 0.03,),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        emailController.value = TextEditingValue(
                          text: value.toLowerCase(),
                          selection: TextSelection.collapsed(offset: value.length),
                        );
                      },

                      decoration: InputDecoration(
                          hintText: 'Enter Mail ID',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            color: Color(0xFF7C7C7C),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF817979),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF005F65),
                              width: 1.5,
                            ),
                          ),

                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12
                          )
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }

                        if (!RegExp(r'^[\w\.-]+@gmail\.com$').hasMatch(value)) {
                          return 'Enter valid email';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: height * 0.03,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF005F65),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            )
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('name', nameController.text);
                            await prefs.setString('phone', phoneController.text);
                            await prefs.setString('email', emailController.text);

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => HomeScreen())
                            );
                          }
                        },
                        child: Text('SAVE',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w700,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}