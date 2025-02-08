import 'package:flutter/material.dart';
import 'package:motif/motif.dart';
import 'package:provider/provider.dart';
import 'package:iot/core/providers/auth_provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // const Positioned.fill(
//           //   child: (),
//           // ),
//           Center(
//             child: Card(
//               margin: const EdgeInsets.all(32),
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text(
//                           'Welcome Back! <3',
//                           style: Theme.of(context).textTheme.headlineMedium,
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 24),
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: const InputDecoration(
//                             labelText: 'Email',
//                             border: OutlineInputBorder(),
//                             prefixIcon: Icon(Icons.email_outlined),
//                           ),
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'Please enter your email';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _passwordController,
//                           decoration: const InputDecoration(
//                             labelText: 'Password',
//                             border: OutlineInputBorder(),
//                             prefixIcon: Icon(Icons.lock_outline),
//                           ),
//                           obscureText: true,
//                           validator: (value) {
//                             if (value?.isEmpty ?? true) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 24),
//                         Consumer<AuthProvider>(
//                           builder: (context, auth, _) {
//                             if (auth.isLoading) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 if (auth.error != null)
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 16),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .errorContainer,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Text(
//                                         auth.error!,
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .error,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 FilledButton.icon(
//                                   icon: const Icon(Icons.login),
//                                   label: const Text('Sign In'),
//                                   onPressed: () async {
//                                     if (_formKey.currentState?.validate() ??
//                                         false) {
//                                       await auth.signIn(
//                                         _emailController.text,
//                                         _passwordController.text,
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(text: "aminemenadi@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "amine2005");
  bool _saveCredentials = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AppContainer.sm(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/LOGIC_3.png',
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 20),
                    Card(
                      margin: const EdgeInsets.all(24),
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 12),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: MenuAnchor(
                                  builder: (context, controller, _) {
                                    return TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        prefixIcon: const Icon(
                                            Icons.person_outline_outlined),
                                        labelText: 'Username',
                                        hintText: '202YXXXXXXX',
                                        alignLabelWithHint: true,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    );
                                  },

                                  // items is credentials
                                  menuChildren: [],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: TextFormField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    prefixIcon:
                                        Icon(Icons.lock_outline_rounded),
                                    labelText: 'Password',
                                    helperText:
                                        'a password by default is birthday "DDMMYYYY"',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              // checkbox for save credentials
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: ListTile(
                                  trailing: Switch(
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    value: _saveCredentials,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _saveCredentials = value;
                                      });
                                    },
                                  ),
                                  title: const Text('Save credentials'),
                                  subtitle: const Text(
                                      'Save your credentials for the next time'),
                                  leading: const Icon(Icons.key_rounded),
                                  onTap: () {
                                    setState(() {
                                      _saveCredentials = !_saveCredentials;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Consumer<AuthProvider>(
                                  builder: (context, authProvider, child) {
                                    if (authProvider.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return Material(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      elevation: 3,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.fingerprint_rounded,
                                          color: Colors.white,
                                        ),
                                        title: const Center(
                                          child: Text(
                                            'Sign in',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onTap: () {
                                          authProvider.signIn(
                                            _usernameController.text,
                                            _passwordController.text,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),

                              if (context.watch<AuthProvider>().error != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.watch<AuthProvider>().error!,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class AppContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  const AppContainer({super.key, required this.child, this.maxWidth});

  // sm
  const AppContainer.sm({super.key, required this.child}) : maxWidth = 600;
  // md
  const AppContainer.md({super.key, required this.child}) : maxWidth = 600;
  // lg
  const AppContainer.lg({super.key, required this.child}) : maxWidth = 900;

  @override
  Widget build(BuildContext context) {
    // dynamic on null
    double getDynamicMaxWidth() {
      if (maxWidth != null) {
        return maxWidth!;
      }
      var currentMaxWidth = MediaQuery.sizeOf(context).width;
      if (currentMaxWidth > 800) {
        return 800;
      }
      if (currentMaxWidth > 800) {
        return 700;
      }
      return 600;
    }

    // max width id 800
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            clipBehavior: Clip.none,
            constraints: BoxConstraints(
              maxWidth: getDynamicMaxWidth(),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
