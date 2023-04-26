// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:robot_gui/screens/terminal/terminal_tab.dart';

// class TerminalScreen extends StatefulWidget {
//   const TerminalScreen({Key? key}) : super(key: key);

//   @override
//   State<TerminalScreen> createState() => _TerminalScreenState();
// }

// class _TerminalScreenState extends State<TerminalScreen> {
//   int currentIndex = 0;
//   int _lastCount = 0;
//   final Map<String, TerminalTab> _terminals = {
//     "terminal 0": const TerminalTab()
//   };
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: TabView(
//         onNewPressed: () {
//           setState(() {
//             _lastCount = _lastCount + 1;

//             _terminals['Terminal $_lastCount'] = const TerminalTab();
//             currentIndex = _terminals.length - 1;
//           });
//         },
//         bodies: _terminals.values.toList(),
//         currentIndex: currentIndex,
//         onChanged: (i) => setState(() {
//           currentIndex = i;
//         }),
//         tabs: _terminals.keys
//             .map(
//               (e) => Tab(
//                   text: Text(e),
//                   onClosed: _terminals.length <= 1
//                       ? null
//                       : () {
//                           setState(() {
//                             if (currentIndex == _terminals.length - 1) {
//                               currentIndex = currentIndex - 1;
//                             }
//                             _terminals.remove(e);
//                           });
//                         }),
//             )
//             .toList(),
//       ),
//     );
//   }
// }
