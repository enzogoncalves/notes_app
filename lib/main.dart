import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_events.dart';
import 'package:notes_app/models/color.dart';
import 'package:notes_app/pages/home_page.dart';
import 'package:notes_app/repositories/notes_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final NotesRepository notesRepository = NotesRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(dialogBackgroundColor: AppColors().dismissibleNoteBackgroundColor),
      home: BlocProvider(
        create: (context) => NotesBloc(notesRepository: notesRepository)..add(NotesLoadEvent()),
        child: const NotesPage(),
      ),
    );
  }
}
