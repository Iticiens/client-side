// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:iot/core/providers/auth_provider.dart';

// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:intl/intl.dart';
// import 'package:motif/motif.dart';

// const double xsmall = 10.0;
// const double small = 16.0;
// const double medium = 20.0;
// const double large = 32.0;
// const double xlarge = 50.0;
// Color background = const Color(0xFF000500);
// Color userChat = const Color(0xFF1A80E5);
// Color resChat = const Color(0xFF243647);
// Color chatColor = const Color(0xFF47698A);
// var white = const Color(0xFFFFFFFF);
// Color hintColor = const Color(0xFF47698A);

// TextStyle messageText = GoogleFonts.poppins(color: white, fontSize: small);
// TextStyle appBarTitle =
//     GoogleFonts.poppins(color: white, fontWeight: FontWeight.bold);
// TextStyle hintText = GoogleFonts.poppins(color: hintColor, fontSize: small);
// TextStyle dateText = GoogleFonts.poppins(color: white, fontSize: 13);
// TextStyle promptText = GoogleFonts.poppins(color: white, fontSize: small);

// class ChatScreen extends StatelessWidget {
//   final Map<String, dynamic> arduinoData;

//   const ChatScreen({super.key, required this.arduinoData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         actions: [
//           Consumer<AuthProvider>(
//             builder: (context, auth, _) {
//               final user = auth.currentUser;
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text(
//                     user?.data['name'] ?? 'Guest',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           const Positioned.fill(
//             child: SinosoidalMotif(),
//           ),
//           Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 800),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Expanded(
//                   //   child: ListView.builder(
//                   //     itemCount: _messages.length,
//                   //     itemBuilder: (context, index) {
//                   //       final message = _messages[index];
//                   //       return Messages(
//                   //         isUser: message.isUser,
//                   //         message: message.message,
//                   //         date: DateFormat('HH:mm').format(message.date),
//                   //         onAnimatedTextFinished: onAnimatedTextFinished,
//                   //         // onAnimatedTextFinished: onAnimatedTextFinished,
//                   //       );
//                   //     },
//                   //   ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: medium, vertical: small),
//                     child: Expanded(
//                       flex: 20,
//                       child: TextFormField(
//                         maxLines: 6,
//                         minLines: 1,
//                         controller: _userMessage,
//                         decoration: InputDecoration(
//                           contentPadding:
//                               const EdgeInsets.fromLTRB(medium, 0, small, 0),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(xlarge),
//                           ),
//                           hintText: 'Enter prompt',
//                           hintStyle: hintText,
//                           suffixIcon: GestureDetector(
//                             onTap: () {
//                               if (!isLoading && _userMessage.text.isNotEmpty) {
//                                 sendMessage();
//                               }
//                             },
//                             child: isLoading
//                                 ? Container(
//                                     width: medium,
//                                     height: medium,
//                                     margin: const EdgeInsets.all(xsmall),
//                                     child: CircularProgressIndicator(
//                                       valueColor:
//                                           AlwaysStoppedAnimation<Color>(white),
//                                       strokeWidth: 3,
//                                     ),
//                                   )
//                                 : Icon(
//                                     Icons.arrow_upward,
//                                     color: _userMessage.text.isNotEmpty
//                                         ? Colors.white
//                                         : const Color(0x5A6C6C65),
//                                   ),
//                           ),
//                         ),
//                         style: promptText,
//                         onChanged: (value) {
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Message {
//   final bool isUser;
//   final String message;
//   final DateTime date;
//   Message({required this.isUser, required this.message, required this.date});
// }

// class Messages extends StatelessWidget {
//   final bool isUser;
//   final String message;
//   final String date;
//   final Function onAnimatedTextFinished;
//   final isAnimated = ValueNotifier(false);

//   Messages({
//     Key? key,
//     required this.isUser,
//     required this.message,
//     required this.date,
//     required this.onAnimatedTextFinished,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(small),
//       margin: const EdgeInsets.symmetric(vertical: small).copyWith(
//         left: isUser ? 100 : xsmall,
//         right: isUser ? xsmall : 100,
//       ),
//       decoration: BoxDecoration(
//         color: isUser ? userChat : resChat,
//         borderRadius: BorderRadius.only(
//           topLeft: const Radius.circular(xsmall),
//           bottomLeft: isUser ? const Radius.circular(xsmall) : Radius.zero,
//           topRight: const Radius.circular(xsmall),
//           bottomRight: !isUser ? const Radius.circular(xsmall) : Radius.zero,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isUser)
//             GestureDetector(
//               onLongPress: () async {
//                 await Clipboard.setData(ClipboardData(text: message));
//               },
//               child: AnimatedTextKit(
//                 animatedTexts: [
//                   TyperAnimatedText(message, textStyle: messageText),
//                 ],
//                 totalRepeatCount: 1,
//                 isRepeatingAnimation: false,
//                 stopPauseOnTap: true,
//                 onFinished: () {
//                   isAnimated.value = true;
//                   onAnimatedTextFinished();
//                 },
//               ),
//             ),
//           if (isUser)
//             Text(
//               message,
//               style: messageText,
//             ),
//           Row(
//             mainAxisAlignment:
//                 isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
//             children: [
//               Text(
//                 "\n$date",
//                 style: dateText,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
