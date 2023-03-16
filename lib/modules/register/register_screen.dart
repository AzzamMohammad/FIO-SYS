import 'package:file_sys/modules/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../compoents/loading.dart';
import '../../constantes.dart';
import '../../constants/colors.dart';
import '../../storage/shared_data.dart';

class RegisterScreen extends StatelessWidget {


  final RegisterController registerController = Get.find();
  final formKay = GlobalKey<FormState>();
  final IsHead = true.obs;
  final IsSave = false.obs;
  final List<String> RoleList = ['Admin','User'];
  final LoadingMessage loadingMessage = LoadingMessage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(6),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * .2,
            ),
            Center(
              child: Text(
                'REGISTER',
                style: TextStyle(
                  color: Color1,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * .2,
            ),
            Form(
              key: formKay,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    controller: registerController.NameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Name';
                      }else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      registerController.UserName = value!;
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: registerController.emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    validator: (value) {
                      final pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'Enter Your Email';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      registerController.UserEmail = value!;
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Obx(() {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      controller: registerController.PassWordController,
                      obscureText: IsHead.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: IsHead.value
                              ? Icon(
                            Icons.visibility_off,
                            size: 20,
                          )
                              : Icon(
                            Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            IsHead(!IsHead.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your password";
                        } else if (value.length < 8) {
                          return "Password most be more tha 8 characters";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        registerController.UserPassword = value!;
                      },
                    );
                  }),
                  SizedBox(
                    height: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Remember me",
                      //       style: TextStyle(fontSize: 15),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Obx(() {
                      //       return GestureDetector(
                      //         onTap: () {
                      //           IsSave(!IsSave.value);
                      //         },
                      //         child: Container(
                      //           width: 22,
                      //           height: 22,
                      //           decoration: BoxDecoration(
                      //               borderRadius:
                      //               BorderRadius.all(Radius.circular(7)),
                      //               border: Border.all(
                      //                   color: Theme.of(context).primaryColor,
                      //                   width: 3),
                      //               color: IsSave.value == false
                      //                   ? Theme.of(context).scaffoldBackgroundColor
                      //                   : Theme.of(context).primaryColor),
                      //           child: Icon(
                      //             Icons.check,
                      //             color: IsSave.value == false
                      //                 ? Theme.of(context).scaffoldBackgroundColor
                      //                 : Colors.white,
                      //             size: 17,
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      //   ],
                      // ),
                     Obx((){
                       return DropdownButtonHideUnderline(
                         child: DropdownButton<String>(
                           underline: Divider(thickness: 2,color: Color(0xff076579),height: 20,),
                           menuMaxHeight: 150,
                           dropdownColor: Color(0xffEDDBC0),
                           borderRadius: BorderRadius.all(Radius.circular(8)),
                           alignment: AlignmentDirectional.centerStart,
                           items: RoleList.map((String role) {
                             return DropdownMenuItem(
                               value: role,
                               child: Text(role),
                             );
                           }).toList(),
                           icon: Icon(Icons.arrow_drop_down_outlined),
                           value: RoleList[registerController.Role.value - 1],
                           onChanged: (value) async {
                             registerController.Role(RoleList.indexOf(value!) + 1);
                           },
                         ),
                       );
                     })
                    ],

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isValid = formKay.currentState?.validate();
                      if (isValid == true) {
                        formKay.currentState?.save();
                        if (IsSave.value) {
                          registerController.sharedData.SaveEmail(registerController.UserEmail);
                          registerController.sharedData.SavePassword(registerController.UserPassword);
                        }
                        OnClickLogin(context);
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 50)),
                      maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 50)),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('Go to'),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/login');
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  void OnClickLogin(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    await registerController.RegisterClicked();

    if (registerController.state) {
      loadingMessage.Dismiss();
      Get.offAllNamed('/login');
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          registerController.message,
          true);
    }
  }

}
