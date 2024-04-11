// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
//
// import '../../Models/brew.dart';
// import '../../Shared/loading.dart';
// import '../teacher_wrapper.dart';
// import 'brew_tile.dart';
//
// class BrewList extends StatefulWidget {
//   const BrewList({Key? key}) : super(key: key);
//
//   @override
//   State<BrewList> createState() => _BrewListState();
// }
//
// class _BrewListState extends State<BrewList> {
//   @override
//   Widget build(BuildContext context) {
//     final brews = Provider.of<List<Brew>?>(context) ?? [];
//
//     if (brews == null || brews.isEmpty) {
//       // Return a placeholder or an empty widget when brews is null or empty
//       return Loading();
//     }
//
//     return ListView.builder(
//       itemCount: brews.length,
//       itemBuilder: (context, index) {
//         return BrewTile(brew: brews[index]);
//       },
//     );
//   }
// }
//
//
