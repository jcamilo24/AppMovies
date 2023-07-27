import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/sign_in_controller.dart';
import '../controller/state/sign_in_state.dart';
import 'widgets/submit_button.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (BuildContext context) {
        return SignInController(
          const SignInState(),
          authenticationRepository: context.read(),
        );
      },
      child: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Builder(builder: (context) {
              final controller = Provider.of<SignInController>(
                context,
              );
              return AbsorbPointer(
                absorbing: controller.state.fetching,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (text) {
                        controller.onUsernameChange(text);
                      },
                      decoration: const InputDecoration(
                        hintText: 'UserName',
                      ),
                      validator: (text) {
                        text = text?.trim().toLowerCase() ?? '';

                        if (text.isEmpty) {
                          return 'Invalid Username';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (text) {
                        controller.onPasswordChange(text);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (text) {
                        text = text?.replaceAll(' ', '') ?? '';

                        if (text.length < 4) {
                          return 'Invalid Password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SubmitButton(),
                  ],
                ),
              );
            }),
          ),
        ),
      )),
    );
  }
}
